@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Technical Extension Building Block'
@Metadata.allowExtensions: true
@Search.searchable: true


define view entity ZAEMC_TEBBLOCK
  as projection on ZAEMI_TEBBLOCK as TechExtensionBuildingBlock
{

      @UI.facet: [
        {
          id:            'TechExtensionBuildingBlock',
          type:          #IDENTIFICATION_REFERENCE,
          label:         'Technical Extension Building Block',
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
      _TierVH.TierTitle                       as Tier,

      @Consumption.valueHelpDefinition: [ {
      entity: { name: 'ZAEMI_EXTDOMVH', element: 'ExtensionDomainId' },
      additionalBinding: [{ localElement: 'ConfigId', element: 'ConfigId', usage: #FILTER }]
      } ]
      @EndUserText.label: 'Extension Domain'
      @Search.defaultSearchElement: true
      @UI.textArrangement: #TEXT_ONLY
      @ObjectModel.text.element: [ 'ExtensionDomain' ]
      ExtensionDomainId,
      _ExtensionDomainVH.ExtensionDomainTitle as ExtensionDomain,


      @Consumption.valueHelpDefinition: [ {
      entity: { name: 'ZAEMI_BBLOCKVH', element: 'BuildingBlockId' },
      additionalBinding: [{ localElement: 'ConfigId', element: 'ConfigId', usage: #FILTER }]
      } ]
      @EndUserText.label: 'Building Block'
      @Search.defaultSearchElement: true
      @UI.textArrangement: #TEXT_ONLY
      @ObjectModel.text.element: [ 'BuildingBlock' ]
      BuildingBlockId,
      _BuildingBlockVH.BuildingBlockTitle     as BuildingBlock,

      LastChangedAt,
      LocalLastChangedAt,

      _Config : redirected to parent ZAEMC_CONFIG,

      _TierVH



}
