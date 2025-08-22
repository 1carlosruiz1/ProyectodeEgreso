const menu=document.getElementById('divmenu');
cargarMenu();

function cargarMenu() {
    fetch('datos.php')
        .then(res => res.json())
        .then(data => {
            console.log(data);
            if (data.success) {
                data.success.forEach(element => {
                    menu.innerHTML += `<div class='menu-card'> <img class='IMGPlato' src=../IMG/platos/${element.ID_plato}></img> <p>${element.temporada}</p><button onClick=comprar(${element.Precio}) class='buy-btn'>Comprar</button> </div> `

                });
            } else {
                menu.innerHTML = `<h1>no hay platos en este momento</h1>`
            }

        })

}
