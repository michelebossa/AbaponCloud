CLASS zcl_mb_estrazione_flight DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_mb_estrazione_flight IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA: lt_flights TYPE TABLE OF /dmo/flight,
          ls_flight  TYPE /dmo/flight.

    " Select flight data from the SFLIGHT table
    SELECT * FROM /dmo/flight INTO TABLE @lt_flights.

    out->write( 'Flight Data Extraction:' ).

    LOOP AT lt_flights INTO ls_flight.
      out->write( ls_flight ).

    enDLOOP.
  ENDMETHOD.
ENDCLASS.
