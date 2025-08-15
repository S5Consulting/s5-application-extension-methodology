CLASS lhc_extusecase DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.


    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR extusecase RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR extusecase RESULT result.
    METHODS get_global_features FOR GLOBAL FEATURES
      IMPORTING REQUEST requested_features FOR extusecase RESULT result.
    METHODS checkconsistency FOR DETERMINE ON SAVE
      IMPORTING keys FOR extusecase~checkconsistency.

ENDCLASS.

CLASS lhc_extusecase IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_global_authorizations.

  ENDMETHOD.

  METHOD get_global_features.

  ENDMETHOD.

  METHOD checkconsistency.

    READ ENTITIES OF zaemi_extuc IN LOCAL MODE
    ENTITY extusecase
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(extusecases)
    FAILED DATA(failed_extusecases).

  ENDMETHOD.

ENDCLASS.
