 const form = document.getElementById("formReinicio");

document.addEventListener("DOMContentLoaded", () => {
  // Captura el token desde la URL
  const params = new URLSearchParams(window.location.search);
  const token = params.get("token");
if (token) {
    document.getElementById("token").value = token;
  } else {
    Swal.fire({
      icon: "error",
      title: "Enlace inválido",
      text: "El enlace de recuperación no es válido o ya expiró",
    }).then(() => {
      window.location.href = "../sesion/login.html";
    });
  }
  
});

  form.addEventListener("submit", function (event){
    event.preventDefault();
    formData = new FormData(form);

  fetch('reinicioContraseña.php', {
      method: 'POST',
      body: formData
    })
    .then(res=> res.json())
    .then(data=>{
      console.log(data);
      
      if (data.datos) {
      Swal.fire({
          icon: "warning",
          title: "Datos",
          text: "Faltan datos",
          confirmButtonText: 'Entendido'
        });
    } else if(data.contraseña){
      Swal.fire({
          icon: "warning",
          title: "Contraseñas incorrectas",
          text: "Las contraseñas no coinciden",
          confirmButtonText: 'Entendido'
        });
    } else if(data.seguridad){
      Swal.fire({
          icon: "warning",
          title: "Contraseñas insegura",
          text: data.seguridad,
          confirmButtonText: 'Entendido'
        });
    } else if(data.token){
      Swal.fire({
          icon: "warning",
          title: "Error",
          text: "Codigo caducado o incorrecto",
          confirmButtonText: 'Entendido'
        }).then(()=>{
            window.location.href="../Cliente/index/index.html";
          })
    }else if(data.success){
      Swal.fire({
          icon: "success",
          title: "exito",
          text: "Contraseña cambiada con exito",
          confirmButtonText: 'Entendido'
        })
        .then(()=>{
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
        })
        
    }
  })
    
  });