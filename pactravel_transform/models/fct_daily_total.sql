{{ config(materialized='table') }}

select 
    booking_date as date,
    booking_type,
    count(trip_id) as total_bookings,
    sum(price) as total_revenue,
    avg(price) as avg_ticket_price
from {{ ref('fct_order_transaction') }}
group by 1, 2
order by 1 desc, 2