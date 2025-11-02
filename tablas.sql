use BDProyecto;
-- Insertar ingredientes
INSERT INTO Ingrediente (nombreIngrediente, unidadMedida) VALUES
('Carne molida', 'g'),
('Pasta para lasagna', 'g'),
('Queso rallado', 'g'),
('Salsa bechamel', 'ml'),
('Lechuga romana', 'g'),
('Crutones', 'g'),
('Queso parmesano', 'g'),
('Aderezo César', 'ml'),
('Masa de pizza', 'g'),
('Salsa de tomate', 'ml'),
('Queso mozzarella', 'g'),
('Albahaca fresca', 'g'),
('Spaghetti', 'g'),
('Huevos', 'unid'),
('Panceta', 'g'),
('Zanahoria', 'g'),
('Papa', 'g'),
('Apio', 'g'),
('Caldo de verduras', 'ml'),
('Pan de hamburguesa', 'unid'),
('Carne de hamburguesa', 'g'),
('Tomate', 'g'),
('Queso cheddar', 'g'),
('Salsa especial', 'ml'),
('Muslo de pollo', 'g'),
('Aceite de oliva', 'ml'),
('Ajo', 'g'),
('Especias varias', 'g'),
('Filete de pescado', 'g'),
('Limón', 'g'),
('Perejil', 'g'),
('Masa quebrada', 'g'),
('Espinaca', 'g'),
('Queso ricotta', 'g'),
('Arroz arborio', 'g'),
('Champiñones', 'g');

-- Insertar platos
INSERT INTO Plato (nombrePlato, descripcion, precio, temporada, tiempoPreparacion, promocion, receta) VALUES
('Lasagna de Carne', 'Capas de pasta con carne molida, salsa bechamel y queso gratinado', 650.00, 'Todo el año', 45, 10.0, 'Capas de pasta, carne, bechamel y queso'),
('Ensalada César', 'Lechuga fresca con crutones, queso parmesano y aderezo César', 450.00, 'Verano', 15, 0.0, 'Mezclar todos los ingredientes'),
('Pizza Margherita', 'Base de masa con salsa de tomate, mozzarella y albahaca fresca', 550.00, 'Todo el año', 25, 5.0, 'Preparar masa, agregar salsa y hornear'),
('Spaghetti Carbonara', 'Spaghetti con salsa cremosa de huevo, queso y panceta', 600.00, 'Todo el año', 20, 0.0, 'Cocer pasta, mezclar con salsa y panceta'),
('Sopa de Verduras', 'Mezcla de verduras frescas hervidas en caldo ligero', 400.00, 'Invierno', 30, 0.0, 'Hervir verduras en caldo'),
('Hamburguesa Clásica', 'Pan de hamburguesa con carne, lechuga, tomate, queso y salsa', 550.00, 'Todo el año', 20, 5.0, 'Armar hamburguesa con ingredientes'),
('Pollo al Horno', 'Muslos de pollo marinados y horneados con especias', 700.00, 'Todo el año', 60, 0.0, 'Marinar pollo y hornear'),
('Filete de Pescado', 'Filete de pescado a la plancha con limón y hierbas', 800.00, 'Todo el año', 25, 0.0, 'Cocinar pescado a la plancha'),
('Tarta de Espinaca', 'Masa quebrada rellena de espinaca, queso y huevo', 500.00, 'Todo el año', 35, 5.0, 'Hornear masa rellena de espinaca y queso'),
('Risotto de Champiñones', 'Arroz cremoso con champiñones frescos y queso parmesano', 650.00, 'Otoño', 40, 0.0, 'Cocer arroz y mezclar con champiñones');

