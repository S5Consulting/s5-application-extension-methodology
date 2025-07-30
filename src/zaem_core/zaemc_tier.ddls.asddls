@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Extention Style'
@Metadata.allowExtensions: true
@Search.searchable: true


define view entity ZAEMC_TIER
  as projection on ZAEMI_TIER as Tier
{
      @UI.facet: [
        {
          id:            'Tiers',
          type:          #IDENTIFICATION_REFERENCE,
          label:         'Tier',
          purpose: #STANDARD
        }
      ]

      @EndUserText.label: 'Id'
  key Id,
      @EndUserText.label: 'Config Id'
  key ConfigId,
      @EndUserText.label: 'Title'
      @Search.defaultSearchElement: true
      Title,
      LastChangedAt,
      LocalLastChangedAt,

      _Config : redirected to parent ZAEMC_CONFIG
}
