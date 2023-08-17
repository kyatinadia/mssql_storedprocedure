-- Active: 1681548299618@@mst-sqlmi-pbitest.public.c29bef56a9d0.database.windows.net@3342@SQL_TEST1@dbo
ALTER PROCEDURE dbo.kyatinadiayahoocom_procedure
AS
SELECT 
        c."Kota/Kabupaten",
        c."Bulan",
        IIF(c.Prevmonth = 0, '0.00%', CAST(CAST((c.Jumlah - c.Prevmonth) * 100.00 / c.Prevmonth AS DECIMAL(10, 2)) AS VARCHAR(10)) + '%') AS "Kenaikan Kedatangan Penduduk"
    FROM (
        SELECT 
            b.Kota "Kota/Kabupaten",
            b.Monthyear "Bulan",
            b.Jumlah, 
            LAG(b.Jumlah, 1,0) OVER (PARTITION BY b.Kota ORDER BY b.Month ASC) AS Prevmonth  
        FROM (
            SELECT
                a.[Kota/Kabupaten] "Kota",
                CONCAT(a.Bulan,' ', a.Tahun) as Monthyear,
                a.Month, 
                sum(a.Jumlah) "Jumlah" 
            FROM (
                SELECT
                    Kota_Kabupaten "Kota/Kabupaten",
                    CASE
                    WHEN STR(Month) = 1 THEN 'Jan'
                    WHEN STR(Month) = 2 THEN 'Feb'
                    WHEN STR(Month) = 3 THEN 'Mar'
                    WHEN STR(Month) = 4 THEN 'Apr'
                    WHEN STR(Month) = 5 THEN 'May'
                    WHEN STR(Month) = 6 THEN 'Jun'
                    WHEN STR(Month) = 7 THEN 'Jul'
                    WHEN STR(Month) = 8 THEN 'Aug'
                    WHEN STR(Month) = 9 THEN 'Sep'
                    WHEN STR(Month) = 10 THEN 'Oct'
                    WHEN STR(Month) = 11 THEN 'Nov'
                    WHEN STR(Month) = 12 THEN 'Dec'
                    END AS "Bulan",
                    Year "Tahun",
                    Month,
                    Jumlah
                FROM Kedatangan_Penduduk
            ) AS a
            GROUP BY a.[Kota/Kabupaten], CONCAT(a.Bulan,' ', a.Tahun), a.Month
        ) AS b
    ) AS c;


EXEC kyatinadiayahoocom_procedure;