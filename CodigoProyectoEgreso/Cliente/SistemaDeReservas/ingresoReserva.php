<?php
require_once '../sesion/conexion.php';
session_start();

$fecha = $_POST['fecha'];
$horaInicio = $_POST["horaInicio"];
$horaFin = $_POST["horaFin"];
$IDMesa = !empty($_POST["numeroMesa"]) ? $_POST["numeroMesa"] : null;
if (empty($fecha) || empty($horaInicio) || empty($horaFin)) {
    echo json_encode(["vacio" => "Todos los campos deben de estar llenos"]);
    exit;
}
$inicio = new DateTime("$fecha $horaInicio");
$ahora = new DateTime();
$tempo=$ahora->modify("+1 hour"); 

if ($inicio < $tempo) {
    echo json_encode(["fecha" => "La fecha y hora de inicio deben tener al menos 1 hora de anticipación."]);
    exit;
}
$inicioTimestamp = strtotime($horaInicio);
$finTimestamp = strtotime($horaFin);
// Calculamos la diferencia en segundos
$diferenciaSegundos = $finTimestamp - $inicioTimestamp;
// 30 minutos = 1800 segundos
if ($diferenciaSegundos < 1800) {
    echo json_encode(["horaFin" => "La hora de fin debe ser al menos 30 minutos después de la hora de inicio."]);
    exit;
}
$ahoraString = $ahora->format('Y-m-d H:i:s');
try {
    $sqlCheck = "SELECT COUNT(*) FROM reserva WHERE ID_cliente = ?";
    $stmtCheck = $con->prepare($sqlCheck);
    $stmtCheck->execute([$_SESSION['usuario']['ID']]);
    $cantidadReservas = $stmtCheck->fetchColumn();

    if ($cantidadReservas >= 3) {
        echo json_encode(["limite" => "Ya alcanzó el límite de 3 reservas activas."]);
        exit;
    }
    //para ver q no se solapen
    if($IDMesa){
            $sqlCheck = "SELECT COUNT(*) FROM Reserva WHERE ID_mesa = ? AND fechaReserva = ? AND cancelado = 0 AND (
                         (horaInicio <= ? AND horaFin > ?) OR
                         (horaInicio < ? AND horaFin >= ?) OR
                         (horaInicio >= ? AND horaFin <= ?)
                                        )";
                        $stmtCheck = $con->prepare($sqlCheck);
                        $stmtCheck->execute([
                            $IDMesa, $fecha, $horaInicio, $horaInicio, $horaFin, $horaFin, $horaInicio, $horaFin
                        ]);

                        $solapadas = $stmtCheck->fetchColumn();
    }
     

    if ($solapadas > 0) {
        echo json_encode(["error" => "La mesa ya tiene una reserva en ese horario."]);
        exit;
    }

    $sql = "INSERT INTO reserva (ID_mesa, ID_cliente, horaInicio, horaFin, fechaReserva, fechaRealizacionCliente) 
            VALUES (?,?,?,?,?,?)";
    $stmt = $con->prepare($sql); 
    $stmt->execute([$IDMesa, $_SESSION['usuario']['ID'], $horaInicio, $horaFin, $fecha, $ahoraString]);

    echo json_encode(["success" => "Reserva creada con éxito"]);

} catch (PDOException $e) {
    echo json_encode(["error" => $e->getMessage()]);
}
