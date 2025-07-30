@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Technical Extension Building Block'
define view entity ZAEMI_TEBBLOCK
  as select from zaema_tebblock
  association to parent ZAEMI_CONFIG as _Config            on  $projection.ConfigId = _Config.Id
  association to ZAEMI_TIERVH        as _TierVH            on  $projection.TierId   = _TierVH.TierId
                                                           and $projection.ConfigId = _TierVH.ConfigId
  association to ZAEMI_EXTDOMVH      as _ExtensionDomainVH on  $projection.ExtensionDomainId = _ExtensionDomainVH.ExtensionDomainId
                                                           and $projection.ConfigId          = _ExtensionDomainVH.ConfigId
  association to ZAEMI_BBLOCKVH      as _BuildingBlockVH   on  $projection.BuildingBlockId = _BuildingBlockVH.BuildingBlockId
                                                           and $projection.ConfigId        = _BuildingBlockVH.ConfigId
{

  key id                    as Id,
  key config_id             as ConfigId,
      title                 as Title,
      tier_id               as TierId,
      extension_domain_id   as ExtensionDomainId,
      building_block_id     as BuildingBlockId,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      _Config,
      _TierVH,
      _ExtensionDomainVH,
      _BuildingBlockVH
}
