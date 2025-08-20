<?php
 include '../sesion/conexion.php';


        $sql = "SELECT * FROM plato";
        $stmt = $con->prepare($sql);
        $stmt->execute();
        $res = $stmt->fetch(PDO::FETCH_ASSOC);

        echo json_encode( value: $res);