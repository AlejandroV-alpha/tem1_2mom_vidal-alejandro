import csv
from pathlib import Path

root = Path(__file__).resolve().parents[1]

origen = root / "data/raw/Sample - Superstore.csv"
destino = root / "data/processed/sample_superstore_utf8.csv"

with origen.open("r", encoding="cp1252", newline="") as entrada:
    lector = csv.reader(entrada)

    encabezado = next(lector)

    if len(encabezado) != 21:
        raise ValueError("El dataset no contiene las 21 columnas esperadas.")

    total = 0

    with destino.open("w", encoding="utf-8", newline="") as salida:
        escritor = csv.writer(
            salida,
            delimiter=",",
            quotechar='"',
            quoting=csv.QUOTE_MINIMAL,
            lineterminator="\n"
        )

        escritor.writerow(encabezado)

        for numero, fila in enumerate(lector, start=2):
            if len(fila) != 21:
                raise ValueError(
                    f"Fila {numero}: se esperaban 21 columnas y se encontraron {len(fila)}."
                )

            escritor.writerow(fila)
            total += 1

if total != 9994:
    raise ValueError(f"Cantidad inesperada de registros: {total}")

print("Preparacion completada correctamente.")
print("Registros:", total)
print("Columnas:", len(encabezado))
print("Archivo:", destino)
print("Tamano:", round(destino.stat().st_size / 1024, 2), "KB")
