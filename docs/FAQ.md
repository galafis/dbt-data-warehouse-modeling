# Frequently Asked Questions (FAQ)

## General Questions

### What is dbt?

dbt (data build tool) is an open-source command-line tool that enables data analysts and engineers to transform data in their warehouse more effectively. It allows you to write SQL select statements and turn them into tables and views, with built-in features for testing, documentation, and version control.

### Why use dbt?

- **Version Control**: Track changes to your analytics code
- **Testing**: Built-in data quality testing
- **Documentation**: Auto-generated, living documentation
- **DRY Principle**: Reusable code via macros and packages
- **Modularity**: Break complex transformations into manageable pieces
- **Collaboration**: Git-based workflow for teams

### What databases does dbt support?

dbt supports 20+ databases including:
- PostgreSQL, MySQL, SQL Server
- Snowflake, BigQuery, Redshift
- Databricks, Spark, Trino
- And many more via community adapters

## Project-Specific Questions

### How many models are in this project?

This project contains:
- 3 staging models
- 2 intermediate models
- 5 marts models (3 core + 2 metrics)
- **Total: 10 models**

### How many tests are there?

- 82 data quality tests across all models
- Mix of schema tests and custom SQL tests

### What's the difference between staging, intermediate, and marts?

- **Staging**: Clean and standardize raw data (1:1 with sources)
- **Intermediate**: Business logic, joins, calculations
- **Marts**: Analytics-ready tables for BI tools (facts & dimensions)

### Why use incremental models?

Incremental models process only new/changed data:
- ✅ Faster builds (minutes vs hours)
- ✅ Lower compute costs
- ✅ Maintains full history
- ❌ More complex to maintain
- ❌ Requires careful testing

## Technical Questions

### What's the difference between table and view materialization?

**View**:
- Query runs every time view is accessed
- No storage cost
- Always up-to-date
- Slower queries

**Table**:
- Data is stored physically
- Higher storage cost
- Faster queries
- Needs rebuild to update

**Incremental**:
- Best of both worlds for large datasets
- Only processes changes
- Faster builds
- More complex

### How do I add a new model?

1. Create SQL file in appropriate directory
2. Add to schema.yml with documentation
3. Add tests (unique, not_null, etc.)
4. Run `dbt run --select new_model`
5. Run `dbt test --select new_model`
6. Commit and push

### How do I add a new test?

**Schema Test** (in .yml):
```yaml
columns:
  - name: column_name
    tests:
      - unique
      - not_null
```

**Custom Test** (SQL file in tests/):
```sql
-- tests/my_test.sql
select * from {{ ref('my_model') }}
where invalid_condition
```

### What's a macro?

A macro is a reusable piece of Jinja code:

```sql
{% macro cents_to_dollars(column) %}
    ({{ column }} / 100.0)::numeric(10,2)
{% endmacro %}

-- Usage:
{{ cents_to_dollars('amount_cents') }}
```

### How do I reference another model?

Use the `ref()` function:

```sql
select * from {{ ref('stg_orders') }}
```

Benefits:
- Automatic dependency tracking
- Environment-aware (dev/prod)
- Compilation checks

### How do I reference a source table?

Use the `source()` function:

```sql
select * from {{ source('raw', 'orders') }}
```

Define sources in schema.yml:
```yaml
sources:
  - name: raw
    tables:
      - name: orders
```

## Workflow Questions

### What's the typical development workflow?

1. Create feature branch
2. Add/modify models
3. Test locally: `dbt run` and `dbt test`
4. Commit changes
5. Open pull request
6. Code review
7. Merge to main
8. Deploy to production

### How do I run only changed models?

```bash
# Compare with previous state
dbt run --select state:modified+

# Or use selector
dbt run --select staging.*
```

### How do I debug a failing model?

1. Run `dbt compile` to see rendered SQL
2. Check `target/compiled/` for compiled SQL
3. Run SQL directly in database
4. Check `logs/dbt.log` for errors
5. Use `--debug` flag for verbose output

### How often should I run dbt?

Depends on your needs:
- **Real-time**: Use dbt Cloud with webhooks
- **Hourly**: Cron job or Airflow
- **Daily**: Most common pattern
- **On-demand**: Manual or event-driven

## Best Practices Questions

### Should I use uppercase or lowercase for SQL?

Lowercase is recommended:
- More readable
- Less shouting 😄
- Consistent with dbt conventions

### How should I name models?

Follow conventions:
- **Staging**: `stg_<source>_<entity>.sql`
- **Intermediate**: `int_<description>.sql`
- **Facts**: `fct_<entity>.sql`
- **Dimensions**: `dim_<entity>.sql`
- **Metrics**: `<metric_name>.sql`

