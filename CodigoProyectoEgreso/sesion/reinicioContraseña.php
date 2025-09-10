<?php
require "conexion.php";
session_start();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $token = $_POST['token'] ?? null;
    $newPass = $_POST['newPass'] ?? null;
    $repeatPass = $_POST['repeatPass'] ?? null;

    if (!$token || !$newPass || !$repeatPass) {
        echo json_encode(["datos" => "Faltan datos"]);
        exit;
    }

    if ($newPass !== $repeatPass) {
        echo json_encode(["contraseña" => "Las contraseñas no coinciden"]);
        exit;
    }

        if (
        strlen($newPass) < 8 || 
        !preg_match('/[A-Za-z]/', $newPass) || 
        !preg_match('/[0-9]/', $newPass)
        ) {
        echo json_encode([
            "seguridad" => "La contraseña debe tener al menos 8 caracteres, incluir una letra y un número"
        ]);
        exit; }

    try {
        // Verifica si el token existe y es válido
        $sql = "SELECT ID_usuario FROM CodigoRecuperacion WHERE codigo = ? AND tiempo_expiracion > NOW()";
        $stmt = $con->prepare($sql);
        $stmt->execute([$token]);
        $usuario = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($usuario) {
            // Si el codigo existe

            $hash = password_hash($newPass, PASSWORD_BCRYPT);
            $sql = "UPDATE usuario SET contraseña = ? WHERE ID_usuario = ?";
            $stmt = $con->prepare($sql);
            $stmt->execute([$hash, $usuario['ID_usuario']]);

            // Borra el token para que no pueda reutilizarse
            $sql = "DELETE FROM CodigoRecuperacion WHERE codigo = ?";
            $stmt = $con->prepare($sql);
            $stmt->execute([$token]);

            //creo el sesion para mandarlo al index de una
            $sql = "SELECT * FROM Usuario WHERE ID_usuario = ?";
            $stmt = $con->prepare($sql);
            $stmt->execute([$usuario['ID_usuario']]);
            $usuario = $stmt->fetch(PDO::FETCH_ASSOC);

            $sqlEmpleado = "SELECT tipo FROM Empleado WHERE ID_empleado = ?";
            $stmt = $con->prepare($sqlEmpleado);
            $stmt->execute([$usuario['ID_usuario']]);
            $empleado = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($empleado) {
                $_SESSION['usuario']=[
                "nombre" =>  $usuario['nombre'],
                "apellido" => $usuario['apellido'],
                "email" => $usuario['email'],
                "tipo" => $empleado['tipo'],
                "ID" => $usuario['ID_usuario']
            ];
            } else {
                $_SESSION['usuario']=[
                "nombre" => $usuario['nombre'],
                "apellido" => $usuario['apellido'],
                "email" => $usuario['email'],
                "tipo" => "Cliente",
                "ID" => $usuario['ID_usuario']
            ];
            }
            
            echo json_encode([
                "success" => true,
                "usuario" => $_SESSION['usuario']
        ]);
        } else {
            echo json_encode(["token" => "Token inválido o caducado"]);
        }
    } catch (PDOException $e) {
        echo json_encode(["error" => $e->getMessage()]);
    }
}
