# Análisis de ventas de Sample Superstore con Apache Hive

**Tecnologías Emergentes · Segundo momento · Alejandro Vidal**

## 1. Descripción del proyecto

El proyecto transforma el CSV de Sample Superstore en un archivo compatible con Hive, lo carga en HDFS y utiliza consultas HiveQL para evaluar la calidad de los datos y analizar el desempeño comercial.

## 2. Objetivos

- Preparar el conjunto de datos y verificar su integridad en Hive.
- Analizar ventas y ganancias por región y período, y segmentar clientes según recencia, frecuencia e importe acumulado.
- Evaluar la rentabilidad de productos, el impacto de los descuentos y la concentración de ventas y ganancias mediante Pareto.

## 3. Tecnologías y herramientas utilizadas

| Tecnología | Uso y versión comprobada |
| --- | --- |
| Apache Hadoop | HDFS para almacenamiento y YARN para ejecución. La imagen base del entorno LI16 usa Hadoop 3.3.6. |
| Apache Hive y Beeline | HiveServer2 y cliente JDBC. La captura de conexión muestra la versión 4.0.1. |
| PostgreSQL | Base de datos del metastore de Hive. El Compose de LI16 usa la imagen `postgres:16-alpine`. |
| Docker y Docker Compose | Construcción de imágenes y ejecución del entorno LI16. |
| Python 3 | Preparación del archivo mediante la biblioteca estándar. |

[Captura de conexión a HiveServer2](evidencias/pregunta-01/02_creacion_base_datos.png).

## 4. Requisitos previos

- Python 3.8 o posterior para ejecutar el script de preparación, que utiliza `Path.unlink(missing_ok=True)`.
- Docker en ejecución con el comando `docker compose` disponible.
- Entorno de la práctica LI16 disponible como carpeta hermana `../bigdata-hive-li16`, con su `Dockerfile`, su archivo `docker-compose.yml` y la configuración requerida por ese entorno. El despliegue se realiza desde esa carpeta. Los demás comandos de PowerShell parten de la raíz del repositorio del examen.

## 5. Dataset utilizado y sus características

Sample Superstore contiene líneas de pedidos con datos de clientes, productos, ubicaciones, ventas, cantidades, descuentos y ganancias. El CSV original está separado por comas y codificado en Windows-1252. Contiene 9.994 registros, 21 columnas, 5.009 órdenes y 793 clientes. Las fechas de pedido abarcan de enero de 2014 a diciembre de 2017. El archivo preparado conserva el encabezado y usa tabulaciones y UTF-8.

[CSV original](data/raw/Sample%20-%20Superstore.csv) · [TSV preparado](data/processed/sample_superstore_hive.tsv) · [Captura del dataset](evidencias/dataset_00/01_dataset_original.png).

## 6. Estructura del repositorio

```text
.
├── README.md
├── data/
│   ├── raw/           CSV original
│   └── processed/     TSV para Hive
├── docs/
│   ├── diccionario_datos.md
│   └── resultados/    Informes de las preguntas 02 a 06
├── evidencias/
│   ├── dataset_00/    Captura del dataset original
│   └── pregunta-01/ a pregunta-06/
└── scripts/           Preparación en Python y consultas HiveQL de la 02 a la 08
```

## 7. Diccionario de datos

El diccionario documenta los 21 campos, su significado, sus restricciones y los rangos observados. Para reproducir el esquema físico se usa la definición de la sección 10. La tabla creada en Hive utiliza `DECIMAL(18,4)` para `sales` y `profit`, mientras que el diccionario registra `DECIMAL(12,4)` para ambos campos.

[Diccionario de datos](docs/diccionario_datos.md) · [Esquema mostrado por Hive](evidencias/pregunta-01/04_descripcion_tabla.png).

## 8. Procedimiento de preparación y carga de datos

Desde la raíz del repositorio, ejecuta el [script de preparación](scripts/01_prepare_dataset.py). El script valida el número de campos y registros, convierte las fechas de pedido y envío a `AAAA-MM-DD` y genera el TSV.

```powershell
python scripts/01_prepare_dataset.py
```

Después de iniciar el entorno según la sección 9, copia el TSV al contenedor del NameNode y súbelo a HDFS. La ruta de carga es `/data/superstore/sample_superstore_hive.tsv`.

```powershell
$compose = '../bigdata-hive-li16/docker-compose.yml'
docker compose -f $compose cp ./data/processed/sample_superstore_hive.tsv namenode:/tmp/sample_superstore_hive.tsv
docker compose -f $compose exec namenode hdfs dfs -mkdir -p /data/superstore
docker compose -f $compose exec namenode hdfs dfs -put -f /tmp/sample_superstore_hive.tsv /data/superstore/
docker compose -f $compose exec namenode hdfs dfs -ls -h /data/superstore/
```

## 9. Procedimiento de ejecución del entorno Hadoop y Hive

Desde la raíz del repositorio, entra en el entorno LI16 y ejecuta su script de arranque para Windows. El script construye la imagen base de Hadoop e inicia los servicios con Compose.

```powershell
Push-Location ../bigdata-hive-li16
./start-cluster.bat
docker compose ps
Pop-Location
```

Con HDFS disponible, realiza la carga de la sección 8. Cuando HiveServer2 acepte conexiones, abre Beeline desde el contenedor del servicio.

```powershell
$compose = '../bigdata-hive-li16/docker-compose.yml'
docker compose -f $compose exec hiveserver2 beeline -u 'jdbc:hive2://localhost:10000/default' -n hive
```

