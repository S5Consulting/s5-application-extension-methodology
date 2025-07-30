@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.representativeKey: 'TierID'
@EndUserText.label: 'Tier VH'
@Search.searchable: true
define view entity ZAEMI_TIERVH
  as select from ZAEMI_COMBO_TIERVH as Tier
{

      @EndUserText.label: 'Id'
      @UI.hidden: true
  key Id    as TierId,
      @EndUserText.label: 'Config Id'
      @UI.hidden: true
  key ConfigId,
      @EndUserText.label: 'Tier'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
      Title as TierTitle
} 
