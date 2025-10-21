{{
  config(
    materialized='table',
    tags=['marts', 'metrics']
  )
}}

/*
Metrics Model: Revenue by Month
Author: Gabriel Demetrios Lafis
Description: Monthly aggregation of revenue, profit, and order metrics
*/

with orders as (
    select * from {{ ref('fct_orders') }}
),

monthly_metrics as (
    select
        date_trunc('month', order_date)::date as year_month,
        
        -- Order metrics
        count(distinct order_id) as order_count,
        count(distinct customer_id) as unique_customers,
        sum(quantity) as total_items_sold,
        
        -- Revenue metrics
        sum(sales_amount) as total_revenue,
        sum(net_sales) as total_net_revenue,
        sum(profit_amount) as total_profit,
        sum(cost_amount) as total_cost,
        
        -- Average metrics
        avg(sales_amount) as avg_order_value,
        avg(net_sales) as avg_net_order_value,
        avg(profit_margin) as profit_margin,
        avg(discount_rate) as avg_discount_rate,
        
        -- Performance metrics
        sum(case when is_profitable then 1 else 0 end) as profitable_orders,
        sum(case when has_discount then 1 else 0 end) as discounted_orders
        
    from orders
    group by date_trunc('month', order_date)
),

final as (
    select
        *,
        
        -- Calculated metrics
        profitable_orders::float / nullif(order_count, 0) as profitable_order_rate,
        discounted_orders::float / nullif(order_count, 0) as discount_rate_pct,
        total_profit / nullif(total_revenue, 0) as overall_profit_margin
        
    from monthly_metrics
)

select * from final
order by year_month