## 10. Creación y utilización de la base de datos y tabla

Ejecuta en Beeline la definición usada en la pregunta 01. La tabla administrada `tem1_2mom_alejandro_vidal.sample_superstore` almacena texto delimitado por tabulaciones y declara que debe omitirse la primera línea del archivo.

```sql
CREATE DATABASE IF NOT EXISTS tem1_2mom_alejandro_vidal;
USE tem1_2mom_alejandro_vidal;

CREATE TABLE sample_superstore (
    row_id INT,
    order_id STRING,
    order_date DATE,
    ship_date DATE,
    ship_mode STRING,
    customer_id STRING,
    customer_name STRING,
    segment STRING,
    country STRING,
    city STRING,
    state STRING,
    postal_code STRING,
    region STRING,
    product_id STRING,
    category STRING,
    sub_category STRING,
    product_name STRING,
    sales DECIMAL(18,4),
    quantity INT,
    discount DECIMAL(5,4),
    profit DECIMAL(18,4)
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
TBLPROPERTIES ('skip.header.line.count'='1');

DESCRIBE sample_superstore;

LOAD DATA INPATH '/data/superstore/sample_superstore_hive.tsv'
INTO TABLE sample_superstore;

SELECT COUNT(*) AS registros_con_identificador
FROM sample_superstore
WHERE row_id IS NOT NULL;
```

Ejecuta la carga sobre una tabla recién creada. La evidencia de la pregunta 01 muestra 9.995 filas en el conteo inicial con `COUNT(*)`. La auditoría de la pregunta 02 filtra por `row_id IS NOT NULL` y documenta 9.994 registros.

## 11. Consultas HiveQL correspondientes a las preguntas del examen

La pregunta 01 corresponde a la preparación, definición y carga de las secciones 8 a 10. Después de la carga, puedes ejecutar las consultas en Beeline. Este ejemplo copia la auditoría al contenedor y ejecuta el archivo con `-f`. Para ejecutar otra pregunta, usa el archivo correspondiente en ambos comandos.

```powershell
$compose = '../bigdata-hive-li16/docker-compose.yml'
docker compose -f $compose cp ./scripts/02_auditoria_calidad.hql hiveserver2:/tmp/02_auditoria_calidad.hql
docker compose -f $compose exec hiveserver2 beeline -u 'jdbc:hive2://localhost:10000/default' -n hive -f /tmp/02_auditoria_calidad.hql
```

| Pregunta | Consulta |
| --- | --- |
| 02. Auditoría de calidad e integridad | [02_auditoria_calidad.hql](scripts/02_auditoria_calidad.hql) |
| 03. Evolución regional de ventas y ganancias | [03_evolucion_regional.hql](scripts/03_evolucion_regional.hql) |
| 04. Segmentación de clientes mediante RFM | [04_segmentacion_rfm.hql](scripts/04_segmentacion_rfm.hql) |
| 05. Ranking de productos según rentabilidad | [05_ranking_productos.hql](scripts/05_ranking_productos.hql) |
| 06. Impacto de los descuentos en la rentabilidad | [06_impacto_descuentos.hql](scripts/06_impacto_descuentos.hql) |
| 07. Tendencias temporales | [07_tendencias_temporales.hql](scripts/07_tendencias_temporales.hql) |
| 08. Análisis de Pareto | [08_analisis_pareto.hql](scripts/08_analisis_pareto.hql) |

## 12. Documentación de resultados y evidencias

| Pregunta | Documentación | Evidencias |
| --- | --- | --- |
| 01 | Procedimiento en las secciones 8 a 10 | [Carga en HDFS](evidencias/pregunta-01/01_carga_hdfs.png) · [Creación de la base de datos](evidencias/pregunta-01/02_creacion_base_datos.png) · [Creación de la tabla](evidencias/pregunta-01/03_creacion_tabla.png) · [Descripción de la tabla](evidencias/pregunta-01/04_descripcion_tabla.png) · [Carga en Hive](evidencias/pregunta-01/05_carga_datos_hive.png) |
| 02 | [Informe de auditoría](docs/resultados/pregunta-02.md) | [Resumen de calidad](evidencias/pregunta-02/01_resumen_calidad.png) |
| 03 | [Informe de evolución regional](docs/resultados/pregunta-03.md) | [Evolución regional](evidencias/pregunta-03/01_evolucion_regional.png) |
| 04 | [Informe de segmentación RFM](docs/resultados/pregunta-04.md) | [Captura 1](evidencias/pregunta-04/01_segmentacion_rfm.png) · [Captura 2](evidencias/pregunta-04/02_segmentacion_rfm.png) |
| 05 | [Informe de ranking de productos](docs/resultados/pregunta-05.md) | [Rentabilidad por categoría](evidencias/pregunta-05/01_ranking_rentabilidad_categoria.png) · [Mayor volumen](evidencias/pregunta-05/02_mayor_volumen.png) · [Menor rentabilidad](evidencias/pregunta-05/03_menor_rentabilidad.png) |
| 06 | [Informe de descuentos](docs/resultados/pregunta-06.md) | [Rentabilidad por rango de descuento](evidencias/pregunta-06/01_impacto_descuentos_rentabilidad.png) · [Impacto por categoría y subcategoría](evidencias/pregunta-06/02_impacto_descuentos_categoria_subcategoria.png) |

