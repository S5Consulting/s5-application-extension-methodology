@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Building Block'
@Metadata.allowExtensions: true
@Search.searchable: true


define view entity ZAEMC_AREA
  as projection on ZAEMI_AREA as Area
{
      @UI.facet: [
        {
          id:            'Area',
          type:          #IDENTIFICATION_REFERENCE,
          label:         'Area',
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
