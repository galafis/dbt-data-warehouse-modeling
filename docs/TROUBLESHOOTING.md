# Troubleshooting Guide

## Common Issues and Solutions

### 1. Connection Errors

#### Issue: "Could not connect to database"

```
Database Error
connection to server at "localhost" (::1), port 5432 failed
```

**Solutions**:
1. Verify database is running: `pg_isready` (PostgreSQL)
2. Check credentials in `~/.dbt/profiles.yml`
3. Verify network connectivity: `telnet localhost 5432`
4. Check firewall settings
5. Ensure database user has proper permissions

#### Issue: "Invalid credentials"

**Solutions**:
1. Verify username/password in profiles.yml
2. Use environment variables: `export DBT_PASSWORD=yourpassword`
3. Test connection manually: `psql -h localhost -U username -d dbname`

### 2. Compilation Errors

#### Issue: "Compilation Error: Model X not found"

**Solutions**:
1. Check model name in `ref()` matches file name
2. Verify model is in correct directory
3. Run `dbt compile` to check for errors
4. Clear cache: `rm -rf target/` and rebuild

#### Issue: "Syntax error in SQL"

**Solutions**:
1. Check for missing commas in CTEs
2. Verify all Jinja closing tags
3. Test SQL in database console first
4. Use `dbt compile` to see rendered SQL

### 3. Test Failures

#### Issue: "Test failed: unique"

**Solutions**:
1. Check for duplicates: `SELECT column, COUNT(*) GROUP BY column HAVING COUNT(*) > 1`
2. Review source data quality
3. Add deduplication logic in staging
4. Consider using `unique_where` for conditional uniqueness

#### Issue: "Test failed: not_null"

**Solutions**:
1. Check source data: `SELECT * FROM table WHERE column IS NULL`
2. Add default values in staging
3. Filter out null records if acceptable
4. Update source data quality

#### Issue: "Test failed: relationships"

**Solutions**:
1. Check for orphan records: `SELECT * FROM child WHERE parent_id NOT IN (SELECT id FROM parent)`
2. Add cascading logic in staging
3. Filter invalid relationships
4. Use `relationships:where` for conditional checks

### 4. Performance Issues

#### Issue: "Model takes too long to run"

**Solutions**:
1. Add incremental materialization for large tables
2. Use indexes on join columns
3. Partition large tables by date
4. Review query plan: `EXPLAIN` in database
5. Increase `threads` in profiles.yml

#### Issue: "Out of memory errors"

**Solutions**:
1. Use `incremental` instead of `table`
2. Break large models into smaller pieces
3. Increase database resources
4. Use `ephemeral` for intermediate steps
5. Add `WHERE` filters to reduce data volume

### 5. Dependency Issues

#### Issue: "Dependency cycle detected"

**Solutions**:
1. Review `ref()` calls to find circular dependencies
2. Visualize DAG: `dbt docs generate && dbt docs serve`
3. Refactor models to break cycle
4. Consider using seeds or sources

#### Issue: "Model depends on non-existent model"

**Solutions**:
1. Verify all `ref()` calls point to existing models
2. Check spelling and capitalization
3. Ensure model is in project
4. Run `dbt compile` to identify missing refs

### 6. Documentation Issues

#### Issue: "dbt docs serve not working"

**Solutions**:
1. Run `dbt docs generate` first
2. Check port 8080 is not in use: `lsof -i :8080`
3. Try different port: `dbt docs serve --port 8081`
4. Check browser console for errors

#### Issue: "Documentation not updating"

**Solutions**:
1. Clear target directory: `rm -rf target/`
2. Run `dbt docs generate --no-partial-parse`
3. Hard refresh browser: Ctrl+Shift+R (or Cmd+Shift+R)
4. Check schema.yml files are saved

### 7. Common dbt Commands

#### Debug connection:
```bash
dbt debug
```

#### Run specific model:
```bash
dbt run --select model_name
```

#### Run model and its dependencies:
```bash
dbt run --select +model_name
```

#### Run model and its children:
```bash
dbt run --select model_name+
```

#### Test specific model:
```bash
dbt test --select model_name
```

#### Full refresh incremental model:
```bash
dbt run --full-refresh --select model_name
```

#### Run modified models:
```bash
dbt run --select state:modified+
```

### 8. Best Practices for Debugging

1. **Start Small**: Test individual models before running full project
2. **Use `dbt compile`**: Check compiled SQL in target/compiled/
3. **Check Logs**: Review logs/ directory for detailed errors
4. **Incremental Development**: Build and test one model at a time
5. **Use `--store-failures`**: Save failing test records for analysis
6. **Version Control**: Commit frequently to track changes
7. **Read Error Messages**: dbt provides detailed error context

### 9. Getting Help

If you're still stuck:

1. **Check Documentation**: [dbt Docs](https://docs.getdbt.com/)
2. **Search Discourse**: [dbt Community](https://discourse.getdbt.com/)
3. **Open Issue**: [GitHub Issues](https://github.com/galafis/dbt-data-warehouse-modeling/issues)
4. **Review Logs**: Check `logs/dbt.log` for details
5. **Ask Community**: Slack, Discord, or Stack Overflow

### Quick Checklist

When something goes wrong:

- [ ] Is dbt installed? (`dbt --version`)
- [ ] Is profiles.yml configured correctly?
- [ ] Can you connect to the database?
- [ ] Does `dbt debug` pass all checks?
- [ ] Does `dbt compile` work?
- [ ] Are all dependencies installed?
- [ ] Is the database schema correct?
- [ ] Do you have the right permissions?
- [ ] Are logs providing useful information?
- [ ] Have you tried clearing the cache?

## Environment-Specific Issues

### Docker

```bash
# If running in Docker, ensure volumes are mounted
docker run -v $(pwd):/usr/app -v ~/.dbt:/root/.dbt dbt
```

### Cloud IDEs (Gitpod, Codespaces)

```bash
# May need to expose ports manually
dbt docs serve --host 0.0.0.0 --port 8080
```

### Windows

```bash
# Use forward slashes in paths
# Ensure line endings are LF not CRLF
git config core.autocrlf false
```
