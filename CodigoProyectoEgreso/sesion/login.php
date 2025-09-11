<?php
    require "conexion.php";
    $lifetime = 60 * 60 * 24 * 30;
    session_set_cookie_params($lifetime);
    $email = $_POST["emailLogin"];
    $pass = $_POST["passLogin"];
    session_start();
    try {


        $sql = "SELECT * FROM usuario WHERE email = ?";
        $stmt = $con->prepare($sql);
        $stmt->execute([$email]);
        $usuario = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($usuario) {
            // Verificar la contraseña
            if (password_verify($pass, $usuario['contraseña'])) {
                $id = $usuario['ID_usuario'];

                // Intentar encontrarlo como empleado
                $sql = "SELECT * FROM usuario 
                    JOIN empleado ON usuario.ID_usuario = empleado.ID_empleado 
                    WHERE ID_empleado = ?";
                $stmt = $con->prepare($sql);
                $stmt->execute([$id]);
                $empleado = $stmt->fetch(PDO::FETCH_ASSOC);

                if ($empleado) {
                    $_SESSION['usuario'] = [
                        "nombre" => $empleado['nombre'],
                        "apellido" => $empleado['apellido'],
                        "email" => $empleado['email'],
                        "ID" => $empleado['ID_empleado'],
                        "tipo" => $empleado['tipo']
                    ];
                    echo json_encode([
                        "success" => true,
                        "usuario" => $_SESSION['usuario']
                    ]);
                    exit;
                }

                // Si no es empleado
                $sql = "SELECT * FROM usuario 
                    JOIN cliente ON usuario.ID_usuario = cliente.ID_cliente 
                    WHERE ID_cliente = ?";
                $stmt = $con->prepare($sql);
                $stmt->execute([$id]);
                $cliente = $stmt->fetch(PDO::FETCH_ASSOC);

                if ($cliente) {
                    $_SESSION['usuario'] = [
                        "nombre" => $cliente['nombre'],
                        "apellido" => $cliente['apellido'],
                        "email" => $cliente['email'],
                        "ID" => $cliente['ID_cliente'],
                        "tipo" => "Cliente"
                    ];
                    echo json_encode([
                        "success" => true,
                        "usuario" => $_SESSION['usuario']
                    ]);
                    exit;
                }
            } else {
                echo json_encode(["contraseña" => "Contraseña incorrecta"]);
            }
        } else {
            echo json_encode(["email" => "Email incorrecto"]);
        }
    } catch (PDOException $e) {
        echo json_encode(["error" => $e->getMessage()]);
    }
