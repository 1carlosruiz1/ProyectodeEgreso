cargadoDatos()
function cargadoDatos(){
  fetch('selectReserva.php')
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                const reserva = data.reservas
                if (reserva) {
                  reserva.forEach(element => {
                    reservasList.innerHTML += `
                  <div class="card-reserva" id="reserva-${element.ID_reserva}">
                    <p>
                      Nombre: ${data.success.nombre}<br>
                      Apellido: ${data.success.apellido}<br>
                      Fecha de la reserva: ${element.fechaReserva}<br>
                      Hora de inicio: ${element.horaInicio}<br>
                      Hora de finalización: ${element.horaFin}
                    </p>
                    <button class="botonReserva" onclick="CancelarReserva(${element.ID_reserva})">
                      Cancelar reserva
                    </button>
                    <button class="botonReserva" onclick="CancelarReserva(${element.ID_reserva})">
                      Cancelar reserva
                    </button>
                  </div>`;
                  });
                    
                } else {
                    reservasList.innerHTML = '<p>No tiene reservas registradas.</p>';
                }
            } else {
                Swal.fire({
                    icon: 'warning',
                    title: 'Error',
                    text: `${data.error}`,
                    confirmButtonText: 'Entendido'
                });
            }
        });
}

function CancelarReserva(ID_reserva){
  Swal.fire({
    title: '¿Estás seguro de que querés cancelar la reserva?',
    text: "Esta acción no se puede deshacer",
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#d33',
    cancelButtonColor: '#3085d6',
    confirmButtonText: 'Sí, cancelar',
    cancelButtonText: 'No, mantener'
  }).then((result) => {
    if (result.isConfirmed) {
      const formData = new FormData();
      formData.append('ID_reserva', ID_reserva); // enviamos solo el ID

      fetch('deleteReserva.php', {
        method: 'POST',
        body: formData
      })
      .then(res => res.json())
      .then(data => {
        if(data.success){
          Swal.fire('Cancelada', 'La reserva ha sido cancelada', 'success');
          // opcional: eliminar la tarjeta de reserva de la UI
          document.getElementById(`reserva-${ID_reserva}`)?.remove();
        } else {
          Swal.fire({
                    icon: 'warning',
                    title: 'Error',
                    text: `${data.error}`,
                    confirmButtonText: 'Entendido'
                });
        }
      });
    }
  });
}

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
