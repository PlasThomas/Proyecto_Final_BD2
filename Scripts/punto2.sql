use ecommerce;

show tables;

SELECT * FROM categoria;
SELECT * FROM cliente;
SELECT * FROM detalle_pedido;
SELECT * FROM envio;
SELECT * FROM estado;
SELECT * FROM pais;
SELECT * FROM pedido;
SELECT * FROM producto;
SELECT * FROM producto_promocion;
SELECT * FROM promocion;
SELECT * FROM subcategoria;
SELECT * FROM tienda;

desc categoria;
desc cliente;
desc detalle_pedido;
desc envio;
desc estado;
desc pais;
desc pedido;
desc producto;
desc producto_promocion;
desc promocion;
desc subcategoria;
desc tienda;

-- Trigger 1

-- Creacion de tabla concentrado_ventas
CREATE TABLE concentrado_ventas(
  id_concentrado_ventas INT AUTO_INCREMENT PRIMARY KEY,
  id_tienda INT NOT NULL,
  total_venta DECIMAL(10,2) NOT NULL,
  estatus_pedido VARCHAR(50) NOT NULL,
  metodo_pago VARCHAR(50) NOT NULL,
  avg_descuento DECIMAL(10,2) NOT NULL,
  total_transacciones
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


