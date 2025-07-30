@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for On Stack Extension Domain'
@Metadata.allowExtensions: true
@Search.searchable: true


define view entity ZAEMC_OSEDOM
  as projection on ZAEMI_OSEDOM as OnStackExtDomain
{
      @UI.facet: [
        {
          id:            'ExtentionDomain',
          type:          #IDENTIFICATION_REFERENCE,
          label:         'Extention Domain',
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
