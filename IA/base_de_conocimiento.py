import fitz  # PyMuPDF

pdf_document = fitz.open("Creacion 3ra entrega.pdf")
texto_extraido = ""
for pagina in pdf_document:
    texto_extraido += pagina.get_text()


import faiss
import numpy as np

# Crear un conjunto de vectores de ejemplo (100 vectores de 128 dimensiones)
dimension = 128
num_vectors = 100
data = np.random.random((num_vectors, dimension)).astype('float32')

# Crear un índice de FAISS
index = faiss.IndexFlatL2(dimension)  # IndexFlatL2 usa la distancia Euclidiana

# Agregar los vectores al índice
index.add(data)

# Ver cuántos vectores están en el índice
print(f"Vectores en el índice: {index.ntotal}")
