{{
  config(
    materialized='table',
    tags=['marts', 'core', 'dimension']
  )
}}

/*
Dimension Table: Products
Author: Gabriel Demetrios Lafis
Description: Product dimension with attributes
*/

with products as (
    select * from {{ ref('stg_products') }}
),

product_metrics as (
    select
        product_id,
        count(distinct order_id) as total_orders,
        sum(quantity) as total_units_sold,
        sum(sales_amount) as total_sales,
        sum(profit_amount) as total_profit,
        avg(profit_margin) as avg_profit_margin,
        min(order_date) as first_order_date,
        max(order_date) as last_order_date
    from {{ ref('fct_orders') }}
    group by product_id
),

final as (
    select
        -- Keys
        p.product_id,
        
        -- Attributes
        p.product_name,
        p.category,
        p.sub_category,
        
        -- Metrics
        coalesce(pm.total_orders, 0) as total_orders,
        coalesce(pm.total_units_sold, 0) as total_units_sold,
        coalesce(pm.total_sales, 0) as total_sales,
        coalesce(pm.total_profit, 0) as total_profit,
        coalesce(pm.avg_profit_margin, 0) as avg_profit_margin,
        pm.first_order_date,
        pm.last_order_date,
        
        -- Calculated fields
        case
            when pm.total_sales >= 50000 then 'Best Seller'
            when pm.total_sales >= 20000 then 'Popular'
            when pm.total_sales >= 5000 then 'Average'
            else 'Low Seller'
        end as product_performance,
        
        -- Metadata
        p.loaded_at,
        current_timestamp as _dbt_loaded_at
        
    from products p
    left join product_metrics pm on p.product_id = pm.product_id
)

select * from final
