# Pregunta 2. Auditoría de calidad e integridad de datos

## 1. Estrategia de solución

Se utilizó una consulta HiveQL con CTE para evaluar la calidad
del dataset, identificando registros, órdenes y clientes únicos,
duplicados y posibles inconsistencias comerciales y temporales.

## 2. Consulta HiveQL

Archivo: `scripts/02_auditoria_calidad.hql`

## 3. Resultados obtenidos

| Indicador                  | Resultado |
| -------------------------- | --------: |
| Total de registros         |     9.994 |
| Órdenes únicas             |     5.009 |
| Clientes únicos            |       793 |
| Identificadores duplicados |         0 |
| Ventas no válidas          |         0 |
| Descuentos inválidos       |         0 |
| Fechas inválidas           |         0 |
| Envíos inconsistentes      |         0 |

## 4. Interpretación técnica

El análisis identificó 9.994 registros, correspondientes a
5.009 órdenes y 793 clientes únicos.

No se encontraron identificadores duplicados, ventas no válidas,
descuentos fuera del intervalo esperado ni inconsistencias
en las fechas de pedido y envío.

La revisión previa del archivo CSV tampoco identificó campos
vacíos ni registros con columnas faltantes.

## 5. Criterios de tratamiento

- Identificadores duplicados: revisar y conservar un único registro válido.
- Ventas no positivas: excluirlas de los análisis comerciales.
- Descuentos inválidos: revisar los valores fuera del intervalo de 0 a 1.
- Fechas inválidas: verificar y corregir los formatos.
- Envíos inconsistentes: revisar los registros donde el envío
  precede al pedido.

## 6. Conclusión

El dataset presenta condiciones adecuadas para continuar
con los análisis comerciales, ya que las verificaciones
realizadas no identificaron inconsistencias en los indicadores evaluados.
