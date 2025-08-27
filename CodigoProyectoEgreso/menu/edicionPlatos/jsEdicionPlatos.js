const foto=document.getElementById("foto");
const formMenu=document.getElementById("formMenu");

const archivoInput = document.getElementById('imagen');

formMenu.addEventListener("submit", function(event){
    event.preventDefault();
    const archivo = archivoInput.files[0];
    const formData = new FormData();
    formData.append('imagen', archivo); // clave 'archivo' debe coincidir con $_FILES['archivo']
    fetch('phpEdicionPlatos.php',{
        method: 'POST',
        body:formData
    })
        .then(res=>res.json())
        .then(data => {
            console.log(data);
            
        document.getElementById('mensaje').textContent = "Archivo subido correctamente a " + data.success;
        foto.src=data.success
    })
    .catch(err => {
        document.getElementById('mensaje').textContent = 'Error al subir: ' + err;
    })  
    
})