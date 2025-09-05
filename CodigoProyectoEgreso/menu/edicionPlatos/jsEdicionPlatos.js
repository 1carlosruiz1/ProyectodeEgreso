const foto=document.getElementById("foto");
const formMenu=document.getElementById("formMenu");
const archivoInput = document.getElementById('imagen');


formMenu.addEventListener("submit", function(event){
    event.preventDefault();
    const tiempoPreparacion = document.getElementById("tiempoPreparacion").value;
    const precio = document.getElementById("Precio").value;
    if (isNaN(precio) || precio <= 0) {
    swal.fire("No nos podemos permitir tantas perdidas chef");
    return;
    }
    if (isNaN(tiempoPreparacion) || tiempoPreparacion <= 0) {
    swal.fire("El tiempo debe estar en cantidad de minutos");
    return;
    }
    const formData = new FormData(formMenu);
    fetch('phpEdicionPlatos.php',{
        method: 'POST',
        body:formData
    })
        .then(res=>res.json())
        .then(data => {
            console.log(data);
            if(data.success){
                swal.fire("Comida agregada al menú")  
            }else if(data.vacio){
                swal.fire("Error: " + data.vacio)
            }else{
                 swal.fire("Error: " + data.error)
            }     
    })
    
})

archivoInput.addEventListener("change", function(event) { //preguntar torres como dunciona
    const archivo = event.target.files[0];
    if (archivo) {
        const lector = new FileReader();
        lector.onload = function(e) {
            document.getElementById("foto").src = e.target.result;
        };
        lector.readAsDataURL(archivo); // convierte la imagen en base64 para mostrarla
    }
});