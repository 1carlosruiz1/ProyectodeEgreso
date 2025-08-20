<?php
try {
    $con = new PDO('mysql:host=localhost;dbname=BDProyecto;charset=utf8', 'root', '');
} catch (PDOException $e) {
    echo json_encode(["conexion fallida" => $e->getMessage()]);
    exit;
}
