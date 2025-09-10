<?php
require "conexion.php";
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;
use PHPMailer\PHPMailer\SMTP;
$emailUsuario=$_POST["emailRecuperar"];
try {

        $sql = "SELECT * FROM usuario WHERE email = ?";
        $stmt = $con->prepare(query: $sql);
        $stmt->execute([$emailUsuario]);
        $usuario = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($usuario && $usuario['activo']) {
                require '../PHPMailer/Exception.php';
                require '../PHPMailer/SMTP.php';
                require '../PHPMailer/PHPMailer.php';
                $mail = new PHPMailer(true);

        try {

            $token = bin2hex(random_bytes(16)); // genera un token seguro de 32 caracteres
            $expiracion = date("Y-m-d H:i:s", strtotime("+1 hour"));

            $sqlInsert = "INSERT INTO CodigoRecuperacion (id_usuario, codigo, tiempo_expiracion) VALUES (?, ?, ?)";
            $stmtInsert = $con->prepare($sqlInsert);
            $stmtInsert->execute([$usuario['ID_usuario'], $token, $expiracion]);

            $resetLink = "http://localhost/CodigoProyectoEgreso/sesion/reinicioContraseña.html?token=$token";


            //Server settings
            $mail->isSMTP();
                $mail->Host       = 'smtp.gmail.com';
                $mail->SMTPAuth   = true;
                $mail->Username   = 'LosMagorditos@gmail.com';
                $mail->Password   = 'apbmpxievyigsiks';  // tu contraseña real
                $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;
                $mail->Port       = 465;

                $mail->setFrom('LosMagorditos@gmail.com', 'Restaurante');
                $mail->addAddress($emailUsuario, $usuario['nombre']); 

                $mail->isHTML(true);
                $mail->Subject = 'Recuperacion de contrasenia';
                $mail->Body    = "Hola {$usuario['nombre']},<br><br>
                                Haga clic en el siguiente enlace para restablecer su contraseña:<br>
                                <a href='$resetLink'>$resetLink</a><br><br>
                                Si no solicitó este cambio, ignore este correo.";
                $mail->AltBody = "Hola {$usuario['nombre']},\n\n
                                Copie y pegue el siguiente enlace en su navegador para restablecer su contraseña:\n
                                $resetLink\n\n
                                Si no solicitó este cambio, ignore este correo.";


            $mail->send();
            echo json_encode(["success" => "Email enviado correctamente"]);
        } catch (Exception $e) {
            echo json_encode (["error" => "Message could not be sent. Mailer Error: {$mail->ErrorInfo}"]);
        }
        } else {
            echo json_encode(["email" => "Email incorrecto"]);
        }
    } catch (PDOException $e) {
        echo json_encode(["error" => $e->getMessage()]);
    }