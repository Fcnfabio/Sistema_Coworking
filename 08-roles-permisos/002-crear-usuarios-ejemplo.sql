-- =====================================================
-- CREACIÓN DE USUARIOS Y ASIGNACIÓN DE ROLES
-- =====================================================
USE coworking_db;

-- Crear usuarios con contraseñas seguras
CREATE USER IF NOT EXISTS 'admin_cow'@'%' IDENTIFIED BY 'Admin2026!';
CREATE USER IF NOT EXISTS 'recepcion_cow'@'%' IDENTIFIED BY 'Recep2026!';
CREATE USER IF NOT EXISTS 'user_carlos'@'%' IDENTIFIED BY 'User2026!';
CREATE USER IF NOT EXISTS 'gerente_tech'@'%' IDENTIFIED BY 'Gerente2026!';
CREATE USER IF NOT EXISTS 'contador_cow'@'%' IDENTIFIED BY 'Conta2026!';

-- Asignar roles a los usuarios
GRANT 'administrador' TO 'admin_cow'@'%';
GRANT 'recepcionista' TO 'recepcion_cow'@'%';
GRANT 'usuario' TO 'user_carlos'@'%';
GRANT 'gerente_corporativo' TO 'gerente_tech'@'%';
GRANT 'contador' TO 'contador_cow'@'%';

-- Establecer los roles como predeterminados (para que no tengan que activarlos manualmente al loguearse)
SET DEFAULT ROLE ALL TO 'admin_cow'@'%', 'recepcion_cow'@'%', 'user_carlos'@'%', 'gerente_tech'@'%', 'contador_cow'@'%';

SELECT '✅ Usuarios de prueba creados y roles asignados' AS resultado;