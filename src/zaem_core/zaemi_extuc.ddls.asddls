@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Extention Use Case'
define root view entity ZAEMI_EXTUC
  as select from zaema_extuc
  composition [0..*] of ZAEMI_SCENE   as _Scene
  composition [0..*] of ZAEMI_EXTTASK as _ExtTask
  association to ZAEMI_AREAVH         as _AreaVH on $projection.AreaId = _AreaVH.areaid
{
  key id                    as Id,
      title                 as Title,
      area_id               as AreaId,
      business_context      as BusinessContext,
      diagram               as Diagram,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      _Scene,
      _ExtTask,
      _AreaVH
}
