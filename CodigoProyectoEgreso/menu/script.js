const menu=document.getElementById('menu-container');
cargarMenu();

function cargarMenu() {
    fetch('datos.php')
        .then(res => res.json())
        .then(data => {
            console.log(data);
            if (data.success) {
                data.success.forEach(element => {
                    menu.innerHTML += `<div class='menu-card'>
                    <h2 class='menu-card-title'>${element.nombre_plato}</h2> <img
                     src="../IMG/fotosPlatos/${element.ID_plato}" alt='fotoPlato'></img>
                     <div class="menu-card-content">
                         <p class='menu-card-price'>${element.precio}</p>
                         <p class='tiempo-preparacion'>${element.tiempoPreparacion}</p>
                     <button onClick=agregarAlCarrito class='menu-card-btn'>Agregar al carrito</button> 
                     <a href="menugrande.html"><button class="menu-card-btn">Ver mas</button></a>
                     </div>
                     </div> `
            
                });
            } else {
                menu.innerHTML = `<h1>No hay platos en este momento</h1>`
            }
        })

}
function agregarAlCarrito() {}
