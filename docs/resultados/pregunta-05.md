# Pregunta 05. Ranking de productos según rentabilidad

## 1. Enunciado

Identifique los productos de mayor y menor desempeño económico.

Se requiere determinar:

- Los cinco productos con mayor ganancia acumulada por categoría.
- Los cinco productos con mayor volumen de ventas.
- Los cinco productos con menor rentabilidad.
- El margen de ganancia individual y la posición de cada producto dentro de su categoría.

## 2. Estrategia de solución

Se agruparon los registros por categoría y producto, calculando las ventas totales, unidades vendidas y ganancias acumuladas.

Posteriormente, se utilizaron funciones de ventana para establecer rankings, calcular márgenes de ganancia y obtener valores acumulados por categoría.

Se aplicaron `RANK()`, `DENSE_RANK()` y `SUM() OVER()` para analizar el desempeño económico de los productos.

## 3. Consultas HiveQL

Las tres consultas desarrolladas y ejecutadas se encuentran en:

`scripts/05_ranking_productos.hql`

## 4. Resultados obtenidos

### Resultado 1. Cinco productos con mayor ganancia acumulada por categoría

Se identificaron cinco productos destacados en cada una de las tres categorías.

| Categoría       | Producto destacado                            | Ganancia | Margen (%) |
| --------------- | --------------------------------------------- | -------: | ---------: |
| Furniture       | Hon Deluxe Fabric Upholstered Stacking Chairs |  1927.44 |      18.12 |
| Office Supplies | Fellowes PB500 Electric Punch                 |  7753.04 |      28.24 |
| Technology      | Canon imageCLASS 2200 Advanced Copier         | 25199.93 |      40.91 |

La consulta también muestra los otros cuatro productos por categoría y la ganancia acumulada correspondiente.

**Evidencia:** `evidencias/pregunta-05/01_ranking_rentabilidad_categoria.png`

### Resultado 2. Cinco productos con mayor volumen de ventas

Se obtuvieron los siguientes productos según las unidades vendidas:

| Producto                                                   | Categoría       | Unidades |
| ---------------------------------------------------------- | --------------- | -------: |
| GBC Premium Transparent Covers with Diagonal Lined Pattern | Office Supplies |       67 |
| Situations Contoured Folding Chairs, 4/Set                 | Furniture       |       64 |
| Chromcraft Round Conference Tables                         | Furniture       |       61 |
| Wilson Jones Turn Tabs Binder Tool for Ring Binders        | Office Supplies |       59 |
| Global Wood Trimmed Manager's Task Chair, Khaki            | Furniture       |       59 |

**Evidencia:** `evidencias/pregunta-05/02_mayor_volumen.png`

### Resultado 3. Cinco productos con menor rentabilidad

Se identificaron los siguientes productos con los márgenes de ganancia más bajos:

| Producto                                           | Categoría       | Ganancia | Margen (%) |
| -------------------------------------------------- | --------------- | -------: | ---------: |
| Eureka Disposable Bags for Sanitaire Vibra Groomer | Office Supplies |    -4.47 |    -275.00 |
| Bush Westfield Collection Bookcases                | Furniture       |  -190.85 |    -210.00 |
| Euro Pro Shark Stick Mini Vacuum                   | Office Supplies |  -325.63 |    -190.71 |
| Okidata B401 Printer                               | Technology      |  -251.99 |    -140.00 |
| Zebra GK420t Direct Thermal Printer                | Technology      |  -938.28 |    -133.33 |

**Evidencia:** `evidencias/pregunta-05/03_menor_rentabilidad.png`

## 5. Interpretación técnica

Los resultados permiten observar diferencias importantes entre el volumen de ventas y la rentabilidad de los productos.

Technology presenta el producto destacado con mayor ganancia acumulada, mientras que algunos productos con un volumen considerable de unidades vendidas no necesariamente generan los mejores beneficios.

Por otra parte, los productos con márgenes negativos representan pérdidas económicas, lo que evidencia la importancia de analizar tanto las ventas como las ganancias.

## 6. Conclusión

El análisis permitió identificar los productos con mejor y peor desempeño económico mediante funciones de agregación y ventana en HiveQL.

El uso de `RANK()`, `DENSE_RANK()` y `SUM() OVER()` facilitó la clasificación de productos y el cálculo de ganancias acumuladas por categoría, proporcionando información útil para evaluar el rendimiento comercial.
