USE ecommerce;

INSERT INTO pais (pais_id, nombre) VALUES
(1, 'México'),
(2, 'Estados Unidos'),
(3, 'España'),
(4, 'Colombia'),
(5, 'Argentina');

INSERT INTO estado (estado_id, nombre, pais_id) VALUES
-- México
(1, 'Ciudad de México', 1),
(2, 'Jalisco', 1),
(3, 'Nuevo León', 1),
-- Estados Unidos
(4, 'California', 2),
(5, 'Texas', 2),
(6, 'Florida', 2),
-- España
(7, 'Madrid', 3),
(8, 'Barcelona', 3),
(9, 'Valencia', 3),
-- Colombia
(10, 'Bogotá', 4),
(11, 'Antioquia', 4),
-- Argentina
(12, 'Buenos Aires', 5),
(13, 'Córdoba', 5);

INSERT INTO cliente (nombre, apellido_paterno, apellido_materno, email, genero, id_pais, id_estado) VALUES
('Juan', 'Pérez', 'Gómez', 'juan.perez@email.com', 'M', 1, 1),
('María', 'López', 'Hernández', 'maria.lopez@email.com', 'F', 1, 2),
('Carlos', 'García', NULL, 'carlos.garcia@email.com', 'M', 1, 3),
('Ana', 'Martínez', 'Sánchez', 'ana.martinez@email.com', 'F', 3, 7),
('John', 'Smith', NULL, 'john.smith@email.com', 'M', 2, 4),
('Laura', 'Johnson', 'Brown', 'laura.johnson@email.com', 'F', 2, 5),
('Pedro', 'González', 'Ramírez', 'pedro.gonzalez@email.com', 'M', 4, 10),
('Sofía', 'Rodríguez', 'Díaz', 'sofia.rodriguez@email.com', 'F', 5, 12),
('Miguel', 'Fernández', 'Vázquez', 'miguel.fernandez@email.com', 'M', 3, 8),
('Elena', 'Torres', 'Jiménez', 'elena.torres@email.com', 'F', 3, 9);


INSERT INTO categoria (nombre) VALUES
('Electrónica'),
('Ropa'),
('Hogar'),
('Deportes'),
('Juguetes');

INSERT INTO subcategoria (nombre, categoria_id) VALUES
-- Electrónica
('Smartphones', 1),
('Computadoras', 1),
('Audio', 1),
-- Ropa
('Hombre', 2),
('Mujer', 2),
('Niños', 2),
-- Hogar
('Muebles', 3),
('Electrodomésticos', 3),
('Decoración', 3),
-- Deportes
('Fútbol', 4),
('Natación', 4),
('Ciclismo', 4),
-- Juguetes
('Educativos', 5),
('Juegos de mesa', 5),
('Muñecas', 5);

INSERT INTO producto (nombre, id_categoria, id_subcategoria, precio, stock) VALUES
-- Electrónica
('Smartphone X1', 1, 1, 8999.99, 50),
('Laptop Pro', 1, 2, 19999.99, 30),
('Audífonos Bluetooth', 1, 3, 799.50, 100),
-- Ropa
('Camisa hombre manga larga', 2, 4, 499.99, 80),
('Vestido verano', 2, 5, 699.99, 60),
('Conjunto infantil', 2, 6, 399.99, 40),
-- Hogar
('Sofá 3 plazas', 3, 7, 8999.00, 15),
('Refrigerador', 3, 8, 12999.00, 20),
('Lámpara moderna', 3, 9, 899.50, 35),
-- Deportes
('Balón fútbol profesional', 4, 10, 599.99, 25),
('Goggles natación', 4, 11, 349.50, 40),
('Bicicleta montaña', 4, 12, 8999.99, 10),
-- Juguetes
('Set bloques construcción', 5, 13, 499.99, 30),
('Juego de ajedrez', 5, 14, 299.99, 20),
('Muñeca interactiva', 5, 15, 799.99, 25);

