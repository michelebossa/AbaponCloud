@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZCOMPONENTI_MB'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define view entity ZR_COMPONENTI_MB
  as select from zcomponenti_mb
  association to parent ZR_BIGLIETTO_MB2 as _Biglietto 
  on _Biglietto.IdBiglietto = $projection.IdBiglietto
{ 
  key id_biglietto as IdBiglietto,
  key progressivo as Progressivo,
  tipo_utente as TipoUtente,
  @Semantics.user.createdBy: true
  creato_da as CreatoDa,
  @Semantics.systemDateTime.createdAt: true
  creato_a as CreatoA,
  @Semantics.user.lastChangedBy: true
  modificato_da as ModificatoDa,
  @Semantics.systemDateTime.lastChangedAt: true
  modificato_a as ModificatoA,
  //@Semantics.systemDateTime.localInstanceLastChangedAt: true
  //locallastchanged as Locallastchanged,
  //Associations
  _Biglietto 
}
