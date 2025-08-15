@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Scene'
define view entity ZAEMI_SCENE
  as select from zaema_scene
  association to parent ZAEMI_EXTUC as _UseCase on $projection.UseCaseId = _UseCase.Id
{

  key id                    as Id,
  key use_case_id           as UseCaseId,
      title                 as Title,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      _UseCase
}
