@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.representativeKey: 'AreaId'
@EndUserText.label: 'Area VH'
@Search.searchable: true
define view entity ZAEMI_AREAVH
  as select from    ZAEMI_AREA   as Area
    left outer join ZAEMI_CONFIG as Config on Config.Id = Area.ConfigId
{
      @EndUserText.label: 'Id'
      @UI.hidden: true
  key Area.Id       as AreaId,
      @EndUserText.label: 'Config Id'
      @UI.hidden: true
  key Area.ConfigId,
      @EndUserText.label: 'Area'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
      Area.Title    as AreaTitle,
      @UI.hidden: true
      Config.Active as IsActive
}
