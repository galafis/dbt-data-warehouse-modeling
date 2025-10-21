{{
  config(
    materialized='incremental',
    unique_key='order_id',
    tags=['marts', 'core', 'fact']
  )
}}

/*
Fact Table: Orders
Author: Gabriel Demetrios Lafis
Description: Main fact table for order transactions
*/

with orders_enriched as (
    select * from {{ ref('int_orders_enriched') }}
    
    {% if is_incremental() %}
    -- Only process new/updated orders
    where order_date >= (select max(order_date) - interval '7 days' from {{ this }})
    {% endif %}
),

final as (
    select
        -- Keys
        order_id,
        customer_id,
        product_id,
        
        -- Dates
        order_date,
        ship_date,
        
        -- Measures
        sales_amount,
        net_sales,
        profit_amount,
        cost_amount,
        quantity,
        
        -- Rates
        discount_rate,
        profit_margin,
        
        -- Dimensions
        customer_segment,
        customer_country,
        customer_city,
        customer_state,
        customer_region,
        product_category,
        product_sub_category,
        
        -- Metrics
        days_to_ship,
        
        -- Flags
        is_profitable,
        has_discount,
        
        -- Metadata
        current_timestamp as _dbt_loaded_at
        
    from orders_enriched
)

select * from final
