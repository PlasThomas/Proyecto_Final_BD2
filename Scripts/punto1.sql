-- 1. Creación de Usuarios con Políticas Específicas
	-- 1. Crear un usuario que pueda realizar lecturas en todas las tablas, con una limitación de 15 consultas por hora.

-- crear el usuario
CREATE USER 'lector'@'%' IDENTIFIED BY 'lector123';

-- dar permisos de solo lectura a todas las tablas
GRANT SELECT ON ecommerce.* TO 'lector'@'%';

-- limitar a 15 consultas por hora
ALTER USER 'lector'@'%' WITH MAX_QUERIES_PER_HOUR 15;

	-- 2. Crear un usuario con permisos de lectura y escritura en todas las tablas, limitado a 2 conexiones concurrentes y prohibido realizar operaciones DDL.

-- crear el usuario
CREATE USER 'editor'@'%' IDENTIFIED BY 'editor123';

-- otorgar permisos de lectura y escritura (SELECT, INSERT, UPDATE, DELETE) en todas las tablas
GRANT SELECT, INSERT, UPDATE, DELETE ON ecommerce.* TO 'editor'@'%';

-- limitar a 2 conexiones simultáneas
ALTER USER 'editor'@'%' WITH MAX_USER_CONNECTIONS 2;
