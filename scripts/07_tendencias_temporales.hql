
USE tem1_2mom_alejandro_vidal;


WITH ventas_mensuales AS (
    SELECT
        YEAR(order_date) AS anio,
        MONTH(order_date) AS mes,

        CONCAT(
            CAST(YEAR(order_date) AS STRING),
            '-',
            LPAD(CAST(MONTH(order_date) AS STRING), 2, '0')
        ) AS periodo,

        SUM(sales) AS ventas_mes,
        SUM(profit) AS ganancias_mes

    FROM sample_superstore
    GROUP BY
        YEAR(order_date),
        MONTH(order_date)
),

ventanas AS (
    SELECT
        *,

        LAG(ventas_mes, 1) OVER (
            ORDER BY anio, mes
        ) AS ventas_mes_anterior,

        LAG(ganancias_mes, 1) OVER (
            ORDER BY anio, mes
        ) AS ganancias_mes_anterior,

        AVG(ventas_mes) OVER (
            ORDER BY anio, mes
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) AS promedio_movil_ventas_3m,

        AVG(ganancias_mes) OVER (
            ORDER BY anio, mes
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) AS promedio_movil_ganancias_3m

    FROM ventas_mensuales
),

comparacion AS (
    SELECT
        actual.*,

        anterior.ventas_mes AS ventas_mismo_mes_anterior,
        anterior.ganancias_mes AS ganancias_mismo_mes_anterior

    FROM ventanas actual

    LEFT JOIN ventas_mensuales anterior
        ON anterior.anio = actual.anio - 1
        AND anterior.mes = actual.mes
)

SELECT
    periodo,

    ROUND(ventas_mes, 2) AS ventas,
    ROUND(ganancias_mes, 2) AS ganancias,

    ROUND(
        CASE
            WHEN ventas_mes_anterior IS NOT NULL
                 AND ventas_mes_anterior <> 0
            THEN
                100.0 * (ventas_mes - ventas_mes_anterior)
                / ventas_mes_anterior
            ELSE NULL
        END, 2
    ) AS variacion_ventas_mes_pct,

    ROUND(
        CASE
            WHEN ganancias_mes_anterior IS NOT NULL
                 AND ganancias_mes_anterior <> 0
            THEN
                100.0 * (ganancias_mes - ganancias_mes_anterior)
                / ABS(ganancias_mes_anterior)
            ELSE NULL
        END, 2
    ) AS variacion_ganancias_mes_pct,

    ROUND(
        CASE
            WHEN ventas_mismo_mes_anterior IS NOT NULL
                 AND ventas_mismo_mes_anterior <> 0
            THEN
                100.0 * (ventas_mes - ventas_mismo_mes_anterior)
                / ventas_mismo_mes_anterior
            ELSE NULL
        END, 2
    ) AS variacion_ventas_anual_pct,

    ROUND(
        CASE
            WHEN ganancias_mismo_mes_anterior IS NOT NULL
                 AND ganancias_mismo_mes_anterior <> 0
            THEN
                100.0 * (ganancias_mes - ganancias_mismo_mes_anterior)
                / ABS(ganancias_mismo_mes_anterior)
            ELSE NULL
        END, 2
    ) AS variacion_ganancias_anual_pct,

    ROUND(promedio_movil_ventas_3m, 2)
        AS promedio_movil_ventas_3m,

    ROUND(promedio_movil_ganancias_3m, 2)
        AS promedio_movil_ganancias_3m

FROM comparacion
ORDER BY anio, mes;


-- RESULTADO 2: Tres meses con mayor y menor
-- volumen de ventas.

WITH ventas_mensuales AS (
    SELECT
        YEAR(order_date) AS anio,
        MONTH(order_date) AS mes,

        CONCAT(
            CAST(YEAR(order_date) AS STRING),
            '-',
            LPAD(CAST(MONTH(order_date) AS STRING), 2, '0')
        ) AS periodo,

        SUM(sales) AS ventas_mes,
        SUM(profit) AS ganancias_mes

    FROM sample_superstore
    GROUP BY
        YEAR(order_date),
        MONTH(order_date)
),

ranking AS (
    SELECT
        *,

        RANK() OVER (
            ORDER BY ventas_mes DESC
        ) AS ranking_mayor,

        RANK() OVER (
            ORDER BY ventas_mes ASC
        ) AS ranking_menor

    FROM ventas_mensuales
)

SELECT
    CASE
        WHEN ranking_mayor <= 3 THEN 'Tres mayores'
        ELSE 'Tres menores'
    END AS clasificacion,

    periodo,
    ROUND(ventas_mes, 2) AS ventas,
    ROUND(ganancias_mes, 2) AS ganancias,

    ranking_mayor,
    ranking_menor

FROM ranking

WHERE ranking_mayor <= 3
   OR ranking_menor <= 3

ORDER BY
    CASE
        WHEN ranking_mayor <= 3 THEN 1
        ELSE 2
    END,
    ventas_mes DESC;
