USE ecommerce;
-- Trigger 1
-- Creacion de tabla concentrado_ventas
CREATE TABLE concentrado_ventas(
  id_concentrado_ventas INT AUTO_INCREMENT PRIMARY KEY,
  id_tienda INT NOT NULL,
  total_venta DECIMAL(10,2) NOT NULL,
  estatus_pedido VARCHAR(50) NOT NULL,
  metodo_pago VARCHAR(50) NOT NULL,
  avg_descuento DECIMAL(10,2) NOT NULL,
  total_transacciones INT NOT NULL,
  FOREIGN KEY (id_tienda) REFERENCES tienda(tienda_id)
);

select from;

DELIMITER $$
DROP PROCEDURE IF EXISTS total_ventas_diario$$
CREATE PROCEDURE total_ventas_diario()
BEGIN
    
END$$
DELIMITER ;

CALL total_ventas_diario();



-- Trigger 2

DELIMITER $$
DROP PROCEDURE IF EXISTS consumo_cliente_tiendas$$
CREATE PROCEDURE consumo_cliente_tiendas(
    IN ncliente VARCHAR(50)
)
BEGIN

END$$
DELIMITER ;

CALL consumo_cliente_tiendas();


