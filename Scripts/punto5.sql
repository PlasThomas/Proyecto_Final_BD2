-- 5. Creación de Vistas para Análisis
use ecommerce;

-- 1. Desarrollar una vista que muestre el detalle completo del concentrado de ventas,
-- incluyendo datos de promociones aplicadas.

create or replace view ventas as
select 
    p.pedido_id,
    dp.producto_id,
    prod.nombre as nombre_producto,
    c.cliente_id,
    concat(c.nombre, ' ', c.apellido_paterno, ' ', ifnull(c.apellido_materno, '')) as nombre_cliente,
    dp.cantidad,
    dp.precio_unitario,
    dp.descuento_aplicado,
    (dp.precio_unitario * dp.cantidad) as subtotal,
    ((dp.precio_unitario * dp.cantidad) * (dp.descuento_aplicado / 100)) as descuento_total,
    ((dp.precio_unitario * dp.cantidad) - ((dp.precio_unitario * dp.cantidad) * (dp.descuento_aplicado / 100))) as total_final,
    promo.nombre as nombre_promocion,
    promo.porcentaje_descuento,
    p.metodo_pago,
    p.estatus,
    p.total as total_pedido
from pedido p
join detalle_pedido dp on p.pedido_id = dp.pedido_id
join producto prod on dp.producto_id = prod.producto_id
left join producto_promocion pp on prod.producto_id = pp.producto_id
left join promocion promo on pp.promo_id = promo.promo_id
join cliente c on p.cliente_id = c.cliente_id;


-- 2. Crear una vista que muestre el concentrado de ventas filtrado por tipo de tienda y
-- rango de fechas.

create or replace view tienda_y_fecha as
select 
    t.tipo_tienda,
    t.nombre as nombre_tienda,
    p.pedido_id,
    p.total as total_pedido,
    p.metodo_pago,
    p.estatus,
    e.fecha_envio,
    c.cliente_id,
    concat(c.nombre, ' ', c.apellido_paterno, ' ', ifnull(c.apellido_materno, '')) as nombre_cliente
from pedido p
join envio e on p.pedido_id = e.pedido_id
join tienda t on e.tienda_id = t.tienda_id
join cliente c on p.cliente_id = c.cliente_id
where e.fecha_envio is not null;


-- Ver los primeros 10 registros del concentrado de ventas
select * from ventas limit 10;

-- Ver productos que tuvieron descuento aplicado (descuento_aplicado > 0)
select * from ventas 
where descuento_aplicado > 0;

-- Ventas agrupadas por método de pago
select metodo_pago, count(*) as total_ventas, sum(total_final) as total_ingresos
from ventas
group by metodo_pago;

-- Total de ventas por producto
select nombre_producto, sum(cantidad) as total_vendido, sum(total_final) as ingresos_totales
from ventas
group by nombre_producto
order by ingresos_totales desc;

-- Ver ventas donde se aplicó la promoción "Cyber Monday"
select * from ventas
where nombre_promocion = 'Cyber Monday';



drop view if exists ventas;

drop view if exists tienda_y_fecha;
