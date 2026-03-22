-- Analisis harga rata-rata berdasarkan provider (Nama Hotel/Maskapai)
SELECT 
    booking_type,
    provider_name,
    COUNT(*) as total_transactions,
    ROUND(AVG(price)::numeric, 2) as avg_price,
    MAX(price) as max_price
FROM final.fct_order_transaction
GROUP BY booking_type, provider_name
ORDER BY avg_price DESC
LIMIT 10;