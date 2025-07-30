@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Extention Style'
@Metadata.allowExtensions: true
@Search.searchable: true


define view entity ZAEMC_EXTSTYLE
  as projection on ZAEMI_EXTSTYLE as ExtentionStyle
{
      @UI.facet: [
        {
          id:            'ExtentionStyle',
          type:          #IDENTIFICATION_REFERENCE,
          label:         'Extention Style',
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

      @Consumption.valueHelpDefinition: [ {
      entity: { name: 'ZAEMI_TIERVH', element: 'TierId' },
      additionalBinding: [{ localElement: 'ConfigId', element: 'ConfigId', usage: #FILTER }]
      } ]
      @EndUserText.label: 'Tier'
      @Search.defaultSearchElement: true
      @UI.textArrangement: #TEXT_ONLY
      @ObjectModel.text.element: [ 'Tier' ]
      TierId,
      _TierVH.TierTitle as Tier,

      //      @EndUserText.label: 'Description'
      //      Description,`

      LastChangedAt,
      LocalLastChangedAt,

      _Config : redirected to parent ZAEMC_CONFIG,

      _TierVH
}