INSERT INTO promocion (nombre, descripcion, porcentaje_descuento, fecha_inicio, fecha_fin) VALUES
('Cyber Monday', 'Descuentos en electrónica', 15.00, '2023-11-27', '2023-11-30'),
('Verano Fashion', 'Descuentos en ropa', 20.00, '2023-06-01', '2023-08-31'),
('Hogar y Más', 'Promoción en muebles', 10.00, '2023-09-01', '2023-09-30'),
('Back to School', 'Promoción en computadoras', 12.50, '2023-07-15', '2023-08-15'),
('Navidad', 'Promoción navideña en juguetes', 25.00, '2023-12-01', '2023-12-25');

INSERT INTO producto_promocion (producto_id, promo_id) VALUES
(1, 1), (2, 1), (3, 1),  -- Electrónica en Cyber Monday
(2, 4),                   -- Laptop en Back to School
(4, 2), (5, 2), (6, 2),   -- Ropa en Verano Fashion
(7, 3), (8, 3),           -- Hogar en Hogar y Más
(13, 5), (14, 5), (15, 5); -- Juguetes en Navidad

INSERT INTO tienda (nombre, direccion, ciudad, tipo_tienda, id_pais, id_estado) VALUES
('Tienda Centro', 'Av. Principal 123', 'Ciudad de México', 'física', 1, 1),
('Tienda Guadalajara', 'Calle Independencia 456', 'Guadalajara', 'física', 1, 2),
('Tienda Online', NULL, NULL, 'en línea', NULL, NULL),
('Tienda Monterrey', 'Blvd. Constitución 789', 'Monterrey', 'física', 1, 3),
('Distribuidor Nacional', 'Av. Industrial 321', 'Toluca', 'distribuidor', 1, 1);

INSERT INTO pedido (cliente_id, total, metodo_pago, estatus) VALUES
(1, 26999.98, 'tarjeta crédito', 'completado'),
(2, 1199.49, 'paypal', 'completado'),
(3, 4999.99, 'transferencia', 'pendiente'),
(4, 16999.00, 'tarjeta débito', 'enviado'),
(5, 2398.47, 'tarjeta crédito', 'completado'),
(6, 8999.00, 'efectivo', 'cancelado'),
(7, 349.50, 'paypal', 'completado'),
(8, 799.99, 'tarjeta crédito', 'enviado'),
(9, 599.99, 'transferencia', 'pendiente'),
(10, 12999.00, 'tarjeta crédito', 'completado');

INSERT INTO detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, descuento_aplicado) VALUES
-- Pedido 1: 2 productos (Laptop + Smartphone)
(1, 2, 1, 19999.99, 0.00),
(1, 1, 1, 8999.99, 0.00),

-- Pedido 2: Audífonos + Camisa
(2, 3, 1, 799.50, 0.00),
(2, 4, 1, 499.99, 0.00),

-- Pedido 3: Vestido verano
(3, 5, 1, 699.99, 0.00),
(3, 6, 2, 399.99, 0.00),

-- Pedido 4: Refrigerador
(4, 8, 1, 12999.00, 0.00),
(4, 9, 1, 899.50, 0.00),

-- Pedido 5: Productos con descuento (promoción)
(5, 1, 1, 8999.99, 15.00),  -- 15% descuento por promoción
(5, 13, 2, 499.99, 25.00),   -- 25% descuento por promoción

-- Resto de pedidos
(6, 7, 1, 8999.00, 0.00),
(7, 11, 1, 349.50, 0.00),
(8, 15, 1, 799.99, 0.00),
(9, 14, 1, 299.99, 0.00),
(10, 8, 1, 12999.00, 0.00);


INSERT INTO envio (pedido_id, tienda_id, direccion_envio, fecha_envio, empresa_logistica) VALUES
(1, 1, 'Calle Rosa 123, Col. Centro, CDMX', '2023-05-15 10:30:00', 'Estafeta'),
(2, 3, 'Envío digital - producto digital', NULL, NULL),
(4, 2, 'Av. Juárez 456, Col. Moderna, Guadalajara', '2023-05-18 14:15:00', 'DHL'),
(7, 3, 'Envío digital - producto digital', NULL, NULL),
(8, 4, 'Calle Hidalgo 789, Monterrey', '2023-05-20 09:45:00', 'FedEx'),
(10, 5, 'Av. Industrial 321, Toluca', '2023-05-22 16:20:00', 'Estafeta');