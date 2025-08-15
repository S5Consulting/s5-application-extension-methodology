@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Scene'
@Metadata.allowExtensions: true
@Search.searchable: true


define view entity ZAEMC_SCENE
  as projection on ZAEMI_SCENE as Scene
{
      @UI.facet: [
        {
          id:            'Scene',
          type:          #IDENTIFICATION_REFERENCE,
          label:         'Scene',
          purpose: #STANDARD
        }
      ]

      @EndUserText.label: 'Id'
  key Id,
      @EndUserText.label: 'Use Case Id'
  key UseCaseId,
      @EndUserText.label: 'Title'
      @Search.defaultSearchElement: true
      Title,
      LastChangedAt,
      LocalLastChangedAt,

      _UseCase : redirected to parent ZAEMC_EXTUC
}
