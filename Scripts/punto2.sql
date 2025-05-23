USE ecommerce;

-- <============================ Trigger 1 ============================> -- 

-- #### Creacion de tabla concentrado_ventas
DROP TABLE IF EXISTS concentrado_ventas;
CREATE TABLE concentrado_ventas(
  id_concentrado_ventas INT AUTO_INCREMENT PRIMARY KEY,
  id_tienda INT NOT NULL,
  fecha_transaccion DATE NOT NULL,
  total_venta DECIMAL(10,2) NOT NULL,
  estatus_pedido VARCHAR(50) NOT NULL,
  metodo_pago VARCHAR(50) NOT NULL,
  avg_descuento DECIMAL(10,2) NOT NULL,
  total_transacciones INT NOT NULL,
  FOREIGN KEY (id_tienda) REFERENCES tienda(tienda_id)
);

-- #### CREACION DEL TRIGGER 
DELIMITER $$
DROP PROCEDURE IF EXISTS total_ventas_diario$$
CREATE PROCEDURE total_ventas_diario()
BEGIN
  TRUNCATE TABLE concentrado_ventas;
  INSERT INTO concentrado_ventas(
    id_tienda, fecha_transaccion, total_venta, estatus_pedido, metodo_pago, avg_descuento, total_transacciones)
  SELECT 
    t.tienda_id,
    DATE(p.fecha_pedido),
    SUM(dp.cantidad * dp.precio_unitario * (1 - dp.descuento_aplicado / 100)) AS venta_total,
    p.estatus,
    p.metodo_pago,
    AVG(dp.descuento_aplicado) AS promedio_descuento,
    COUNT(DISTINCT p.pedido_id) AS transacciones_totales
  FROM pedido AS p
  JOIN detalle_pedido AS dp ON p.pedido_id = dp.pedido_id
  JOIN envio AS e ON p.pedido_id = e.pedido_id
  JOIN tienda AS t ON e.tienda_id = t.tienda_id
  GROUP BY t.tienda_id, DATE(p.fecha_pedido), p.estatus, p.metodo_pago;
END$$
DELIMITER ;


-- para utilizarse con mariaDB
DELIMITER $$
DROP PROCEDURE IF EXISTS total_ventas_diario$$
CREATE PROCEDURE total_ventas_diario()
BEGIN
  TRUNCATE TABLE concentrado_ventas;
	INSERT INTO concentrado_ventas(id_tienda,fecha_transaccion, total_venta, estatus_pedido, metodo_pago, avg_descuento, total_transacciones)
	SELECT t.tienda_id, p.fecha_pedido, 
  	SUM(dp.cantidad * dp.precio_unitario * (1-dp.descuento_aplicado/100)) as venta_total,
    p.estatus , p.metodo_pago,
    AVG(dp.descuento_aplicado) promedio_descuento,
    COUNT(DISTINCT p.pedido_id) AS transaciones_totales
  FROM pedido as p
  JOIN detalle_pedido AS dp ON (p.pedido_id = dp.pedido_id)
  JOIN envio AS e ON (p.pedido_id = e.pedido_id)
  JOIN tienda AS t ON (e.tienda_id = t.tienda_id) 
  GROUP BY t.tienda_id, p.fecha_pedido DESC;
	SELECT * FROM concentrado_ventas;  
END$$
DELIMITER ;



CALL total_ventas_diario();
SELECT * FROM concentrado_ventas;



--<============================ Trigger 2 ============================> -- 

-- Se utilizo la exprecion "dp.cantidad * dp.precio_unitario * (1-dp.descuento_aplicado/100)" para el consumo para considerar toda la informacion
-- disponibl y asi tener datos mas exactos.
-- Se usa como argumento de entrada ncliente para encontrar los datos correspondientes y se utiliza "tienda_id" para agrupar los datos por tienda.

DELIMITER $$
DROP PROCEDURE IF EXISTS consumo_cliente_tiendas$$
CREATE PROCEDURE consumo_cliente_tiendas(
    IN ncliente INT
)
BEGIN
	SELECT e.tienda_id,SUM(dp.cantidad * dp.precio_unitario * (1-dp.descuento_aplicado/100)) AS total_consumo, 
  COUNT(DISTINCT p.pedido_id) AS numero_de_pedidos, 
  AVG(dp.cantidad * dp.precio_unitario * (1-dp.descuento_aplicado/100)) AS promedio_consumo
	FROM pedido AS p 
	JOIN detalle_pedido AS dp ON(p.pedido_id = dp.detalle_id)
	JOIN envio AS e ON(p.pedido_id = e.pedido_id)
	WHERE p.cliente_id = ncliente
	GROUP BY e.tienda_id;
END$$
DELIMITER ;

-- se tiene que ingresar el id del cliente como argumento del procedimiento almacenado
CALL consumo_cliente_tiendas(1);
