_# Modern Data Warehousing with dbt

![dbt](https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white) ![SQL](https://img.shields.io/badge/SQL-025E8C?style=for-the-badge&logo=sql&logoColor=white)

---

## 🇧🇷 Modelagem de Data Warehouse com dbt (data build tool)

Este repositório é um projeto completo de modelagem e transformação de dados para um data warehouse utilizando o **dbt (data build tool)**. O projeto demonstra como aplicar os princípios da engenharia de software (versionamento, testes, modularidade) ao desenvolvimento de pipelines de transformação de dados baseados em SQL.

### 🎯 Objetivo

O objetivo é construir um data warehouse moderno, confiável e bem documentado. O repositório serve como um guia prático para analistas de dados e engenheiros de analytics que desejam adotar o dbt para gerenciar suas transformações de dados, garantindo qualidade, consistência e manutenibilidade.

### 📂 Conteúdo do Repositório

*   **/models**: Contém os modelos SQL que definem as transformações de dados. Os modelos são organizados em camadas (staging, intermediate, marts).
*   **/seeds**: Arquivos CSV que podem ser carregados no data warehouse como tabelas estáticas (ex: tabelas de dimensão).
*   **/tests**: Testes de qualidade de dados (singular, genérico) para garantir a integridade dos modelos.
*   **/macros**: Macros Jinja para reutilização de código SQL e criação de abstrações.
*   **/analysis**: Análises exploratórias e queries ad-hoc que não são materializadas como modelos.
*   `dbt_project.yml`: Arquivo de configuração principal do projeto dbt.

### ✨ Princípios e Práticas

*   **Transformação no Warehouse (ELT)**: O dbt opera sob o paradigma ELT (Extract, Load, Transform), onde os dados brutos são carregados no data warehouse e as transformações são aplicadas via SQL.
*   **Idempotência**: Os modelos são projetados para serem idempotentes, o que significa que podem ser executados várias vezes sem causar efeitos colaterais.
*   **Testes de Dados**: Automação de testes para validar a qualidade dos dados, como checagens de nulos, unicidade e integridade referencial.
*   **Documentação Automatizada**: O dbt gera automaticamente uma documentação completa do projeto, incluindo um DAG (Directed Acyclic Graph) das dependências entre os modelos.

---

## 🇬🇧 Data Warehouse Modeling with dbt (data build tool)

This repository is a complete data modeling and transformation project for a data warehouse using **dbt (data build tool)**. The project demonstrates how to apply software engineering principles (versioning, testing, modularity) to the development of SQL-based data transformation pipelines.

### 🎯 Objective

The goal is to build a modern, reliable, and well-documented data warehouse. The repository serves as a practical guide for data analysts and analytics engineers who want to adopt dbt to manage their data transformations, ensuring quality, consistency, and maintainability.

### 📂 Repository Content

*   **/models**: Contains the SQL models that define the data transformations. The models are organized into layers (staging, intermediate, marts).
*   **/seeds**: CSV files that can be loaded into the data warehouse as static tables (e.g., dimension tables).
*   **/tests**: Data quality tests (singular, generic) to ensure the integrity of the models.
*   **/macros**: Jinja macros for SQL code reuse and creating abstractions.
*   **/analysis**: Exploratory analysis and ad-hoc queries that are not materialized as models.
*   `dbt_project.yml`: The main configuration file for the dbt project.

### ✨ Principles and Practices

*   **Transformation in the Warehouse (ELT)**: dbt operates under the ELT (Extract, Load, Transform) paradigm, where raw data is loaded into the data warehouse and transformations are applied via SQL.
*   **Idempotency**: Models are designed to be idempotent, meaning they can be run multiple times without causing side effects.
*   **Data Testing**: Automation of tests to validate data quality, such as null checks, uniqueness, and referential integrity.
*   **Automated Documentation**: dbt automatically generates complete project documentation, including a DAG (Directed Acyclic Graph) of the dependencies between models.

## Improved dbt Repository

### Additional Content
- Staging, intermediate, and mart layers
- Incremental models and snapshots
- Testing and documentation
## Improved dbt Repository

### Additional Content
- Staging, intermediate, and mart layers
- Incremental models and snapshots
- Testing and documentation
