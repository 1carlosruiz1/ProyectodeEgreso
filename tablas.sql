DROP DATABASE IF EXISTS BDProyecto;
CREATE DATABASE BDProyecto;
USE BDProyecto;

CREATE TABLE Usuario (
    ID_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    email VARCHAR(150) UNIQUE,
    contraseña VARCHAR(150),
    estado BOOLEAN default true
);

CREATE TABLE CodigoRecuperacion (
    ID_usuario INT,
    codigo VARCHAR(100),
    fechaExpiracion DATETIME,
    PRIMARY KEY (ID_usuario, codigo),
    FOREIGN KEY (ID_usuario) REFERENCES Usuario(ID_usuario)
);

CREATE TABLE Empleado (
    ID_empleado INT PRIMARY KEY,
    tipo VARCHAR(50),
    FOREIGN KEY (ID_empleado) REFERENCES Usuario(ID_usuario)
);

CREATE TABLE Cliente (
    ID_cliente INT PRIMARY KEY,
    puntosCliente INT DEFAULT 0,
    FOREIGN KEY (ID_cliente) REFERENCES Usuario(ID_usuario)
);

CREATE TABLE Plato (
    ID_plato INT AUTO_INCREMENT PRIMARY KEY,
    nombrePlato VARCHAR(100),
    descripcion TEXT,
    precio DECIMAL(10,2),
    temporada VARCHAR(50),
    tiempoPreparacion INT,
    promocion DECIMAL(5,2),
    receta TEXT
);

CREATE TABLE Favorito (
    ID_cliente INT,
    ID_plato INT,
    PRIMARY KEY (ID_cliente, ID_plato),
    FOREIGN KEY (ID_cliente) REFERENCES Cliente(ID_cliente),
    FOREIGN KEY (ID_plato) REFERENCES Plato(ID_plato)
);

CREATE TABLE Etiqueta (
    ID_etiqueta INT AUTO_INCREMENT PRIMARY KEY,
    nombreEtiqueta VARCHAR(100)
);

CREATE TABLE EtiquetaCliente (
    ID_etiqueta INT,
    ID_cliente INT,
    cantidad INT DEFAULT 0,
    PRIMARY KEY (ID_etiqueta, ID_cliente),
    FOREIGN KEY (ID_etiqueta) REFERENCES Etiqueta(ID_etiqueta),
    FOREIGN KEY (ID_cliente) REFERENCES Cliente(ID_cliente)
);
CREATE TABLE Comentario (
    ID_comentario INT AUTO_INCREMENT PRIMARY KEY,
    ID_cliente INT,
    infoComentario TEXT,
    puntaje INT,
    fechaComentario DATE,
    FOREIGN KEY (ID_cliente) REFERENCES Cliente(ID_cliente)
);

CREATE TABLE Mesa (
    ID_mesa INT AUTO_INCREMENT PRIMARY KEY,
    numeroMesa INT
);

CREATE TABLE Reserva (
    ID_reserva INT AUTO_INCREMENT PRIMARY KEY,
    ID_cliente INT,
    ID_mesa INT,
    horaInicio TIME,
    horaFin TIME,
    cancelado BOOLEAN default false,
    fechaReserva DATE,
    fechaRealizacion DATE,
    FOREIGN KEY (ID_cliente) REFERENCES Cliente(ID_cliente),
    FOREIGN KEY (ID_mesa) REFERENCES Mesa(ID_mesa)
);

CREATE TABLE Pedido (
    ID_pedido INT AUTO_INCREMENT PRIMARY KEY,
    fechaPedido DATETIME,
    especificaciones TEXT,
    ID_mesa INT,
    puntosCompra INT,
    fechaEsperada DATETIME,
    ID_cliente INT,
    ID_mozo INT,
    cocinado boolean default false,
    FOREIGN KEY (ID_mesa) REFERENCES Mesa(ID_mesa),
    FOREIGN KEY (ID_cliente) REFERENCES Cliente(ID_cliente),
    FOREIGN KEY (ID_mozo) REFERENCES Empleado(ID_empleado)
);

CREATE TABLE Entrega (
    ID_entrega INT AUTO_INCREMENT PRIMARY KEY,
    ID_pedido INT,
    ID_delivery INT,
    latitud  DECIMAL(10, 7),
	longitud DECIMAL(10, 7),
    telefono INT,
    confirmacionDelivery BOOLEAN,
    confirmacionCliente BOOLEAN,
    FOREIGN KEY (ID_pedido) REFERENCES Pedido(ID_pedido),
    FOREIGN KEY (ID_delivery) REFERENCES Empleado(ID_empleado)
);

CREATE TABLE SeCompone (
    ID_pedido INT,
    ID_plato INT,
    cantidad INT,
    PRIMARY KEY (ID_pedido, ID_plato),
    FOREIGN KEY (ID_pedido) REFERENCES Pedido(ID_pedido),
    FOREIGN KEY (ID_plato) REFERENCES Plato(ID_plato)
);

CREATE TABLE Ingrediente (
    ID_ingrediente INT AUTO_INCREMENT PRIMARY KEY,
    nombreIngrediente VARCHAR(100),
    unidadMedida VARCHAR(50)
);

CREATE TABLE Necesita (
    ID_plato INT,
    ID_ingrediente INT,
    cantidad double,
    PRIMARY KEY (ID_plato, ID_ingrediente),
    FOREIGN KEY (ID_plato) REFERENCES Plato(ID_plato),
    FOREIGN KEY (ID_ingrediente) REFERENCES Ingrediente(ID_ingrediente) ON DELETE CASCADE
);

CREATE TABLE Stock (
    ID_stock INT AUTO_INCREMENT PRIMARY KEY,
    stock INT,
    ID_ingrediente INT,
    fechaIngreso DATE,
    fechaVencimiento DATE,
    FOREIGN KEY (ID_ingrediente) REFERENCES Ingrediente(ID_ingrediente) ON DELETE CASCADE
);
