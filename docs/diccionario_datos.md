# Diccionario de datos - Sample Superstore

## 1. Informacion general

- Dataset: Sample Superstore
- Archivo: Sample - Superstore.csv
- Formato: CSV
- Codificacion: Windows-1252 (cp1252)
- Separador: coma (,)
- Registros analizados: 9994
- Columnas: 21

## 2. Diccionario de datos

| N. | Campo original | Tipo Hive | Descripcion | Restricciones o consideraciones |
|---:|---|---|---|---|
| 1 | Row ID | INT | Identificador unico de cada registro. | Unico y positivo. |
| 2 | Order ID | STRING | Identificador de la orden de compra. | No vacio; puede repetirse entre productos de una orden. |
| 3 | Order Date | DATE | Fecha en que se realizo el pedido. | Fecha valida, formato original MM/DD/YYYY. |
| 4 | Ship Date | DATE | Fecha en que se envio el pedido. | Fecha valida y no anterior a Order Date. |
| 5 | Ship Mode | STRING | Modalidad de envio utilizada. | Categoria controlada. |
| 6 | Customer ID | STRING | Identificador del cliente. | Identificador no numerico; no vacio. |
| 7 | Customer Name | STRING | Nombre del cliente. | Texto descriptivo. |
| 8 | Segment | STRING | Segmento comercial del cliente. | Categoria controlada. |
| 9 | Country | STRING | Pais donde se realizo la venta. | En este dataset se encontro un unico valor. |
| 10 | City | STRING | Ciudad del cliente o destino de venta. | Texto descriptivo. |
| 11 | State | STRING | Estado geografico. | Texto descriptivo. |
| 12 | Postal Code | STRING | Codigo postal. | Se conserva como texto para evitar perder ceros iniciales. |
| 13 | Region | STRING | Region geografica de la venta. | Categoria controlada. |
| 14 | Product ID | STRING | Identificador del producto. | Codigo alfanumerico. |
| 15 | Category | STRING | Categoria principal del producto. | Categoria controlada. |
| 16 | Sub-Category | STRING | Subcategoria del producto. | Categoria controlada. |
| 17 | Product Name | STRING | Nombre descriptivo del producto. | Texto; puede contener comas. |
| 18 | Sales | DECIMAL(12,4) | Importe de venta del registro. | Valor esperado positivo. |
| 19 | Quantity | INT | Cantidad de unidades vendidas. | Valor esperado positivo. |
| 20 | Discount | DECIMAL(5,4) | Descuento aplicado a la venta. | Rango esperado entre 0 y 1. |
| 21 | Profit | DECIMAL(12,4) | Ganancia o perdida del registro. | Puede ser positivo, cero o negativo. |

## 3. Perfil inicial del dataset

| Indicador | Resultado |
|---|---:|
| Registros | 9994 |
| Columnas | 21 |
| Row ID diferentes | 9994 |
| Order ID diferentes | 5009 |
| Customer ID diferentes | 793 |
| Filas con columnas adicionales | 0 |
| Filas con columnas faltantes | 0 |
| Campos vacios detectados | 0 |

## 4. Rangos observados

| Campo | Minimo | Maximo |
|---|---:|---:|
| Row ID | 1 | 9994 |
| Order Date | 2014-01-03 | 2017-12-30 |
| Ship Date | 2014-01-07 | 2018-01-05 |
| Sales | 0.444 | 22638.48 |
| Quantity | 1 | 14 |
| Discount | 0 | 0.8 |
| Profit | -6599.978 | 8399.976 |

## 5. Consideraciones

- Se analizaron todos los registros mediante Python.
- Los tipos numericos y fechas se comprobaron mediante conversiones.
- Los identificadores se conservan como texto cuando no representan cantidades.
- Los campos de texto requieren validaciones de dominio adicionales.
- La auditoria detallada de duplicados, fechas inconsistentes, ventas y descuentos se desarrollara en la Pregunta 2 mediante HiveQL.
