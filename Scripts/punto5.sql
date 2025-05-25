-- 5. Creación de Vistas para Análisis
use ecommerce;

-- 1. Desarrollar una vista que muestre el detalle completo del concentrado de ventas,
-- incluyendo datos de promociones aplicadas.
drop view if exists detalle_ventas;
CREATE OR REPLACE VIEW detalle_ventas AS
SELECT a.*, cv.promo_id ,cv.nombre, cv.porcentaje_descuento, DATEDIFF(cv.fecha_fin, cv.fecha_inicio) AS duracion_dias_promo
from concentrado_ventas AS a
JOIN tienda t ON (a.id_tienda = t.tienda_id)
JOIN envio e ON (t.tienda_id  = e.tienda_id)
JOIN detalle_pedido dp ON (e.pedido_id = dp.pedido_id) 
JOIN producto_promocion pp ON (dp.producto_id = pp.producto_id)
JOIN promocion cv ON (pp.promo_id  = cv.promo_id);

SELECT * FROM detalle_ventas;


-- 2. Crear una vista que muestre el concentrado de ventas filtrado por tipo de tienda y
-- rango de fechas.
drop view if exists detalle_tienda_fechas;
CREATE OR REPLACE VIEW detalle_tienda_fechas AS
SELECT a.id_concentrado_ventas, a.id_tienda, t.nombre AS tienda_nombre, t.tipo_tienda,
a.total_venta, a.estatus_pedido, a.metodo_pago, a.avg_descuento, a.total_transacciones, a.fecha_transaccion
from concentrado_ventas AS a
JOIN tienda t ON (a.id_tienda = t.tienda_id)
WHERE a.fecha_transaccion BETWEEN '2024-01-01' AND '2025-06-01'
GROUP BY t.tipo_tienda;

SELECT * FROM detalle_tienda_fechas;






