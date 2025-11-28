CLASS lhc_zr_biglietto_mb2 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR Biglietto
        RESULT result,
      earlynumbering_create FOR NUMBERING
        IMPORTING entities FOR CREATE Biglietto,
      ValidateStato FOR VALIDATE ON SAVE
        IMPORTING keys FOR Biglietto~ValidateStato,
      GetDefaultsForCreate FOR READ
        IMPORTING keys FOR FUNCTION Biglietto~GetDefaultsForCreate RESULT result,
      get_instance_features FOR INSTANCE FEATURES
        IMPORTING keys REQUEST requested_features FOR Biglietto RESULT result,
      onSave FOR DETERMINE ON SAVE
        IMPORTING keys FOR Biglietto~onSave,
*      onChange FOR DETERMINE ON MODIFY
*        IMPORTING keys FOR Biglietto~onChange,
      CustomDelete FOR MODIFY
        IMPORTING keys FOR ACTION Biglietto~CustomDelete RESULT result.
ENDCLASS.

CLASS lhc_zr_biglietto_mb2 IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD earlynumbering_create.
    DATA: lv_id TYPE zr_biglietto_mb2-idbiglietto.
* SELECT MAX( IdBiglietto ) AS max_id
*  FROM zr_biglietto_mb2 INTO @DATA(lv_max_id).

*    WITH +big AS (
*      SELECT MAX( IdBiglietto )  AS max_id
*      FROM zr_biglietto_mb2
*      UNION
*      SELECT MAX( IdBiglietto )  AS max_id
*      FROM zbiglietto_mb2_d
*    )    SELECT MAX( max_id ) FROM +big INTO @DATA(lv_max_id) .

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_biglietto>).

      IF <fs_biglietto>-IdBiglietto IS NOT INITIAL.
        lv_id = <fs_biglietto>-IdBiglietto.
      ELSE.

* Renge numerazione ZID_BIG_MB
        TRY.
            cl_numberrange_runtime=>number_get(
              EXPORTING
                nr_range_nr = '01'
                object      = 'ZID_BIG_MB'
                quantity = '1'
              IMPORTING
                number      = DATA(lv_max)
                returncode = DATA(code)
                returned_quantity = DATA(return_qty) ).

          CATCH cx_nr_object_not_found INTO DATA(lx_obj_not_found).
          CATCH cx_number_ranges INTO DATA(lx_ranges_error).

            LOOP AT entities INTO DATA(entity_line).

              APPEND VALUE #( %cid = entity_line-%cid
                              %key  = entity_line-%key ) TO failed-biglietto.
              APPEND VALUE #( %cid = entity_line-%cid
                              %key = entity_line-%key
                              %msg = lx_ranges_error ) TO reported-biglietto.
            ENDLOOP.
            EXIT.
        ENDTRY.



*        lv_max_id += 1.
        lv_id = lv_max. "lv_max_id.
      ENDIF.
      APPEND VALUE #( %cid = <fs_biglietto>-%cid
                      %is_draft = <fs_biglietto>-%is_draft
                      IdBiglietto = lv_id ) TO mapped-biglietto.

    ENDLOOP.
  ENDMETHOD.

  METHOD ValidateStato.
    DATA:
        lt_biglietto TYPE TABLE FOR READ RESULT zr_biglietto_mb2.
    READ ENTITIES OF zr_biglietto_mb2 IN LOCAL MODE
    ENTITY Biglietto
    FIELDS (  Stato )
    WITH CORRESPONDING #( keys )
    RESULT lt_biglietto.

    LOOP AT lt_biglietto ASSIGNING FIELD-SYMBOL(<fs_biglietto>)
    WHERE stato <> 'BOZZA' AND stato <> 'FINALE' AND stato <> 'CANC'.
      APPEND VALUE #( %tky = <fs_biglietto>-%tky
                     ) TO failed-biglietto.

      APPEND VALUE #( %tky = <fs_biglietto>-%tky
                      %msg = NEW zcx_error_big_mb( textid = zcx_error_big_mb=>invalid_stat
                                                   iv_stato = <fs_biglietto>-Stato
                                                   severity = if_abap_behv_message=>severity-error )
                      %element-Stato = if_abap_behv=>mk-on
