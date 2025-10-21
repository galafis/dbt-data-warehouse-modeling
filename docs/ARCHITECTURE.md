# Architecture Documentation

## Overview

This project implements a modern data warehouse using dbt (data build tool) following the Medallion Architecture pattern with three distinct layers: Bronze (Staging), Silver (Intermediate), and Gold (Marts).

## Architecture Layers

### 1. Staging Layer (Bronze) 🥉

**Purpose**: Clean and standardize raw data from source systems.

**Models**:
- `stg_orders.sql`: Cleans orders data, applies data quality filters
- `stg_customers.sql`: Standardizes customer information
- `stg_products.sql`: Cleans product catalog data

**Characteristics**:
- Materialized as **views** (low storage, fast refresh)
- 1:1 mapping with source tables
- Minimal transformations
- Data quality filters applied
- Column renaming and type casting

**Key Features**:
- Data quality flags
- Null handling
- Date standardization
- Lowercase text normalization

### 2. Intermediate Layer (Silver) 🥈

**Purpose**: Business logic, enrichment, and complex transformations.

**Models**:
- `int_orders_enriched.sql`: Joins orders with customers and products
- `int_customer_metrics.sql`: Aggregates customer-level metrics

**Characteristics**:
- Materialized as **views** (or ephemeral for optimization)
- Complex joins and calculations
- Business logic implementation
- Metric calculations

**Key Features**:
- Multi-table joins
- Calculated fields
- Business rules
- Aggregations

### 3. Marts Layer (Gold) 🥇

**Purpose**: Analytics-ready tables optimized for BI tools.

#### Core Models

**Fact Tables**:
- `fct_orders.sql`: Order transactions (incremental)
  - Contains measures (sales, profit, quantity)
  - Foreign keys to dimensions
  - Incremental refresh for efficiency

**Dimension Tables**:
- `dim_customers.sql`: Customer master data
  - Includes lifetime metrics
  - Customer segmentation
  - SCD Type 1 (overwrites)

- `dim_products.sql`: Product catalog
  - Product attributes
  - Performance metrics
  - Category hierarchies

#### Metrics Models

- `revenue_by_month.sql`: Monthly revenue aggregations
- `customer_cohorts.sql`: Cohort analysis by first purchase

**Characteristics**:
- Materialized as **tables** (fast query performance)
- Incremental models for large fact tables
- Pre-aggregated metrics
- Business-friendly naming

## Data Quality Strategy

### Test Coverage

```
┌─────────────────────┬───────────┬────────────────────────┐
│ Layer               │ # Models  │ # Tests                │
├─────────────────────┼───────────┼────────────────────────┤
│ Staging             │ 3         │ 30+ schema tests       │
│ Intermediate        │ 2         │ 20+ schema tests       │
│ Marts - Core        │ 3         │ 25+ schema tests       │
│ Marts - Metrics     │ 2         │ 7+ schema tests        │
│ Custom Tests        │ -         │ 3 SQL tests            │
├─────────────────────┼───────────┼────────────────────────┤
│ TOTAL               │ 10        │ 82+ tests              │
└─────────────────────┴───────────┴────────────────────────┘
```

### Test Types

1. **Uniqueness**: Primary keys must be unique
2. **Not Null**: Required fields must have values
3. **Relationships**: Foreign keys must reference valid records
4. **Accepted Values**: Categorical fields must have valid options
5. **Accepted Range**: Numeric fields must be within valid ranges
6. **Custom Tests**: Business-specific validation logic

## Macro Library

### Utility Macros

- `cents_to_dollars(column_name)`: Converts cents to dollars
- `surrogate_key(field_list)`: Generates MD5 hash keys
- `generate_schema_name(custom_schema_name, node)`: Schema naming logic

### Test Macros

- `accepted_range`: Custom test for numeric range validation

## Performance Optimizations

### Materialization Strategy

```
Staging (Views)
    ↓
Intermediate (Views/Ephemeral)
    ↓
Marts (Tables/Incremental)
```

**Benefits**:
- Staging: Low storage, easy refresh
- Intermediate: Flexible, no storage
- Marts: Fast queries, optimized for analytics

### Incremental Models

`fct_orders` uses incremental materialization:
- Only processes new/changed records
- Reduces build time from hours to minutes
- Maintains historical data
- Uses `unique_key` for upsert logic

## CI/CD Pipeline

### GitHub Actions Workflow

```yaml
Trigger: Push/PR to main/develop
├── Job 1: Compile and Test
│   ├── Install dbt
│   ├── Compile models
│   ├── Parse project
│   ├── Generate docs
│   └── Validate structure
├── Job 2: Lint YAML
│   └── Check YAML formatting
└── Job 3: Lint SQL
    └── Check SQL style
```

## Deployment Strategy

### Development Workflow

```
1. Feature Branch → 2. Local Dev → 3. PR → 4. CI Checks → 5. Merge → 6. Production
```

### Environment Separation

- **dev**: Development environment (fast feedback)
- **staging**: Pre-production testing
- **prod**: Production analytics

## Best Practices Implemented

✅ Layered architecture (separation of concerns)  
✅ Comprehensive testing (data quality)  
✅ Living documentation (schema.yml files)  
✅ Version control (Git)  
✅ CI/CD automation (GitHub Actions)  
✅ Incremental models (performance)  
✅ DRY principle (macros)  
✅ Naming conventions (consistency)

## Monitoring and Observability

### dbt Artifacts

- `manifest.json`: Complete project structure
- `run_results.json`: Execution results
- `catalog.json`: Schema documentation
- `sources.json`: Source data freshness

### Key Metrics to Monitor

- Build time per model
- Test failure rate
- Data freshness
- Row counts
- Schema changes

## Future Enhancements

- [ ] dbt Cloud integration
- [ ] Data freshness checks
- [ ] Exposure tracking (BI dashboards)
- [ ] Advanced metrics (churn, LTV)
- [ ] Alerting on test failures
- [ ] Performance monitoring dashboard

## References

- [dbt Best Practices](https://docs.getdbt.com/guides/best-practices)
- [Analytics Engineering Guide](https://www.getdbt.com/analytics-engineering/)
- [Kimball Dimensional Modeling](https://www.kimballgroup.com/data-warehouse-business-intelligence-resources/)
