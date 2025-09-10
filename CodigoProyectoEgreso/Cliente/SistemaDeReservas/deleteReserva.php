<?php
require "../sesion/conexion.php";
$ID_reserva=$_POST["ID_reserva"];
try{
    $stmt = $con->prepare("DELETE FROM Reserva WHERE ID_reserva = ?");
    $stmt->execute([$ID_reserva]);
    echo json_encode(["success"=>true]);

}catch(PDOException $e){
    echo json_encode(["error"=> $e->getMessage()]);
}