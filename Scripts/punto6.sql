show databases;
use ecommerce;
show tables;
select user from mysql.user;


-- 6. Acceso Restringido a Información Específica

/*1. Configurar un usuario que únicamente tenga acceso a las vistas desarrolladas en los
puntos 5.1 y 5.2.*/
create user 'viewer'@'%' IDENTIFIED BY 'visor'; -- creamos al usuario que tendra permisos sobre las vistas

CREATE role 'analista_ventas'; -- creamos el rol que se le asignaran al usuario

-- Asignamos los privilegios sobre las vistas al ROL
GRANT SELECT ON ecommerce.concentrado_por_tienda_y_fecha TO 'analista_ventas'; 
GRANT SELECT ON ecommerce.ventas TO 'analista_ventas';


GRANT 'analista_ventas' to 'viewer'@'%'; -- le damos el rol al usuario
SET DEFAULT ROLE 'analista_ventas' to  'viewer'@'%'; -- cada que inicie el usuario ya tendra seteado el rol



