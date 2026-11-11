# Pregunta 03 - Evolucion regional de ventas y ganancias

## 1. Objetivo

Analizar la evolucion anual de las ventas y ganancias por region, identificando la rentabilidad, las variaciones porcentuales y el posicionamiento de cada region.

## 2. Estrategia de solucion

Se agruparon las ventas y ganancias por region y año mediante GROUP BY.

Se utilizaron funciones de ventana:

- LAG(): obtiene los valores del año anterior para calcular variaciones.
- RANK(): establece posiciones de las regiones segun sus ventas y ganancias.
- PARTITION BY: realiza las comparaciones independientemente por region o año.

Tambien se calculo el margen de rentabilidad dividiendo las ganancias entre las ventas y multiplicando por 100.

## 3. Consulta HiveQL

Archivo: `scripts/03_evolucion_regional.hql`

## 4. Evidencia de ejecucion

Archivo: `evidencias/pregunta-03/01_evolucion_regional.png`

## 5. Resultado obtenido

La consulta genero 16 registros correspondientes a cuatro regiones durante cuatro años (2014-2017).

Se obtuvieron las ventas totales, ganancias, margenes de rentabilidad, variaciones interanuales y rankings regionales.

Las variaciones del año 2014 aparecen como NULL porque no existe un periodo anterior para realizar la comparacion.

## 6. Interpretacion tecnica

Los resultados permiten comparar el comportamiento comercial de las cuatro regiones a lo largo del tiempo.

Se observa que la region West presenta el mayor volumen de ventas en 2014, con 147883.03, mientras que Central registra el menor volumen, con 103838.16.

Los rankings permiten identificar las posiciones de cada region y las funciones LAG() facilitan el analisis de crecimiento o disminucion respecto al año anterior.

## 7. Conclusion

El uso de funciones de ventana en Hive permite analizar tendencias historicas sin perder el detalle de cada region. Esto facilita identificar cambios en el rendimiento comercial y comparar la rentabilidad entre periodos.
