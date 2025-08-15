CLASS lhc_config DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
       IMPORTING REQUEST requested_authorizations FOR config RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR config RESULT result.
    METHODS get_global_features FOR GLOBAL FEATURES
      IMPORTING REQUEST requested_features FOR config RESULT result.
    METHODS setactive FOR MODIFY
      IMPORTING keys FOR ACTION config~setactive RESULT result.
    METHODS setversion FOR DETERMINE ON SAVE
      IMPORTING keys FOR config~setversion.
    METHODS createnewversion FOR MODIFY
      IMPORTING keys FOR ACTION config~createnewversion.
    METHODS precheck_delete FOR PRECHECK
      IMPORTING keys FOR DELETE config.

ENDCLASS.

CLASS lhc_config IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD get_instance_features.
    " Read ACTIVE flag for supplied keys
    READ ENTITIES OF zaemi_config IN LOCAL MODE
      ENTITY config
      FIELDS ( active )
      WITH CORRESPONDING #( keys )
      RESULT DATA(configs)
      FAILED failed.

    " Enable delete only for inactive configs
    result =
      VALUE #( FOR config IN configs
                 ( %key              = config-%key
                   %features-%delete = COND #(
                     WHEN config-active = abap_true
                     THEN if_abap_behv=>fc-o-disabled
                     ELSE if_abap_behv=>fc-o-enabled ) ) ).
  ENDMETHOD.

  METHOD get_global_features.
    " Create allowed only when no config exists
    IF requested_features-%create = if_abap_behv=>mk-on.
      SELECT COUNT( * ) FROM zaemi_config INTO @DATA(lv_config_count).
      result-%create = if_abap_behv=>fc-o-disabled.

      " Enable create or raise error
      IF lv_config_count = 0.
        result-%create = if_abap_behv=>fc-o-enabled.
      ELSE.
        APPEND VALUE #( %msg = new_message_with_text(
                            severity = if_abap_behv_message=>severity-error
                            text     = 'You cannot create new config. Create new version!' ) )
          TO reported-config.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD setactive.
    " Deactivate all configurations then activate only selected ones

    DATA all_keys LIKE keys.

    " Read keys of all configurations
    SELECT id
    FROM zaemi_config INTO CORRESPONDING FIELDS OF TABLE @all_keys.

    " Set active = abap_false for all configurations
    MODIFY ENTITIES OF zaemi_config IN LOCAL MODE
      ENTITY config
        UPDATE
          FIELDS ( active )
          WITH VALUE #( FOR key IN all_keys
                         ( %tky         = key-%tky
                           active = abap_false ) )

     FAILED failed
     REPORTED reported.

    " Set active = abap_true for configurations passed in keys
    MODIFY ENTITIES OF zaemi_config IN LOCAL MODE
        ENTITY config
          UPDATE
            FIELDS ( active )
            WITH VALUE #( FOR key IN keys
                           ( %tky         = key-%tky
                             active = abap_true ) )

       FAILED failed
       REPORTED reported.

    " Read back all configurations for response
    READ ENTITIES OF zaemi_config IN LOCAL MODE
      ENTITY config
        ALL FIELDS WITH CORRESPONDING #( all_keys )
      RESULT DATA(configs).

    " Prepare action result with current state
    result = VALUE #( FOR config IN configs
                        ( %tky   = config-%tky
                          %param = config ) ).

    " Ensure %param-active reflects final activation state
    LOOP AT result ASSIGNING FIELD-SYMBOL(<result>).
      READ TABLE keys ASSIGNING FIELD-SYMBOL(<key_true>) WITH KEY %tky = <result>-%tky.
      IF sy-subrc = 0.
        <result>-%param-active = abap_true.
      ELSE.
        <result>-%param-active = abap_false.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD setversion.
    " Assign consecutive version numbers to entries without version

    " Read versions for provided keys
    READ ENTITIES OF zaemi_config IN LOCAL MODE
      ENTITY config
      FIELDS ( version )
      WITH CORRESPONDING #( keys )
      RESULT DATA(configs).

    " Keep only entries with initial version
    DELETE configs WHERE version IS NOT INITIAL.

    " Nothing to do if empty
    CHECK configs IS NOT INITIAL.

    " Determine current maximum version
    SELECT FROM zaemi_config FIELDS MAX( version )
    INTO @DATA(max_version).

    " Update version with running index starting from max + 1
    MODIFY ENTITIES OF zaemi_config IN LOCAL MODE
    ENTITY config
    UPDATE FIELDS ( version )
    WITH VALUE #( FOR config IN configs INDEX INTO index ( %tky = config-%tky version = max_version + index ) ).

  ENDMETHOD.

  METHOD createnewversion.
    " Clone selected configurations with all compositions into a new version

    " Prepare create tables for various composition entities
    DATA: create_configs                 TYPE TABLE FOR CREATE zaemi_config,
          create_tiers                   TYPE TABLE FOR CREATE zaemi_config\_tier,
          create_extension_styles        TYPE TABLE FOR CREATE zaemi_config\_extensionstyle,
          create_extension_domains       TYPE TABLE FOR CREATE zaemi_config\_extensiondomain,
          create_building_blocks         TYPE TABLE FOR CREATE zaemi_config\_buildingblock,
          create_on_stack_domains        TYPE TABLE FOR CREATE zaemi_config\_onstackextensiondomain,
          create_techext_building_blocks TYPE TABLE FOR CREATE zaemi_config\_techextensionbuildingblock,
          create_areas                   TYPE TABLE FOR CREATE zaemi_config\_area.

    " Read root entities
    READ ENTITIES OF zaemi_config IN LOCAL MODE
      ENTITY config
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(configs)
      FAILED DATA(failed_configs).

    " Read compositions
    READ ENTITIES OF zaemi_config IN LOCAL MODE
      ENTITY config BY \_tier
      ALL FIELDS WITH CORRESPONDING #( configs )
      RESULT DATA(tiers)
      FAILED DATA(failed_tiers).

    READ ENTITIES OF zaemi_config IN LOCAL MODE
      ENTITY config BY \_extensiondomain
      ALL FIELDS WITH CORRESPONDING #( configs )
      RESULT DATA(extension_domains)
      FAILED DATA(failed_extension_domains).

    READ ENTITIES OF zaemi_config IN LOCAL MODE
      ENTITY config BY \_extensionstyle
      ALL FIELDS WITH CORRESPONDING #( configs )
      RESULT DATA(extension_styles)
      FAILED DATA(failed_extension_styles).

    READ ENTITIES OF zaemi_config IN LOCAL MODE
      ENTITY config BY \_onstackextensiondomain
      ALL FIELDS WITH CORRESPONDING #( configs )
      RESULT DATA(on_stack_domains)
      FAILED DATA(failed_onst_extension_domains).

    READ ENTITIES OF zaemi_config IN LOCAL MODE
      ENTITY config BY \_buildingblock
      ALL FIELDS WITH CORRESPONDING #( configs )
      RESULT DATA(building_blocks)
      FAILED DATA(failed_building_blocks).

    READ ENTITIES OF zaemi_config IN LOCAL MODE
      ENTITY config BY \_area
      ALL FIELDS WITH CORRESPONDING #( configs )
      RESULT DATA(areas)
      FAILED DATA(failed_areas).

    READ ENTITIES OF zaemi_config IN LOCAL MODE
      ENTITY config BY \_techextensionbuildingblock
      ALL FIELDS WITH CORRESPONDING #( configs )
      RESULT DATA(tech_extension_building_blocks)
      FAILED DATA(failed_techext_building_blocks).

    " Build deep create payload for each config
    LOOP AT configs ASSIGNING FIELD-SYMBOL(<config>).

      " Get current max version for zaemi_config
      SELECT FROM zaemi_config FIELDS MAX( version ) INTO @DATA(max_version).

      " Create new config version with incremented version number
      APPEND VALUE #( %cid  = keys[ KEY entity id = <config>-id ]-%cid
                      %data = CORRESPONDING #( <config> EXCEPT id ) )
        TO create_configs ASSIGNING FIELD-SYMBOL(<create_config>).

      <create_config>-active  = abap_false.
      <create_config>-version = max_version + sy-index.

      " Handle tier composition
      APPEND VALUE #( %cid_ref = <create_config>-%cid )
        TO create_tiers ASSIGNING FIELD-SYMBOL(<create_tier>).

      LOOP AT tiers ASSIGNING FIELD-SYMBOL(<tier>).
        IF <tier>-configid = <config>-id.
          APPEND VALUE #( %cid  = <create_config>-%cid && <tier>-id
                          %data = CORRESPONDING #( <tier> EXCEPT configid ) )
            TO <create_tier>-%target ASSIGNING FIELD-SYMBOL(<create_tier_n>).

        ENDIF.
      ENDLOOP.

      " Handle extension_style composition
      APPEND VALUE #( %cid_ref = <create_config>-%cid )
        TO create_extension_styles ASSIGNING FIELD-SYMBOL(<create_extension_style>).

      LOOP AT extension_styles ASSIGNING FIELD-SYMBOL(<extension_style>).
        IF <extension_style>-configid = <config>-id.
          APPEND VALUE #( %cid  = <create_config>-%cid && <extension_style>-id
                          %data = CORRESPONDING #( <extension_style> EXCEPT configid ) )
            TO <create_extension_style>-%target ASSIGNING FIELD-SYMBOL(<create_extension_style_n>).
        ENDIF.
      ENDLOOP.

      " Handle extension domain composition
      APPEND VALUE #( %cid_ref = <create_config>-%cid )
        TO create_extension_domains ASSIGNING FIELD-SYMBOL(<create_extension_domain>).

      LOOP AT extension_domains ASSIGNING FIELD-SYMBOL(<extension_domain>).
        IF <extension_domain>-configid = <config>-id.
          APPEND VALUE #( %cid  = <create_config>-%cid && <extension_domain>-id
                          %data = CORRESPONDING #( <extension_domain> EXCEPT configid ) )
            TO <create_extension_domain>-%target ASSIGNING FIELD-SYMBOL(<create_extension_domain_n>).
        ENDIF.
      ENDLOOP.

      " Handle building block composition
      APPEND VALUE #( %cid_ref = <create_config>-%cid )
        TO create_building_blocks ASSIGNING FIELD-SYMBOL(<create_building_block>).

      LOOP AT building_blocks ASSIGNING FIELD-SYMBOL(<building_block>).
        IF <building_block>-configid = <config>-id.
          APPEND VALUE #( %cid  = <create_config>-%cid && <building_block>-id
                          %data = CORRESPONDING #( <building_block> EXCEPT configid ) )
            TO <create_building_block>-%target ASSIGNING FIELD-SYMBOL(<create_building_block_n>).
        ENDIF.
      ENDLOOP.

      " Handle area composition
      APPEND VALUE #( %cid_ref = <create_config>-%cid )
        TO create_areas ASSIGNING FIELD-SYMBOL(<create_area>).

      LOOP AT areas ASSIGNING FIELD-SYMBOL(<area>).
        IF <area>-configid = <config>-id.
          APPEND VALUE #( %cid  = <create_config>-%cid && <area>-id
                          %data = CORRESPONDING #( <area> EXCEPT configid ) )
            TO <create_area>-%target ASSIGNING FIELD-SYMBOL(<create_area_n>).
        ENDIF.
      ENDLOOP.

      " Handle on-stack extension domain composition
      APPEND VALUE #( %cid_ref = <create_config>-%cid )
        TO create_on_stack_domains ASSIGNING FIELD-SYMBOL(<create_on_stack_domain>).

      LOOP AT on_stack_domains ASSIGNING FIELD-SYMBOL(<on_stack_domain>).
        IF <on_stack_domain>-configid = <config>-id.
          APPEND VALUE #( %cid  = <create_config>-%cid && <on_stack_domain>-id
                          %data = CORRESPONDING #( <on_stack_domain> EXCEPT configid ) )
            TO <create_on_stack_domain>-%target ASSIGNING FIELD-SYMBOL(<create_on_stack_domain_n>).
        ENDIF.
      ENDLOOP.

      " Handle extension_building_block composition
      APPEND VALUE #( %cid_ref = <create_config>-%cid )
        TO create_techext_building_blocks ASSIGNING FIELD-SYMBOL(<create_techext_build_block>).

      LOOP AT tech_extension_building_blocks ASSIGNING FIELD-SYMBOL(<extension_building_block>).
        IF <extension_building_block>-configid = <config>-id.
          APPEND VALUE #( %cid  = <create_config>-%cid && <extension_building_block>-id
                          %data = CORRESPONDING #( <extension_building_block> EXCEPT configid ) )
            TO <create_techext_build_block>-%target ASSIGNING FIELD-SYMBOL(<create_techext_build_block_n>).
        ENDIF.
      ENDLOOP.

    ENDLOOP.

    " Write new entities to DB
    MODIFY ENTITIES OF zaemi_config IN LOCAL MODE
      ENTITY config
        CREATE FIELDS ( active title version )
        WITH create_configs
      ENTITY config
        CREATE BY \_tier
        FIELDS ( title )
        WITH create_tiers
      ENTITY config
        CREATE BY \_extensiondomain
        FIELDS ( title )
        WITH create_extension_domains
      ENTITY config
        CREATE BY \_buildingblock
        FIELDS ( title )
        WITH create_building_blocks
      ENTITY config
        CREATE BY \_area
        FIELDS ( title )
        WITH create_areas
      ENTITY config
        CREATE BY \_onstackextensiondomain
        FIELDS ( title )
        WITH create_on_stack_domains
      ENTITY config
        CREATE BY \_extensionstyle
        FIELDS ( title tierid )
        WITH create_extension_styles
      ENTITY config
        CREATE BY \_techextensionbuildingblock
        FIELDS ( title tierid extensiondomainid buildingblockid )
        WITH create_techext_building_blocks
      MAPPED DATA(create_mapped).

    " Fix foreign keys in extension style using mapped IDs
    READ ENTITIES OF zaemi_config IN LOCAL MODE
        ENTITY config BY \_extensionstyle
        ALL FIELDS WITH CORRESPONDING #( create_mapped-config )
        RESULT DATA(mod_extension_styles).

    LOOP AT mod_extension_styles ASSIGNING FIELD-SYMBOL(<mod_extension_styles>).
      DATA(lv_old_tierid) = CONV string( <mod_extension_styles>-tierid ).
      LOOP AT create_mapped-tier ASSIGNING FIELD-SYMBOL(<new_tier>) WHERE %cid CS lv_old_tierid.
        <mod_extension_styles>-tierid = <new_tier>-id.
      ENDLOOP.
    ENDLOOP.

    " Persist updated tierid in extension style
    MODIFY ENTITIES OF zaemi_config IN LOCAL MODE
        ENTITY extensionstyle
        UPDATE FIELDS ( tierid )
        WITH VALUE #( FOR mod_extension_style IN mod_extension_styles ( %tky = mod_extension_style-%tky tierid = mod_extension_style-tierid ) ).

    " Read created tech extension building blocks for FK correction
    READ ENTITIES OF zaemi_config IN LOCAL MODE
        ENTITY config BY \_techextensionbuildingblock
        ALL FIELDS WITH CORRESPONDING #( create_mapped-config )
        RESULT DATA(mod_techext_build_blocks).

    " Fix tierid, buildingblockid and extensiondomainid via mapped IDs
    LOOP AT mod_techext_build_blocks ASSIGNING FIELD-SYMBOL(<mod_techext_build_block>).
      lv_old_tierid = CONV string( <mod_techext_build_block>-tierid ).
      LOOP AT create_mapped-tier ASSIGNING <new_tier> WHERE %cid CS lv_old_tierid.
        <mod_techext_build_block>-tierid = <new_tier>-id.
      ENDLOOP.

      DATA(lv_old_buildingblockid) = CONV string( <mod_techext_build_block>-buildingblockid ).
      LOOP AT create_mapped-buildingblock ASSIGNING FIELD-SYMBOL(<new_buildingblock>) WHERE %cid CS lv_old_buildingblockid.
        <mod_techext_build_block>-buildingblockid = <new_buildingblock>-id.
      ENDLOOP.

      DATA(lv_old_extensiondomainid) = CONV string( <mod_techext_build_block>-extensiondomainid ).
      LOOP AT create_mapped-extensiondomain ASSIGNING FIELD-SYMBOL(<new_extensiondomain>) WHERE %cid CS lv_old_extensiondomainid.
        <mod_techext_build_block>-extensiondomainid = <new_extensiondomain>-id.
      ENDLOOP.
    ENDLOOP.

    " Persist updated foreign keys for tech extension building block
    MODIFY ENTITIES OF zaemi_config IN LOCAL MODE
        ENTITY techextensionbuildingblock
        UPDATE FIELDS ( tierid buildingblockid extensiondomainid )
        WITH VALUE #( FOR mod_techext_build_block IN mod_techext_build_blocks (
        %tky = mod_techext_build_block-%tky
        tierid = mod_techext_build_block-tierid
        buildingblockid = mod_techext_build_block-buildingblockid extensiondomainid = mod_techext_build_block-extensiondomainid ) ).

    " Return mapped output
    mapped-config = create_mapped-config.

  ENDMETHOD.

  METHOD precheck_delete.
    READ ENTITIES OF zaemi_config IN LOCAL MODE
    ENTITY config
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(configs).

    LOOP AT configs ASSIGNING FIELD-SYMBOL(<config>) WHERE active = abap_true.
      APPEND VALUE #( %tky = <config>-%tky ) TO failed-config.

      APPEND VALUE #( %tky = keys[ 1 ]-%tky
                      %msg = new_message_with_text(
                               severity = if_abap_behv_message=>severity-error
                               text     = 'Can not delete active config'
                             ) ) TO reported-config.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
