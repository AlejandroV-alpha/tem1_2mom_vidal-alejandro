WITH ventas_anuales AS (
    SELECT
        region,
        YEAR(order_date) AS anio,
        SUM(sales) AS ventas_totales,
        SUM(profit) AS ganancias_totales
    FROM tem1_2mom_alejandro_vidal.sample_superstore
    WHERE order_date IS NOT NULL
      AND region IS NOT NULL
    GROUP BY region, YEAR(order_date)
),

indicadores AS (
    SELECT
        region,
        anio,
        ventas_totales,
        ganancias_totales,

        ROUND(
            ganancias_totales / ventas_totales * 100, 2
        ) AS margen_rentabilidad,

        LAG(ventas_totales) OVER (
            PARTITION BY region
            ORDER BY anio
        ) AS ventas_anio_anterior,

        LAG(ganancias_totales) OVER (
            PARTITION BY region
            ORDER BY anio
        ) AS ganancias_anio_anterior

    FROM ventas_anuales
),

resultados AS (
    SELECT
        region,
        anio,
        ROUND(ventas_totales, 2) AS ventas_totales,
        ROUND(ganancias_totales, 2) AS ganancias_totales,
        margen_rentabilidad,

        ROUND(
            (ventas_totales - ventas_anio_anterior)
            / ventas_anio_anterior * 100, 2
        ) AS variacion_ventas_pct,

        ROUND(
            (ganancias_totales - ganancias_anio_anterior)
            / ABS(ganancias_anio_anterior) * 100, 2
        ) AS variacion_ganancias_pct,

        RANK() OVER (
            PARTITION BY anio
            ORDER BY ventas_totales DESC
        ) AS ranking_ventas,

        RANK() OVER (
            PARTITION BY anio
            ORDER BY ganancias_totales DESC
        ) AS ranking_ganancias,

        RANK() OVER (
            PARTITION BY anio
            ORDER BY ventas_totales ASC
        ) AS ranking_ventas_asc

    FROM indicadores
)

SELECT *
FROM resultados
ORDER BY anio, region;