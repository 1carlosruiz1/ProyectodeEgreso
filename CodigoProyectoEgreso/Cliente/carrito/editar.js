document.addEventListener("DOMContentLoaded", function (data) {
  fetch('../../sesion/controlExistenciaUsuario.php')
    .then(res => res.json())
    .then(data => {
      if (data.success) {
        // Si está logueado 
        dropdown.appendChild(crearOpcion(`Hola, ${data.usuario.nombre}`));
        const misReservas=dropdown.appendChild(crearOpcion("Mis Reservas"));
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
        //para ver las reservas (usando el boton creade en el logueo)
        misReservas.addEventListener("click", function (event) {
          window.location.href = "../SistemaDeReservas/MisReservas.html"
        })

      }else{
        window.location.href = "../index/index.html"
      }
    })
})

document.getElementById('ingredientes-list').addEventListener('click', function(e) {
    if (e.target.classList.contains('mas') || e.target.classList.contains('menos')) {
        const cantidadSpan = e.target.parentElement.querySelector('.ingrediente-cantidad');
        let cantidad = parseInt(cantidadSpan.textContent, 10);

        if (e.target.classList.contains('mas')) {
            cantidad++;
        } else if (e.target.classList.contains('menos') && cantidad > 0) {
            cantidad--;
        }

        cantidadSpan.textContent = cantidad;
    }
});