# Pregunta 06. Impacto de los descuentos en la rentabilidad

## 1. Enunciado

Analizar el impacto de los descuentos aplicados sobre las ventas y la rentabilidad, identificando los rangos de descuento que generan mayores pérdidas y las categorías y subcategorías más afectadas.

## 2. Estrategia de solución

Se agruparon los registros según el nivel de descuento aplicado, clasificándolos en cuatro rangos: sin descuento, descuento bajo, medio y alto.

Posteriormente, se calcularon las ventas totales, ganancias acumuladas, margen de rentabilidad y cantidad de registros con pérdidas.

También se realizó un análisis por categoría y subcategoría para identificar los productos comerciales más afectados por los descuentos.

## 3. Consultas HiveQL desarrolladas

Se utilizaron dos consultas con funciones de agregación y expresiones condicionales:

- **Consulta 1:** Análisis general de la rentabilidad según el rango de descuento.
- **Consulta 2:** Análisis del impacto de los descuentos por categoría y subcategoría.

## 4. Resultados obtenidos

### Resultado 1. Rentabilidad según el rango de descuento

| Rango           | Registros | Ventas totales |   Ganancias | Margen (%) | Registros con pérdidas |
| --------------- | --------: | -------------: | ----------: | ---------: | ---------------------: |
| Sin descuento   |      4798 |   1,087,908.47 |  320,987.60 |      29.51 |                      0 |
| Descuento bajo  |      3803 |     846,522.24 |  100,785.47 |      11.91 |                    523 |
| Descuento medio |       537 |     298,541.41 |  -58,817.00 |     -19.70 |                    492 |
| Descuento alto  |       857 |     642,278.74 | -765,559.05 |    -119.20 |                    856 |

**Interpretación:** Los resultados muestran que los registros sin descuento presentan el mayor margen de rentabilidad, con un 29.51 %. A medida que aumenta el descuento, la rentabilidad disminuye. El descuento alto genera las mayores pérdidas, con una ganancia acumulada negativa de 765,559.05.

**Evidencia:** `evidencias/pregunta-06/01_impacto_descuentos_rentabilidad.png`

### Resultado 2. Impacto de los descuentos por categoría y subcategoría

Se identificaron las siguientes subcategorías afectadas:

| Categoría       | Subcategoría | Rango | Registros con pérdidas (%) |   Ganancia |
| --------------- | ------------ | ----- | -------------------------: | ---------: |
| Office Supplies | Binders      | Alto  |                     100.00 | -38,510.50 |
| Furniture       | Furnishings  | Alto  |                     100.00 |  -5,944.66 |
| Office Supplies | Appliances   | Alto  |                     100.00 |  -8,629.64 |
| Technology      | Machines     | Alto  |                     100.00 | -19,579.32 |
| Furniture       | Bookcases    | Alto  |                     100.00 |  -3,894.94 |
| Furniture       | Bookcases    | Medio |                      98.18 |  -7,202.82 |
| Furniture       | Tables       | Medio |                      97.73 | -30,698.22 |
| Furniture       | Chairs       | Medio |                      93.67 |  -6,737.12 |
| Technology      | Phones       | Medio |                      88.99 |  -6,385.79 |
| Technology      | Machines     | Medio |                      70.00 |  -9,976.03 |
| Office Supplies | Storage      | Bajo  |                      50.95 |  -4,249.35 |
| Office Supplies | Supplies     | Bajo  |                      45.21 |  -2,907.49 |
| Furniture       | Tables       | Bajo  |                      43.66 |    -303.56 |
| Furniture       | Bookcases    | Bajo  |                      40.82 |   1,549.49 |
| Technology      | Accessories  | Bajo  |                      29.93 |   6,647.78 |

**Interpretación:** Las subcategorías presentan mayores porcentajes de registros con pérdidas cuando se aplican descuentos altos. Destacan Binders, Furnishings, Appliances, Machines y Bookcases, donde el 100 % de los registros analizados presenta pérdidas.

**Evidencia:** `evidencias/pregunta-06/02_impacto_descuentos_categoria_subcategoria.png`

## 5. Conclusión

El análisis demuestra que los descuentos elevados afectan negativamente la rentabilidad de las ventas. Los resultados permiten identificar los rangos de descuento más perjudiciales y las subcategorías que presentan mayores pérdidas económicas.

Las consultas de HiveQL permiten evaluar el comportamiento de las ganancias y respaldar decisiones comerciales relacionadas con las políticas de descuentos.
