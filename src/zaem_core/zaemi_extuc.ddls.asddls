@AbapCatalog.sqlViewName: 'ZAEMIEXTUC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Extention Use Case'
define root view ZAEMI_EXTUC
  as select from zaema_extuc
{
  key id                    as Id,
      title                 as Title,
      area                  as Area,
      business_context      as BusinessContext,
      diagram               as Diagram,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt
}
