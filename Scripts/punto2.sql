USE ecommerce;

DELIMITER $$
DROP PROCEDURE IF EXISTS total_ventas_diario$$
CREATE PROCEDURE total_ventas_diario()
BEGIN
    
END$$
DELIMITER ;

CALL total_ventas_diario();

DELIMITER $$
DROP PROCEDURE IF EXISTS consumo_cliente_tiendas$$
CREATE PROCEDURE consumo_cliente_tiendas(
    IN ncliente VARCHAR(50)
)
BEGIN

END$$
DELIMITER ;

CALL consumo_cliente_tiendas();