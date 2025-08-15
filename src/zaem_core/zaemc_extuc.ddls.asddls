@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Extention Use Case'
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZAEMC_EXTUC
  as projection on ZAEMI_EXTUC as ExtUseCase
{
      @EndUserText.label: 'Id'
  key Id,
      @EndUserText.label: 'Title'
      @Search.defaultSearchElement: true
      Title,

      @Consumption.valueHelpDefinition: [ {
      entity: { name: 'ZAEMI_AREAVH', element: 'AreaId' },
      additionalBinding: [{ localConstant: 'X', element: 'IsActive', usage: #FILTER }]
      } ]
      @EndUserText.label: 'Area'
      @Search.defaultSearchElement: true
      @UI.textArrangement: #TEXT_ONLY
      @ObjectModel.text.element: [ 'Area' ]
      AreaId,
      _AreaVH.AreaTitle as Area,

      @EndUserText.label: 'Business Context'
      @Search.defaultSearchElement: true
      BusinessContext,
      @EndUserText.label: 'Diagram'
      Diagram,
      LastChangedAt,
      LocalLastChangedAt,

      _Scene   : redirected to composition child ZAEMC_SCENE,
      _ExtTask : redirected to composition child ZAEMC_EXTTASK

}
