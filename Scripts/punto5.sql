-- 5. Creación de Vistas para Análisis
use ecommerce;

-- 1. Desarrollar una vista que muestre el detalle completo del concentrado de ventas,
-- incluyendo datos de promociones aplicadas.
CREATE OR REPLACE VIEW ventas AS
SELECT 
    p.pedido_id,
    dp.producto_id,
    prod.nombre AS nombre_producto,
    c.cliente_id,
    CONCAT(c.nombre, ' ', c.apellido_paterno, ' ', IFNULL(c.apellido_materno, '')) AS nombre_cliente,
    dp.cantidad,
    dp.precio_unitario,
    dp.descuento_aplicado,
    (dp.precio_unitario * dp.cantidad) AS subtotal,
    ((dp.precio_unitario * dp.cantidad) * (dp.descuento_aplicado / 100)) AS descuento_total,
    ((dp.precio_unitario * dp.cantidad) - ((dp.precio_unitario * dp.cantidad) * (dp.descuento_aplicado / 100))) AS total_final,
    promo.nombre AS nombre_promocion,
    promo.porcentaje_descuento,
    p.metodo_pago,
    p.estatus,
    p.total AS total_pedido,
    t.nombre AS nombre_tienda,
    t.tipo_tienda,
    e.fecha_envio
FROM pedido p
JOIN detalle_pedido dp ON p.pedido_id = dp.pedido_id
JOIN producto prod ON dp.producto_id = prod.producto_id
LEFT JOIN producto_promocion pp ON prod.producto_id = pp.producto_id
LEFT JOIN promocion promo ON pp.promo_id = promo.promo_id
JOIN cliente c ON p.cliente_id = c.cliente_id
LEFT JOIN envio e ON p.pedido_id = e.pedido_id
LEFT JOIN tienda t ON e.tienda_id = t.tienda_id;


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

SELECT * FROM ventas WHERE estatus = 'completado' AND nombre_promocion IS NOT NULL;

-- Ver todo el concentrado
select * from concentrado_por_tienda_y_fecha;

-- Filtrar por tipo de tienda y fechas específicas
select * 
from concentrado_por_tienda_y_fecha
where tipo_tienda = 'física'
  and fecha_envio between '2024-05-01' and '2024-05-31';

-- Ver todos los registros del concentrado de ventas
select * from ventas;

-- Buscar ventas con una promoción específica
select * 
from ventas
where nombre_promocion = 'Back to School';

-- Buscar ventas realizadas por un cliente específico
select * 
from ventas
where nombre_cliente like '%juan perez%';

-- Filtrar por método de pago
select * 
from ventas
where metodo_pago = 'tarjeta credito';

-- Ventas donde se aplicó algún descuento (mayor a 0)
select * 
from ventas
where descuento_aplicado > 0;

-- Ventas cuyo total final supera cierto monto
select * 
from ventas
where total_final > 500;

-- Agrupar por producto para ver totales por nombre de producto
select 
    nombre_producto,
    sum(cantidad) as total_cantidad,
    sum(total_final) as total_vendido
from ventas
group by nombre_producto
order by total_vendido desc;

select 
    nombre_tienda,
    fecha_envio,
    sum(total_venta) as total_dia
from concentrado_por_tienda_y_fecha
group by nombre_tienda, fecha_envio
order by fecha_envio;

select *
from concentrado_por_tienda_y_fecha
where tipo_tienda = 'distribuidor';


select 
    tipo_tienda,
    avg(promedio_descuento) as descuento_promedio
from concentrado_por_tienda_y_fecha
group by tipo_tienda;


select *
from concentrado_por_tienda_y_fecha
where fecha_envio between '2022-04-01' and '2024-04-30';


drop view if exists ventas;

drop view if exists concentrado_por_tienda_y_fecha;



