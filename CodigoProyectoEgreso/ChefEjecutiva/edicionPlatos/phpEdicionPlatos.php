<?php
include '../../sesion/conexion.php';

$response = [];

$nombre = $_POST['Nombre'] ?? '';
$precio = $_POST['Precio'] ?? '';
$temporada = $_POST['Temporada'] ?? '';
$tiempoPreparacion = $_POST['tiempoPreparacion'] ?? '';
$descripcionPlato = $_POST['DescripcionPlato'] ?? '';

if ($nombre && $precio && $temporada && $tiempoPreparacion && $descripcionPlato) {
    try {
        $sql = "INSERT INTO Plato (nombre_plato, precio, temporada, tiempoPreparacion, descripcion) VALUES (?,?,?,?,?)";
        $stmt = $con->prepare($sql);
        $stmt->execute([$nombre, $precio, $temporada, $tiempoPreparacion, $descripcionPlato]);
        $res = $con->lastInsertId();
        $response['success'] = "Creación de plato exitosa";
        $response['idPlato'] = $res;

        if (isset($_FILES['imagen'])) {
            $archivo = $_FILES['imagen'];
            $destino = '../../IMG/fotosPlatos/' . $res;
            if (move_uploaded_file($archivo['tmp_name'], $destino)) {
                $response['fotoSuccess'] = $destino;
            } else {
                $response['fotoError'] = "Error al mover la foto.";
            }
        }

    } catch (PDOException $e) {
        $response['error'] = $e->getMessage();
    }
} else {
    $response['vacio'] = "Todos los campos deben de estar llenos o diferentes a 0";
}

echo json_encode($response);
