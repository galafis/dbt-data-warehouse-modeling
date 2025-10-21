# Contributing to dbt Data Warehouse Modeling

Thank you for your interest in contributing to this project! 🎉

## How to Contribute

### Reporting Issues

- Use GitHub Issues to report bugs or suggest features
- Provide clear descriptions and examples
- Include dbt version and database adapter information

### Code Contributions

1. **Fork the Repository**
   ```bash
   git clone https://github.com/galafis/dbt-data-warehouse-modeling.git
   cd dbt-data-warehouse-modeling
   ```

2. **Create a Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make Your Changes**
   - Follow the existing code style
   - Add tests for new features
   - Update documentation as needed

4. **Test Your Changes**
   ```bash
   dbt deps
   dbt compile
   dbt run
   dbt test
   ```

5. **Commit Your Changes**
   ```bash
   git add .
   git commit -m "Add: brief description of changes"
   ```

6. **Push and Create Pull Request**
   ```bash
   git push origin feature/your-feature-name
   ```

## Development Guidelines

### Code Style

- Use clear, descriptive names for models and columns
- Add comments to explain complex logic
- Follow the layered architecture (staging → intermediate → marts)
- Use CTEs for readability

### Model Naming Conventions

- **Staging**: `stg_<source>_<entity>.sql`
- **Intermediate**: `int_<entity>_<description>.sql`
- **Facts**: `fct_<entity>.sql`
- **Dimensions**: `dim_<entity>.sql`
- **Metrics**: `<metric_name>.sql`

### Testing

- Add schema tests for all models (unique, not_null, relationships)
- Create custom tests for business logic
- Ensure all tests pass before submitting PR

### Documentation

- Add descriptions to all models and columns in `.yml` files
- Update README.md if adding new features
- Include examples for complex functionality

## Questions?

Feel free to open an issue for any questions or clarifications!
