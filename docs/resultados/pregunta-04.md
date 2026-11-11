# Pregunta 04. Segmentación avanzada de clientes mediante RFM

## 1. Enunciado

Construya un análisis RFM (Recency, Frequency, Monetary) para identificar los diferentes perfiles de clientes, considerando la fecha de última compra, la frecuencia de pedidos y el importe total acumulado. Asigne puntuaciones a cada dimensión y clasifique a los clientes en segmentos según su comportamiento de compra.

## 2. Estrategia

Se implementó un análisis RFM utilizando Apache Hive sobre la tabla `sample_superstore`, agrupando los registros por cliente.

Se utilizaron las siguientes dimensiones:

- **Recency (R):** cantidad de días transcurridos desde la última compra del cliente hasta la fecha máxima registrada en el dataset. Un menor número de días representa una mejor puntuación.
- **Frequency (F):** cantidad de órdenes únicas realizadas por cada cliente.
- **Monetary (M):** importe total acumulado de las ventas realizadas por cada cliente.

Para asignar las puntuaciones se utilizó la función `NTILE(5)`, que distribuye los clientes en cinco grupos según cada dimensión, asignando puntuaciones del 1 al 5.

La clasificación considera los siguientes criterios:

| Segmento              | Criterio                                                     |
| --------------------- | ------------------------------------------------------------ |
| Alto valor            | Las tres puntuaciones R, F y M son iguales o superiores a 4. |
| En riesgo de abandono | La puntuación R es igual o inferior a 2.                     |
| Recurrentes           | La puntuación F es igual o superior a 4.                     |
| Otros clientes        | Clientes que no cumplen los criterios anteriores.            |

## 3. Implementación en HiveQL

La consulta se desarrolló mediante expresiones comunes de tabla (CTE), separando el cálculo de métricas, la asignación de puntuaciones y la clasificación final.

El script correspondiente se encuentra en:

`scripts/04_segmentacion_rfm.hql`

Se utilizaron las siguientes funciones:

- `MAX()`: obtiene la fecha máxima del dataset como referencia.
- `DATEDIFF()`: calcula los días transcurridos desde la última compra.
- `COUNT(DISTINCT)`: cuenta las órdenes únicas de cada cliente.
- `SUM()`: calcula el importe acumulado de ventas.
- `NTILE(5)`: distribuye los clientes en cinco grupos para asignar las puntuaciones.
- `CASE WHEN`: establece las reglas de clasificación de los segmentos.

La puntuación R se ordena inversamente, porque una menor cantidad de días desde la última compra representa un mejor resultado. En cambio, Frequency y Monetary se ordenan ascendentemente para asignar mejores puntuaciones a los valores más altos.

## 4. Evidencias de ejecución

Se registraron dos evidencias de la ejecución de la consulta en Apache Hive mediante Beeline:

- `evidencias/pregunta-04/01_segmentacion_rfm.png`: muestra el inicio de los resultados de la consulta.
- `evidencias/pregunta-04/02_segmentacion_rfm.png`: muestra la parte final de los resultados y la finalización de la ejecución.

## 5. Resultados obtenidos

La consulta se ejecutó correctamente y devolvió **793 clientes segmentados**.

La fecha máxima utilizada como referencia fue el 30 de diciembre de 2017.

Los resultados obtenidos se distribuyeron de la siguiente manera:

| Segmento              | Clientes |       Porcentaje |
| --------------------- | -------: | ---------------: |
| Alto valor            |      104 |          13,11 % |
| Recurrentes           |      131 |          16,52 % |
| En riesgo de abandono |      318 |          40,10 % |
| Otros clientes        |      240 |          30,26 % |
| **Total**             |  **793** | **100 % aprox.** |

Las puntuaciones individuales de cada dimensión se encuentran entre 1 y 5, mientras que la puntuación RFM total se encuentra entre 3 y 15.

## 6. Interpretación técnica

Los resultados muestran que el segmento más numeroso corresponde a los clientes en riesgo de abandono, con 318 clientes, equivalente aproximadamente al 40,10 % del total analizado. Esto indica que una proporción importante de clientes lleva un periodo considerable sin realizar compras.

Por otra parte, se identificaron 104 clientes de alto valor, quienes presentan puntuaciones elevadas en las tres dimensiones del análisis. Estos clientes representan un grupo importante para las estrategias de fidelización.

También se identificaron 131 clientes recurrentes, caracterizados principalmente por una frecuencia elevada de pedidos, y 240 clientes clasificados como otros clientes, que no cumplen los criterios establecidos para los segmentos anteriores.

La utilización de quintiles permitió establecer puntuaciones relativas según el comportamiento de los clientes dentro del conjunto de datos, mientras que las reglas `CASE WHEN` facilitaron su clasificación.

## 7. Conclusión

Se implementó satisfactoriamente un análisis RFM mediante Apache Hive, utilizando funciones de agregación, funciones de ventana y condiciones de clasificación.

El análisis permitió segmentar 793 clientes en cuatro grupos, identificando aquellos que generan mayor valor, mantienen compras frecuentes o presentan riesgo de abandono.

De esta manera, Hive permitió transformar los registros de ventas en información útil para comprender el comportamiento de los clientes y apoyar la toma de decisiones comerciales.
