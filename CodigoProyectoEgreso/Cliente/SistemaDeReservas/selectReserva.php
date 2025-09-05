<?php
session_start();
require_once '../sesion/conexion.php';
try {
    $sql = "SELECT * FROM reserva WHERE (ID_cliente = ?)";
    $stmt = $con->prepare($sql);
    $stmt->execute([$_SESSION['usuario']['ID']]);
    $reservas = $stmt->fetchAll(PDO::FETCH_ASSOC);
    echo json_encode([
    "success" => $_SESSION['usuario'],
    "reservas" => $reservas
]);
} catch (PDOException $e) {
    echo json_encode(["error" => $e->getMessage()]);
}

