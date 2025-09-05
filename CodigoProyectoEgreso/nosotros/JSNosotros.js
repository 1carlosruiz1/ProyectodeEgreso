const iconoLogin = document.querySelector('.IconoLogin');

document.addEventListener("DOMContentLoaded", function (data) {
  fetch('../sesion/controlExistenciaUsuario.php')
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
        // No logueado: opciones genéricas
        dropdown.appendChild(crearOpcion("Iniciar sesión"));
        console.log("no se logueo: " + data.error);

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
      } //fin del else q es por si no hay usuario registrado
    })
})


document.getElementById("iconoLogin").addEventListener("click", async e => { //el async y await es como decir: espera a que temrine la operacion 
  e.preventDefault();
  const res = await fetch("../sesion/controlExistenciaUsuario.php");
  const { success } = await res.json();
  if (!success) location.href = "../sesion/RegistroDeSesion.html";
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