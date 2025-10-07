# Modern Data Warehouse Modeling with dbt

![dbt](https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white) ![SQL](https://img.shields.io/badge/SQL-025E8C?style=for-the-badge&logo=sql&logoColor=white) ![Analytics Engineering](https://img.shields.io/badge/Analytics_Engineering-00C853?style=for-the-badge)

---

## 🇧🇷 Modelagem Moderna de Data Warehouse com dbt

Projeto completo e profissional de **Analytics Engineering** utilizando **dbt (data build tool)**. Demonstra arquitetura em camadas, modelos incrementais, testes automatizados e documentação viva para data warehouses modernos.

### 🎯 Objetivo

Construir um data warehouse moderno, confiável e escalável aplicando princípios de engenharia de software (versionamento, testes, CI/CD) a transformações SQL, permitindo que equipes de dados trabalhem com qualidade e velocidade.

### 🌟 Por que dbt?

dbt revolucionou a engenharia de analytics:

| Aspecto | Antes do dbt | Com dbt |
|---------|--------------|---------|
| **Transformações** | Scripts SQL ad-hoc | Modelos versionados |
| **Testes** | Manuais ou inexistentes | Automatizados |
| **Documentação** | Desatualizada | Gerada automaticamente |
| **Dependências** | Gerenciadas manualmente | DAG automático |
| **Colaboração** | Difícil | Git workflow |
| **CI/CD** | Raro | Padrão da indústria |

### 📊 Casos de Uso Reais

1. **E-commerce**: Modelagem de funil de vendas e análise de cohort
2. **SaaS**: Métricas de produto (MAU, DAU, churn, LTV)
3. **Fintech**: Agregações de transações e detecção de fraude
4. **Marketing**: Attribution modeling e ROI de campanhas
5. **Operações**: KPIs operacionais e dashboards executivos

### 🏗️ Arquitetura em Camadas

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

### 📂 Estrutura do Repositório

```
dbt-data-warehouse-modeling/
├── models/
│   ├── staging/
│   │   ├── _staging.yml                  # Documentação staging
│   │   ├── stg_orders.sql                # Staging de pedidos
│   │   ├── stg_customers.sql             # Staging de clientes
│   │   └── stg_products.sql              # Staging de produtos
│   ├── intermediate/
│   │   ├── _intermediate.yml
│   │   ├── int_orders_enriched.sql       # Pedidos enriquecidos
│   │   └── int_customer_metrics.sql      # Métricas de clientes
│   └── marts/
│       ├── core/
│       │   ├── _core.yml
│       │   ├── fct_orders.sql            # Fato: Pedidos
│       │   ├── dim_customers.sql         # Dimensão: Clientes
│       │   └── dim_products.sql          # Dimensão: Produtos
│       └── metrics/
│           ├── _metrics.yml
│           ├── revenue_by_month.sql      # Receita mensal
│           └── customer_cohorts.sql      # Análise de cohort
├── tests/
│   ├── assert_positive_revenue.sql       # Teste customizado
│   └── assert_valid_dates.sql            # Validação de datas
├── macros/
│   ├── generate_schema_name.sql          # Macro de schema
│   ├── cents_to_dollars.sql              # Conversão de moeda
│   └── surrogate_key.sql                 # Chave surrogate
├── seeds/
│   └── country_codes.csv                 # Dados estáticos
├── snapshots/
│   └── orders_snapshot.sql               # Snapshot SCD Type 2
├── dbt_project.yml                       # Configuração do projeto
├── profiles.yml                          # Configuração de conexão
└── README.md
```

### 🚀 Instalação e Configuração

#### 1. Instalar dbt

```bash
# Via pip
pip install dbt-core dbt-postgres  # ou dbt-snowflake, dbt-bigquery, etc.

# Verificar instalação
dbt --version
```

#### 2. Configurar Conexão

```yaml
# profiles.yml
my_project:
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
    
    prod:
      type: postgres
      host: prod-db.company.com
      user: analytics_user
      password: "{{ env_var('DBT_PASSWORD') }}"
      port: 5432
      dbname: analytics
      schema: dbt_prod
      threads: 8
```

#### 3. Executar dbt

```bash
# Instalar dependências
dbt deps

# Executar todos os modelos
dbt run

# Executar testes
dbt test

# Gerar documentação
dbt docs generate
dbt docs serve
```

### 💻 Exemplos de Modelos

#### Staging Layer

```sql
-- models/staging/stg_orders.sql

{{
  config(
    materialized='view'
  )
}}

with source as (
    select * from {{ source('raw', 'orders') }}
),

renamed as (
    select
        -- IDs
        order_id,
        customer_id,
        
        -- Timestamps
        order_date::date as order_date,
        created_at::timestamp as created_at,
        
        -- Amounts (convert cents to dollars)
        {{ cents_to_dollars('amount_cents') }} as order_amount,
        {{ cents_to_dollars('tax_cents') }} as tax_amount,
        {{ cents_to_dollars('shipping_cents') }} as shipping_amount,
        
        -- Status
        lower(status) as order_status,
        
        -- Metadata
        _loaded_at
        
    from source
    where deleted_at is null  -- Exclude soft-deleted records
)

select * from renamed
```

#### Intermediate Layer

```sql
-- models/intermediate/int_orders_enriched.sql

{{
  config(
    materialized='ephemeral'
  )
}}

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
        -- Order info
        o.order_id,
        o.order_date,
        o.order_amount,
        o.order_status,
        
        -- Customer info
        c.customer_id,
        c.customer_name,
        c.customer_email,
        c.customer_segment,
        c.first_order_date,
        
        -- Product info
        p.product_id,
        p.product_name,
        p.product_category,
        
        -- Calculated fields
        o.order_amount + o.tax_amount + o.shipping_amount as total_amount,
        datediff('day', c.first_order_date, o.order_date) as days_since_first_order,
        
        -- Flags
        case 
            when o.order_date = c.first_order_date then true 
            else false 
        end as is_first_order
        
    from orders o
    left join customers c on o.customer_id = c.customer_id
    left join products p on o.product_id = p.product_id
)

select * from enriched
```

#### Marts Layer - Fact Table

```sql
-- models/marts/core/fct_orders.sql

{{
  config(
    materialized='incremental',
    unique_key='order_id',
    on_schema_change='fail'
  )
}}

with orders_enriched as (
    select * from {{ ref('int_orders_enriched') }}
    
    {% if is_incremental() %}
    -- Only process new/updated orders
    where order_date >= (select max(order_date) from {{ this }})
    {% endif %}
),

final as (
    select
        -- Keys
        {{ dbt_utils.generate_surrogate_key(['order_id']) }} as order_key,
        order_id,
        customer_id,
        product_id,
        
        -- Dates
        order_date,
        
        -- Measures
        order_amount,
        tax_amount,
        shipping_amount,
        total_amount,
        
        -- Attributes
        order_status,
        is_first_order,
        days_since_first_order,
        
        -- Metadata
        current_timestamp as _dbt_loaded_at
        
    from orders_enriched
)

select * from final
```

#### Marts Layer - Dimension Table

```sql
-- models/marts/core/dim_customers.sql

{{
  config(
    materialized='table'
  )
}}

with customers as (
    select * from {{ ref('stg_customers') }}
),

customer_orders as (
    select
        customer_id,
        count(*) as total_orders,
        sum(total_amount) as lifetime_value,
        min(order_date) as first_order_date,
        max(order_date) as last_order_date
    from {{ ref('fct_orders') }}
    group by customer_id
),

final as (
    select
        -- Keys
        {{ dbt_utils.generate_surrogate_key(['c.customer_id']) }} as customer_key,
        c.customer_id,
        
        -- Attributes
        c.customer_name,
        c.customer_email,
        c.customer_segment,
        c.country_code,
        
        -- Metrics
        coalesce(co.total_orders, 0) as total_orders,
        coalesce(co.lifetime_value, 0) as lifetime_value,
        co.first_order_date,
        co.last_order_date,
        
        -- Calculated
        case 
            when co.total_orders = 0 then 'Never Purchased'
            when co.total_orders = 1 then 'One-Time'
            when co.total_orders <= 5 then 'Occasional'
            else 'Frequent'
        end as customer_type,
        
        -- Metadata
        c._loaded_at,
        current_timestamp as _dbt_loaded_at
        
    from customers c
    left join customer_orders co on c.customer_id = co.customer_id
)

select * from final
```

### 🧪 Testes de Qualidade

#### Testes Genéricos (schema.yml)

```yaml
# models/staging/_staging.yml

version: 2

models:
  - name: stg_orders
    description: "Staging layer for orders"
    columns:
      - name: order_id
        description: "Primary key"
        tests:
          - unique
          - not_null
      
      - name: customer_id
        description: "Foreign key to customers"
        tests:
          - not_null
          - relationships:
              to: ref('stg_customers')
              field: customer_id
      
      - name: order_amount
        description: "Order amount in dollars"
        tests:
          - not_null
          - dbt_utils.accepted_range:
              min_value: 0
              max_value: 1000000
      
      - name: order_status
        description: "Order status"
        tests:
          - accepted_values:
              values: ['pending', 'processing', 'shipped', 'delivered', 'cancelled']
```

#### Testes Singulares (SQL)

```sql
-- tests/assert_positive_revenue.sql

-- Ensure all revenue values are positive
select
    order_id,
    order_amount
from {{ ref('fct_orders') }}
where order_amount < 0
```

### 🔧 Macros Úteis

```sql
-- macros/cents_to_dollars.sql

{% macro cents_to_dollars(column_name) %}
    ({{ column_name }} / 100.0)::numeric(10,2)
{% endmacro %}

-- Usage: {{ cents_to_dollars('amount_cents') }}
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

### 📊 Modelos Incrementais

```sql
-- models/marts/metrics/daily_revenue.sql

{{
  config(
    materialized='incremental',
    unique_key='date',
    on_schema_change='sync_all_columns'
  )
}}

select
    order_date as date,
    count(*) as order_count,
    sum(order_amount) as total_revenue,
    avg(order_amount) as avg_order_value,
    current_timestamp as _updated_at
    
from {{ ref('fct_orders') }}

{% if is_incremental() %}
    where order_date > (select max(date) from {{ this }})
{% endif %}

group by order_date
```

### 📸 Snapshots (SCD Type 2)

```sql
-- snapshots/orders_snapshot.sql

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

### 🎓 Conceitos Avançados

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

### 💡 Melhores Práticas

1. **Use camadas** (staging → intermediate → marts)
2. **Teste tudo** (unique, not_null, relationships)
3. **Documente modelos** (descriptions, columns)
4. **Use refs** ao invés de nomes de tabelas
5. **Implemente CI/CD** (GitHub Actions, GitLab CI)
6. **Monitore performance** (dbt Cloud, logs)
7. **Versionamento semântico** para mudanças breaking

### 🔗 Recursos Adicionais

- [dbt Documentation](https://docs.getdbt.com/)
- [dbt Discourse Community](https://discourse.getdbt.com/)
- [Analytics Engineering Guide](https://www.getdbt.com/analytics-engineering/)
- [dbt Utils Package](https://github.com/dbt-labs/dbt-utils)

### 🎯 Próximos Passos

- [ ] Adicionar mais modelos de métricas (churn, LTV, cohort)
- [ ] Implementar testes de performance
- [ ] Criar macros customizadas
- [ ] Integrar com dbt Cloud
- [ ] Adicionar CI/CD pipeline
- [ ] Implementar data quality monitoring

---

## 🇬🇧 Modern Data Warehouse Modeling with dbt

Complete and professional **Analytics Engineering** project using **dbt (data build tool)**. Demonstrates layered architecture, incremental models, automated testing, and living documentation for modern data warehouses.

### 🚀 Quick Start

```bash
# Install dbt
pip install dbt-core dbt-postgres

# Initialize project
dbt init my_project

# Run models
dbt run

# Test data quality
dbt test

# Generate documentation
dbt docs generate && dbt docs serve
```

### 🎓 Key Learnings

- ✅ Build layered data warehouse (staging → marts)
- ✅ Implement incremental models
- ✅ Write automated data tests
- ✅ Create reusable macros
- ✅ Generate living documentation
- ✅ Apply Analytics Engineering best practices

---

**Author:** Gabriel Demetrios Lafis  
**License:** MIT  
**Last Updated:** October 2025
