-- Assert that all customers have at least one order
-- This test will fail if any customer has zero orders

select
    customer_id,
    total_orders
from {{ ref('dim_customers') }}
where total_orders = 0
