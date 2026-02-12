# Modern Data Warehouse Modeling with dbt

![dbt](https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white) ![SQL](https://img.shields.io/badge/SQL-025E8C?style=for-the-badge&logo=sql&logoColor=white) ![YAML](https://img.shields.io/badge/YAML-CB171E?style=for-the-badge&logo=yaml&logoColor=white) ![Jinja](https://img.shields.io/badge/Jinja-B41717?style=for-the-badge&logo=jinja&logoColor=white) ![Analytics Engineering](https://img.shields.io/badge/Analytics_Engineering-00C853?style=for-the-badge)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) ![Languages](https://img.shields.io/github/languages/count/galafis/dbt-data-warehouse-modeling) ![Top Language](https://img.shields.io/github/languages/top/galafis/dbt-data-warehouse-modeling)

---

## Modelagem Moderna de Data Warehouse com dbt

Projeto de **Analytics Engineering** utilizando **dbt (data build tool)**. Demonstra arquitetura em camadas, modelos incrementais, testes automatizados e documentação para data warehouses modernos.

### Objetivo

Construir um data warehouse moderno e confiável aplicando princípios de engenharia de software (versionamento, testes) a transformações SQL, permitindo que equipes de dados trabalhem com qualidade e velocidade.

### Por que dbt?

dbt é uma ferramenta popular para engenharia de analytics:

| Aspecto | Antes do dbt | Com dbt |
|---------|--------------|---------|
| **Transformações** | Scripts SQL ad-hoc | Modelos versionados |
| **Testes** | Manuais ou inexistentes | Automatizados |
| **Documentação** | Desatualizada | Gerada automaticamente |
| **Dependências** | Gerenciadas manualmente | DAG automático |
| **Colaboração** | Difícil | Git workflow |

### Casos de Uso

1. **E-commerce**: Modelagem de funil de vendas e análise de cohort
2. **SaaS**: Métricas de produto (MAU, DAU, churn, LTV)
3. **Fintech**: Agregações de transações
4. **Marketing**: Attribution modeling e ROI de campanhas
5. **Operações**: KPIs operacionais e dashboards executivos

### Arquitetura em Camadas

```
┌─────────────────────────────────────────┐
│         RAW DATA (Source)               │
│  - Orders, Customers, Products          │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│      STAGING LAYER (stg_*)              │
│  - Limpeza básica                       │
│  - Renomeação de colunas                │
│  - Tipagem de dados                     │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│   INTERMEDIATE LAYER (int_*)            │
│  - Joins complexos                      │
│  - Lógica de negócio                    │
│  - Agregações intermediárias            │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│      MARTS LAYER (fct_*, dim_*)         │
│  - Tabelas de fato                      │
│  - Dimensões                            │
│  - Métricas de negócio                  │
└─────────────────────────────────────────┘
```

### Estrutura do Repositório

```
dbt-data-warehouse-modeling/
├── docs/
│   ├── ARCHITECTURE.md                   # Documentação de arquitetura
│   ├── DATA_FLOW.md                      # Diagrama de fluxo de dados
│   ├── FAQ.md                            # Perguntas frequentes
│   └── TROUBLESHOOTING.md                # Guia de troubleshooting
├── images/
│   └── layered_architecture.png          # Diagrama de arquitetura
├── models/
│   ├── staging/                          # Camada de Staging
│   │   ├── _staging.yml                  # Documentação e testes
│   │   ├── stg_orders.sql                # Staging de pedidos
│   │   ├── stg_customers.sql             # Staging de clientes
│   │   └── stg_products.sql              # Staging de produtos
│   ├── intermediate/                     # Camada Intermediária
│   │   ├── _intermediate.yml             # Documentação e testes
│   │   ├── int_orders_enriched.sql       # Pedidos enriquecidos
│   │   └── int_customer_metrics.sql      # Métricas de clientes
│   └── marts/                            # Camada de Marts
│       ├── core/                         # Modelos core (fatos/dimensões)
│       │   ├── _core.yml                 # Documentação e testes
│       │   ├── fct_orders.sql            # Fato: Pedidos
│       │   ├── dim_customers.sql         # Dimensão: Clientes
│       │   └── dim_products.sql          # Dimensão: Produtos
│       └── metrics/                      # Modelos de métricas
│           ├── _metrics.yml              # Documentação e testes
│           ├── revenue_by_month.sql      # Receita mensal
│           └── customer_cohorts.sql      # Análise de cohort
├── tests/                                # Testes customizados
│   ├── assert_positive_revenue.sql       # Valida receitas positivas
│   ├── assert_valid_dates.sql            # Valida datas
│   └── assert_customers_have_orders.sql  # Valida relacionamentos
├── macros/                               # Macros reutilizáveis
│   ├── cents_to_dollars.sql              # Conversão de moeda
│   ├── generate_schema_name.sql          # Geração de schema
│   ├── surrogate_key.sql                 # Chave surrogate
│   └── tests/
│       └── accepted_range.sql            # Teste customizado de range
├── seeds/                                # Dados estáticos
│   └── country_codes.csv                 # Códigos de países
├── snapshots/                            # Snapshots SCD Type 2
│   └── orders_snapshot.sql               # Snapshot de pedidos
├── dbt_project.yml                       # Configuração do projeto
├── profiles.yml.example                  # Exemplo de configuração
├── .gitignore                            # Arquivos ignorados
├── LICENSE                               # Licença MIT
├── CONTRIBUTING.md                       # Guia de contribuição
└── README.md                             # Este arquivo

**Estatísticas do Projeto:**
- 10 Modelos SQL (3 staging, 2 intermediate, 5 marts)
- 82 Testes de Qualidade de Dados (schema + custom)
- 4 Macros Customizadas
- 1 Snapshot para histórico
- 1 Seed de dados de referência

**Tecnologias e Linguagens:**
- **SQL**: Linguagem principal para transformações de dados (18 arquivos)
- **YAML**: Configuração de modelos, testes e documentação (6 arquivos)
- **Jinja**: Template engine para SQL dinâmico (integrado nos arquivos SQL)
- **PostgreSQL**: Banco de dados de desenvolvimento (padrão)
- **dbt Core**: Framework de transformação de dados
```

### Quick Start

#### 1. Clonar o Repositório

```bash
git clone https://github.com/galafis/dbt-data-warehouse-modeling.git
cd dbt-data-warehouse-modeling
```

#### 2. Instalar dbt

```bash
# Via pip
pip install dbt-core dbt-postgres  # ou dbt-snowflake, dbt-bigquery, etc.

# Verificar instalação
dbt --version
```

#### 3. Configurar Conexão com o Banco de Dados

```bash
# Copiar exemplo de profiles
cp profiles.yml.example ~/.dbt/profiles.yml

# Editar com suas credenciais
nano ~/.dbt/profiles.yml
```

Exemplo de configuração:
```yaml
# ~/.dbt/profiles.yml
data_warehouse:
  target: dev
  outputs:
    dev:
      type: postgres
      host: localhost
      user: analytics_user
      password: "{{ env_var('DBT_PASSWORD') }}"
      port: 5432
      dbname: analytics
      schema: dbt_dev
      threads: 4
```

#### 4. Executar o Projeto

```bash
# Compilar modelos (valida SQL)
dbt compile

# Executar todos os modelos
dbt run

# Executar apenas staging
dbt run --select staging

# Executar testes de qualidade
dbt test

# Gerar e visualizar documentação
dbt docs generate
dbt docs serve  # Abre em http://localhost:8080
```

#### 5. Validar Instalação

```bash
# Verificar estrutura do projeto
dbt debug

# Listar todos os modelos
dbt list

# Visualizar DAG de dependências
dbt docs generate && dbt docs serve
```

### Exemplos de Modelos

Each layer in the project builds on the previous one. See the actual model files for full implementations.

#### Staging Layer

Staging models clean and standardize raw data. For example, `stg_orders.sql` applies type casts, data quality checks, and filters out invalid records:

```sql
-- models/staging/stg_orders.sql (simplified)
with source as (
    select * from {{ source('raw', 'orders') }}
),

renamed as (
    select
        order_id,
        customer_id,
        product_id,
        cast(order_date as date) as order_date,
        cast(sales as numeric(10,2)) as sales_amount,
        cast(quantity as integer) as quantity,
        cast(discount as numeric(5,4)) as discount_rate,
        cast(profit as numeric(10,2)) as profit_amount,
        current_timestamp as loaded_at
    from source
)

select * from renamed
```

#### Intermediate Layer

Intermediate models join and enrich data. `int_orders_enriched.sql` combines orders with customer and product data:

```sql
-- models/intermediate/int_orders_enriched.sql (simplified)
with orders as (
    select * from {{ ref('stg_orders') }}
),
customers as (
    select * from {{ ref('stg_customers') }}
),
products as (
    select * from {{ ref('stg_products') }}
),
enriched as (
    select
        o.order_id,
        o.order_date,
        o.sales_amount,
        c.customer_name,
        c.segment as customer_segment,
        p.product_name,
        p.category as product_category,
        o.sales_amount * (1 - o.discount_rate) as net_sales
    from orders o
    left join customers c on o.customer_id = c.customer_id
    left join products p on o.product_id = p.product_id
)
select * from enriched
```

#### Marts Layer - Fact Table

`fct_orders.sql` is an incremental model that serves as the main fact table:

```sql
-- models/marts/core/fct_orders.sql (simplified)
{{
  config(
    materialized='incremental',
    unique_key='order_id'
  )
}}

with orders_enriched as (
    select * from {{ ref('int_orders_enriched') }}
    {% if is_incremental() %}
    where order_date >= (select max(order_date) - interval '7 days' from {{ this }})
    {% endif %}
)
select
    order_id, customer_id, product_id,
    order_date, sales_amount, net_sales, profit_amount,
    customer_segment, product_category,
    current_timestamp as _dbt_loaded_at
from orders_enriched
```

### Testes de Qualidade

#### Testes Genéricos (schema.yml)

All models have schema-level tests defined in their `_*.yml` files. For example:

```yaml
columns:
  - name: order_id
    description: Primary key for orders
    tests:
      - unique
      - not_null
  
  - name: sales_amount
    description: Sales amount in dollars
    tests:
      - not_null
      - accepted_range:
          min_value: 0
          max_value: 1000000
```

#### Testes Singulares (SQL)

```sql
-- tests/assert_positive_revenue.sql
select
    order_id,
    sales_amount,
    net_sales
from {{ ref('fct_orders') }}
where sales_amount < 0 
   or net_sales < 0
```

### Macros

```sql
-- macros/cents_to_dollars.sql
{% macro cents_to_dollars(column_name) %}
    ({{ column_name }} / 100.0)::numeric(10,2)
{% endmacro %}
```

```sql
-- macros/generate_schema_name.sql
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}
        {{ default_schema }}
    {%- elif target.name == 'prod' -%}
        {{ custom_schema_name | trim }}
    {%- else -%}
        {{ default_schema }}_{{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}
```

### Incremental Models

`fct_orders` uses incremental materialization to process only new or changed records. See [models/marts/core/fct_orders.sql](models/marts/core/fct_orders.sql) for the full implementation.

### Snapshots (SCD Type 2)

```sql
-- snapshots/orders_snapshot.sql
{% snapshot orders_snapshot %}
{{
    config(
      target_schema='snapshots',
      unique_key='order_id',
      strategy='timestamp',
      updated_at='loaded_at'
    )
}}
select 
    order_id, customer_id, product_id,
    order_date, ship_date,
    sales_amount, profit_amount, quantity, discount_rate,
    loaded_at
from {{ ref('stg_orders') }}
{% endsnapshot %}
```

### Conceitos

#### Materializations

| Type | Use Case | Performance | Storage |
|------|----------|-------------|---------|
| **view** | Staging, low volume | Fast build, slow query | Minimal |
| **table** | Marts, frequent queries | Slow build, fast query | High |
| **incremental** | Large fact tables | Fast build, fast query | Medium |
| **ephemeral** | Intermediate, CTEs | No build, inline | None |

#### DAG (Directed Acyclic Graph)

dbt automaticamente cria o DAG de dependências:

```bash
# Visualizar DAG
dbt docs generate
dbt docs serve

# Executar apenas um modelo e suas dependências
dbt run --select +fct_orders

# Executar apenas um modelo e seus dependentes
dbt run --select fct_orders+

# Executar modelos modificados
dbt run --select state:modified+
```

### Melhores Práticas

1. **Use camadas** (staging → intermediate → marts)
2. **Teste tudo** (unique, not_null, relationships)
3. **Documente modelos** (descriptions, columns)
4. **Use refs** ao invés de nomes de tabelas
5. **Monitore performance** (dbt Cloud, logs)
6. **Versionamento semântico** para mudanças breaking

### Documentação Adicional

**Documentação do Projeto**:
- [Arquitetura Detalhada](docs/ARCHITECTURE.md) - Visão completa da arquitetura
- [Fluxo de Dados](docs/DATA_FLOW.md) - Diagramas de lineage e dependências
- [FAQ](docs/FAQ.md) - Perguntas frequentes e respostas
- [Troubleshooting](docs/TROUBLESHOOTING.md) - Guia de solução de problemas
- [Guia de Contribuição](CONTRIBUTING.md) - Como contribuir com o projeto

**Recursos Externos**:
- [dbt Documentation](https://docs.getdbt.com/)
- [dbt Discourse Community](https://discourse.getdbt.com/)
- [Analytics Engineering Guide](https://www.getdbt.com/analytics-engineering/)
- [dbt Best Practices](https://docs.getdbt.com/guides/best-practices)

### Funcionalidades Implementadas

- Arquitetura em Camadas: staging → intermediate → marts
- Modelos Incrementais: fct_orders com estratégia incremental
- Testes Automatizados: 82 testes de qualidade de dados
- Documentação: schema.yml para todos os modelos
- Macros Customizadas: conversões, testes e utilitários
- Snapshots: histórico de mudanças (SCD Type 2)
- Seeds: dados de referência versionados

### Qualidade de Dados e Testes

O projeto inclui testes em múltiplas camadas:

**Testes Schema (YAML):**
- `unique`: Garante unicidade de chaves primárias
- `not_null`: Valida campos obrigatórios
- `relationships`: Valida integridade referencial
- `accepted_values`: Valida valores categóricos
- `accepted_range`: Valida ranges numéricos

**Testes Customizados (SQL):**
- `assert_positive_revenue`: Valida que receitas são positivas
- `assert_valid_dates`: Valida lógica de datas
- `assert_customers_have_orders`: Valida relacionamentos

### Próximos Passos

- [ ] Adicionar mais modelos de métricas (churn, LTV detalhado)
- [ ] Implementar testes de performance
- [ ] Integrar com dbt Cloud
- [ ] Adicionar data quality monitoring em tempo real
- [ ] Criar dashboards de exemplo no Metabase/Superset

---

## Modern Data Warehouse Modeling with dbt

**Analytics Engineering** project using **dbt (data build tool)**. Demonstrates layered architecture, incremental models, automated testing, and documentation for modern data warehouses.

### Project Overview

- **10 SQL Models**: Organized in 3 layers (staging → intermediate → marts)
- **82 Data Tests**: Quality checks on all models
- **4 Custom Macros**: Reusable utilities and test functions
- **1 Snapshot**: SCD Type 2 implementation

### Technologies

- **SQL**: Primary language for data transformations (18 files)
- **YAML**: Model configuration, tests, and documentation (6 files)
- **Jinja**: Template engine for dynamic SQL (embedded in SQL files)
- **PostgreSQL**: Default development database
- **dbt Core**: Data transformation framework

### Quick Start (English)

```bash
# Clone repository
git clone https://github.com/galafis/dbt-data-warehouse-modeling.git
cd dbt-data-warehouse-modeling

# Install dbt
pip install dbt-core dbt-postgres

# Configure connection (copy and edit profiles.yml.example)
cp profiles.yml.example ~/.dbt/profiles.yml

# Run models
dbt run

# Test data quality
dbt test

# Generate documentation
dbt docs generate && dbt docs serve
```

### Key Learnings

- Build layered data warehouse (staging → intermediate → marts)
- Implement incremental models for large fact tables
- Write automated data tests
- Create reusable macros and custom tests
- Generate auto-updated documentation
- Apply Analytics Engineering best practices
- Version control your data transformations

### Documentation

- [Architecture](docs/ARCHITECTURE.md) - Architecture documentation
- [Data Flow](docs/DATA_FLOW.md) - Lineage diagrams
- [FAQ](docs/FAQ.md) - Frequently asked questions
- [Troubleshooting](docs/TROUBLESHOOTING.md) - Common issues and solutions
- [Contributing](CONTRIBUTING.md) - Contribution guidelines

### What’s Included

- **Documented**: Schema docs and inline comments for all models
- **Tested**: Data quality tests on every model
- **Layered**: Proper staging → intermediate → marts architecture
- **Educational**: Good reference for learning dbt patterns

---

**Author:** Gabriel Demetrios Lafis  
**License:** MIT  
**Last Updated:** February 2026
