@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Extention Style'
define view entity ZAEMI_EXTSTYLE
  as select from zaema_extstyle
  association to parent ZAEMI_CONFIG as _Config on  $projection.ConfigId = _Config.Id
  association to ZAEMI_TIERVH        as _TierVH on  $projection.TierId   = _TierVH.TierId
                                                and $projection.ConfigId = _TierVH.ConfigId
{

  key id                    as Id,
  key config_id             as ConfigId,
      title                 as Title,
      tier_id               as TierId,
//      description           as Description,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      _Config,
      _TierVH
}
