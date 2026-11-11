
USE tem1_2mom_alejandro_vidal;


WITH clasificados AS (
    SELECT
        category,
        sub_category,
        sales,
        profit,
        discount,
        CASE
            WHEN discount = 0 THEN 'Sin descuento'
            WHEN discount <= 0.20 THEN 'Descuento bajo'
            WHEN discount <= 0.50 THEN 'Descuento medio'
            ELSE 'Descuento alto'
        END AS rango_descuento
    FROM sample_superstore
)
SELECT
    rango_descuento,
    COUNT(*) AS total_registros,
    ROUND(SUM(sales), 2) AS ventas_totales,
    ROUND(SUM(profit), 2) AS ganancias_totales,

    ROUND(
        100.0 * SUM(profit) / SUM(sales), 2
    ) AS margen_rentabilidad_pct,

    SUM(
        CASE WHEN profit < 0 THEN 1 ELSE 0 END
    ) AS registros_con_perdida,

    ROUND(
        100.0 * SUM(
            CASE WHEN profit < 0 THEN 1 ELSE 0 END
        ) / COUNT(*), 2
    ) AS porcentaje_no_rentables,

    ROUND(AVG(discount) * 100, 2)
        AS descuento_promedio_pct

FROM clasificados
GROUP BY rango_descuento
ORDER BY
    CASE rango_descuento
        WHEN 'Sin descuento' THEN 1
        WHEN 'Descuento bajo' THEN 2
        WHEN 'Descuento medio' THEN 3
        WHEN 'Descuento alto' THEN 4
    END;


-- RESULTADO 2: Categorias y subcategorias
-- mas afectadas por los descuentos.

WITH clasificados AS (
    SELECT
        category,
        sub_category,
        sales,
        profit,
        discount,
        CASE
            WHEN discount = 0 THEN 'Sin descuento'
            WHEN discount <= 0.20 THEN 'Descuento bajo'
            WHEN discount <= 0.50 THEN 'Descuento medio'
            ELSE 'Descuento alto'
        END AS rango_descuento
    FROM sample_superstore
)
SELECT
    category,
    sub_category,
    rango_descuento,
    COUNT(*) AS total_registros,

    SUM(
        CASE WHEN profit < 0 THEN 1 ELSE 0 END
    ) AS registros_con_perdida,

    ROUND(
        100.0 * SUM(
            CASE WHEN profit < 0 THEN 1 ELSE 0 END
        ) / COUNT(*), 2
    ) AS porcentaje_no_rentables,

    ROUND(SUM(sales), 2) AS ventas_totales,
    ROUND(SUM(profit), 2) AS ganancias_totales,
    ROUND(AVG(discount) * 100, 2)
        AS descuento_promedio_pct

FROM clasificados
GROUP BY category, sub_category, rango_descuento
ORDER BY
    porcentaje_no_rentables DESC,
    registros_con_perdida DESC
LIMIT 15;
