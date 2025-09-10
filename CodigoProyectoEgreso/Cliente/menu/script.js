const menu = document.getElementById('menu-container');
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
          fetch('../../sesion/cerrarSesion.php')
            .then(res => res.json())
            .then(data => {
              if (data.success) {
                window.location.href = "../index/index.html"
              } else {
                Swal.fire("No se pudo cerrar la sesion, estamos trabajando en ello, lo lamentamos");
              }
            })
        })


      }else{
        window.location.href = "../index/index.html"
      }
    })
})
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
  if (!success) location.href = "../../sesion/login.html";
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

cargarMenu();

function cargarMenu() {
    fetch('datos.php')
        .then(res => res.json())
        .then(data => {
            console.log(data);
            if (data.success) {
                data.success.forEach(element => {
                    const card = document.createElement("div");
                    card.classList.add("menu-card");

                    card.innerHTML = `
                        <h2 class='menu-card-title'>${element.nombre_plato}</h2>
                        <img src="../../IMG/fotosPlatos/${element.ID_plato}" alt='fotoPlato'>
                        <div class="menu-card-content">
                            <p class='menu-card-price'>${element.precio}</p>
                            <p class='tiempo-preparacion'>${element.tiempoPreparacion}</p>
                            <a href="menugrande.html">
                                <button class="menu-card-btn">Ver más</button>
                            </a>
                        </div>
                    `;
                    const btn = document.createElement("button");
                    btn.textContent = "Agregar al carrito";
                    btn.classList.add("menu-card-btn");
                    btn.addEventListener("click", () => agregarAlCarrito(element));
                    card.querySelector(".menu-card-content").prepend(btn);
                    menu.appendChild(card);
                });
            } else {
                menu.innerHTML = `<h1>No hay platos en este momento</h1>`;
            }
        });
}

function agregarAlCarrito(plato) {
    let carrito = JSON.parse(localStorage.getItem("carrito")) || [];
    carrito.push(plato);
    localStorage.setItem("carrito", JSON.stringify(carrito));
}
