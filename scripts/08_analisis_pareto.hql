
USE tem1_2mom_alejandro_vidal;

WITH productos AS (
    SELECT
        category,
        product_id,
        product_name,
        SUM(sales) AS total_ventas,
        SUM(profit) AS ganancia_total
    FROM sample_superstore
    GROUP BY category, product_id, product_name
),

acumulados AS (
    SELECT
        *,

        SUM(total_ventas) OVER ()
            AS ventas_globales,

        SUM(total_ventas) OVER (
            ORDER BY total_ventas DESC, product_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS ventas_acumuladas

    FROM productos
),

participacion AS (
    SELECT
        *,

        ROUND(
            100.0 * total_ventas / ventas_globales, 2
        ) AS participacion_individual_pct,

        ROUND(
            100.0 * ventas_acumuladas / ventas_globales, 2
        ) AS participacion_acumulada_pct

    FROM acumulados
),

productos_80 AS (
    SELECT
        *,
        COUNT(*) OVER () AS cantidad_productos_hasta_80
    FROM participacion
    WHERE ventas_acumuladas - total_ventas
        < ventas_globales * 0.80
)

SELECT
    product_id,
    product_name,
    category,

    ROUND(total_ventas, 2) AS ventas,
    participacion_individual_pct,
    ROUND(ventas_acumuladas, 2) AS ventas_acumuladas,
    participacion_acumulada_pct,

    cantidad_productos_hasta_80

FROM productos_80
ORDER BY total_ventas DESC;


-- RESULTADO 2: Concentracion del 80% de las ganancias.

WITH productos AS (
    SELECT
        category,
        product_id,
        product_name,
        SUM(sales) AS total_ventas,
        SUM(profit) AS ganancia_total
    FROM sample_superstore
    GROUP BY category, product_id, product_name
),

acumulados AS (
    SELECT
        *,

        SUM(ganancia_total) OVER ()
            AS ganancias_globales,

        SUM(ganancia_total) OVER (
            ORDER BY ganancia_total DESC, product_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS ganancias_acumuladas

    FROM productos
),

participacion AS (
    SELECT
        *,

        ROUND(
            100.0 * ganancia_total / ganancias_globales, 2
        ) AS participacion_individual_pct,

        ROUND(
            100.0 * ganancias_acumuladas / ganancias_globales, 2
        ) AS participacion_acumulada_pct

    FROM acumulados
),

productos_80 AS (
    SELECT
        *,
        COUNT(*) OVER () AS cantidad_productos_hasta_80
    FROM participacion
    WHERE ganancias_acumuladas - ganancia_total
        < ganancias_globales * 0.80
)

SELECT
    product_id,
    product_name,
    category,

    ROUND(ganancia_total, 2) AS ganancias,
    participacion_individual_pct,
    ROUND(ganancias_acumuladas, 2) AS ganancias_acumuladas,
    participacion_acumulada_pct,

    cantidad_productos_hasta_80

FROM productos_80
ORDER BY ganancia_total DESC;
