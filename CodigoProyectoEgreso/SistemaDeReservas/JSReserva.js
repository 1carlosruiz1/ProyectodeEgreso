const button = document.getElementById("button");
const form = document.querySelector("form");
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
// manda el form a la DB
form.addEventListener("submit", function (event) {
  event.preventDefault();
  formData = new FormData(form);

  fetch('ingresoReserva.php', {
    method: 'POST',
    body: formData
  })
    .then(res => res.json())
    .then(data => {
      console.log(data);
      if (data.success) {
        Swal.fire({
          icon: 'success',
          title: 'Reserva reservada',
          confirmButtonText: 'Entendido'
        }).then(() => {
          window.location.href = "../index.html";
        });
      } else {
        Swal.fire({
          icon: 'error',
          title: data.error,
          confirmButtonText: 'Entendido'
        });
      }
    })
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
