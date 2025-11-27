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

ENDCLASS.
