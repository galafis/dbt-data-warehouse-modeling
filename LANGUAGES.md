# 🗣️ Languages and Technologies Used

## Overview

This repository is a **dbt (data build tool)** project for modern data warehouse modeling. The primary languages and technologies used are optimized for analytics engineering and data transformation workflows.

## Primary Languages

### 1. SQL (Structured Query Language) 📊
- **Files**: 18 SQL files
- **Purpose**: Core language for all data transformations
- **Location**: 
  - `models/staging/*.sql` - Staging layer models
  - `models/intermediate/*.sql` - Intermediate transformations
  - `models/marts/**/*.sql` - Marts layer (facts and dimensions)
  - `macros/*.sql` - Reusable SQL macros
  - `snapshots/*.sql` - SCD Type 2 snapshots
  - `tests/*.sql` - Custom data quality tests
- **Details**: 
  - SQL is embedded with Jinja templating for dynamic query generation
  - Dialect: PostgreSQL (compatible with most SQL databases)
  - Used for SELECT statements, CTEs, window functions, aggregations, and joins

### 2. YAML (YAML Ain't Markup Language) 📋
- **Files**: 7 YAML files
- **Purpose**: Configuration, documentation, and test definitions
- **Location**:
  - `models/**/_*.yml` - Model and column documentation with schema tests
  - `dbt_project.yml` - Project configuration
  - `.github/workflows/dbt-ci.yml` - CI/CD pipeline configuration
  - `.user.yml` - User configuration
- **Details**:
  - Defines data tests (unique, not_null, relationships, accepted_values)
  - Documents models and columns for auto-generated docs
  - Configures materialization strategies and other dbt settings

### 3. Jinja (Template Engine) 🎨
- **Files**: Embedded in all SQL files
- **Purpose**: Dynamic SQL generation and code reusability
- **Location**: Throughout SQL files in `{{ }}` and `{% %}` blocks
- **Details**:
  - Used for macros like `{{ ref() }}` and `{{ source() }}`
  - Enables conditional logic (`{% if %}`, `{% for %}`)
  - Powers incremental models with `{{ is_incremental() }}`
  - Custom macros in `macros/` directory

## Supporting Technologies

### 4. PostgreSQL 🐘
- **Purpose**: Target database for development and CI/CD
- **Details**: 
  - SQL dialect used for all transformations
  - Runs in GitHub Actions for automated testing
  - Can be swapped for Snowflake, BigQuery, Redshift, etc.

### 5. Python 🐍
- **Purpose**: dbt runtime environment
- **Details**:
  - dbt is a Python-based CLI tool
  - No custom Python code in this repository
  - Used only for running dbt commands (`dbt run`, `dbt test`, etc.)

### 6. Markdown 📝
- **Files**: 8 documentation files
- **Purpose**: Documentation and guides
- **Location**:
  - `README.md` - Main project documentation
  - `CONTRIBUTING.md` - Contribution guidelines
  - `docs/*.md` - Additional documentation
- **Note**: Marked as `linguist-documentation` in `.gitattributes`

### 7. CSV (Comma-Separated Values) 📈
- **Files**: Seeds in `seeds/` directory
- **Purpose**: Reference data (e.g., country codes, lookup tables)
- **Details**: Static data loaded into the warehouse for joining

## Language Configuration

This repository includes a `.gitattributes` file that helps GitHub Linguist properly detect and display the languages used:

```gitattributes
# SQL - Primary language
*.sql linguist-language=SQL
*.sql linguist-detectable=true

# YAML - Configuration and documentation
*.yml linguist-language=YAML
*.yaml linguist-language=YAML

# Exclude generated/vendored files
target/** linguist-vendored
dbt_packages/** linguist-vendored
logs/** linguist-vendored

# Ensure models, tests, macros count as code
models/** linguist-vendored=false
tests/** linguist-vendored=false
macros/** linguist-vendored=false
```

## File Statistics

| Language | Files | Purpose |
|----------|-------|---------|
| SQL | 18 | Data transformations and tests |
| YAML | 7 | Configuration and documentation |
| Jinja | Embedded | Dynamic SQL templating |
| Markdown | 8 | Documentation |
| CSV | 1+ | Reference data |

## Why These Languages?

### SQL
- **Industry Standard**: Universal language for data transformations
- **Declarative**: Focus on *what* data you want, not *how* to get it
- **Optimized**: Database engines optimize SQL execution
- **Accessible**: Most data professionals know SQL

### YAML
- **Human-Readable**: Easy to write and understand
- **Structured**: Perfect for configuration and documentation
- **dbt Native**: dbt's preferred format for schema definitions

### Jinja
- **DRY Principle**: Don't Repeat Yourself - write reusable code
- **Dynamic**: Generate SQL based on conditions and parameters
- **Powerful**: Macros enable complex logic without Python

## Learning Resources

- **SQL**: [SQL Tutorial](https://www.w3schools.com/sql/) | [PostgreSQL Docs](https://www.postgresql.org/docs/)
- **dbt**: [dbt Documentation](https://docs.getdbt.com/) | [Learn dbt](https://courses.getdbt.com/)
- **Jinja**: [Jinja Templating](https://jinja.palletsprojects.com/) | [dbt Jinja Functions](https://docs.getdbt.com/reference/dbt-jinja-functions)
- **YAML**: [YAML Tutorial](https://www.cloudbees.com/blog/yaml-tutorial-everything-you-need-get-started)

## Repository Language Badges

![Top Language](https://img.shields.io/github/languages/top/galafis/dbt-data-warehouse-modeling)
![Language Count](https://img.shields.io/github/languages/count/galafis/dbt-data-warehouse-modeling)
![SQL](https://img.shields.io/badge/SQL-025E8C?style=flat-square&logo=sql&logoColor=white)
![YAML](https://img.shields.io/badge/YAML-CB171E?style=flat-square&logo=yaml&logoColor=white)
![Jinja](https://img.shields.io/badge/Jinja-B41717?style=flat-square&logo=jinja&logoColor=white)

---

**Note**: GitHub Linguist may take some time to update language statistics after the `.gitattributes` file is added. The language breakdown should appear on the repository homepage within 24 hours of merging these changes.
