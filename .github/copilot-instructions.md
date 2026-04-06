# AI Coding Assistant Instructions for avinash_dbt_tutorial

## Project Overview
This is a **dbt (data build tool) + Python** project implementing a Databricks-based data pipeline using the **medallion architecture** (bronze → silver → gold layers). The primary focus is dbt data modeling and transformation logic.

## Architecture

### Medallion Design Pattern
- **Bronze**: Raw ingestion tables (direct `SELECT *` from sources) - see [models/bronze/](avinash_dbt_tutorial/models/bronze/)
- **Silver**: Cleaned/normalized layer (empty; planned for transformation)
- **Gold**: Business-ready aggregated layer (empty; planned for analytics)

### Data Flow
1. External sources defined in [models/source/sources.yml](avinash_dbt_tutorial/models/source/sources.yml) → `dbt_tutorial_dev.source` schema
2. Bronze models materialize as **tables** (configured in [dbt_project.yml](avinash_dbt_tutorial/dbt_project.yml#L37-39))
3. Each layer writes to separate schema: `bronze`, `silver`, `gold`

### Key Components
- **Profiles**: [profiles.yml](avinash_dbt_tutorial/profiles.yml) - Databricks connection config
- **Models**: SQL templates with Jinja (source references, dynamic logic)
- **Macros**: [macros/generate_schema.sql](avinash_dbt_tutorial/macros/generate_schema.sql) - schema generation override
- **Tests**: Custom generic tests in [tests/generic/](avinash_dbt_tutorial/tests/generic/)
- **Seeds**: Lookup data as CSV in [seeds/](avinash_dbt_tutorial/seeds/)

## Critical Developer Workflows

### Running dbt Commands
```bash
# From avinash_dbt_tutorial/ directory
dbt run          # Execute all models (bronze layer currently active)
dbt test         # Run column tests + custom generic tests
dbt seed         # Load CSV data from seeds/
dbt compile      # Parse + generate compiled SQL in target/compiled/
dbt snapshot     # Execute snapshots (if defined)
dbt clean        # Remove target/ and dbt_packages/
```

### Test Execution
- Column-level tests defined in [models/bronze/properties.yml](avinash_dbt_tutorial/models/bronze/properties.yml) using YAML syntax
- Example tests: `unique`, `not_null`, `accepted_values`, `generic_non_negative` (custom)
- Test severity configurable: `severity: warn` (default) or `error`

## Convention-Specific Patterns

### Model Naming & Configuration
- Files have **case-sensitive** names; YAML model references must match exactly (e.g., `bronze_date.sql` → name: `bronze_date`)
- Materialization set globally per layer in [dbt_project.yml](avinash_dbt_tutorial/dbt_project.yml#L37-39): bronze/silver/gold = `table`
- Override per-model in config block: `config: {materialized: view, schema: bronze}`

### Jinja Usage
- **Source references**: `{{ source('source', 'dim_customer') }}` - uses `sources.yml` definitions
- **Dynamic variables**: `{%- set var_name = "Avinash_Rajak" -%}` - used in analyses
- **Macros**: Custom schema generation via `generate_schema_name()` macro

### Testing Patterns
- **Generic tests**: `generic_non_negative` macro ([tests/generic/generic_non_negative.sql](avinash_dbt_tutorial/tests/generic/generic_non_negative.sql)) validates non-negative numeric columns
- **Test configuration**: Column tests in YAML with conditional severity
- **Accepted values**: Use `accepted_values` test with values list and severity config (see [properties.yml#L22-23](avinash_dbt_tutorial/models/bronze/properties.yml#L22-23) for country validation)

### Analysis Files
- [analyses/](avinash_dbt_tutorial/analyses/) contains exploratory SQL (jinja-1/2/3.sql, 1_explore.sql)
- No materialization; used for ad-hoc exploration and Jinja learning

## Integration Points & Dependencies

### Databricks Connection
- Configured via [profiles.yml](avinash_dbt_tutorial/profiles.yml) (not in repo; user-maintained)
- Requires `dbt-databricks>=1.10.9` adapter for SQL Warehouse/Cluster compatibility
- Python dependencies: `dbt-core>=1.11.5`, `dbt-databricks>=1.10.9` (see [pyproject.toml](pyproject.toml#L9-10))

### Python entrypoint
- [main.py](main.py) currently minimal; placeholder for orchestration or data validation

### Build Artifacts
- [target/manifest.json](avinash_dbt_tutorial/target/manifest.json) - dbt project metadata (compiled models, dependencies)
- [target/compiled/](avinash_dbt_tutorial/target/compiled/) - rendered SQL for debugging
- [target/run_results.json](avinash_dbt_tutorial/target/run_results.json) - test/run execution summary

## When Modifying Code

1. **Adding Bronze Models**: Follow [bronze_customer.sql](avinash_dbt_tutorial/models/bronze/bronze_customer.sql) pattern (simple `SELECT *`), add YAML config to [properties.yml](avinash_dbt_tutorial/models/bronze/properties.yml)
2. **Adding Tests**: Create column tests in properties.yml OR generic test in [tests/generic/](avinash_dbt_tutorial/tests/generic/) for reusable validation
3. **Schema/Materialization Changes**: Modify [dbt_project.yml](avinash_dbt_tutorial/dbt_project.yml) model config or model-level `config()` block
4. **Source Changes**: Update [sources.yml](avinash_dbt_tutorial/models/source/sources.yml) with new tables/database references

## Key Files Reference
- **dbt config**: [dbt_project.yml](avinash_dbt_tutorial/dbt_project.yml)
- **source definitions**: [models/source/sources.yml](avinash_dbt_tutorial/models/source/sources.yml)
- **bronze model tests**: [models/bronze/properties.yml](avinash_dbt_tutorial/models/bronze/properties.yml)
- **custom test logic**: [tests/generic/generic_non_negative.sql](avinash_dbt_tutorial/tests/generic/generic_non_negative.sql)
- **macro library**: [macros/](avinash_dbt_tutorial/macros/)
