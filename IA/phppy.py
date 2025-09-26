# my_script.py
import sys

if len(sys.argv) > 1:
    name = sys.argv[1]
else:
    name = "World"

print(f"Hello, {name} from Python!")

import requests

url = 'http://localhost/CodigoProyectoEgreso/IA/pyphp.php'
mensaje = {
    'nombre': 'Este es un mensaje desde cliente.py'
}

# Enviar POST
response = requests.post(url, json=mensaje)

# Mostrar respuesta del servidor
print("Código de respuesta:", response.status_code)
print("Respuesta:", response.json())