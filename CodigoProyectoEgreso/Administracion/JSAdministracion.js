// Mostrar logo guardado si existe
const logoImg = document.getElementById('logoRestaurante');
const logoStorage = localStorage.getItem('logoRestaurante');
if (logoStorage) {
    logoImg.src = logoStorage;
    // Cambia también el favicon
    document.getElementById('logo').href = logoStorage;
}

// Abrir selector de archivos para cambiar logo
document.getElementById('btnCambiarLogo').onclick = () => {
    document.getElementById('inputLogo').click();
};

// Al seleccionar imagen, guardar en localStorage y actualizar logo
document.getElementById('inputLogo').onchange = function(e) {
    const file = e.target.files[0];
    if (!file) return;
    if (!file.type.match('image.*')) {
        Swal.fire("Solo se permiten imágenes .png o .jpg");
        return;
    }
    const reader = new FileReader();
    reader.onload = function(ev) {
        localStorage.setItem('logoRestaurante', ev.target.result);
        logoImg.src = ev.target.result;
        document.getElementById('logo').href = ev.target.result;
        Swal.fire("Logo actualizado. Recarga las otras pestañas para ver el cambio.");
    };
    reader.readAsDataURL(file);
};

// Mostrar número guardado si existe
const inputTelefono = document.getElementById('inputTelefono');
const telefonoStorage = localStorage.getItem('telefonoRestaurante');
if (telefonoStorage) {
    inputTelefono.value = telefonoStorage;
}

// Cambiar número y guardar en localStorage
document.getElementById('btnCambiarTelefono').onclick = () => {
    const nuevoNumero = inputTelefono.value.trim();
    if (!nuevoNumero) {
        Swal.fire("Ingrese un número válido");
        return;
    }
    localStorage.setItem('telefonoRestaurante', nuevoNumero);
    // Actualiza el número en el footer en vivo
    const telefonoFooter = document.querySelector('.footer-phone-number');
    if (telefonoFooter) telefonoFooter.textContent = nuevoNumero;
    Swal.fire("Número actualizado. Recarga las otras pestañas para ver el cambio.");
};

// Mostrar título guardado si existe
const inputTitulo = document.getElementById('inputTitulo');
const tituloHeader = document.querySelector('.TituloP h1');
const tituloStorage = localStorage.getItem('tituloRestaurante');
if (tituloStorage) {
    inputTitulo.value = tituloStorage;
    if (tituloHeader) tituloHeader.textContent = tituloStorage;
}

// Cambiar título y guardar en localStorage
document.getElementById('btnCambiarTitulo').onclick = () => {
    const nuevoTitulo = inputTitulo.value.trim();
    if (!nuevoTitulo) {
        Swal.fire("Ingrese un título válido");
        return;
    }
    localStorage.setItem('tituloRestaurante', nuevoTitulo);
    if (tituloHeader) tituloHeader.textContent = nuevoTitulo;
    Swal.fire("Título actualizado. Recarga las otras pestañas para ver el cambio.");
};

/* --- SCRIPTS QUE DEBEN IR SIEMPRE EN TODAS LAS PÁGINAS PARA MOSTRAR LOS CAMBIOS --- */
// Actualiza el número del footer y el título del header al cargar la página
const telefonoStorageAlways = localStorage.getItem('telefonoRestaurante');
if (telefonoStorageAlways) {
    const telefonoFooter = document.querySelector('.footer-phone-number');
    if (telefonoFooter) telefonoFooter.textContent = telefonoStorageAlways;
}
const tituloStorageAlways = localStorage.getItem('tituloRestaurante');
if (tituloStorageAlways) {
    const tituloHeader = document.querySelector('.TituloP h1');
    if (tituloHeader) tituloHeader.textContent = tituloStorageAlways;
}


// --- Scripts para el login y dropdown del usuario ---
const iconoLogin = document.querySelector('.IconoLogin');

// Verifica que el usuario esté logueado
let storague = JSON.parse(localStorage.getItem("usuario"));
if (storague) {
    formData = new FormData();
    formData.append("nombre", storague.nombre);
    formData.append("apellido", storague.apellido);
    formData.append("email", storague.email);
    fetch('loguin.php', {
        method: 'POST',
        body: formData
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            // Si está logueado
            Swal.fire("logueado correctamente!");
            dropdown.appendChild(crearOpcion(`Hola, ${data.usuario.nombre}`));
            dropdown.appendChild(crearOpcion("Mis Reservas"));
            dropdown.appendChild(crearOpcion("Favoritos"));
            const cerrarSesion = dropdown.appendChild(crearOpcion("Cerrar sesión"));

            // Para cerrar sesión
            cerrarSesion.addEventListener("click", function (event){
                event.preventDefault();
                fetch('cerrarSesion.php')
                .then(res => res.json())
                .then(data => {
                    if(data.success){
                        window.location.href="index.html";
                    }else{
                        Swal.fire("No se pudo cerrar la sesion, estamos trabajando en ello, lo lamentamos");
                    }
                });
            });
        } else {
            // No logueado: opciones genéricas
            dropdown.appendChild(crearOpcion("Iniciar sesión"));
            console.log("no se logueo: "+data.error);
            ['Perfil', 'Mis Reservas', 'Favoritos'].forEach(opcion => {
                const li = document.createElement('li');
li.textContent = opcion;
li.classList.add('dropdown-opcion');
li.addEventListener('mouseenter', () => {
    li.classList.add('dropdown-opcion-hover');
});
li.addEventListener('mouseleave', () => {
    li.classList.remove('dropdown-opcion-hover');
});
dropdown.appendChild(li);
            });
        }
    });
}

// Verifica existencia de usuario al cargar la página
document.addEventListener("DOMContentLoaded", function (data){
    fetch('controlExistenciaUsuario.php')
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            Swal.fire("logueado correctamente!");
            dropdown.appendChild(crearOpcion(`Hola, ${data.usuario.nombre}`));
            dropdown.appendChild(crearOpcion("Mis Reservas"));
            dropdown.appendChild(crearOpcion("Favoritos"));
            const cerrarSesion = dropdown.appendChild(crearOpcion("Cerrar sesión"));

            cerrarSesion.addEventListener("click", function (event){
                event.preventDefault();
                fetch('cerrarSesion.php')
                .then(res => res.json())
                .then(data => {
                    if(data.success){
                        window.location.href="index.html";
                    }else{
                        Swal.fire("No se pudo cerrar la sesion, estamos trabajando en ello, lo lamentamos");
                    }
                });
            });
        } else {
            dropdown.appendChild(crearOpcion("Iniciar sesión"));
            console.log("no se logueo: "+data.error);
            ['Perfil', 'Mis Reservas', 'Favoritos'].forEach(opcion => {
                const li = document.createElement('li');
                li.textContent = opcion;
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
                dropdown.appendChild(li);
            });
        }
    });
});

// Redirige a registro si no está logueado al hacer click en el icono
document.getElementById("iconoLogin").addEventListener("click", async e => {
    e.preventDefault();
    const res = await fetch("controlExistenciaUsuario.php");
    const { success } = await res.json();
    if (!success) location.href = "RegistroDeSesion.html";
});

// Dropdown de usuario
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

// Función para crear opciones del dropdown
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

/* --- FIN SCRIPTS QUE DEBEN IR SIEMPRE --- */