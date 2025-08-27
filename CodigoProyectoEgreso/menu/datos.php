<?php
include '../sesion/conexion.php';


$sql = "SELECT * FROM plato";
$stmt = $con->prepare($sql);
$stmt->execute();
$res = $stmt->fetchAll(PDO::FETCH_ASSOC);
if (!$res) {
       echo json_encode(["error" => "no hay datos"]);

} else {
       echo json_encode(["success" => $res]);

}