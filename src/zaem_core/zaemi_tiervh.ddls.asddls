@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.representativeKey: 'TierID'
@EndUserText.label: 'Tier VH'
@Search.searchable: true
define view entity ZAEMI_TIERVH
  as select from    ZAEMI_COMBO_TIERVH as Tier
    left outer join ZAEMI_CONFIG       as Config on Config.Id = Tier.ConfigId
{

      @EndUserText.label: 'Id'
      @UI.hidden: true
  key Tier.Id       as TierId,
      @EndUserText.label: 'Config Id'
      @UI.hidden: true
  key Tier.ConfigId,
      @EndUserText.label: 'Tier'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
      Tier.Title    as TierTitle,
      @UI.hidden: true
      Config.Active as IsActive

}
where
  Tier.Title is not initial
