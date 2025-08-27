<?php
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        if (isset($_FILES['imagen'])) { //el $FILES en un ARREGLO SUPERRGLOBAL
            $archivo = $_FILES['imagen']; //el imagen es el name del input
            $nombre = basename($archivo['name']); //aca se extrae el nombre de cada imagen solo funciona si es 1 foto
            $destino = '../../IMG/fotosPlatos/' . $nombre;

            // Crear carpeta si no existe
            if (!is_dir('../../IMG/fotosPlatos/')) {
                mkdir('../../IMG/fotosPlatos/', 0777, true);
            }

            if (move_uploaded_file($archivo['tmp_name'], $destino)) {
                echo json_encode (["success" => $destino]);
            } else {
                echo json_encode (["success" =>  "Error al mover el archivo."]);
            }
        } else {
            echo json_encode (["success" =>  "No se recibió ningún archivo."]);
        }
    } else {
        echo json_encode (["success" => "Método no permitido."]);
    }