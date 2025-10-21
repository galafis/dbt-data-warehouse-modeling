{{
  config(
    materialized='table',
    tags=['marts', 'metrics']
  )
}}

/*
Metrics Model: Customer Cohorts
Author: Gabriel Demetrios Lafis
Description: Cohort analysis of customers based on first purchase date
*/

with customers as (
    select * from {{ ref('dim_customers') }}
),

orders as (
    select * from {{ ref('fct_orders') }}
),

customer_cohorts as (
    select
        date_trunc('month', c.first_order_date)::date as cohort_month,
        c.customer_id,
        c.lifetime_value,
        c.total_orders,
        c.lifetime_profit
    from customers c
    where c.first_order_date is not null
),

cohort_metrics as (
    select
        cohort_month,
        
        -- Cohort size
        count(distinct customer_id) as customers,
        
        -- Aggregate metrics
        sum(total_orders) as total_orders,
        sum(lifetime_value) as total_revenue,
        sum(lifetime_profit) as total_profit,
        
        -- Average metrics
        avg(lifetime_value) as avg_customer_value,
        avg(total_orders) as avg_orders_per_customer,
        avg(lifetime_profit) as avg_profit_per_customer
        
    from customer_cohorts
    group by cohort_month
),

final as (
    select
        *,
        
        -- Calculated metrics
        total_profit / nullif(total_revenue, 0) as cohort_profit_margin,
        total_revenue / nullif(customers, 0) as revenue_per_customer
        
    from cohort_metrics
)

select * from final
order by cohort_month
