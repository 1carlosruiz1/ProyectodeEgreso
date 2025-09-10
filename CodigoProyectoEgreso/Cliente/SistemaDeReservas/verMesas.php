<?php
require "../sesion/conexion.php";
try {
    $sql = "SELECT * FROM Mesa";
    $stmt = $con->prepare($sql); // preparar la consulta
    $stmt->execute();            // ejecutarla

    $mesas = $stmt->fetchAll(PDO::FETCH_ASSOC); // traer todas las filas como array asociativo

    // Ejemplo: devolver en JSON
    echo json_encode(
       [ "success" => true,
        "datos"=> $mesas]
    );

} catch (PDOException $e) {
    echo json_encode([ "Error: " => $e->getMessage()]);
}