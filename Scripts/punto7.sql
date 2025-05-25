CREATE DATABASE IF NOT EXISTS dwecommerce;
USE dwecommerce;

-- Tabla dimensionar de informacion geografica
CREATE TABLE dim_geography (
    geo_id INT AUTO_INCREMENT PRIMARY KEY,
    contry VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL
);
-- Tiene los nombres de estado y pais de las tablas estado y pais. 
INSERT INTO dwecommerce.dim_geography (contry, state) SELECT p.nombre , e.nombre 
from ecommerce.estado p join ecommerce.pais e on (e.pais_id = p.pais_id);


-- Tabla dimencional de tiempo
CREATE TABLE dim_time(
		time_id INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE NOT NULL,
    anio INT NOT NULL,
    mes INT NOT NULL,
    dia INT NOT NULL,
    hora_completa TIME,
  	hora INT NOT NULL,
    nm_mes VARCHAR(16) NOT NULL,
    nm_dia VARCHAR(16) NOT NULL
);
-- Tiene unicamente las fechas en las que se realizaron pedidos
INSERT INTO dim_time(fecha, anio, mes, dia, hora_completa, hora, nm_mes, nm_dia)
SELECT DISTINCT fecha_pedido, YEAR(fecha_pedido), MONTH(fecha_pedido), DAY(fecha_pedido), TIME(fecha_pedido), HOUR(fecha_pedido), MONTHNAME(fecha_pedido), DAYNAME(fecha_pedido) 
FROM ecommerce.pedido;


-- Tabla dimencional de los clientes
CREATE TABLE dim_customer (
    cust_id INT AUTO_INCREMENT PRIMARY KEY,
    cust_nm VARCHAR(250) NOT NULL,
    email VARCHAR(150) NOT NULL,
    gender CHAR(1) NOT NULL
);
-- Solo engloba las mismas caracteristicas que las tablas cliente de ecommerce
INSERT INTO dwecommerce.dim_customer (cust_nm, email, gender)
SELECT CONCAT(
         nombre, ' ',
         apellido_paterno, ' ',
         IFNULL(apellido_materno, '')
       ),
       email,
       genero
FROM ecommerce.cliente;


-- Dimension productos
CREATE TABLE dim_product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_nm VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    activo BOOLEAN NOT NULL,
    category VARCHAR(100) NOT NULL,
    subcategory VARCHAR(100) NOT NULL,
    promocion VARCHAR(100),
    prom_description TEXT,
    desc_porcentaje DECIMAL(5,2)
);
-- contiene toda la informacion concentrada de los productos y promociones
INSERT INTO dwecommerce.dim_product ( 
    product_nm,
    price,
    stock,
    activo,
    category,
    subcategory,
    promocion,
    prom_description,
    desc_porcentaje
)
SELECT
    p.nombre AS product_nm,
    p.precio,
    p.stock,
    p.activo,
    c.nombre AS category,
    s.nombre AS subcategory,
    pr.nombre AS promocion,
    pr.descripcion AS prom_description,
    pr.porcentaje_descuento AS desc_porcentaje
FROM ecommerce.producto p
LEFT JOIN ecommerce.categoria c ON p.id_categoria = c.categoria_id
LEFT JOIN ecommerce.subcategoria s ON p.id_subcategoria = s.subcategoria_id
LEFT JOIN ecommerce.producto_promocion pp ON p.producto_id = pp.producto_id
LEFT JOIN ecommerce.promocion pr ON pp.promo_id = pr.promo_id;


-- Tabla dimensional de tienda
CREATE TABLE dim_store (
    store_id INT AUTO_INCREMENT PRIMARY KEY,
    store_nm  VARCHAR(100) NOT NULL,
    store_address TEXT NOT NULL,
	kind_of_store enum('fisica','en Linea','distribuidor'),
	city VARCHAR(100) NOT NULL
);
-- incluye los datos de las tiendas existentes
INSERT INTO dwecommerce.dim_store (
    store_id,
    store_nm,
    store_address,
    kind_of_store,
    city
)
SELECT
    t.tienda_id,
    t.nombre,
    IFNULL(t.direccion, ''),
    CASE
        WHEN t.tipo_tienda = 'física' THEN 'fisica'
        WHEN t.tipo_tienda = 'en línea' THEN 'en Linea'
        ELSE t.tipo_tienda 
    END AS kind_of_store,
    IFNULL(t.ciudad, '')
FROM ecommerce.tienda t;


-- Tabla de hechos principal
CREATE TABLE fact_pedidos (
  	id INT AUTO_INCREMENT PRIMARY KEY,
  	dim_time_id INT,
		dim_geo_id INT,
    dim_cust_id INT,
    dim_product_id INT,
    dim_store_id INT,
    cantidad_producto_venta INT NOT NULL,
    avg_descuento DECIMAL(10,2) NOT NULL,
    metodo_pago varchar(50) NOT NULL,
    total_transacciones INT NOT NULL,
    costumer_address TEXT,
  	FOREIGN KEY (dim_time_id) REFERENCES dim_time(time_id),
    FOREIGN KEY (dim_geo_id) REFERENCES dim_geography(geo_id),
    FOREIGN KEY (dim_cust_id) REFERENCES dim_customer(cust_id),
    FOREIGN KEY (dim_product_id) REFERENCES dim_product(product_id),
		FOREIGN KEY (dim_store_id) REFERENCES dim_store(store_id)
);
-- Datos completos y concentrados de todo lo relacionado con pedidos
INSERT INTO dwecommerce.fact_pedidos (
  	dim_time_id
    dim_geo_id,
    dim_cust_id,
    dim_product_id,
    dim_store_id,
    cantidad_producto_venta,
    avg_descuento,
    metodo_pago,
    total_transacciones,
    costumer_address
)
SELECT 
	dt.time_id,
    dg.geo_id,
    dc.cust_id,
    dp.product_id,
    ds.store_id,
    dped.cantidad,
    dped.descuento_aplicado,
    p.metodo_pago,
    1 AS total_transacciones,
    CONCAT(cl.nombre, ' ', cl.apellido_paterno, ', ', es.nombre, ', ', pa.nombre) AS costumer_address
FROM ecommerce.pedido p
JOIN ecommerce.cliente cl ON p.cliente_id = cl.cliente_id
JOIN ecommerce.detalle_pedido dped ON p.pedido_id = dped.pedido_id
JOIN dwecommerce.dim_time dt ON p.fecha_pedido = dt.fecha
JOIN ecommerce.producto pr ON dped.producto_id = pr.producto_id
LEFT JOIN ecommerce.envio e ON e.pedido_id = p.pedido_id
LEFT JOIN ecommerce.tienda t ON e.tienda_id = t.tienda_id
JOIN dwecommerce.dim_customer dc ON dc.email = cl.email
JOIN dwecommerce.dim_product dp ON dp.product_nm = pr.nombre
JOIN dwecommerce.dim_store ds ON ds.store_nm = t.nombre
JOIN ecommerce.estado es ON cl.id_estado = es.estado_id
JOIN ecommerce.pais pa ON cl.id_pais = pa.pais_id
JOIN dwecommerce.dim_geography dg ON dg.state = es.nombre AND dg.contry = pa.nombre;