*                        %element-CreatoDa = if_abap_behv=>mk-on
                                         ) TO reported-biglietto.


    ENDLOOP.
  ENDMETHOD.

  METHOD GetDefaultsForCreate.
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_key>).

      result = VALUE #( FOR key IN keys (
               %cid = key-%cid
               %param-stato = 'BOZZA'
                ) ).

    ENDLOOP.
  ENDMETHOD.

  METHOD get_instance_features.
    DATA:
      lt_biglietto TYPE TABLE FOR READ RESULT zr_biglietto_mb2,
      ls_result    LIKE LINE OF result.
    READ ENTITIES OF zr_biglietto_mb2 IN LOCAL MODE
    ENTITY Biglietto
    FIELDS (  Stato )
    WITH CORRESPONDING #( keys )
    RESULT lt_biglietto.
    LOOP AT lt_biglietto ASSIGNING FIELD-SYMBOL(<fs_biglietto>).
      CLEAR ls_result.
      ls_result-%tky = <fs_biglietto>-%tky.
      ls_result-%field-Stato = if_abap_behv=>fc-f-read_only.
      IF <fs_biglietto>-Stato =   'FINALE'.
        ls_result-%action-CustomDelete = if_abap_behv=>fc-o-enabled  .
      ELSE.
        ls_result-%action-CustomDelete = if_abap_behv=>fc-o-disabled  .
      ENDIF.
      APPEND ls_result TO result.
    ENDLOOP.

  ENDMETHOD.

  METHOD onSave.
    DATA:
      lt_biglietto TYPE TABLE FOR READ RESULT zr_biglietto_mb2,
      lt_update    TYPE TABLE FOR UPDATE zr_biglietto_mb2.

    READ ENTITIES OF zr_biglietto_mb2 IN LOCAL MODE
    ENTITY Biglietto
    FIELDS (  Stato )
    WITH CORRESPONDING #( keys )
    RESULT lt_biglietto.
    LOOP AT lt_biglietto INTO DATA(ls_biglietto) WHERE stato = 'BOZZA'.

      APPEND VALUE #( %tky = ls_biglietto-%tky
                             Stato = 'FINALE'
                             %control-Stato = if_abap_behv=>mk-on ) TO lt_update.
    ENDLOOP.

    MODIFY ENTITIES OF zr_biglietto_mb2 IN LOCAL MODE
      ENTITY Biglietto
      UPDATE FROM lt_update.


  ENDMETHOD.

*  METHOD onChange.
*    DATA:
*      lt_biglietto TYPE TABLE FOR READ RESULT zr_biglietto_mb2,
*      lt_update    TYPE TABLE FOR UPDATE zr_biglietto_mb2.
*
*    READ ENTITIES OF zr_biglietto_mb2 IN LOCAL MODE
*    ENTITY Biglietto
*    FIELDS (  Stato )
*    WITH CORRESPONDING #( keys )
*    RESULT lt_biglietto.
*    LOOP AT lt_biglietto INTO DATA(ls_biglietto) WHERE stato = 'FINALE'.
*
*      APPEND VALUE #( %tky = ls_biglietto-%tky
*                             Stato = 'BOZZA'
*                             %control-Stato = if_abap_behv=>mk-on ) TO lt_update.
*    ENDLOOP.
*
*    MODIFY ENTITIES OF zr_biglietto_mb2 IN LOCAL MODE
*      ENTITY Biglietto
*      UPDATE FROM lt_update.
*  ENDMETHOD.

  METHOD CustomDelete.
    DATA:
      lt_biglietto TYPE TABLE FOR READ RESULT zr_biglietto_mb2.

    READ ENTITIES OF zr_biglietto_mb2 IN LOCAL MODE
    ENTITY Biglietto
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT lt_biglietto.
    LOOP AT lt_biglietto INTO DATA(ls_biglietto).
      MODIFY ENTITIES OF zr_biglietto_mb2 IN LOCAL MODE
             ENTITY Biglietto
             UPDATE FROM VALUE #( ( %tky               = ls_biglietto-%tky
                                    Stato             = 'CANC'
                                    %control-Stato = if_abap_behv=>mk-on ) ).
      ls_biglietto-stato = 'CANC'.
      INSERT VALUE #( %tky = ls_biglietto-%tky
                     %param = ls_biglietto ) INTO TABLE result.
    ENDLOOP.

*  DATA:
*      lt_update TYPE TABLE FOR UPDATE zr_biglietto_gf2,
*      ls_update LIKE LINE OF lt_update.
*
*    READ ENTITIES OF zr_biglietto_gf2
*        IN LOCAL MODE
*        ENTITY Biglietto
*        ALL FIELDS
*        WITH CORRESPONDING #( keys )
*        RESULT DATA(lt_biglietto).
*    LOOP AT lt_biglietto
*            ASSIGNING FIELD-SYMBOL(<biglietto>).
*      <biglietto>-Stato = 'CANC'.
*      APPEND VALUE #(
*              %tky = <biglietto>-%tky
*              %param = <biglietto> )
*          TO result.
*      ls_update = CORRESPONDING #( <biglietto> ).
*      ls_update-%control-Stato = if_abap_behv=>mk-on.
*      APPEND ls_update
*        TO lt_update.
*    ENDLOOP.
*
*    MODIFY ENTITIES OF zr_biglietto_gf2
*        IN LOCAL MODE
*        ENTITY Biglietto
*        UPDATE FROM lt_update.
  ENDMETHOD.

ENDCLASS.
