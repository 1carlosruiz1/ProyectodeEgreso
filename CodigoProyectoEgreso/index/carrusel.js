document.addEventListener('DOMContentLoaded', function() {
    const imagenes = document.querySelectorAll('.carrusel-img');
    const prevBtn = document.querySelector('.carrusel-btn.prev');
    const nextBtn = document.querySelector('.carrusel-btn.next');
    let actual = 0; 
    let intervalo;

    function mostrarImagen(idx) {
        imagenes.forEach((img, i) => {
            img.style.display = i === idx ? 'block' : 'none';
        });
    }

    function siguiente() {
        actual = (actual + 1) % imagenes.length;
        mostrarImagen(actual);
    }

    function anterior() {
        actual = (actual - 1 + imagenes.length) % imagenes.length;
        mostrarImagen(actual);
    }

    prevBtn.addEventListener('click', () => {
        anterior();
        reiniciarIntervalo();
    });

    nextBtn.addEventListener('click', () => {
        siguiente();
        reiniciarIntervalo();
    });

    function reiniciarIntervalo() {
        clearInterval(intervalo);
        intervalo = setInterval(siguiente, 4000);
    }

    mostrarImagen(actual);
    intervalo = setInterval(siguiente, 4000);
});