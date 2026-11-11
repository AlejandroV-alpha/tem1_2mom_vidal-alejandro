USE tem1_2mom_alejandro_vidal;

-- RESULTADO 1: Cinco productos con mayor ganancia
-- acumulada por categoria.

WITH productos AS (
    SELECT
        category,
        product_id,
        product_name,
        SUM(sales) AS total_ventas,
        SUM(quantity) AS unidades_vendidas,
        SUM(profit) AS ganancia_total
    FROM sample_superstore
    GROUP BY category, product_id, product_name
),
metricas AS (
    SELECT
        *,
        CASE
            WHEN total_ventas <> 0
            THEN ROUND(ganancia_total / total_ventas * 100, 2)
            ELSE NULL
        END AS margen_ganancia_pct
    FROM productos
),
ranking AS (
    SELECT
        *,
        RANK() OVER (
            PARTITION BY category
            ORDER BY ganancia_total DESC
        ) AS ranking_ganancia_categoria,

        SUM(ganancia_total) OVER (
            PARTITION BY category
            ORDER BY ganancia_total DESC, product_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS ganancia_acumulada_categoria
    FROM metricas
)
SELECT
    category,
    product_id,
    product_name,
    ROUND(total_ventas, 2) AS ventas,
    unidades_vendidas,
    ROUND(ganancia_total, 2) AS ganancia,
    margen_ganancia_pct,
    ranking_ganancia_categoria,
    ROUND(ganancia_acumulada_categoria, 2) AS ganancia_acumulada
FROM ranking
WHERE ranking_ganancia_categoria <= 5
ORDER BY category, ranking_ganancia_categoria;


-- RESULTADO 2: Cinco productos con mayor volumen de ventas.

WITH productos AS (
    SELECT
        category,
        product_id,
        product_name,
        SUM(sales) AS total_ventas,
        SUM(quantity) AS unidades_vendidas,
        SUM(profit) AS ganancia_total
    FROM sample_superstore
    GROUP BY category, product_id, product_name
),
metricas AS (
    SELECT
        *,
        CASE
            WHEN total_ventas <> 0
            THEN ROUND(ganancia_total / total_ventas * 100, 2)
            ELSE NULL
        END AS margen_ganancia_pct
    FROM productos
),
ranking AS (
    SELECT
        *,
        RANK() OVER (
            ORDER BY unidades_vendidas DESC
        ) AS ranking_volumen_global,

        DENSE_RANK() OVER (
            PARTITION BY category
            ORDER BY unidades_vendidas DESC
        ) AS ranking_unidades_categoria,

        SUM(total_ventas) OVER (
            PARTITION BY category
            ORDER BY total_ventas DESC, product_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS ventas_acumuladas_categoria
    FROM metricas
)
SELECT
    category,
    product_id,
    product_name,
    unidades_vendidas,
    ROUND(total_ventas, 2) AS ventas,
    ROUND(ganancia_total, 2) AS ganancia,
    margen_ganancia_pct,
    ranking_volumen_global,
    ranking_unidades_categoria,
    ROUND(ventas_acumuladas_categoria, 2) AS ventas_acumuladas
FROM ranking
WHERE ranking_volumen_global <= 5
ORDER BY ranking_volumen_global;


-- RESULTADO 3: Cinco productos con menor rentabilidad.

WITH productos AS (
    SELECT
        category,
        product_id,
        product_name,
        SUM(sales) AS total_ventas,
        SUM(quantity) AS unidades_vendidas,
        SUM(profit) AS ganancia_total
    FROM sample_superstore
    GROUP BY category, product_id, product_name
),
metricas AS (
    SELECT
        *,
        CASE
            WHEN total_ventas <> 0
            THEN ROUND(ganancia_total / total_ventas * 100, 2)
            ELSE NULL
        END AS margen_ganancia_pct
    FROM productos
),
ranking AS (
    SELECT
        *,
        RANK() OVER (
            ORDER BY margen_ganancia_pct ASC
        ) AS ranking_menor_rentabilidad,

        RANK() OVER (
            PARTITION BY category
            ORDER BY ganancia_total DESC
        ) AS ranking_ganancia_categoria
    FROM metricas
)
SELECT
    category,
    product_id,
    product_name,
    ROUND(total_ventas, 2) AS ventas,
    unidades_vendidas,
    ROUND(ganancia_total, 2) AS ganancia,
    margen_ganancia_pct,
    ranking_menor_rentabilidad,
    ranking_ganancia_categoria
FROM ranking
WHERE ranking_menor_rentabilidad <= 5
ORDER BY ranking_menor_rentabilidad;
