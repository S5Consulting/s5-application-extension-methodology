@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Area'
define view entity ZAEMI_AREA
  as select from zaema_area
    association to parent ZAEMI_CONFIG as _Config on $projection.ConfigId = _Config.Id
{

  key id                    as Id,
  key config_id             as ConfigId,
      title                 as Title,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      
      _Config
}
