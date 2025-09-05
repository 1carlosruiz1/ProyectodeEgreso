<?php
try {
    $con = new PDO('mysql:host=localhost;dbname=BDProyecto;charset=utf8', 'root', '');
} catch (PDOException $e) {
    echo json_encode(["Conexion fallida al servidor" => $e->getMessage()]);
    exit;
}
