DROP DATABASE IF EXISTS BDProyecto;
Create database BDProyecto;
USE BDProyecto;
CREATE TABLE Usuarios (
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
    FOREIGN KEY (ID_cliente ) REFERENCES Usuarios(ID_usuario)
);


CREATE TABLE EtiquetaCliente (
    ID_cliente INT NOT NULL,
    tipoEtiqueta ENUM('no-shows', 'problematico', 'no confirma') NOT NULL,
    fechaCalificacion DATE,
    comentario TEXT,
    PRIMARY KEY (ID_cliente, tipoEtiqueta, fechaCalificacion),
    FOREIGN KEY (ID_cliente) REFERENCES Cliente(ID_cliente)
);


CREATE TABLE Empleado (
    ID_empleado INT PRIMARY KEY,
    FOREIGN KEY (ID_empleado) REFERENCES Usuarios(ID_usuario)
);


CREATE TABLE Delivery (
    ID_delivery INT PRIMARY KEY,
    FOREIGN KEY (ID_delivery) REFERENCES Empleado(ID_empleado)
);

CREATE TABLE Cocinero (
    ID_cocinero INT PRIMARY KEY,
    FOREIGN KEY (ID_cocinero ) REFERENCES Empleado(ID_empleado)
);

CREATE TABLE GerenteGeneral (
    ID_gerente INT PRIMARY KEY,
    ID_empleado INT NOT NULL,
    FOREIGN KEY (ID_gerente ) REFERENCES Empleado(ID_empleado)
);

CREATE TABLE ChefEjecutiva (
    ID_chef INT PRIMARY KEY,
    FOREIGN KEY (ID_chef ) REFERENCES Empleado(ID_empleado)
);

CREATE TABLE Mozo (
    ID_mozo INT PRIMARY KEY,
    FOREIGN KEY (ID_mozo ) REFERENCES Empleado(ID_empleado)
);


CREATE TABLE Pedido (
    ID_pedido INT AUTO_INCREMENT PRIMARY KEY,
    ID_cliente INT NOT NULL,
    ID_mozo INT NOT NULL,
    pedidoCocinado BOOLEAN DEFAULT FALSE,
    fechaPedido DATETIME NOT NULL,
    especificaciones TEXT,
    fechaEsperadaUsuario DATETIME,
    puntosCompraUsuario INT DEFAULT 0,
    numMesaRestaurante INT,
    FOREIGN KEY (ID_cliente) REFERENCES Cliente(ID_cliente),
    FOREIGN KEY (ID_mozo) REFERENCES Mozo(ID_mozo)
);


CREATE TABLE Entrega (
    ID_entrega INT AUTO_INCREMENT PRIMARY KEY,
    ID_pedido INT NOT NULL,
    ID_delivery INT NOT NULL,
    confirmEntregaUsuario BOOLEAN DEFAULT FALSE,
    confirmEntregaDelivery BOOLEAN DEFAULT FALSE,
    ubicacionUsuario VARCHAR(255),
    FOREIGN KEY (ID_pedido) REFERENCES Pedido(ID_pedido),
    FOREIGN KEY (ID_delivery) REFERENCES Delivery(ID_delivery)
);


CREATE TABLE Plato (
    ID_plato INT AUTO_INCREMENT PRIMARY KEY,
    Precio DECIMAL(10,2) NOT NULL,
    temporada VARCHAR(50),
    tiempoPreparacion INT
);


CREATE TABLE Ingrediente (
    ID_ingrediente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);


CREATE TABLE StockIngrediente (
    ID_ingrediente INT NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL,
    fechaVencimiento DATE,
    fechaIngreso DATE,
    PRIMARY KEY (ID_ingrediente, fechaIngreso),
    FOREIGN KEY (ID_ingrediente) REFERENCES Ingrediente(ID_ingrediente)
);

CREATE TABLE Gastan (
    ID_plato INT NOT NULL,
    ID_ingrediente INT NOT NULL,
    cantidadIngrediente DECIMAL(10,2),
    magnitud VARCHAR(50),
    PRIMARY KEY (ID_plato, ID_ingrediente),
    FOREIGN KEY (ID_plato) REFERENCES Plato(ID_plato),
    FOREIGN KEY (ID_ingrediente) REFERENCES Ingrediente(ID_ingrediente)
);


CREATE TABLE SeCompone (
    ID_plato INT NOT NULL,
    ID_pedido INT NOT NULL,
    cantidad INT DEFAULT 1,
    PRIMARY KEY (ID_plato, ID_pedido),
    FOREIGN KEY (ID_plato) REFERENCES Plato(ID_plato),
    FOREIGN KEY (ID_pedido) REFERENCES Pedido(ID_pedido)
);


CREATE TABLE Mesa (
    ID_mesa INT AUTO_INCREMENT PRIMARY KEY,
    numMesa INT NOT NULL
);


CREATE TABLE Reserva (
    ID_reserva INT AUTO_INCREMENT PRIMARY KEY,
    ID_mesa INT NOT NULL,
    horaInicio DATETIME NOT NULL,
    horaFin DATETIME NOT NULL,
    confirmado BOOLEAN,
    cancelado BOOLEAN,
    fechaReserva DATE NOT NULL,
    fechaRealizacionCliente DATE,
    FOREIGN KEY (ID_mesa) REFERENCES Mesa(ID_mesa)
);

CREATE TABLE Comentario (
    ID_comentario INT AUTO_INCREMENT PRIMARY KEY,
    ID_cliente INT NOT NULL,
    informacion TEXT,
    puntaje INT CHECK(puntaje BETWEEN 0 AND 5),
    fecha DATETIME NOT NULL,
    FOREIGN KEY (ID_cliente) REFERENCES Cliente(ID_cliente)
);




