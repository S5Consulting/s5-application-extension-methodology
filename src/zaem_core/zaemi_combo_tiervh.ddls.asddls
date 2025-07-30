@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.representativeKey: 'Id'
@EndUserText.label: 'Tier VH'
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true
define view entity ZAEMI_COMBO_TIERVH
  as select from    zaema_tier  as Tier
    left outer join zaemdr_tier as TierDraft on  Tier.id        = TierDraft.id
                                             and Tier.config_id = TierDraft.configid
{

  key Tier.id                            as Id,
  key Tier.config_id                     as ConfigId,
      @Search.defaultSearchElement: true
      Tier.title                         as Title
} where TierDraft.draftentityoperationcode is null or TierDraft.draftentityoperationcode <> 'D'

union select from zaemdr_tier as TierDraft
{

  key TierDraft.id                       as Id,
  key TierDraft.configid                 as ConfigId,
      TierDraft.title                    as Title
} where TierDraft.draftentityoperationcode <> 'D'
