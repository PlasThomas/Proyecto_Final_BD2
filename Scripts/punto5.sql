-- 5. Creación de Vistas para Análisis
use ecommerce;

-- 1. Desarrollar una vista que muestre el detalle completo del concentrado de ventas,
-- incluyendo datos de promociones aplicadas.
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

create or replace view concentrado_por_tienda_y_fecha as
select 
    t.tipo_tienda,
    t.nombre as nombre_tienda,
    date(e.fecha_envio) as fecha_envio,
    count(distinct p.pedido_id) as total_transacciones,
    sum(dp.precio_unitario * dp.cantidad) as total_venta,
    avg(dp.descuento_aplicado) as promedio_descuento,
    group_concat(distinct p.metodo_pago) as metodos_pago,
    group_concat(distinct p.estatus) as estatuses
from pedido p
join detalle_pedido dp on p.pedido_id = dp.pedido_id
join envio e on p.pedido_id = e.pedido_id
join tienda t on e.tienda_id = t.tienda_id
where e.fecha_envio is not null
group by t.tipo_tienda, t.nombre, date(e.fecha_envio);




drop view if exists ventas;

drop view if exists concentrado_por_tienda_y_fecha;



