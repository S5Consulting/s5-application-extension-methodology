@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Application Methodology Config'
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZAEMC_CONFIG
  as projection on ZAEMI_CONFIG as Config
{
      @EndUserText.label: 'Id'
  key Id,
      @EndUserText.label: 'Title'
      @Search.defaultSearchElement: true
      Title,

      @EndUserText.label: 'Active'
      @Search.defaultSearchElement: true
      Active,
      @EndUserText.label: 'Version'
      @Search.defaultSearchElement: true
      Version,

      LastChangedAt,
      LocalLastChangedAt,

      _Tier                       : redirected to composition child ZAEMC_TIER,
      _ExtensionDomain            : redirected to composition child ZAEMC_EXTDOM,
      _ExtensionStyle             : redirected to composition child ZAEMC_EXTSTYLE,
      _OnStackExtensionDomain     : redirected to composition child ZAEMC_OSEDOM,
      _BuildingBlock              : redirected to composition child ZAEMC_BBLOCK,
      _TechExtensionBuildingBlock : redirected to composition child ZAEMC_TEBBLOCK,
      _Area                       : redirected to composition child ZAEMC_AREA



}
