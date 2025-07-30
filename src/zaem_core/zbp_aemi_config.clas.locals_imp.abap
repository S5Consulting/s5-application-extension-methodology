CLASS lhc_config DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
       IMPORTING REQUEST requested_authorizations FOR config RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR config RESULT result.
    METHODS get_global_features FOR GLOBAL FEATURES
      IMPORTING REQUEST requested_features FOR config RESULT result.
    METHODS setdefault FOR MODIFY
      IMPORTING keys FOR ACTION config~setdefault RESULT result.
ENDCLASS.

CLASS lhc_config IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_global_features.
  ENDMETHOD.

  METHOD setdefault.

    DATA all_keys LIKE keys.

    SELECT id
    FROM zaemi_config INTO CORRESPONDING FIELDS OF TABLE @all_keys.

    MODIFY ENTITIES OF zaemi_config IN LOCAL MODE
      ENTITY config
        UPDATE
          FIELDS ( defaultconfig )
          WITH VALUE #( FOR key IN all_keys
                         ( %tky         = key-%tky
                           defaultconfig = abap_false ) )

     FAILED failed
     REPORTED reported.


    MODIFY ENTITIES OF zaemi_config IN LOCAL MODE
        ENTITY config
          UPDATE
            FIELDS ( defaultconfig )
            WITH VALUE #( FOR key IN keys
                           ( %tky         = key-%tky
                             defaultconfig = abap_true ) )

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
        <result>-%param-defaultconfig = abap_true.
      ELSE.
        <result>-%param-defaultconfig = abap_false.
      ENDIF.
    ENDLOOP.


  ENDMETHOD.

ENDCLASS.
