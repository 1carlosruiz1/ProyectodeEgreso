<?php
header("Content-Type: application/json; charset=utf-8");
require "conexion.php";
session_set_cookie_params(60 * 60 * 24 * 30);
session_start();

$nombre = $_POST["nombre"] ?? '';
$apellido = $_POST["apellido"] ?? '';
$email = $_POST["emailReg"] ?? '';
$pass = $_POST["passReg"] ?? '';
$passHasheada = password_hash($pass, PASSWORD_DEFAULT);
if (strlen($pass) < 8 || 
    !preg_match('/[A-Za-z]/', $pass) || 
    !preg_match('/[0-9]/', $pass)) {
    echo json_encode(["contraseña" => "La contraseña debe tener al menos 8 caracteres, incluir una letra y un número"]);
    exit;
}

    //insert de usuario
    try {
    $sql = "SELECT * FROM usuario WHERE email = ?";
    $stmt = $con->prepare($sql);
    $stmt->execute([$email]);
    if ($stmt->fetch()) {
        echo json_encode(["email" => "El email ya está registrado"]);
        exit;
    }

    $sql = "INSERT INTO usuario (email, contraseña, nombre, apellido) VALUES (?, ?, ?, ?)";
    $stmt = $con->prepare($sql);
    $stmt->execute([$email, $passHasheada, $nombre, $apellido]);

    $idUsuario = $con->lastInsertId();
    
    //mando los datos antes d guardarlos en cliente
      $_SESSION['usuario']=[
            "nombre" =>$nombre,
            "apellido" =>$apellido,
            "email" =>$email,
            "ID" =>$idUsuario,
            "tipo" =>"Cliente"
        ];
    echo json_encode ([
        "success"=> true,
        "usuario" => $_SESSION['usuario']    
      ]);

    $sql = "INSERT INTO cliente (ID_cliente) VALUES (?)";
    $stmt = $con->prepare($sql);
    $stmt->execute([$idUsuario]);

    

} catch (PDOException $e) {
    echo json_encode(["error" => $e->getMessage()]);
}


    