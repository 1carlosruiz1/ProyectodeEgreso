<?php
require "conexion.php";
session_start();
try{
    $con->prepare($stmt="SELECT * FROM Mesa");
    $res->execute();
    $mesas = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    $con->prepare($stmt="SELECT * FROM Plato");
    $res->execute();
    $platos = $stmt->fetchAll(PDO::FETCH_ASSOC);

}catch(PDOException $e){
    echo json_encode(["error"=> $e->getMessage()]);
}