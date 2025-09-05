const iconoLogin = document.querySelector('.IconoLogin');

//logue automatico 
document.addEventListener("DOMContentLoaded", function (data) {
  fetch('../sesion/controlExistenciaUsuario.php')
    .then(res => res.json())
    .then(data => {
      console.log(data);
      
      if (data.success) {
        // Si está logueado
        dropdown.appendChild(crearOpcion(`Bienvenido, ${data.usuario.nombre}`));
        const misReservas = dropdown.appendChild(crearOpcion("Mis Reservas"));
        const favoritos = dropdown.appendChild(crearOpcion("Favoritos"));
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

//para q solo te mande al loguin si no estas logueado
document.getElementById("iconoLogin").addEventListener("click", async e => { //el async y await es como decir: espera a que temrine la operacion 
  e.preventDefault();
  const res = await fetch("../sesion/controlExistenciaUsuario.php");
  const { success } = await res.json();
  if (!success) location.href = "../sesion/RegistroDeSesion.html";
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

// --- SCRIPTS QUE DEBEN IR SIEMPRE EN TODAS LAS PÁGINAS PARA MOSTRAR LOS CAMBIOS ---
// Actualiza el logo del favicon si fue cambiado por el administrador
const logoStorage = localStorage.getItem('logoRestaurante');
if (logoStorage) {
  document.getElementById('logo').href = logoStorage;
}

// Actualiza el número del footer si fue cambiado por el administrador
const telefonoStorage = localStorage.getItem('telefonoRestaurante');
if (telefonoStorage) {
  const telefonoFooter = document.querySelector('.footer-phone-number');
  if (telefonoFooter) telefonoFooter.textContent = telefonoStorage;
}

// Actualiza el título del header si fue cambiado por el administrador
const tituloStorage = localStorage.getItem('tituloRestaurante');
if (tituloStorage) {
  const tituloHeader = document.querySelector('.TituloP h1');
  if (tituloHeader) tituloHeader.textContent = tituloStorage;
}
// --- FIN SCRIPTS QUE DEBEN IR SIEMPRE ---