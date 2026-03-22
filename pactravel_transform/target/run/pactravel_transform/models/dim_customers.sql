
  
    

  create  table "pactravel_dwh"."final"."dim_customers__dbt_tmp"
  
  
    as
  
  (
    

select 
    customer_id,
    customer_first_name || ' ' || customer_family_name as full_name,
    customer_gender as gender,
    customer_birth_date as birth_date,
    customer_country as country,
    customer_phone_number as phone_number
from "pactravel_dwh"."pactravel"."customers"
  );
  