//logue automatico 
document.addEventListener("DOMContentLoaded", function (data) {
    fetch('../sesion/controlExistenciaUsuario.php')
        .then(res => res.json())
        .then(data => {
            console.log(data);
            if (data.usuario) {
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
                                window.location.href = "../index.html"
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
                window.location.href = "../index.html"
            } //fin del else q es por si no hay usuario registrado
        })

    //sacar datos de la BD

    


})