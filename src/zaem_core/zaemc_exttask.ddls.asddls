@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Extension Task'
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity ZAEMC_EXTTASK
  as projection on ZAEMI_EXTTASK as ExtTask
{

      @UI.facet: [
        {
          id:            'ExtTask',
          type:          #IDENTIFICATION_REFERENCE,
          label:         'Extension Task',
          purpose:       #STANDARD
        }
      ]

      @EndUserText.label: 'Id'
  key Id,

      @EndUserText.label: 'Use Case Id'
  key UseCaseId,

      @EndUserText.label: 'Name'
      @Search.defaultSearchElement: true
      Name,

      @Consumption.valueHelpDefinition: [ {
        entity: { name: 'ZAEMI_TIERVH', element: 'TierId' },
        additionalBinding: [{ localConstant: 'X', element: 'IsActive', usage: #FILTER }]
      } ]
      @EndUserText.label: 'Tier'
      @Search.defaultSearchElement: true
      @UI.textArrangement: #TEXT_ONLY
      @ObjectModel.text.element: [ 'Tier' ]
      TierId,
      _TierVH.TierTitle               as Tier,

      @Consumption.valueHelpDefinition: [ {
        entity: { name: 'ZAEMI_EXTSTYLEVH', element: 'ExtensionStyleId' },
        additionalBinding: [{ localElement: 'TierId', element: 'TierId', usage: #FILTER }] }]
      @EndUserText.label: 'Extension Style'
      @Search.defaultSearchElement: true
      @UI.textArrangement: #TEXT_ONLY
      @ObjectModel.text.element: [ 'ExtensionStyle' ]
      ExtensionStyleId,
      _ExtStyleVH.ExtensionStyleTitle as ExtensionStyle,

      //  _ExtensionStyleVH.ExtensionStyleTitle as ExtensionStyle,

      //  @Consumption.valueHelpDefinition: [ {
      //    entity: { name: 'ZAEMI_EXTDOMVH', element: 'ExtensionDomainId' }
      //  } ]
      @EndUserText.label: 'Extension Domain'
      //  @Search.defaultSearchElement: true
      //  @UI.textArrangement: #TEXT_ONLY
      //  @ObjectModel.text.element: [ 'ExtensionDomain' ]
      ExtensionDomainId,
      //  _ExtensionDomainVH.ExtensionDomainTitle as ExtensionDomain,

      //  @Consumption.valueHelpDefinition: [ {
      //    entity: { name: 'ZAEMI_ONSTACKDOMVH', element: 'OnStackDomainId' }
      //  } ]
      @EndUserText.label: 'On Stack Domain'
      //  @UI.textArrangement: #TEXT_ONLY
      //  @ObjectModel.text.element: [ 'OnStackDomain' ]
      OnStackDomainId,
      //  _OnStackDomainVH.OnStackDomainTitle as OnStackDomain,

      //  @Consumption.valueHelpDefinition: [ {
      //    entity: { name: 'ZAEMI_TIERVH', element: 'ExtensionTierId' }
      //  } ]
      @EndUserText.label: 'Extension Tier'
      //  @UI.textArrangement: #TEXT_ONLY
      //  @ObjectModel.text.element: [ 'ExtensionTier' ]
      ExtensionTierId,
      //  _ExtensionTierVH.TierTitle as ExtensionTier,

      //  @Consumption.valueHelpDefinition: [ {
      //    entity: { name: 'ZAEMI_TEBBLOCKVH', element: 'TechnicalExtensionBlockId' }
      //  } ]
      @EndUserText.label: 'Technical Extension Block'
      //  @UI.textArrangement: #TEXT_ONLY
      //  @ObjectModel.text.element: [ 'TechnicalExtensionBlock' ]
      TechnicalExtensionBlockId,
      //  _TechnicalExtensionBlockVH.TechnicalExtensionBlockTitle as TechnicalExtensionBlock,

      Guidance,
      Reasoning,

      //  @Consumption.valueHelpDefinition: [ {
      //    entity: { name: 'ZAEMI_SCENEVH', element: 'SceneId' }
      //  } ]
      @EndUserText.label: 'Scene'
      //  @UI.textArrangement: #TEXT_ONLY
      //  @ObjectModel.text.element: [ 'Scene' ]
      SceneId,
      //  _SceneVH.SceneTitle as Scene,

      //  @Consumption.valueHelpDefinition: [ {
      //    entity: { name: 'ZAEMI_REQUIREMENTVH', element: 'RequirementId' }
      //  } ]
      @EndUserText.label: 'Requirement'
      //  @UI.textArrangement: #TEXT_ONLY
      //  @ObjectModel.text.element: [ 'Requirement' ]
      RequirementId,
      //  _RequirementVH.RequirementTitle as Requirement,

      LastChangedAt,
      LocalLastChangedAt,

      _UseCase : redirected to parent ZAEMC_EXTUC,



      _TierVH
      //  _ExtensionStyleVH,
      //  _ExtensionDomainVH,
      //  _OnStackDomainVH,
      //  _ExtensionTierVH,
      //  _TechnicalExtensionBlockVH,
      //  _SceneVH,
      //  _RequirementVH

}
