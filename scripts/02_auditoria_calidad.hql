WITH datos AS (
    SELECT *
    FROM tem1_2mom_alejandro_vidal.sample_superstore
    WHERE row_id IS NOT NULL
),
duplicados AS (
    SELECT COUNT(*) AS ids_duplicados
    FROM (
        SELECT row_id
        FROM datos
        GROUP BY row_id
        HAVING COUNT(*) > 1
    ) d
),
resumen AS (
    SELECT
        COUNT(*) AS total_registros,
        COUNT(DISTINCT order_id) AS ordenes_unicas,
        COUNT(DISTINCT customer_id) AS clientes_unicos,
        SUM(CASE WHEN sales <= 0 THEN 1 ELSE 0 END) AS ventas_no_validas,
        SUM(CASE WHEN discount < 0 OR discount > 1 THEN 1 ELSE 0 END) AS descuentos_invalidos,
        SUM(CASE WHEN order_date IS NULL OR ship_date IS NULL THEN 1 ELSE 0 END) AS fechas_invalidas,
        SUM(CASE WHEN ship_date < order_date THEN 1 ELSE 0 END) AS envios_inconsistentes
    FROM datos
)
SELECT *
FROM resumen
CROSS JOIN duplicados;