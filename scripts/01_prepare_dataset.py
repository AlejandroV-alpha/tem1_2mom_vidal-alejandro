import csv
from pathlib import Path
from datetime import datetime

root = Path(__file__).resolve().parents[1]

origen = root / "data/raw/Sample - Superstore.csv"
destino = root / "data/processed/sample_superstore_hive.tsv"
anterior = root / "data/processed/sample_superstore_utf8.csv"

total = 0

with origen.open("r", encoding="cp1252", newline="") as entrada:
    lector = csv.reader(entrada)
    encabezado = next(lector)

    if len(encabezado) != 21:
        raise ValueError("Encabezado incorrecto.")

    with destino.open("w", encoding="utf-8", newline="") as salida:
        escritor = csv.writer(
            salida,
            delimiter="\t",
            quotechar=None,
            quoting=csv.QUOTE_NONE,
            lineterminator="\n"
        )

        escritor.writerow(encabezado)

        for numero, fila in enumerate(lector, start=2):
            if len(fila) != 21:
                raise ValueError(f"Fila incorrecta: {numero}")

            if any("\t" in campo or "\n" in campo or "\r" in campo for campo in fila):
                raise ValueError(f"Separador o salto de linea en fila {numero}.")

            fila[2] = datetime.strptime(fila[2], "%m/%d/%Y").strftime("%Y-%m-%d")
            fila[3] = datetime.strptime(fila[3], "%m/%d/%Y").strftime("%Y-%m-%d")

            escritor.writerow(fila)
            total += 1

if total != 9994:
    raise ValueError(f"Registros inesperados: {total}")

anterior.unlink(missing_ok=True)

print("Archivo preparado para Hive.")
print("Registros:", total)
print("Columnas:", len(encabezado))
print("Separador: TAB")
print("Archivo:", destino)
