{{
  config(
    materialized='table',
    tags=['marts', 'core', 'dimension']
  )
}}

/*
Dimension Table: Customers
Author: Gabriel Demetrios Lafis
Description: Customer dimension with attributes and aggregated metrics
*/

with customers as (
    select * from {{ ref('stg_customers') }}
),

customer_metrics as (
    select * from {{ ref('int_customer_metrics') }}
),

final as (
    select
        -- Keys
        c.customer_id,
        
        -- Attributes
        c.customer_name,
        c.segment,
        c.country,
        c.city,
        c.state,
        c.region,
        
        -- Dates
        cm.first_order_date,
        cm.last_order_date,
        
        -- Metrics
        coalesce(cm.total_orders, 0) as total_orders,
        coalesce(cm.total_sales, 0) as lifetime_value,
        coalesce(cm.total_profit, 0) as lifetime_profit,
        coalesce(cm.avg_order_value, 0) as avg_order_value,
        coalesce(cm.total_items_purchased, 0) as total_items_purchased,
        coalesce(cm.avg_profit_margin, 0) as avg_profit_margin,
        coalesce(cm.avg_discount_rate, 0) as avg_discount_rate,
        coalesce(cm.days_as_customer, 0) as days_as_customer,
        coalesce(cm.orders_per_year, 0) as orders_per_year,
        
        -- Calculated classifications
        case 
            when cm.total_orders is null or cm.total_orders = 0 then 'Never Purchased'
            when cm.total_orders = 1 then 'One-Time'
            when cm.total_orders <= 5 then 'Occasional'
            when cm.total_orders <= 10 then 'Regular'
            else 'Frequent'
        end as customer_type,
        
        case
            when cm.total_sales >= 10000 then 'High Value'
            when cm.total_sales >= 5000 then 'Medium Value'
            when cm.total_sales >= 1000 then 'Low Value'
            else 'Very Low Value'
        end as value_segment,
        
        -- Metadata
        c.loaded_at,
        current_timestamp as _dbt_loaded_at
        
    from customers c
    left join customer_metrics cm on c.customer_id = cm.customer_id
)

select * from final
