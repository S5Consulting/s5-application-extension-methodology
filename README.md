# SAP Application Extension Methodology

## Purpose

## Repository Layout
```
/
├── src/                          ABAP backend (RAP artefacts, abapGit format)
│   ├── ddls/                     CDS view entities
│   ├── ddlx/                     CDS projection views
│   ├── behv/                     RAP behavior definitions / implementations
│   ├── clas/                     ABAP classes (service behavior, unit tests)
│   ├── srvd/                     Service definitions
│   ├── srvb/                     Service bindings
│   └── metadata.xml              abapGit manifest
├── s5-aem-maintain/              Fiori Elements V4 admin app (configuration UI)
├── s5-aem-overview/              Freestyle SAPUI5 overview app (placeholder)
└── .abapgit.xml                  abapGit repository descriptor
```

## Domain Model – Maintenance Tables

| Entity                          | Key(s)                                   | Additional Fields      | Description                                                                 |
|---------------------------------|-------------------------------------------|-------------------------|-----------------------------------------------------------------------------|
| `Tier`                          | `Client`, `Id`, `ConfigId`               | `Title`                 | Logical layer of a software system (e.g. *Presentation*, *Application*, *Data*). |
| `ExtensionStyle`               | `Client`, `Id`, `ConfigId`               | `TierId`, `Title`       | How an extension is realised **within** a tier (e.g. *UI Extension*, *New UI*, *Business Logic Extension*). |
| `ExtensionDomain`             | `Client`, `Id`, `ConfigId`               | `Title`                 | Deployment domain of the extension (e.g. *Side‑by‑Side*, *On‑Stack*).       |
| `OnStackExtensionDomain`      | `Client`, `Id`, `ConfigId`               | `Title`                 | Flavours of **on‑stack** extensibility (*SAP Standard*, *Key‑User*, *Developer*). |
| `BuildingBlock`               | `Client`, `Id`, `ConfigId`               | `Title`                 | Technical building block used to implement an extension (e.g. *Freestyle SAPUI5*, *Fiori Elements*, *SAP Build Apps*). |
| `TechnicalExtensionBuildingBlock` | `Client`, `Id`, `ConfigId`           | `TierId`, `ExtensionDomainId`, `BuildingBlockId`, `Title` | Mapping of building blocks to tiers and domains.                             |
| `Area`                         | `Client`, `Id`, `ConfigId`               | `Title`                 | Functional area that can be extended (e.g. *Finance*, *HR*).                |
| `Configuration`               | `Client`, `Id`                            | `Title`, `DefaultConfig`| Root entity grouping configuration entities for extensibility methodology.  |

### Relationships

| From Entity                      | To Entity                      | Cardinality        | Relationship Type                  | Description                                                                 |
|----------------------------------|--------------------------------|--------------------|------------------------------------|-----------------------------------------------------------------------------|
| `ExtensionStyle`                | `Tier`                         | N:1                | Foreign Key (`TierId`)             | Each extension style belongs to one tier.                                   |
| `TechnicalExtensionBuildingBlock` | `Tier`                       | N:1                | Foreign Key (`TierId`)             | Each technical mapping is assigned to a single tier.                        |
| `TechnicalExtensionBuildingBlock` | `ExtensionDomain`           | N:1                | Foreign Key (`ExtensionDomainId`)  | Each mapping is assigned to a single extension domain.                      |
| `TechnicalExtensionBuildingBlock` | `BuildingBlock`             | N:1                | Foreign Key (`BuildingBlockId`)    | Each mapping uses one building block.                                       |
| `ExtensionStyle`, `TechnicalExtensionBuildingBlock`, `Area`, `BuildingBlock`, `Tier`, `ExtensionDomain`, `OnStackExtensionDomain` | `Configuration` | N:1 | Foreign Key (`ConfigId`)               | All config entities are scoped by a configuration.                          |

## Value Help Views – CDS Interface Views

| CDS View Entity                  | Backing Table         | Key(s)                 | Label Field           | Type     | Purpose                                 |
|----------------------------------|------------------------|------------------------|------------------------|----------|-----------------------------------------|
| `ZAEMI_TIERVH`                   | `ZAEMA_TIER`           | `ID`, `CONFIG_ID`      | `TITLE`                | Simple   | Value help for tier.                    |
| `ZAEMI_COMBO_TIERVH`            | `ZAEMA_TIER`           | `ID`, `CONFIG_ID`      | `TITLE`                | Combo    | Used for dropdown with config filtering.|
| `ZAEMI_EXTDOMVH`                | `ZAEMA_EXTDOM`         | `ID`, `CONFIG_ID`      | `TITLE`                | Simple   | Value help for extension domain.        |
| `ZAEMI_COMBO_EXTDOMVH`         | `ZAEMA_EXTDOM`         | `ID`, `CONFIG_ID`      | `TITLE`                | Combo    | Used for dropdown with config filtering.|
| `ZAEMI_BBLOCKVH`                | `ZAEMA_BBLOCK`         | `ID`, `CONFIG_ID`      | `TITLE`                | Simple   | Value help for building block.          |
| `ZAEMI_COMBO_BBLOCKVH`         | `ZAEMA_BBLOCK`         | `ID`, `CONFIG_ID`      | `TITLE`                | Combo    | Used for dropdown with config filtering.|

## ABAP RAP Backend (`src/`)

| Artefact Type             | Naming Pattern                      | Role                                                                 |
|---------------------------|--------------------------------------|----------------------------------------------------------------------|
| CDS View Entity           | `ZAEMC_<entity>.ddls.xml`            | Persistency layer (interface views, e.g. `ZAEMC_TIER`).              |
| CDS Projection View       | `ZAEMI_<entity>.ddls.xml`            | UI/service exposure layer (e.g. `ZAEMI_TIER`).                       |
| CDS Value Help View       | `ZAEMI_<entity>VH.ddls.xml`          | Used as value help in UI annotations.                               |
| CDS Combo Value Help View | `ZAEMI_COMBO_<entity>VH.ddls.xml`   | Filtered value help with config scoping.                            |
| Behavior Definition       | `ZAEMC_<entity>.bdef.xml`           | Managed RAP behavior (create/update/delete, validations).           |
| Behavior Implementation   | `ZBP_AEMI_<entity>.clas.abap`       | ABAP logic (validations, determinations) for behavior.              |
| Service Definition        | `ZAEM_EXPOSE_<object>.srvd.xml`     | Exposes projection views (e.g. `CONFIG`, `EXTUC`).                  |
| Service Binding           | `ZAEMUI_<object>_V4.srvb.xml`       | OData V4 binding for Fiori/UI clients.                              |
| Service UI Variant        | `ZAEMUI_<object>_V2_VAN.iwvb.xml`   | In-app extension variant config (for key-user extensibility).       |
| Unit Test Class           | `ZBP_AEMI_<entity>_TEST.clas.abap`  | Unit tests (jeśli występują).                                       |

## UI5 Applications
### `s5-aem-maintain`
Fiori Elements **List Report – Object Page** (OData V4).

### `s5-aem-overview`
Freestyle SAPUI5 shell (placeholder). Currently contains minimal `Component.js` and `App.view.xml`. Road‑map: KPI cards, diagram of extension strategy.
