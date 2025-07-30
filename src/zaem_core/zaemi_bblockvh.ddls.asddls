@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.representativeKey: 'BuildingBlockID'
@EndUserText.label: 'Building Block VH'
@Search.searchable: true
define view entity ZAEMI_BBLOCKVH
  as select from ZAEMI_COMBO_BBLOCKVH as BuildingBlock
{

      @EndUserText.label: 'Id'
      @UI.hidden: true
  key Id    as BuildingBlockId,
      @EndUserText.label: 'Config Id'
      @UI.hidden: true
  key ConfigId,
      @EndUserText.label: 'BuildingBlock'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
      Title as BuildingBlockTitle
} 
