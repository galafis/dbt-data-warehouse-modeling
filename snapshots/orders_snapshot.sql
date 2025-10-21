{% snapshot orders_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='order_id',
      strategy='timestamp',
      updated_at='loaded_at'
    )
}}

select 
    order_id,
    customer_id,
    product_id,
    order_date,
    ship_date,
    sales_amount,
    profit_amount,
    quantity,
    discount_rate,
    loaded_at
from {{ ref('stg_orders') }}

{% endsnapshot %}
