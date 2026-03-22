-- Melihat tren volume harian terbaru berdasarkan tipe produk
SELECT * FROM final.fct_daily_total 
ORDER BY date DESC, booking_type
LIMIT 20;