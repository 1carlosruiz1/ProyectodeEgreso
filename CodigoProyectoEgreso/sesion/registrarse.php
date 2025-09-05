<?php
header("Content-Type: application/json; charset=utf-8");
require "conexion.php";
session_set_cookie_params(60 * 60 * 24 * 30);
session_start();

$nombre = $_POST["nombre"] ?? '';
$apellido = $_POST["apellido"] ?? '';
$email = $_POST["emailReg"] ?? '';
$pass = $_POST["passReg"] ?? '';
$tipoEmpleado = $_POST["tipo"] ?? '';
$passHasheada = password_hash($pass, PASSWORD_DEFAULT);
if (strlen($pass) < 8 || 
    !preg_match('/[A-Za-z]/', $pass) || 
    !preg_match('/[0-9]/', $pass)) {
    echo json_encode(["contraseña" => "La contraseña debe tener al menos 8 caracteres, incluir una letra y un número"]);
    exit;
}
    //insert de usuario
if(empty($tipoEmpleado)){
    try {
    $sql = "SELECT * FROM usuario WHERE email = ?";
    $stmt = $con->prepare($sql);
    $stmt->execute([$email]);
    if ($stmt->fetch()) {
        echo json_encode(["error" => "El email ya está registrado"]);
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
exit;
}


    //insert de trabajador 
if (!isset($_SESSION['usuario']) || $_SESSION['usuario']['tipo'] !== 'gerenteGeneral') {
    echo json_encode(["error" => "No autorizado"]);
    exit;
}

$tiposValidos = ['delivery', 'cocinero', 'chefEjecutiva', 'gerenteGeneral', 'camarero'];
if (!in_array($tipoEmpleado, $tiposValidos)) {
    echo json_encode(["error" => "Tipo de empleado inválido"]);
    exit;
}

try {
    

    $sql = "INSERT INTO usuario (email, contraseña, nombre, apellido) VALUES (?, ?, ?, ?)";
    $stmt = $con->prepare($sql);
    $stmt->execute([$email, $passHasheada, $nombre, $apellido]);
    $res = $stmt->fetch(PDO::FETCH_ASSOC); //para q sea array asociativo la devolucion

    $idUsuario = $con->lastInsertId();
    
     //mando los datos antes d guardarlos en trabajadores explotados laboralmente
    $_SESSION['usuario']=[
            "nombre" =>$nombre,
            "apellido" =>$apellido,
            "email" =>$email,
            "ID" =>$idUsuario,
            "tipo" =>$tipoEmpleado
        ];
    echo json_encode ([
        "success"=> true,
        "usuario" => $_SESSION['usuario']    
      ]);
    $sql = "INSERT INTO empleado (ID_empleado, tipo) VALUES (?, ?)";
    $stmt = $con->prepare($sql);
    $stmt->execute([$idUsuario, $tipoEmpleado]);


} catch (PDOException $e) {
    echo json_encode(["error" => $e->getMessage()]);
}