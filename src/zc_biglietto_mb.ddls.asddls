@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_BIGLIETTO_MB
  provider contract transactional_query 
  as projection on ZR_BIGLIETTO_MB as Biglietto
{
    key IdBiglietto,
    CreatoDa,
    CreatoA,
    ModificatoDa,
    ModificatoA,
    Modificato
}
