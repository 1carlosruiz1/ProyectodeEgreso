<?php
require "../sesion/conexion.php";
session_start();
try{
    $stmt=$con->prepare("SELECT * FROM Usuario WHERE ID_usuario=?");
    $stmt->execute([$_SESSION['usuario']['ID']]);
    $res=$stmt->fetch(PDO::FETCH_ASSOC);

    echo json_encode(["success"=>$res]);

}catch(PDOException $e){
    echo json_encode(["error"=>$e->getMessage()]);
}
