@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Extension Task'
define view entity ZAEMI_EXTTASK
  as select from zaema_exttask
  association to parent ZAEMI_EXTUC as _UseCase    on $projection.UseCaseId = _UseCase.Id
  association to ZAEMI_TIERVH       as _TierVH     on $projection.TierId = _TierVH.TierId
  association to ZAEMI_EXTSTYLEVH   as _ExtStyleVH on $projection.ExtensionStyleId = _ExtStyleVH.ExtensionStyleId

{

  key id                           as Id,
  key use_case_id                  as UseCaseId,
      name                         as Name,
      tier_id                      as TierId,
      extension_style_id           as ExtensionStyleId,
      extension_domain_id          as ExtensionDomainId,
      on_stack_domain_id           as OnStackDomainId,
      extension_tier_id            as ExtensionTierId,
      technical_extension_block_id as TechnicalExtensionBlockId,
      guidance                     as Guidance,
      reasoning                    as Reasoning,
      scene_id                     as SceneId,
      requirement_id               as RequirementId,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at              as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at        as LocalLastChangedAt,

      _UseCase,
      _TierVH,
      _ExtStyleVH
}
