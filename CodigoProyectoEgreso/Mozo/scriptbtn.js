const btn = document.getElementsByClassName('btn')[0];
const boton = document.getElementsByClassName('boton')[0];
const form = document.querySelector('form');
const container = document.getElementsByClassName('container')[0];
btn.addEventListener('click', function() {
    if (form.style.display === 'none') {
        form.style.display = 'block';
        container.style.position = 'absolute';
        container.style.backgroundColor = '#0F0F0F';
    }
});

const Nuevo = document.getElementsByClassName('NuevoPlato')[0];
const platosContainer = document.getElementById('platos-container');

Nuevo.addEventListener('click', function() {
    const platoDiv = document.createElement('div');
    platoDiv.className = 'plato-extra';
    platoDiv.innerHTML = `
        <label for="platoExtra">Plato</label>
        <select name="platoExtra">
            <option value="plato1">Milanesa con papas fritas</option>
            <option value="plato2">Hamburguesa con queso</option>
            <option value="plato3">Ensalada Cesar</option>
            <option value="plato4">Pizza Margarita</option>
            <option value="plato5">Spaghetti Bolognesa</option>
        </select>
        <label>Descripcion</label>
        <input type="text" name="descripcionExtra" placeholder="Sin cebolla, sin tomate...">
        <button type="button" class="eliminarPlato">Eliminar</button>
    `;
    platosContainer.appendChild(platoDiv);

    platoDiv.querySelector('.eliminarPlato').addEventListener('click', function() {
        platosContainer.removeChild(platoDiv);
    });
});