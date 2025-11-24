CLASS zcl_mb_hello_cloud DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
  methods:
    _m_test
        IMPORTING
            VALUE(iv_input) TYPE string
        RETURNING
            VALUE(rv_output) TYPE string.
ENDCLASS.



CLASS zcl_mb_hello_cloud IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    out->write( _m_test( 'MB'  ) ).
  ENDMETHOD.
  meTHOD _m_test.
    rv_output = |Ciao {  iv_input } |.
    enDMETHOD.
ENDCLASS.
