-- Cek khusus data penerbangan untuk melihat origin
SELECT 
    booking_type,
    provider_name, -- Nama Maskapai
    origin,        -- Nama Kota Asal
    destination,   -- Nama Kota Tujuan
    price
FROM final.fct_order_transaction
WHERE booking_type = 'flight'
LIMIT 10;

-- Kolom origin bernilai NULL pada transaksi tipe hotel karena pesanan hotel hanya mencatat lokasi penginapan (destination) tanpa melibatkan lokasi keberangkatan. 
-- Data origin hanya terisi pada transaksi tipe flight yang merekam rute perjalanan antar kota.