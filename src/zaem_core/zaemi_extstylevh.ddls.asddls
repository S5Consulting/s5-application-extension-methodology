@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.representativeKey: 'ExtensionStyleId'
@EndUserText.label: 'Extension Style VH'
@Search.searchable: true
define view entity ZAEMI_EXTSTYLEVH
  as select from    ZAEMI_EXTSTYLE as ExtensionStyle
    left outer join ZAEMI_CONFIG   as Config on Config.Id = ExtensionStyle.ConfigId
    left outer join ZAEMI_TIER     as Tier   on Tier.Id = ExtensionStyle.TierId
{
      @EndUserText.label: 'Id'
      @UI.hidden: true
  key ExtensionStyle.Id     as ExtensionStyleId,
      @EndUserText.label: 'Config Id'
      @UI.hidden: true
  key ExtensionStyle.ConfigId,
      @EndUserText.label: 'Tier'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
      Tier.Title            as TierTitle,
      @EndUserText.label: 'Extension Style'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
      ExtensionStyle.Title  as ExtensionStyleTitle,
      @UI.hidden: true
      ExtensionStyle.TierId as TierId,
      @UI.hidden: true
      Config.Active         as IsActive
}
