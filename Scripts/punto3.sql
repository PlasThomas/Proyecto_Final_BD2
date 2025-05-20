-- 3. Implementación de Triggers
	-- 1. Desarrollar un trigger que registre en una bitácora los cambios y eliminaciones en las tablas de pedido, producto, cliente y tienda, incluyendo la fecha y usuario que efectuó el cambio.
    
    -- crear tabla bitacora
    CREATE TABLE bitacora (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tabla VARCHAR(50),
    accion ENUM('UPDATE', 'DELETE'),
    id_afectado INT,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(100)
);

-- crear los triggers para regsitrar cambios y eliminaciones

-- triggers para la tabla producto 
CREATE TRIGGER trg_update_producto
AFTER UPDATE ON producto
FOR EACH ROW
INSERT INTO bitacora(tabla, accion, id_afectado, usuario)
VALUES ('producto', 'UPDATE', OLD.producto_id, USER());

CREATE TRIGGER trg_delete_producto
AFTER DELETE ON producto
FOR EACH ROW
INSERT INTO bitacora(tabla, accion, id_afectado, usuario)
VALUES ('producto', 'DELETE', OLD.producto_id, USER());

-- triggers para la tabla pedido
CREATE TRIGGER trg_update_pedido
AFTER UPDATE ON pedido
FOR EACH ROW
INSERT INTO bitacora(tabla, accion, id_afectado, usuario)
VALUES ('pedido', 'UPDATE', OLD.pedido_id, USER());

CREATE TRIGGER trg_delete_pedido
AFTER DELETE ON pedido
FOR EACH ROW
INSERT INTO bitacora(tabla, accion, id_afectado, usuario)
VALUES ('pedido', 'DELETE', OLD.pedido_id, USER());

-- triggers para la tabla cliente
CREATE TRIGGER trg_update_cliente
AFTER UPDATE ON cliente
FOR EACH ROW
INSERT INTO bitacora(tabla, accion, id_afectado, usuario)
VALUES ('cliente', 'UPDATE', OLD.cliente_id, USER());

CREATE TRIGGER trg_delete_cliente
AFTER DELETE ON cliente
FOR EACH ROW
INSERT INTO bitacora(tabla, accion, id_afectado, usuario)
VALUES ('cliente', 'DELETE', OLD.cliente_id, USER());

-- triggers para la tabla tienda
CREATE TRIGGER trg_update_tienda
AFTER UPDATE ON tienda
FOR EACH ROW
INSERT INTO bitacora(tabla, accion, id_afectado, usuario)
VALUES ('tienda', 'UPDATE', OLD.tienda_id, USER());

CREATE TRIGGER trg_delete_tienda
AFTER DELETE ON tienda
FOR EACH ROW
INSERT INTO bitacora(tabla, accion, id_afectado, usuario)
VALUES ('tienda', 'DELETE', OLD.tienda_id, USER());

	-- 2. Establecer un trigger que impida la inserción de productos con precios negativos o nulos.

-- trigger que impide la insercion 
delimiter $$
CREATE TRIGGER trg_prevent_precio_invalido
BEFORE INSERT ON producto
FOR EACH ROW
BEGIN
    IF NEW.precio IS NULL OR NEW.precio < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El precio no puede ser nulo ni negativo.';
    END IF;
END;
end delimiter $$
	
