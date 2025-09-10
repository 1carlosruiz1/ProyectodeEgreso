const formRecuperar=document.getElementById("formRecuperar");
//por si esta logueado
document.addEventListener("DOMContentLoaded", function (data) {
  fetch('controlExistenciaUsuario.php')
    .then(res => res.json())
    .then(data => {
      if(data.success){  
      let tipo = data.usuario.tipo;
    if (tipo === "Gerente") {
      window.location.href = "../Gerente/index.html";
    } else if (tipo === "Chef") {
      window.location.href = "../ChefEjecutiva/index.html";
    } else if (tipo === "Cliente") {
      window.location.href = "../Cliente/index/index.html";
    } else if (tipo === "Cocina") {
      window.location.href = "../Cocina/index.html";
    } else if (tipo === "Delivery") {
      window.location.href = "../Delivery/index.html";
    } else if (tipo === "Mozo") {
      window.location.href = "../Mozo/index.html";
    }
      }
     
    })
})

document.getElementById("iconoLogin").addEventListener("click",function(event){
window.location.href="login.html";
})

formRecuperar.addEventListener("submit", function(event){
  event.preventDefault();
  var formData=new FormData(formRecuperar);
  Swal.fire({
    title: 'Enviando...',
    text: 'Estamos enviando el correo de recuperación',
    allowOutsideClick: false,
    allowEscapeKey: false,
    didOpen: () => {
      Swal.showLoading(); 
    }
  });
  fetch('recuperarContraseña.php', {
      method:'POST',
      body: formData
  })

  .then(res=> res.json())
  .then(data => {
    if(data.success){
       Swal.fire({
        icon: 'success',
        title: 'Email Enviado',
        text: 'Código de recuperación enviado a su Email',
        confirmButtonText: 'Entendido'
      }).then(() => {
        window.location.href = "login.html";
      });
    }else if(data.email){
      Swal.fire({
            icon: 'warning',
            title: 'Error: ',
            text: 'El email presentado no está registrado',
            confirmButtonText: 'Entendido'
          });

    }else{
      Swal.fire({
            icon: 'warning',
            title: 'Error: ',
            text: data.error,
            confirmButtonText: 'Entendido'
          });
    }
  })
})