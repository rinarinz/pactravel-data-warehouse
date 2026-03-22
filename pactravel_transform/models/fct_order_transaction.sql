{{ config(materialized='table') }}

with flight_details as (
    select 
        fb.trip_id::text, 
        'flight' as booking_type, 
        fb.customer_id::text, 
        fb.airline_id::text,     
        fb.airport_src::text,    
        fb.airport_dst::text,    
        fb.aircraft_id::text, -- Ini yang tadi error karena ada huruf "320A320"
        null::text as hotel_id,
        fb.departure_date::date as booking_date, 
        fb.price::numeric as price,
        al.airline_name as provider_name, 
        ap_src.city as origin, 
        ap_dst.city as destination, 
        ac.aircraft_name as travel_details
    from {{ source('pactravel', 'flight_bookings') }} fb
    left join {{ ref('dim_airlines') }} al on fb.airline_id::text = al.airline_id::text
    left join {{ ref('dim_airports') }} ap_src on fb.airport_src::text = ap_src.airport_id::text
    left join {{ ref('dim_airports') }} ap_dst on fb.airport_dst::text = ap_dst.airport_id::text
    left join {{ ref('dim_aircrafts') }} ac on fb.aircraft_id::text = ac.aircraft_id::text
),

hotel_details as (
    select 
        hb.trip_id::text, 
        'hotel' as booking_type, 
        hb.customer_id::text, 
        null::text as airline_id, 
        null::text as airport_src, 
        null::text as airport_dst, 
        null::text as aircraft_id, 
        hb.hotel_id::text as hotel_id,       
        hb.check_in_date::date as booking_date, 
        hb.price::numeric as price,
        h.hotel_name as provider_name, 
        null::text as origin, 
        h.city as destination, 
        null::text as travel_details
    from {{ source('pactravel', 'hotel_bookings') }} hb
    left join {{ ref('dim_hotels') }} h on hb.hotel_id::text = h.hotel_id::text
),

combined as (
    select * from flight_details
    union all
    select * from hotel_details
)

select 
    c.trip_id,
    c.booking_type,
    c.customer_id,
    cust.full_name as customer_name,
    c.airline_id,
    c.hotel_id,
    c.airport_src,
    c.airport_dst,
    c.aircraft_id,
    c.booking_date,
    c.price,
    c.provider_name,
    c.origin,
    c.destination,
    c.travel_details
from combined c
left join {{ ref('dim_customers') }} cust on c.customer_id::text = cust.customer_id::text