@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.representativeKey: 'Id'
@EndUserText.label: 'Building Block'
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true
define view entity ZAEMI_COMBO_BBLOCKVH
  as select from    zaema_bblock  as BuildingBlock
    left outer join zaemdr_bblock as BuildingBlockDraft on  BuildingBlock.id        = BuildingBlockDraft.id
                                             and BuildingBlock.config_id = BuildingBlockDraft.configid
{

  key BuildingBlock.id                            as Id,
  key BuildingBlock.config_id                     as ConfigId,
      @Search.defaultSearchElement: true
      BuildingBlock.title                         as Title
} where BuildingBlockDraft.draftentityoperationcode is null or BuildingBlockDraft.draftentityoperationcode <> 'D'

union select from zaemdr_bblock as BuildingBlockDraft
{

  key BuildingBlockDraft.id                       as Id,
  key BuildingBlockDraft.configid                 as ConfigId,
      BuildingBlockDraft.title                    as Title
} where BuildingBlockDraft.draftentityoperationcode <> 'D'
