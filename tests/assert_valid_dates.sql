-- Assert that order dates are valid and ship dates come after order dates
-- This test will fail if dates are invalid

select
    order_id,
    order_date,
    ship_date
from {{ ref('fct_orders') }}
where order_date is null
   or ship_date is null
   or order_date > ship_date
   or order_date > current_date
   or ship_date > current_date
