const button = document.getElementById("button");
const form = document.getElementById("formReserva");
const iconoLogin = document.querySelector('.IconoLogin');
  const divDatos = document.getElementById("divDatos");
  const divMesas = document.getElementById("divMesas");
  const btnSiguiente = document.getElementById("btnSiguiente");
//se asuegra q este logueado
document.addEventListener("DOMContentLoaded", function (data) {
  fetch('../../sesion/controlExistenciaUsuario.php')
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


iconoLogin.addEventListener("click", async e => { //el async y await es como decir: espera a que temrine la operacion 
  e.preventDefault();
  const res = await fetch("../sesion/controlExistenciaUsuario.php");
  const { success } = await res.json();
  if (!success){ location.href = "../../sesion/login.html"

  }else{
      location.href = "../perfil/perfil.html"
  }
});
//para q solo te mande al loguin si no estas logueado el carrito!!
iconoCarrito.addEventListener("click", async e => {  
  e.preventDefault();
  const res = await fetch("../sesion/controlExistenciaUsuario.php");
  const { success } = await res.json();
  if (success) location.href = "../carrito/carrito.html";
});
  btnSiguiente.addEventListener("click", (e) => {
    e.preventDefault();

  if (form.checkValidity()) { 
  fetch('verMesas.php')
    .then(res => res.json())
    .then(data => {
      if (data.success) {
        divDatos.style.display = "none";
        divMesas.style.display = "block";
        const opcionMesa = document.getElementById("numeroMesa");
        opcionMesa.innerHTML = ""; 
        if (data.datos.length > 0) {
          
          opcionMesa.innerHTML = `<option value="" disabled selected>Seleccione una mesaaa</option>`;
          
          data.datos.forEach(element => {
            opcionMesa.innerHTML += `<option value="${element.ID_mesa}">Mesa ${element.ID_mesa}</option>`; 
          });
        } else {
          opcionMesa.innerHTML = `<option value="" disabled selected>No hay mesas disponibles</option>`;
        }

      } else {
        Swal.fire({
          icon: "warning",
          title: "Error",
          text: data,
          confirmButtonText: 'Entendido'
        })
      }
    });
} else {
  Swal.fire({
    icon: "warning",
    title: "Espacios vacios",
    text: "Todos los datos deben de tener informacion",
    confirmButtonText: 'Entendido'
  })
}

  });


form.addEventListener("submit", function (event) {
  event.preventDefault();
  const formData = new FormData(form);
  fetch('ingresoReserva.php', {
    method:"POST",
    body: formData
  })
  .then(res => res.json())
  .then(data =>{
        console.log(data);
    if(data.vacio){
      Swal.fire({
          icon: "warning",
          title: "Espacios vacios",
          text: "Todos los datos deben de tener informacion",
          confirmButtonText: 'Entendido'
        })
        .then(()=>{
          divDatos.style.display = "block";
          divMesas.style.display = "none";
        })
    } else if (data.fecha){
      Swal.fire({
          icon: "warning",
          title: "Error de fechas",
          text: data.fecha,
          confirmButtonText: 'Entendido'
        })
        .then(()=>{
          divDatos.style.display = "block";
          divMesas.style.display = "none";
        })
        
    } else if(data.horaFin){
      Swal.fire({
          icon: "warning",
          title: "Error de fechas",
          text: data.horaFin,
          confirmButtonText: 'Entendido'
        })
        .then(()=>{
          divDatos.style.display = "block";
          divMesas.style.display = "none";
        })
    } else if(data.error){
      Swal.fire({
          icon: "warning",
          title: "Error",
          text: data.error,
          confirmButtonText: 'Entendido'
        })
        .then(()=>{
          divDatos.style.display = "block";
          divMesas.style.display = "none";
        })
    } else if (data.limite){
      Swal.fire({
          icon: "error",
          title: "Limite de reservas",
          text: data.limite,
          confirmButtonText: 'Entendido'
        })
        .then(()=>{
          window.location.href="../index/index.html"
        });
    } else if (data.success){
      Swal.fire({
          icon: "success",
          title: "Reserva finalizada",
          text: "Reserva realizada correctamente",
          confirmButtonText: 'Entendido'
        })
        .then(()=>{
          window.location.href="../index/index.html"
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
