@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.representativeKey: 'Id'
@EndUserText.label: 'extdom VH'
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true
define view entity ZAEMI_COMBO_EXTDOMVH
  as select from    zaema_extdom  as ExtensionDomain
    left outer join zaemdr_extdom as ExtensionDomainDraft on  ExtensionDomain.id        = ExtensionDomainDraft.id
                                             and ExtensionDomain.config_id = ExtensionDomainDraft.configid
{

  key ExtensionDomain.id                            as Id,
  key ExtensionDomain.config_id                     as ConfigId,
      @Search.defaultSearchElement: true
      ExtensionDomain.title                         as Title
} where ExtensionDomainDraft.draftentityoperationcode is null or ExtensionDomainDraft.draftentityoperationcode <> 'D'

union select from zaemdr_extdom as ExtensionDomainDraft
{

  key ExtensionDomainDraft.id                       as Id,
  key ExtensionDomainDraft.configid                 as ConfigId,
      ExtensionDomainDraft.title                    as Title
} where ExtensionDomainDraft.draftentityoperationcode <> 'D'
