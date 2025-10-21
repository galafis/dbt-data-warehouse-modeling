{{
  config(
    materialized='view',
    tags=['intermediate']
  )
}}

/*
Intermediate Model: Customer Metrics
Author: Gabriel Demetrios Lafis
Description: Calculate customer-level metrics from orders
*/

with orders as (
    select * from {{ ref('stg_orders') }}
),

customer_aggregates as (
    select
        customer_id,
        
        -- Dates
        min(order_date) as first_order_date,
        max(order_date) as last_order_date,
        
        -- Order counts
        count(distinct order_id) as total_orders,
        count(distinct date_trunc('month', order_date)) as active_months,
        
        -- Financial metrics
        sum(sales_amount) as total_sales,
        sum(profit_amount) as total_profit,
        avg(sales_amount) as avg_order_value,
        sum(quantity) as total_items_purchased,
        
        -- Quality metrics
        avg(profit_margin) as avg_profit_margin,
        avg(discount_rate) as avg_discount_rate,
        
        -- Derived metrics
        sum(sales_amount * (1 - discount_rate)) as total_net_sales
        
    from orders
    group by customer_id
),

final as (
    select
        *,
        
        -- Calculated fields
        datediff(day, first_order_date, last_order_date) as days_as_customer,
        
        case
            when total_profit > 0 then total_profit / nullif(total_sales, 0)
            else 0
        end as lifetime_profit_margin,
        
        case
            when days_as_customer > 0 
            then total_orders::float / nullif(days_as_customer, 0) * 365
            else 0
        end as orders_per_year
        
    from customer_aggregates
)

select * from final
