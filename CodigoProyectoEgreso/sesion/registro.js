const formRegistro = document.getElementById("formRegistro");
const formLogin = document.getElementById("formLogin");

//se fija que no esté logueado
document.addEventListener("DOMContentLoaded", function (data) {
  fetch('controlExistenciaUsuario.php')
    .then(res => res.json())
    .then(data => {
      if (data.success) {
        window.location.href = "../index.html"
      }
    })
})

//registro
formRegistro.addEventListener("submit", function (event) {
  event.preventDefault();
  var passReg = document.getElementById("passReg").value;
  var repeatpasswordReg = document.getElementById("repeatPassReg").value;

  if (passReg == repeatpasswordReg) {
    formData = new FormData(formRegistro);
    fetch('registrarse.php', {
      method: 'POST',
      body: formData
    })
      .then(res => res.json())
      .then(data => {
        if (data.success) {
          window.location.href = "../index/index.html"
        } else if (data.contraseña) {
          Swal.fire({
            icon: 'warning',
            title: 'Contraseña insegura',
            text: 'La contraseña debe tener al menos 8 caracteres, incluir una letra y un número',
            confirmButtonText: 'Entendido'
          });

        } else {
          Swal.fire({
            icon: "warning",
            title: "Error:",
            text: data.error
          });

        }
      })
  } else {
    Swal.fire("Ambas contraseñas deben ser iguales");
  }
});

//logueo
formLogin.addEventListener("submit", function (event) {
  event.preventDefault();
  formData = new FormData(formLogin);
  fetch('login.php', {
    method: 'POST',
    body: formData
  })

    .then(res => res.json())
    .then(data => {
      console.log(data);

      if (data.success) {
        window.location.href = "../index/index.html"
      } else if (data.contraseña) {
        Swal.fire({
          icon: "warning",
          title: "Contraseña incorrecta",
          text: "Contraseña incorrecta"
        });
      } else if (data.email) {
        Swal.fire({
          icon: "warning",
          title: "Email incorrecto"
        });
      } else {
        Swal.fire({
          icon: "warning",
          title: "Error:",
          text: data.error
        });
      }
    })
})

//cambio d elogueo a registro//
btncambiar.addEventListener("click", function () {   //hacer el boton para cambiar al otro
  document.getElementById("cardRegistro").style.display = "block";
  document.getElementById("cardLogin").style.display = "none";
  document.getElementById("btncambiar").style.display = "none";
  document.getElementById("btncambiar1").style.display = "block";
  document.getElementsByClassName("card")[0].style.height = "55vh"; // Oculta la tarjeta de inicio de sesión
});

//cambio d elogueo a registro//
btncambiar1.addEventListener("click", function () {   //hacer el boton para cambiar al otro
  document.getElementById("cardRegistro").style.display = "none";
  document.getElementById("cardLogin").style.display = "block";
  document.getElementById("btncambiar1").style.display = "none";
  document.getElementById("btncambiar").style.display = "block";
  document.getElementsByClassName("card")[0].style.height = "65vh"; // Oculta la tarjeta de inicio de sesión

});


const dropdown = document.createElement('ul');
dropdown.style.position = 'absolute';
dropdown.style.top = '100%';
dropdown.style.left = '-120px';
dropdown.style.background = '#222';
dropdown.style.color = '#fff';
dropdown.style.padding = '0';
dropdown.style.margin = '0';
dropdown.style.borderRadius = '6px';
dropdown.style.display = 'none';
dropdown.style.listStyle = 'none';
dropdown.style.minWidth = '120px';
dropdown.style.zIndex = '9999';


const iconoLogin = document.querySelector('.IconoLogin');
iconoLogin.style.position = 'relative';
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
  li.style.padding = '0.2em 0.5em';
  li.style.borderRadius = '4px';
  li.style.fontSize = '1.1rem';
  li.style.color = 'var(--color-white)';
  li.style.fontFamily = "var(--font-main)";
  li.style.cursor = 'pointer';
  li.style.transition = 'color 0.2s, background 0.2s, text-decoration 0.2s';

  li.addEventListener('mouseenter', () => {
    li.style.color = 'var(--color-accent)';
    li.style.background = 'rgba(255,102,20,0.08)';
    li.style.textDecoration = 'underline';
    li.style.textDecorationColor = 'var(--color-accent)';
  });

  li.addEventListener('mouseleave', () => {
    li.style.color = 'var(--color-white)';
    li.style.background = 'none';
    li.style.textDecoration = 'none';
  });

  return li;
}
