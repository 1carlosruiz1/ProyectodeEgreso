DROP DATABASE IF EXISTS BDProyecto;
CREATE DATABASE BDProyecto;
USE BDProyecto;
CREATE TABLE Usuario (
    ID_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    contraseña VARCHAR(255) NOT NULL,
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE Cliente (
    ID_cliente INT PRIMARY KEY,
    PuntosCliente INT DEFAULT 0,
    FOREIGN KEY (ID_cliente) REFERENCES Usuario(ID_usuario)
);

CREATE TABLE EtiquetaCliente (
    ID_cliente INT,
    tipoEtiqueta ENUM('no-shows', 'problematico', 'no confirma'),
    fechaCalificacion DATE,
    comentario VARCHAR(255),
    PRIMARY KEY (ID_cliente, tipoEtiqueta, fechaCalificacion),
    FOREIGN KEY (ID_cliente) REFERENCES Cliente(ID_cliente)
);

CREATE TABLE Empleado (
    ID_empleado INT PRIMARY KEY,
    FOREIGN KEY (ID_empleado) REFERENCES Usuario(ID_usuario)
);

CREATE TABLE Delivery (
    ID_delivery INT PRIMARY KEY,
    FOREIGN KEY (ID_delivery) REFERENCES Empleado(ID_empleado)
);

CREATE TABLE Cocinero (
    ID_cocinero INT PRIMARY KEY,
    FOREIGN KEY (ID_cocinero) REFERENCES Empleado(ID_empleado)
);

CREATE TABLE GerenteGeneral (
    ID_gerente INT PRIMARY KEY,
    FOREIGN KEY (ID_gerente) REFERENCES Empleado(ID_empleado)
);

CREATE TABLE ChefEjecutiva (
    ID_chef INT PRIMARY KEY,
    FOREIGN KEY (ID_chef) REFERENCES Empleado(ID_empleado)
);

CREATE TABLE Mozo (
    ID_mozo INT PRIMARY KEY,
    FOREIGN KEY (ID_mozo) REFERENCES Empleado(ID_empleado)
);

CREATE TABLE Mesa (
    ID_mesa INT AUTO_INCREMENT PRIMARY KEY,
    numMesa INT
);

CREATE TABLE Pedido (
    ID_pedido INT AUTO_INCREMENT PRIMARY KEY,
    ID_cliente INT,
    ID_mozo INT,
    pedidoCocinado BOOLEAN,
    fechaPedido DATETIME,
    especificaciones VARCHAR(255),
    fechaEsperadaUsuario DATETIME,
    puntosCompraUsuario INT,
    numMesaRestaurante INT,
    FOREIGN KEY (ID_cliente) REFERENCES Cliente(ID_cliente),
    FOREIGN KEY (ID_mozo) REFERENCES Mozo(ID_mozo),
    FOREIGN KEY (numMesaRestaurante) REFERENCES Mesa(ID_mesa)
);

CREATE TABLE Entrega (
    ID_entrega INT AUTO_INCREMENT PRIMARY KEY,
    ID_pedido INT,
    ID_delivery INT,
    confirmEntregaUsuario BOOLEAN,
    confirmEntregaDelivery BOOLEAN,
    ubicacionUsuario VARCHAR(255),
    FOREIGN KEY (ID_pedido) REFERENCES Pedido(ID_pedido),
    FOREIGN KEY (ID_delivery) REFERENCES Delivery(ID_delivery)
);

CREATE TABLE Plato (
    ID_plato INT AUTO_INCREMENT PRIMARY KEY,
    nombre_plato VARCHAR(100),
    precio DECIMAL(10,2),
    temporada VARCHAR(50),
    tiempoPreparacion INT,
    descripcion VARCHAR (500)
);

CREATE TABLE Ingrediente (
    ID_ingrediente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    cantidad INT,
    fechaVencimiento DATE,
    fechaIngreso DATE
    );

CREATE TABLE Gastan (
    ID_plato INT,
    ID_ingrediente INT,
    cantidadIngrediente INT,
    magnitud VARCHAR(50),
    PRIMARY KEY (ID_plato, ID_ingrediente),
    FOREIGN KEY (ID_plato) REFERENCES Plato(ID_plato),
    FOREIGN KEY (ID_ingrediente) REFERENCES Ingrediente(ID_ingrediente)
);

CREATE TABLE SeCompone (
    ID_plato INT,
    ID_pedido INT,
    cantidad INT,
    PRIMARY KEY (ID_plato, ID_pedido),
    FOREIGN KEY (ID_plato) REFERENCES Plato(ID_plato),
    FOREIGN KEY (ID_pedido) REFERENCES Pedido(ID_pedido)
);

CREATE TABLE Reserva (
    ID_reserva INT AUTO_INCREMENT PRIMARY KEY,
    ID_mesa INT,
    horaInicio DATETIME,
    horaFin DATETIME,
    confirmado BOOLEAN,
    cancelado BOOLEAN,
    fechaReserva DATE,
    fechaRealizacionCliente DATE,
    FOREIGN KEY (ID_mesa) REFERENCES Mesa(ID_mesa)
);

CREATE TABLE Comentario (
    ID_comentario INT AUTO_INCREMENT PRIMARY KEY,
    ID_cliente INT,
    informacion VARCHAR(255),
    puntaje INT,
    fecha DATE,
    FOREIGN KEY (ID_cliente) REFERENCES Cliente(ID_cliente)
);





