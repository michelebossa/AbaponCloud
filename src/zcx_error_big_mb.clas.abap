CLASS zcx_error_big_mb DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_abap_behv_message .
    INTERFACES if_t100_message .
    INTERFACES if_t100_dyn_msg .
    CONSTANTS:
      gc_messsage_class TYPE sy-msgid VALUE 'ZERR_BIGL_MB',
      BEGIN OF invalid_stat,
        msgid TYPE symsgid VALUE gc_messsage_class,
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'GV_STATO',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_stat.
    DATA:
        gv_stato TYPE zr_biglietto_mb2-Stato.
    METHODS constructor
      IMPORTING
        !textid   LIKE if_t100_message=>t100key OPTIONAL
        !previous LIKE previous OPTIONAL
        severity  TYPE if_abap_behv_message=>t_severity OPTIONAL
        iv_stato  TYPE zr_biglietto_mb2-Stato OPTIONAL.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcx_error_big_mb IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor(
    previous = previous
    ).
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
    if_abap_behv_message~m_severity = severity.
    gv_stato = iv_stato.

  ENDMETHOD.


ENDCLASS.
