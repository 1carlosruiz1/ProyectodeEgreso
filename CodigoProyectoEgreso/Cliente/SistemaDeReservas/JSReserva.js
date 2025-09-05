const button = document.getElementById("button");
const form = document.getElementById("form");
const iconoLogin = document.querySelector('.IconoLogin');

//se asuegra q este logueado
document.addEventListener("DOMContentLoaded", function (data) {
  fetch('../sesion/controlExistenciaUsuario.php')
    .then(res => res.json())
    .then(data => {
      if (data.success) {
        // Si está logueado
        dropdown.appendChild(crearOpcion(`Hola, ${data.usuario.nombre}`));
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
                window.location.href = "../index/index.html"
              } else {
                Swal.fire("No se pudo cerrar la sesion, estamos trabajando en ello, lo lamentamos");
              }
            })
        })
         //para ver las reservas (usando el boton creade en el logueo)
        misReservas.addEventListener("click", function (event) {
          window.location.href = "MisReservas.html"
        })

      } else {
        // No logueado
        window.location.href = "../index/index.html";
      } //fin del else q es por si no hay usuario registrado
    })
})

let infoReserva;

form.addEventListener("submit", function (event) {
  event.preventDefault();

  const formData = new FormData(form);

  // Convertimos FormData a objeto
  infoReserva = Object.fromEntries(formData.entries());

  console.log(infoReserva); // ahora sí puedes ver todas las claves y valores del form  
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
