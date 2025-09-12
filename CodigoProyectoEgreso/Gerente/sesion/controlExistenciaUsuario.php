<?php
$lifetime = 60 * 60 * 24 * 30;
session_set_cookie_params($lifetime);
session_start();
header("Content-type: application/json");
if (isset($_SESSION['usuario'])) {
    echo json_encode([
        "success" => true,
        "usuario" => $_SESSION['usuario']
    ]);
} else {
    echo json_encode(["error" => "no hay usuario logueado"]);
}