### How many tests should I write?

Test all:
- Primary keys (unique + not_null)
- Foreign keys (relationships)
- Required fields (not_null)
- Categorical fields (accepted_values)
- Business logic (custom tests)

**Rule of thumb**: At least 3-5 tests per model

### When should I use seeds vs models?

**Use seeds for**:
- Small reference data (< 1000 rows)
- Static lookup tables
- Configuration data
- Test fixtures

**Use models for**:
- Large datasets
- Frequently changing data
- Data from databases
- Transformed data

## Performance Questions

### How can I make my models faster?

1. Use incremental materialization
2. Add WHERE filters to reduce data
3. Use indexes on join columns
4. Partition large tables
5. Increase threads in profiles.yml
6. Use ephemeral for small intermediates
7. Optimize SQL (avoid SELECT *)

### What's the difference between ephemeral and view?

**Ephemeral**:
- Not materialized at all
- Compiled as CTE in parent model
- No storage
- Can't be queried directly
- Useful for simple transformations

**View**:
- Actual database view
- Can be queried independently
- Useful for debugging
- Better for complex logic

### Should I use CTEs or subqueries?

**CTEs (Common Table Expressions)** are preferred:
```sql
with orders as (
    select * from {{ ref('stg_orders') }}
)

select * from orders
```

Benefits:
- More readable
- Easier to debug
- dbt best practice
- Better for maintenance

## Deployment Questions

### How do I deploy to production?

1. Merge to main branch
2. Deploy using orchestrator (Airflow, dbt Cloud)
3. Run in production environment
4. Monitor for failures

### What's the difference between dev and prod?

- **Dev**: Your personal schema for development
- **Prod**: Production schema for BI tools
- Controlled by `target` in profiles.yml
- Different credentials, schemas, resources

### How do I handle migrations?

Use `on_schema_change`:
```yaml
config:
  materialized: incremental
  on_schema_change: sync_all_columns  # or fail, ignore, append_new_columns
```

## Troubleshooting Questions

### Why is my model not updating?

1. Check materialization type
2. For incremental: may need `--full-refresh`
3. Verify upstream models ran successfully
4. Check for filters that might exclude data
5. Review logs for errors

### Why are my tests failing?

Common causes:
1. Data quality issues in source
2. Incorrect test configuration
3. Schema changes
4. Business logic errors
5. Stale data

Check `target/run_results.json` for details

### How do I handle circular dependencies?

1. Visualize with `dbt docs serve`
2. Refactor one model to break cycle
3. Use seeds or sources instead of refs
4. Consider if dependency is necessary

## Community Questions

### How can I contribute?

See [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines:
1. Fork repository
2. Create feature branch
3. Make changes
4. Add tests
5. Submit pull request

### Where can I get help?

- [dbt Slack Community](https://www.getdbt.com/community/)
- [dbt Discourse](https://discourse.getdbt.com/)
- [GitHub Issues](https://github.com/galafis/dbt-data-warehouse-modeling/issues)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/dbt)

### How do I stay updated?

- Follow [@getdbt](https://twitter.com/getdbt) on Twitter
- Subscribe to [dbt Newsletter](https://www.getdbt.com/newsletter/)
- Watch [dbt YouTube Channel](https://www.youtube.com/c/dbtLabs)
- Attend [Coalesce Conference](https://coalesce.getdbt.com/)

## Advanced Questions

### Can I use Python with dbt?

Yes! dbt 1.3+ supports Python models:
```python
def model(dbt, session):
    df = dbt.ref("staging_model")
    # Transform with pandas/polars
    return df
```

### How do I implement SCD Type 2?

Use dbt snapshots:
```sql
{% snapshot orders_snapshot %}
{{
    config(
        target_schema='snapshots',
        unique_key='order_id',
        strategy='timestamp',
        updated_at='updated_at'
    )
}}

select * from {{ source('raw', 'orders') }}
{% endsnapshot %}
```

### Can I use dbt with Airflow?

Yes! Popular patterns:
1. BashOperator: `dbt run`
2. dbt Operator: `dbt-airflow` package
3. Cosmos: Modern dbt + Airflow integration

### What are exposures?

Exposures track how models are used downstream:
```yaml
exposures:
  - name: revenue_dashboard
    type: dashboard
    depends_on:
      - ref('fct_orders')
    owner:
      name: Analytics Team
```

## Still Have Questions?

Open an issue on GitHub or join the dbt community!
