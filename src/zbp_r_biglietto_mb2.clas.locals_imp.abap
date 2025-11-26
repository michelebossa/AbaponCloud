CLASS lhc_zr_biglietto_mb2 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR Biglietto
        RESULT result,
      earlynumbering_create FOR NUMBERING
        IMPORTING entities FOR CREATE Biglietto.
ENDCLASS.

CLASS lhc_zr_biglietto_mb2 IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD earlynumbering_create.
    DATA: lv_id TYPE zr_biglietto_mb2-idbiglietto.
* SELECT MAX( IdBiglietto ) AS max_id
*  FROM zr_biglietto_mb2 INTO @DATA(lv_max_id).

    WITH +big AS (
      SELECT MAX( IdBiglietto )  AS max_id
      FROM zr_biglietto_mb2
      UNION
      SELECT MAX( IdBiglietto )  AS max_id
      FROM zbiglietto_mb2_d
    )    SELECT MAX( max_id ) FROM +big INTO @DATA(lv_max_id) .

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_biglietto>).

      IF <fs_biglietto>-IdBiglietto IS NOT INITIAL.
        lv_id = <fs_biglietto>-IdBiglietto.
      ELSE.

* Renge numerazione ZID_BIG_MB



*        TRY.
*            DATA(lo_get_number) = cl_numberrange_buffer=>get_instance( ).
*            lo_get_number->if_numberrange_buffer~number_get_no_buffer( EXPORTING
*            iv_object    = 'ZID_BIG_MB'
*             iv_subobject = '01'
*                                                           iv_interval  = '01'
*                                                                 iv_quantity  = 1
*                                             iv_ignore_buffer     = abap_true
*                                                              IMPORTING
*            ev_number    = DATA(lv_max)
**                                             ev_returned_quantity = lv_returned_qunatity
*                                                         ).
*          CATCH cx_number_ranges INTO DATA(lr_error).
*        ENDTRY.
        lv_max_id += 1.
        lv_id = lv_max_id.
      ENDIF.
      APPEND VALUE #( %cid = <fs_biglietto>-%cid
                      %is_draft = <fs_biglietto>-%is_draft
                      IdBiglietto = lv_id ) TO mapped-biglietto.

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
