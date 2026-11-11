# Análisis de ventas de Sample Superstore con Apache Hive

Segundo momento de Tecnologías Emergentes · Alejandro Vidal

El proyecto prepara los datos de Sample Superstore para cargarlos en HDFS y consultarlos con HiveQL. Los análisis cubren calidad de datos, desempeño regional, segmentación de clientes, rentabilidad de productos y descuentos.

## Datos y carga en Hive

- [CSV original](data/raw/Sample%20-%20Superstore.csv) y [captura del dataset](evidencias/dataset_00/01_dataset_original.png).
- [Diccionario de datos](docs/diccionario_datos.md), [script de preparación](scripts/01_prepare_dataset.py) y [TSV procesado](data/processed/sample_superstore_hive.tsv).
- Evidencias de la pregunta 01. [Carga en HDFS](evidencias/pregunta-01/01_carga_hdfs.png), [creación de la base de datos](evidencias/pregunta-01/02_creacion_base_datos.png), [creación de la tabla](evidencias/pregunta-01/03_creacion_tabla.png), [descripción de la tabla](evidencias/pregunta-01/04_descripcion_tabla.png) y [carga de datos en Hive](evidencias/pregunta-01/05_carga_datos_hive.png).

## Consultas, resultados y evidencias

| Pregunta | Consulta | Documentación | Evidencias |
| --- | --- | --- | --- |
| 02. Auditoría de calidad e integridad | [HiveQL](scripts/02_auditoria_calidad.hql) | [Resultados](docs/resultados/pregunta-02.md) | [Resumen de calidad](evidencias/pregunta-02/01_resumen_calidad.png) |
| 03. Evolución regional de ventas y ganancias | [HiveQL](scripts/03_evolucion_regional.hql) | [Resultados](docs/resultados/pregunta-03.md) | [Evolución regional](evidencias/pregunta-03/01_evolucion_regional.png) |
| 04. Segmentación de clientes mediante RFM | [HiveQL](scripts/04_segmentacion_rfm.hql) | [Resultados](docs/resultados/pregunta-04.md) | [Captura 1](evidencias/pregunta-04/01_segmentacion_rfm.png) · [Captura 2](evidencias/pregunta-04/02_segmentacion_rfm.png) |
| 05. Ranking de productos según rentabilidad | [HiveQL](scripts/05_ranking_productos.hql) | [Resultados](docs/resultados/pregunta-05.md) | [Rentabilidad por categoría](evidencias/pregunta-05/01_ranking_rentabilidad_categoria.png) · [Mayor volumen](evidencias/pregunta-05/02_mayor_volumen.png) · [Menor rentabilidad](evidencias/pregunta-05/03_menor_rentabilidad.png) |
| 06. Impacto de los descuentos en la rentabilidad | [HiveQL](scripts/06_impacto_descuentos.hql) | [Resultados](docs/resultados/pregunta-06.md) | [Rentabilidad por rango de descuento](evidencias/pregunta-06/01_impacto_descuentos_rentabilidad.png) · [Impacto por categoría y subcategoría](evidencias/pregunta-06/02_impacto_descuentos_categoria_subcategoria.png) |
| 07. Tendencias temporales | [HiveQL](scripts/07_tendencias_temporales.hql) | — | — |
| 08. Análisis de Pareto | [HiveQL](scripts/08_analisis_pareto.hql) | — | — |
