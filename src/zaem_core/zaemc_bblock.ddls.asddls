@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Building Block'
@Metadata.allowExtensions: true
@Search.searchable: true


define view entity ZAEMC_BBLOCK
  as projection on ZAEMI_BBLOCK as BuildingBlock
{
      @UI.facet: [
        {
          id:            'BuildingBlock',
          type:          #IDENTIFICATION_REFERENCE,
          label:         'Building Block',
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
