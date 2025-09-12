const iconoLogin = document.querySelector('.IconoLogin');
document.addEventListener("DOMContentLoaded", function (data) {
  fetch('../../sesion/controlExistenciaUsuario.php')
    .then(res => res.json())
    .then(data => {
      if (data.success) {
        // Si está logueado 
        dropdown.appendChild(crearOpcion(`Hola, ${data.usuario.nombre}`));
        dropdown.appendChild(crearOpcion("Mis Reservas"));
        dropdown.appendChild(crearOpcion("Favoritos"));
        const cerrarSesion = dropdown.appendChild(crearOpcion("Cerrar sesión"));

        //para cerrar sesion (el li creado antes 2
        cerrarSesion.addEventListener("click", function (event) {
          event.preventDefault()
          fetch('../sesion/cerrarSesion.php')
            .then(res => res.json())
            .then(data => {
              if (data.success) {
                window.location.href = "../index/index.html"
              } else {
                Swal.fire("No se pudo cerrar la sesion, estamos trabajando en ello, lo lamentamos");
              }
            })
        })


      } else {
        // No logueado
        Swal.fire("No hay anda para ver si no está logueado").then(() => {
        window.location.href = "../index/index.html";
      });
      } //fin del else q es por si no hay usuario registrado
    })
})

// carrito.js

// Cargar carrito desde localStorage
function cargarCarrito() {
  const lista = document.getElementById("carritoLista");
  lista.innerHTML = "";

  let carrito = JSON.parse(localStorage.getItem("carrito")) || [];

  if (carrito.length === 0) {
    lista.innerHTML = "<h1>El carrito está vacío</h1>";
    actualizarTotal();
    return;
  }

  carrito.forEach(item => {
    const div = document.createElement("div");
    div.classList.add("carrito-item");

    div.innerHTML = `
      <img src="../../IMG/fotosPlatos/${item.ID_plato}" 
           alt="Plato" class="carrito-img">

      <div class="carrito-info">
        <div class="carrito-nombre">${item.nombre_plato}</div>
        <div class="carrito-desc">${item.descripcion}</div>
        <div class="carrito-precio">$${item.precio}</div>
      </div>

      <div class="carrito-acciones">
        <a href="Editar.html">
          <button class="carrito-btn editar">Editar</button>
        </a>
        <button class="carrito-btn eliminar" onclick="eliminarDelCarrito(${item.ID_plato})">Eliminar</button>
      </div>
    `;

    lista.appendChild(div);
  });
  
  actualizarTotal();
}

// Eliminar plato del carrito por ID
function eliminarDelCarrito(idPlato) {
  let carrito = JSON.parse(localStorage.getItem("carrito")) || [];
  carrito = carrito.filter(item => item.ID_plato !== idPlato);
  localStorage.setItem("carrito", JSON.stringify(carrito));
  cargarCarrito(); // refrescar vista
}

// Función para agregar plato al carrito
function agregarAlCarrito(plato) {
  let carrito = JSON.parse(localStorage.getItem("carrito")) || [];
  carrito.push(plato);
  localStorage.setItem("carrito", JSON.stringify(carrito));
  cargarCarrito();
}

// Calcular y mostrar el total
function actualizarTotal() {
  let carrito = JSON.parse(localStorage.getItem("carrito")) || [];
  let total = carrito.reduce((sum, item) => sum + parseFloat(item.precio), 0);

  const contenedor = document.querySelector(".carrito-contenedor");
  let totalDiv = document.querySelector(".carrito-total");

  if (carrito.length === 0) {
    if (totalDiv) {
      totalDiv.remove();
    }
    return;
  }

  if (!totalDiv) {
    totalDiv = document.createElement("div");
    totalDiv.classList.add("carrito-total");

    totalDiv.innerHTML = `
      <span>Total:</span>
      <span class="carrito-total-precio"></span>
      <button class="carrito-btn pagar">Pagar</button>
    `;

    contenedor.appendChild(totalDiv);
  }

  const totalElement = totalDiv.querySelector(".carrito-total-precio");
  totalElement.textContent = `$${total.toFixed(2)}`;
}


// Ejecutar al cargar la página
document.addEventListener("DOMContentLoaded", cargarCarrito);

document.getElementById("iconoCarrito").addEventListener("click", async e => { //el async y await es como decir: espera a que temrine la operacion 
  e.preventDefault();
  const res = await fetch("../../sesion/controlExistenciaUsuario.php");
  const { success } = await res.json();
  if (success) location.href = "../carrito/carrito.html";
});

document.getElementById("iconoLogin").addEventListener("click", async e => { //el async y await es como decir: espera a que temrine la operacion 
  e.preventDefault();
  const res = await fetch("../../sesion/controlExistenciaUsuario.php");
  const { success } = await res.json();
  if (!success){ location.href = "../../sesion/login.html"

  }else{
      location.href = "../perfil/perfil.html"
  }
});


const dropdown = document.createElement('ul');
dropdown.classList.add('dropdown-menu');
iconoLogin.appendChild(dropdown);

let hideTimeout = null;

iconoLogin.addEventListener('mouseenter', () => {
  clearTimeout(hideTimeout);
  dropdown.style.display = 'block';
});

iconoLogin.addEventListener('mouseleave', () => {
  hideTimeout = setTimeout(() => {
    dropdown.style.display = 'none';
  }, 120);
});

dropdown.addEventListener('mouseenter', () => {
  clearTimeout(hideTimeout);
  dropdown.style.display = 'block';
});

dropdown.addEventListener('mouseleave', () => {
  dropdown.style.display = 'none';
});

function crearOpcion(texto) {
  const li = document.createElement('li');
  li.textContent = texto;
  li.classList.add('dropdown-opcion');

  li.addEventListener('mouseenter', () => {
    li.classList.add('dropdown-opcion-hover');
  });

  li.addEventListener('mouseleave', () => {
    li.classList.remove('dropdown-opcion-hover');
  });

  return li;
}
//hasta acá lo q va en todas las paginas