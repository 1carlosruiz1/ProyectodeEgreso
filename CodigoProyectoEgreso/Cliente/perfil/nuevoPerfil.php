<?php
include "../sesion/conexion.php";
session_start();
$nombre=$_POST['nombre'];
$apellido=$_POST['apellido'];
$email=$_POST['email'];
if(!empty($nombre)||!empty($apellido)||empty($email)){
    echo json_encode(["vacio"=>"Todos los campos deben de tener datos"]);
}
try{
    $stmt = $con->prepare("UPDATE Usuario SET nombre=?, apellido=?, email=? WHERE ID_usuario=?");
    $stmt->execute([$nombre, $apellido, $email, $_SESSION['usuario']['ID']]);
    echo json_encode(["success"=>"Datos actualizados exitosamente"]);
}catch(PDOException $e){
    echo json_encode(["error"=>$e->getMessage()]);
}
