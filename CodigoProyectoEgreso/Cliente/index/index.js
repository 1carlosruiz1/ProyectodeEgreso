const iconoLogin = document.querySelector('.IconoLogin');
const iconoCarrito=document.getElementById('iconoCarrito');
//logue automatico 
document.addEventListener("DOMContentLoaded", function (data) {
  fetch('../sesion/controlExistenciaUsuario.php')
    .then(res => res.json())
    .then(data => {
      if (data.success) {
        // Si está logueado
        dropdown.appendChild(crearOpcion(`Bienvenido, ${data.usuario.nombre}`));
        const perfil = dropdown.appendChild(crearOpcion("Perfil"));
        const misReservas = dropdown.appendChild(crearOpcion("Mis Reservas"));
        const favoritos = dropdown.appendChild(crearOpcion("Favoritos"));
        const Historial = dropdown.appendChild(crearOpcion("Historial"));
        const cerrarSesion = dropdown.appendChild(crearOpcion("Cerrar sesión"));
        

        //para cerrar sesion (usando el boton creade en el logueo)
        
        cerrarSesion.addEventListener("click", function (event) {
          event.preventDefault()
          fetch('../sesion/cerrarSesion.php')
            .then(res => res.json())
            .then(data => {
              if (data.success) {
                window.location.href = "index.html"
              } else {
                Swal.fire("No se pudo cerrar la sesion, estamos trabajando en ello, lo lamentamos");
              }
            })
        })

        //para ver las reservas (usando el boton creade en el logueo)
        misReservas.addEventListener("click", function (event) {
          window.location.href = "../SistemaDeReservas/MisReservas.html"
        })
        //Para ver el historial
        Historial.addEventListener("click", function (event) {
          window.location.href = "../Historial/historial.html"
        })
        //para ver el perfil (usando el boton creade en el logueo)
        perfil.addEventListener("click", function (event) {
          window.location.href = "../perfil/perfil.html"
        })
      } else {

        // No logueado
        
        dropdown.appendChild(crearOpcion("Iniciar sesión"));

        ['Perfil', 'Mis Reservas', 'Favoritos'].forEach(opcion => {
  const li = document.createElement('li');
  li.textContent = opcion;
  li.classList.add('dropdown-opcion');
  li.addEventListener('mouseenter', () => {
    li.classList.add('dropdown-opcion-hover');
  });
  li.addEventListener('mouseleave', () => {
    li.classList.remove('dropdown-opcion-hover');
  });
  dropdown.appendChild(li);
});

// Para el dropdown:
dropdown.classList.add('dropdown-menu');
      } //fin del else q es por si no hay usuario registrado
    })
})

//para q solo te mande al loguin si no estas logueado el logo
iconoLogin.addEventListener("click", async e => { //el async y await es como decir: espera a que temrine la operacion 
  e.preventDefault();
  const res = await fetch("../sesion/controlExistenciaUsuario.php");
  const { success } = await res.json();
  if (!success) location.href = "../../sesion/login.html";
});
//para q solo te mande al loguin si no estas logueado el carrito!!
iconoCarrito.addEventListener("click", async e => {  
  e.preventDefault();
  const res = await fetch("../sesion/controlExistenciaUsuario.php");
  const { success } = await res.json();
  if (success) location.href = "../carrito/carrito.html";
});


const dropdown = document.createElement('ul');
dropdown.classList.add('dropdown-menu');
iconoLogin.appendChild(dropdown);

iconoLogin.style.position = 'relative';
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