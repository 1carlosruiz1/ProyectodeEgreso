<?php
session_start();
$date = $_POST['fecha'];
$horaInicio = $_POST["horaInicio"];
$horaFin = $_POST["horaFin"];
require_once '../sesion/conexion.php';
try{
    $sql="INSERT INTO reserva (ID_cliente, fechaReserva, horaInicio, horaFin) VALUES (?,?,?,?)";
    $stmt=$con->prepare($sql); 
    $stmt->execute([$_SESSION['usuario']['ID'], $date, $horaInicio, $horaFin]);
    echo json_encode(["success"=>"reserva reservada"]);
}catch(PDOException $e){
    echo json_encode(["error"=>$e->getMessage()]);
}