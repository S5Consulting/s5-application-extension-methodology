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
      @EndUserText.label: 'Area'
      @Search.defaultSearchElement: true
      Area,
      @EndUserText.label: 'Business Context'
      @Search.defaultSearchElement: true
      BusinessContext,
      @EndUserText.label: 'Diagram'
      Diagram,
      LastChangedAt,
      LocalLastChangedAt
}
