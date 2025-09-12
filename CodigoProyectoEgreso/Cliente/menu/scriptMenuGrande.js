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