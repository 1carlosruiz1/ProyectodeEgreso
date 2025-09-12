const menu = document.getElementById('menu-container');
const iconoLogin = document.querySelector('.IconoLogin');

document.addEventListener("DOMContentLoaded", function (data) {
  fetch('../sesion/controlExistenciaUsuario.php')
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



const form=document.getElementById("perfil-form");

form.addEventListener("submit", function(datos){
    datos.preventDefault();
    const formdata=new FormData(form);
    fetch('nuevoPerfil.php', {
        method: "POST",
        body:formdata
    })
    .then(res=>res.json)
    .then(data=>{
        if(data.success){
            Swal.fire({
          icon: "success",
          title: "Exito",
          text: data,
          confirmButtonText: 'Entendido'
        })
        }else if(data.vacio){
            Swal.fire({
          icon: "error",
          title: "Error",
          text: data,
          confirmButtonText: 'Entendido'
        })
        }else if(data.error){
            Swal.fire({
          icon: "error",
          title: "Error",
          text: data,
          confirmButtonText: 'Entendido'
        })
        }
    })
})

//para ver los datos del suuari
verDatos()
function verDatos(){
    fetch('verDatos.php')
    .then(res=>res.json())
    .then(data=>{
        if(data.success){
            document.getElementById("nombre").value = data.success.nombre;
            document.getElementById("apellido").value = data.success.apellido;
            document.getElementById("mail").value = data.success.email;
        }else{
            Swal.fire({
          icon: "error",
          title: "Error",
          text: data,
          confirmButtonText: 'Entendido'
        })
        }
    })
}