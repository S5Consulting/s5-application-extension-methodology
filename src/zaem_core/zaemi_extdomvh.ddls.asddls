@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.representativeKey: 'ExtensionDomainID'
@EndUserText.label: 'Extension Domain VH'
@Search.searchable: true
define view entity ZAEMI_EXTDOMVH
  as select from ZAEMI_COMBO_EXTDOMVH as ExtensionDomain
{

      @EndUserText.label: 'Id'
      @UI.hidden: true
  key Id    as ExtensionDomainId,
      @EndUserText.label: 'Config Id'
      @UI.hidden: true
  key ConfigId,
      @EndUserText.label: 'ExtensionDomain'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
      Title as ExtensionDomainTitle
} 
