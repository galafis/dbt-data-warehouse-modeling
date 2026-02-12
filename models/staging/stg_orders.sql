{{
  config(
    materialized='view',
    tags=['staging']
  )
}}

/*
Staging Model: Orders
Author: Gabriel Demetrios Lafis
Description: Clean and standardize raw orders data
*/

with source as (
    select * from {{ source('raw', 'orders') }}
),

renamed as (
    select
        -- Primary Key
        order_id,
        
        -- Foreign Keys
        customer_id,
        product_id,
        
        -- Dates
        cast(order_date as date) as order_date,
        cast(ship_date as date) as ship_date,
        
        -- Dimensions
        ship_mode,
        segment,
        country,
        city,
        state,
        region,
        category,
        sub_category,
        product_name,
        
        -- Metrics
        cast(sales as numeric(10,2)) as sales_amount,
        cast(quantity as integer) as quantity,
        cast(discount as numeric(5,4)) as discount_rate,
        cast(profit as numeric(10,2)) as profit_amount,
        
        -- Metadata
        current_timestamp as loaded_at
        
    from source
),

cleaned as (
    select
        *,
        
        -- Data Quality Checks
        case
            when sales_amount < 0 then 'Invalid: Negative Sales'
            when quantity <= 0 then 'Invalid: Zero or Negative Quantity'
            when order_date > ship_date then 'Invalid: Order Date After Ship Date'
            else 'Valid'
        end as data_quality_flag,
        
        -- Calculated Fields
        sales_amount * (1 - discount_rate) as net_sales,
        profit_amount / nullif(sales_amount, 0) as profit_margin,
        (ship_date - order_date) as days_to_ship
        
    from renamed
)

select * from cleaned
where data_quality_flag = 'Valid'
