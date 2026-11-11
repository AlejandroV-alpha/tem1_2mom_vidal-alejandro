
USE tem1_2mom_alejandro_vidal;

-- 1. Obtener las metricas iniciales de cada cliente.
WITH fecha_referencia AS (
    SELECT MAX(order_date) AS fecha_maxima
    FROM sample_superstore
),
clientes_base AS (
    SELECT
        customer_id,
        MAX(order_date) AS ultima_compra,
        COUNT(DISTINCT order_id) AS frequency,
        SUM(sales) AS monetary
    FROM sample_superstore
    WHERE customer_id IS NOT NULL
      AND TRIM(customer_id) <> ''
      AND order_date IS NOT NULL
    GROUP BY customer_id
),

-- 2. Calcular Recency.
metricas_rfm AS (
    SELECT
        c.customer_id,
        c.ultima_compra,
        DATEDIFF(f.fecha_maxima, c.ultima_compra) AS recency,
        c.frequency,
        c.monetary
    FROM clientes_base c
    CROSS JOIN fecha_referencia f
),

-- 3. Asignar puntuaciones de 1 a 5.
puntuaciones AS (
    SELECT
        customer_id,
        ultima_compra,
        recency,
        frequency,
        ROUND(monetary, 2) AS monetary,

        NTILE(5) OVER (
            ORDER BY recency DESC, customer_id
        ) AS r_score,

        NTILE(5) OVER (
            ORDER BY frequency ASC, customer_id
        ) AS f_score,

        NTILE(5) OVER (
            ORDER BY monetary ASC, customer_id
        ) AS m_score

    FROM metricas_rfm
),

-- 4. Clasificar clientes.
segmentacion AS (
    SELECT
        *,
        (r_score + f_score + m_score) AS rfm_score,

        CASE
            WHEN r_score >= 4
             AND f_score >= 4
             AND m_score >= 4
                THEN 'Alto valor'

            WHEN r_score <= 2
                THEN 'En riesgo de abandono'

            WHEN f_score >= 4
                THEN 'Recurrentes'

            ELSE 'Otros clientes'
        END AS segmento

    FROM puntuaciones
)

-- 5. Mostrar resultados.
SELECT
    customer_id,
    ultima_compra,
    recency,
    frequency,
    monetary,
    r_score,
    f_score,
    m_score,
    rfm_score,
    segmento
FROM segmentacion
ORDER BY rfm_score DESC, monetary DESC;
