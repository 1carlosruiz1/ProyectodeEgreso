document.getElementById('ingredientes-list').addEventListener('click', function(e) {
    if (e.target.classList.contains('mas') || e.target.classList.contains('menos')) {
        const cantidadSpan = e.target.parentElement.querySelector('.ingrediente-cantidad');
        let cantidad = parseInt(cantidadSpan.textContent, 10);

        if (e.target.classList.contains('mas')) {
            cantidad++;
        } else if (e.target.classList.contains('menos') && cantidad > 0) {
            cantidad--;
        }

        cantidadSpan.textContent = cantidad;
    }
});