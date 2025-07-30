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

ENDCLASS.

CLASS lhc_config IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_global_features.
  ENDMETHOD.

  METHOD setactive.

    DATA all_keys LIKE keys.

    SELECT id
    FROM zaemi_config INTO CORRESPONDING FIELDS OF TABLE @all_keys.

    MODIFY ENTITIES OF zaemi_config IN LOCAL MODE
      ENTITY config
        UPDATE
          FIELDS ( active )
          WITH VALUE #( FOR key IN all_keys
                         ( %tky         = key-%tky
                           active = abap_false ) )

     FAILED failed
     REPORTED reported.


    MODIFY ENTITIES OF zaemi_config IN LOCAL MODE
        ENTITY config
          UPDATE
            FIELDS ( active )
            WITH VALUE #( FOR key IN keys
                           ( %tky         = key-%tky
                             active = abap_true ) )

       FAILED failed
       REPORTED reported.


    " Fill the response table
    READ ENTITIES OF zaemi_config IN LOCAL MODE
      ENTITY config
        ALL FIELDS WITH CORRESPONDING #( all_keys )
      RESULT DATA(configs).

    result = VALUE #( FOR config IN configs
                        ( %tky   = config-%tky
                          %param = config ) ).

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
    READ ENTITIES OF zaemi_config IN LOCAL MODE
      ENTITY config
      FIELDS ( version )
      WITH CORRESPONDING #( keys )
      RESULT DATA(configs).

    DELETE configs WHERE version IS NOT INITIAL.

    CHECK configs IS NOT INITIAL.

    SELECT FROM zaemi_config FIELDS MAX( version )
    INTO @DATA(max_version).

    MODIFY ENTITIES OF zaemi_config IN LOCAL MODE
    ENTITY zaemi_config
    UPDATE FIELDS ( version )
    WITH VALUE #( FOR config IN configs INDEX INTO index ( %tky = config-%tky version = max_version + index ) ).

  ENDMETHOD.

  METHOD createnewversion.

    " Prepare create tables for various composition entities
    DATA: create_configs             TYPE TABLE FOR CREATE zaemi_config,
          create_tiers               TYPE TABLE FOR CREATE zaemi_config\_tier,
          create_extension_domains   TYPE TABLE FOR CREATE zaemi_config\_extensiondomain,
          create_building_blocks     TYPE TABLE FOR CREATE zaemi_config\_buildingblock,
          create_on_stack_domains    TYPE TABLE FOR CREATE zaemi_config\_onstackextensiondomain,
          create_areas               TYPE TABLE FOR CREATE zaemi_config\_area.

    " Read root entities
    READ ENTITIES OF zaemi_config IN LOCAL MODE
      ENTITY zaemi_config
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(configs)
      FAILED DATA(failed_configs).

    " Read compositions
    READ ENTITIES OF zaemi_config IN LOCAL MODE
      ENTITY zaemi_config BY \_tier
      ALL FIELDS WITH CORRESPONDING #( configs )
      RESULT DATA(tiers)
      FAILED DATA(failed_tiers).

    READ ENTITIES OF zaemi_config IN LOCAL MODE
      ENTITY zaemi_config BY \_extensiondomain
      ALL FIELDS WITH CORRESPONDING #( configs )
      RESULT DATA(extension_domains)
      FAILED DATA(failed_extension_domains).

    READ ENTITIES OF zaemi_config IN LOCAL MODE
      ENTITY zaemi_config BY \_extensionstyle
      ALL FIELDS WITH CORRESPONDING #( configs )
      RESULT DATA(extension_styles)
      FAILED DATA(failed_extension_styles).

    READ ENTITIES OF zaemi_config IN LOCAL MODE
      ENTITY zaemi_config BY \_onstackextensiondomain
      ALL FIELDS WITH CORRESPONDING #( configs )
      RESULT DATA(on_stack_domains)
      FAILED DATA(failed_onst_extension_domains).

    READ ENTITIES OF zaemi_config IN LOCAL MODE
      ENTITY zaemi_config BY \_buildingblock
      ALL FIELDS WITH CORRESPONDING #( configs )
      RESULT DATA(building_blocks)
      FAILED DATA(failed_building_blocks).

    READ ENTITIES OF zaemi_config IN LOCAL MODE
      ENTITY zaemi_config BY \_area
      ALL FIELDS WITH CORRESPONDING #( configs )
      RESULT DATA(areas)
      FAILED DATA(failed_areas).

    READ ENTITIES OF zaemi_config IN LOCAL MODE
      ENTITY zaemi_config BY \_techextensionbuildingblock
      ALL FIELDS WITH CORRESPONDING #( configs )
      RESULT DATA(tech_extension_building_blocks)
      FAILED DATA(failed_techext_building_blocks).

    " Process each root config entry
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

    ENDLOOP.

    " Write new entities to DB
    MODIFY ENTITIES OF zaemi_config IN LOCAL MODE
      ENTITY zaemi_config
        CREATE FIELDS ( active title version )
        WITH create_configs
      ENTITY zaemi_config
        CREATE BY \_tier
        FIELDS ( title )
        WITH create_tiers
      ENTITY zaemi_config
        CREATE BY \_extensiondomain
        FIELDS ( title )
        WITH create_extension_domains
      ENTITY zaemi_config
        CREATE BY \_buildingblock
        FIELDS ( title )
        WITH create_building_blocks
      ENTITY zaemi_config
        CREATE BY \_area
        FIELDS ( title )
        WITH create_areas
      ENTITY zaemi_config
        CREATE BY \_onstackextensiondomain
        FIELDS ( title )
        WITH create_on_stack_domains
      MAPPED DATA(create_mapped).

    " Return mapped output
    mapped-config = create_mapped-config.

  ENDMETHOD.


ENDCLASS.
