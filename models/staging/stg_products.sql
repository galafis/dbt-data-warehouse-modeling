{{
  config(
    materialized='view',
    tags=['staging']
  )
}}

/*
Staging Model: Products
Author: Gabriel Demetrios Lafis
Description: Clean and standardize raw product data
*/

with source as (
    select * from {{ source('raw', 'products') }}
),

renamed as (
    select
        -- Primary Key
        product_id,
        
        -- Attributes
        product_name,
        lower(trim(category)) as category,
        lower(trim(sub_category)) as sub_category,
        
        -- Metadata
        current_timestamp as loaded_at
        
    from source
),

cleaned as (
    select
        *,
        
        -- Data Quality Checks
        case
            when product_name is null then 'Invalid: Missing Product Name'
            when category is null then 'Invalid: Missing Category'
            else 'Valid'
        end as data_quality_flag
        
    from renamed
)

select * from cleaned
where data_quality_flag = 'Valid'
