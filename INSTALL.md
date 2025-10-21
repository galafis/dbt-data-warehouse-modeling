# Installation Guide

Complete guide to setting up this dbt project on your local machine.

## Prerequisites

- Python 3.8+ installed
- Access to a data warehouse (PostgreSQL, Snowflake, BigQuery, etc.)
- Git installed
- Basic SQL knowledge

## Step 1: Clone the Repository

```bash
git clone https://github.com/galafis/dbt-data-warehouse-modeling.git
cd dbt-data-warehouse-modeling
```

## Step 2: Install dbt

### Option A: Using pip (Recommended)

```bash
# For PostgreSQL
pip install dbt-core dbt-postgres

# For Snowflake
pip install dbt-core dbt-snowflake

# For BigQuery
pip install dbt-core dbt-bigquery

# Verify installation
dbt --version
```

### Option B: Using virtual environment

```bash
# Create virtual environment
python -m venv dbt-env

# Activate (Linux/Mac)
source dbt-env/bin/activate

# Activate (Windows)
dbt-env\Scripts\activate

# Install dbt
pip install dbt-core dbt-postgres

# Verify
dbt --version
```

## Step 3: Configure Database Connection

### Create profiles.yml

```bash
# Copy example file
cp profiles.yml.example ~/.dbt/profiles.yml

# Edit with your credentials
nano ~/.dbt/profiles.yml
```

### PostgreSQL Configuration

```yaml
data_warehouse:
  target: dev
  outputs:
    dev:
      type: postgres
      host: localhost
      user: your_username
      password: "{{ env_var('DBT_PASSWORD') }}"
      port: 5432
      dbname: analytics
      schema: dbt_dev
      threads: 4
```

### Snowflake Configuration

```yaml
data_warehouse:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: your_account.us-east-1
      user: your_username
      password: "{{ env_var('SNOWFLAKE_PASSWORD') }}"
      role: TRANSFORMER
      database: ANALYTICS
      warehouse: TRANSFORMING
      schema: dbt_dev
      threads: 4
```

### BigQuery Configuration

```yaml
data_warehouse:
  target: dev
  outputs:
    dev:
      type: bigquery
      method: service-account
      project: your-gcp-project
      dataset: dbt_dev
      threads: 4
      keyfile: /path/to/service-account.json
      location: US
```

## Step 4: Set Environment Variables

```bash
# Add to ~/.bashrc or ~/.zshrc
export DBT_PASSWORD="your_database_password"

# For current session only
export DBT_PASSWORD="your_database_password"
```

## Step 5: Verify Connection

```bash
# Test database connection
dbt debug

# Expected output:
# All checks passed!
```

## Step 6: Run the Project

```bash
# Compile models (validates SQL)
dbt compile

# Run all models
dbt run

# Run tests
dbt test

# Generate documentation
dbt docs generate

# View documentation
dbt docs serve
```

## Troubleshooting

### Connection Issues

If `dbt debug` fails:

1. **Verify credentials**: Check username/password
2. **Check database**: Ensure database is running
3. **Test connectivity**: Try connecting with native client
4. **Check firewall**: Ensure port is not blocked
5. **Review profiles.yml**: Verify file location and syntax

### Common Errors

**Error: "Could not find profile named 'data_warehouse'"**
- Solution: Ensure profiles.yml exists at `~/.dbt/profiles.yml`
- Check profile name matches `dbt_project.yml`

**Error: "Database Error: permission denied"**
- Solution: Grant required permissions to database user
- Check user has SELECT, CREATE TABLE rights

**Error: "Compilation Error: Model not found"**
- Solution: Run `dbt deps` if using packages
- Clear cache: `rm -rf target/`

## Optional: IDE Setup

### VS Code Extensions

Install recommended extensions:
- dbt Power User
- SQL Formatter
- YAML
- GitLens

### Configure VS Code

Create `.vscode/settings.json`:
```json
{
  "files.associations": {
    "*.sql": "jinja-sql"
  },
  "dbt.enableAutoComplete": true
}
```

## Next Steps

1. Review [Architecture Documentation](docs/ARCHITECTURE.md)
2. Read [FAQ](docs/FAQ.md) for common questions
3. Check [Troubleshooting Guide](docs/TROUBLESHOOTING.md)
4. Start developing: See [CONTRIBUTING.md](CONTRIBUTING.md)

## Quick Reference

```bash
# Essential Commands
dbt debug          # Test connection
dbt compile        # Validate SQL
dbt run            # Execute models
dbt test           # Run tests
dbt docs generate  # Generate docs
dbt docs serve     # View docs

# Selective Execution
dbt run --select staging       # Run staging only
dbt run --select +fct_orders   # Run with dependencies
dbt test --select dim_customers # Test specific model

# Utility Commands
dbt clean          # Clean target directory
dbt deps           # Install packages
dbt list           # List all resources
```

## Support

Need help? Check:
- [Troubleshooting Guide](docs/TROUBLESHOOTING.md)
- [FAQ](docs/FAQ.md)
- [GitHub Issues](https://github.com/galafis/dbt-data-warehouse-modeling/issues)
- [dbt Community](https://discourse.getdbt.com/)
