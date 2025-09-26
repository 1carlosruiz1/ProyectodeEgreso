from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return '¡Hola, Flask está corriendo en local!'

if __name__ == '__main__':
    app.run(debug=True)
    
from flask import Flask, request, jsonify

app = Flask(__name__)

# Base de datos temporal (en memoria)
items = [
    {"id": 1, "nombre": "Item 1"},
    {"id": 2, "nombre": "Item 2"}
]

# GET /api/items
@app.route('/api/items', methods=['GET'])
def get_items():
    return jsonify(items)

# GET /api/items/<id>
@app.route('/api/items/<int:item_id>', methods=['GET'])
def get_item(item_id):
    item = next((i for i in items if i['id'] == item_id), None)
    if item:
        return jsonify(item)
    return jsonify({'error': 'Item no encontrado'}), 404

# POST /api/items
@app.route('/api/items', methods=['POST'])
def create_item():
    data = request.json
    new_item = {
        "id": items[-1]['id'] + 1 if items else 1,
        "nombre": data.get('nombre')
    }
    items.append(new_item)
    return jsonify(new_item), 201

# PUT /api/items/<id>
@app.route('/api/items/<int:item_id>', methods=['PUT'])
def update_item(item_id):
    data = request.json
    for item in items:
        if item['id'] == item_id:
            item['nombre'] = data.get('nombre', item['nombre'])
            return jsonify(item)
    return jsonify({'error': 'Item no encontrado'}), 404

# DELETE /api/items/<id>
@app.route('/api/items/<int:item_id>', methods=['DELETE'])
def delete_item(item_id):
    global items
    items = [i for i in items if i['id'] != item_id]
    return jsonify({'message': 'Item eliminado'}), 200

if __name__ == '__main__':
    app.run(debug=True)