-- Insertar relación Necesita
-- NOTA: Usamos los mismos IDs que generó AUTO_INCREMENT porque empezamos desde 1
INSERT INTO Necesita (ID_plato, ID_ingrediente, cantidad) VALUES
(1,1,500),
(1,2,250),
(1,3,200),
(1,4,300),
(2,5,150),
(2,6,50),
(2,7,30),
(2,8,40),
(3,9,200),
(3,10,100),
(3,11,100),
(3,12,5),
(4,13,200),
(4,14,2),
(4,15,100),
(4,7,50),
(5,16,100),
(5,17,150),
(5,18,50),
(5,19,300),
(6,20,1),
(6,21,150),
(6,5,30),
(6,22,40),
(6,23,20),
(6,24,15),
(7,25,250),
(7,26,20),
(7,27,5),
(7,28,5),
(8,29,200),
(8,30,10),
(8,31,5),
(8,26,10),
(9,32,150),
(9,33,100),
(9,34,50),
(9,14,1),
(10,35,150),
(10,36,100),
(10,7,30),
(10,19,200);
-- Insertar stock inicial
INSERT INTO Stock (stock, ID_ingrediente, fechaIngreso, fechaVencimiento) VALUES
(2000, 1, '2025-08-20', '2025-12-10'),   -- Carne molida
(1000, 2, '2025-07-25', '2026-03-01'),   -- Pasta para lasagna
(500, 3, '2025-08-10', '2025-09-20'),    -- Queso rallado
(800, 4, '2025-08-05', '2025-09-15'),    -- Salsa bechamel
(500, 5, '2025-09-01', '2025-09-15'),    -- Lechuga romana
(200, 6, '2025-08-20', '2026-01-01'),    -- Crutones
(150, 7, '2025-08-25', '2025-09-25'),    -- Queso parmesano
(200, 8, '2025-08-10', '2025-09-20'),    -- Aderezo César
(500, 9, '2025-08-25', '2025-09-25'),    -- Masa de pizza
(300, 10, '2025-08-20', '2025-10-10'),   -- Salsa de tomate
(400, 11, '2025-08-22', '2025-09-20'),   -- Queso mozzarella
(50, 12, '2025-09-01', '2025-09-15'),    -- Albahaca fresca
(500, 13, '2025-08-20', '2026-02-01'),   -- Spaghetti
(50, 14, '2025-08-30', '2025-09-15'),    -- Huevos
(200, 15, '2025-08-28', '2025-09-15'),   -- Panceta
(300, 16, '2025-08-30', '2025-09-18'),   -- Zanahoria
(400, 17, '2025-08-25', '2025-09-20'),   -- Papa
(100, 18, '2025-08-28', '2025-09-18'),   -- Apio
(1000, 19, '2025-08-27', '2025-09-15'),  -- Caldo de verduras
(50, 20, '2025-08-30', '2025-09-25'),    -- Pan de hamburguesa
(500, 21, '2025-08-28', '2025-09-18'),   -- Carne de hamburguesa
(200, 22, '2025-09-01', '2025-09-18'),   -- Tomate
(100, 23, '2025-08-25', '2025-09-20'),   -- Queso cheddar
(150, 24, '2025-08-25', '2025-09-20'),   -- Salsa especial
(300, 25, '2025-08-28', '2025-09-20'),   -- Muslo de pollo
(500, 26, '2025-08-01', '2026-08-01'),   -- Aceite de oliva
(50, 27, '2025-08-05', '2025-10-01'),    -- Ajo
(50, 28, '2025-08-01', '2026-03-01'),    -- Especias varias
(200, 29, '2025-09-01', '2025-09-15'),   -- Filete de pescado
(50, 30, '2025-08-30', '2025-09-20'),    -- Limón
(50, 31, '2025-08-28', '2025-09-18'),    -- Perejil
(200, 32, '2025-08-25', '2025-09-25'),   -- Masa quebrada
(150, 33, '2025-09-01', '2025-09-18'),   -- Espinaca
(100, 34, '2025-08-25', '2025-09-20'),   -- Queso ricotta
(200, 35, '2025-08-01', '2026-03-01'),   -- Arroz arborio
(150, 36, '2025-09-01', '2025-09-18');   -- Champiñones

-- mesas

INSERT INTO Mesa (numeroMesa) VALUES (1);
INSERT INTO Mesa (numeroMesa) VALUES (2);
INSERT INTO Mesa (numeroMesa) VALUES (3);
INSERT INTO Mesa (numeroMesa) VALUES (4);
INSERT INTO Mesa (numeroMesa) VALUES (5);
INSERT INTO Mesa (numeroMesa) VALUES (6);
INSERT INTO Mesa (numeroMesa) VALUES (7);
INSERT INTO Mesa (numeroMesa) VALUES (8);
INSERT INTO Mesa (numeroMesa) VALUES (9);
INSERT INTO Mesa (numeroMesa) VALUES (10);

INSERT INTO Restaurante (
    nombre, 
    historia, 
    horarios, 
    mision, 
    vision, 
    valores, 
    telefono
) VALUES (
    'Los Magorditos',
    'Restaurante familiar fundado en 2005, especializado en comida casera y sabores tradicionales.',
    'Lunes a Domingo: 12:00 - 23:00',
    'Brindar una experiencia culinaria agradable y accesible para todos.',
    'Ser reconocidos como el restaurante favorito de la ciudad por nuestra calidad y servicio.',
    'Calidad, Sabor, Atención, Tradición',
    27123456
);
