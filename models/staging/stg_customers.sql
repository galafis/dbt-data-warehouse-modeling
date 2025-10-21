{{
  config(
    materialized='view',
    tags=['staging']
  )
}}

/*
Staging Model: Customers
Author: Gabriel Demetrios Lafis
Description: Clean and standardize raw customer data
*/

with source as (
    select * from {{ source('raw', 'customers') }}
),

renamed as (
    select
        -- Primary Key
        customer_id,
        
        -- Attributes
        customer_name,
        lower(trim(segment)) as segment,
        
        -- Location
        country,
        city,
        state,
        lower(trim(region)) as region,
        
        -- Metadata
        current_timestamp as loaded_at
        
    from source
),

cleaned as (
    select
        *,
        
        -- Data Quality Checks
        case
            when customer_name is null then 'Invalid: Missing Name'
            when country is null then 'Invalid: Missing Country'
            else 'Valid'
        end as data_quality_flag
        
    from renamed
)

select * from cleaned
where data_quality_flag = 'Valid'
