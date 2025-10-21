{{
  config(
    materialized='view',
    tags=['intermediate']
  )
}}

/*
Intermediate Model: Orders Enriched
Author: Gabriel Demetrios Lafis
Description: Enrich orders with customer and product information
*/

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
        o.ship_date,
        o.sales_amount,
        o.quantity,
        o.discount_rate,
        o.profit_amount,
        o.profit_margin,
        o.days_to_ship,
        
        -- Customer info
        c.customer_id,
        c.customer_name,
        c.segment as customer_segment,
        c.country as customer_country,
        c.city as customer_city,
        c.state as customer_state,
        c.region as customer_region,
        
        -- Product info
        p.product_id,
        p.product_name,
        p.category as product_category,
        p.sub_category as product_sub_category,
        
        -- Calculated fields
        o.sales_amount * (1 - o.discount_rate) as net_sales,
        o.sales_amount - o.profit_amount as cost_amount,
        
        -- Flags
        case 
            when o.profit_amount > 0 then true 
            else false 
        end as is_profitable,
        
        case
            when o.discount_rate > 0 then true
            else false
        end as has_discount,
        
        -- Metadata
        o.loaded_at
        
    from orders o
    left join customers c on o.customer_id = c.customer_id
    left join products p on o.product_id = p.product_id
)

select 
    *,
    net_sales as total_amount
from enriched
