//@AbapCatalog.sqlViewName: 'ZAEMICONFIG'
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Application Methodology Config'
define root view entity ZAEMI_CONFIG
  as select from zaema_config
  composition [0..*] of ZAEMI_TIER     as _Tier
  composition [0..*] of ZAEMI_EXTDOM   as _ExtensionDomain
  composition [0..*] of ZAEMI_OSEDOM   as _OnStackExtensionDomain
  composition [0..*] of ZAEMI_EXTSTYLE as _ExtensionStyle
  composition [0..*] of ZAEMI_BBLOCK   as _BuildingBlock
  composition [0..*] of ZAEMI_AREA     as _Area
  composition [0..*] of ZAEMI_TEBBLOCK as _TechExtensionBuildingBlock
{
  key id                    as Id,
      title                 as Title,
      active                as Active,
      version               as Version,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      _Tier,
      _ExtensionDomain,
      _ExtensionStyle,
      _OnStackExtensionDomain,
      _BuildingBlock,
      _Area,
      _TechExtensionBuildingBlock
}
