
cargarMenu();

function cargarMenu(){
  const data = 1;
  menu.innerHTML +=`<div class="item-menu">
                <div class="item-header">
                    <span class="item-nombre">ASADO CON PAPAS</span>
                    <span class="item-linea"></span>
                    <span class="item-precio">$1.600</span>
                </div>
                <div class="item-desc">
                    Toque crunchy - Mayonesa - Guacamole fresco
                </div>
                 <button onClick=comprar(${data}) class="buy-btn">Comprar</button>
            </div>
            `

            menu.innerHTML+=` <button class="menu-btn">Ver menú</button>`
           
         }
