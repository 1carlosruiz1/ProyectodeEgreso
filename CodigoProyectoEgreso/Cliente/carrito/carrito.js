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
        // No logueado
        Swal.fire("No hay anda para ver si no está logueado").then(() => {
        window.location.href = "../index/index.html";
      });
      } //fin del else q es por si no hay usuario registrado
    })
})

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