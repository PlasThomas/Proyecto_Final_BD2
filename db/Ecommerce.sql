-- Crear base de datos
CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

-- Tabla: pais
CREATE TABLE pais (
    pais_id INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Tabla: estado
CREATE TABLE estado (
    estado_id INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    pais_id INT,
    FOREIGN KEY (pais_id) REFERENCES pais(pais_id)
);

-- Tabla: cliente
CREATE TABLE cliente (
    cliente_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido_paterno VARCHAR(100) NOT NULL,
    apellido_materno VARCHAR(100),
    email VARCHAR(150) UNIQUE NOT NULL,
    genero CHAR(1),
    id_pais INT,
    id_estado INT,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_pais) REFERENCES pais(pais_id),
    FOREIGN KEY (id_estado) REFERENCES estado(estado_id)
);

-- Tabla: categoria
CREATE TABLE categoria (
    categoria_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Tabla: subcategoria
CREATE TABLE subcategoria (
    subcategoria_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    categoria_id INT,
    FOREIGN KEY (categoria_id) REFERENCES categoria(categoria_id)
);

-- Tabla: producto
CREATE TABLE producto (
    producto_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    id_categoria INT,
    id_subcategoria INT,
    precio DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_categoria) REFERENCES categoria(categoria_id),
    FOREIGN KEY (id_subcategoria) REFERENCES subcategoria(subcategoria_id)
);

-- Tabla: pedido
CREATE TABLE pedido (
    pedido_id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    fecha_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2),
    metodo_pago VARCHAR(50),
    estatus VARCHAR(50) DEFAULT 'pendiente',
    FOREIGN KEY (cliente_id) REFERENCES cliente(cliente_id)
);

-- Tabla: detalle_pedido
CREATE TABLE detalle_pedido (
    detalle_id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    descuento_aplicado DECIMAL(5,2) DEFAULT 0.00,
    FOREIGN KEY (pedido_id) REFERENCES pedido(pedido_id),
    FOREIGN KEY (producto_id) REFERENCES producto(producto_id)
);

-- Tabla: promocion
CREATE TABLE promocion (
    promo_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    porcentaje_descuento DECIMAL(5,2) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL
);

-- Tabla: producto_promocion (relación N a N)
CREATE TABLE producto_promocion (
    producto_id INT NOT NULL,
    promo_id INT NOT NULL,
    PRIMARY KEY (producto_id, promo_id),
    FOREIGN KEY (producto_id) REFERENCES producto(producto_id),
    FOREIGN KEY (promo_id) REFERENCES promocion(promo_id)
);

CREATE TABLE tienda (
    tienda_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion TEXT,
    ciudad VARCHAR(100),
    tipo_tienda ENUM('física', 'en línea', 'distribuidor') NOT NULL,
	id_pais INT,
    id_estado INT,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_pais) REFERENCES pais(pais_id),
    FOREIGN KEY (id_estado) REFERENCES estado(estado_id)
);


-- Tabla: envio
CREATE TABLE envio (
    envio_id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    tienda_id INT NOT NULL,
    direccion_envio TEXT NOT NULL,
    fecha_envio DATETIME,
    empresa_logistica VARCHAR(100),
    FOREIGN KEY (pedido_id) REFERENCES pedido(pedido_id),
    FOREIGN KEY (tienda_id) REFERENCES tienda(tienda_id)
);
