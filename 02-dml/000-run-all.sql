-- =====================================================
-- ARCHIVO MAESTRO DE DATOS INICIALES
-- Proyecto: Sistema de Gestión de Coworking
-- Instrucción: Ejecutar este archivo para poblar toda 
-- la base de datos en el orden correcto.
-- =====================================================

USE coworking_db;

-- ⚠️ IMPORTANTE: Desactivar verificación de FK temporalmente 
-- solo si necesitas re-ejecutar todo desde cero.
-- SET FOREIGN_KEY_CHECKS = 0;
-- TRUNCATE TABLE logs;
-- TRUNCATE TABLE accesos;
-- TRUNCATE TABLE facturas;
-- TRUNCATE TABLE pagos;
-- TRUNCATE TABLE reserva_servicios;
-- TRUNCATE TABLE reservas;
-- TRUNCATE TABLE espacios;
-- TRUNCATE TABLE historial_membresias;
-- TRUNCATE TABLE membresias;
-- TRUNCATE TABLE usuarios;
-- TRUNCATE TABLE servicios_adicionales;
-- TRUNCATE TABLE tipos_espacio;
-- TRUNCATE TABLE tipos_membresia;
-- TRUNCATE TABLE empresas;
-- SET FOREIGN_KEY_CHECKS = 1;

-- =====================================================
-- EJECUCIÓN EN ORDEN (respeta dependencias de FK)
-- =====================================================

-- PASO 1: Catálogos base (sin dependencias)
SOURCE 001-insert-empresas.sql;
SOURCE 002-insert-tipos-membresia.sql;
SOURCE 003-insert-tipos-espacio.sql;
SOURCE 004-insert-servicios-adicionales.sql;

-- PASO 2: Usuarios y Membresías
SOURCE 005-insert-usuarios.sql;
SOURCE 006-insert-membresias.sql;
SOURCE 007-insert-historial-membresias.sql;

-- PASO 3: Espacios y Reservas
SOURCE 008-insert-espacios.sql;
SOURCE 009-insert-reservas.sql;
SOURCE 010-insert-reserva-servicios.sql;

-- PASO 4: Pagos y Facturación
SOURCE 011-insert-pagos.sql;
SOURCE 012-insert-facturas.sql;

-- PASO 5: Accesos y Logs
SOURCE 013-insert-accesos.sql;
SOURCE 014-insert-logs.sql;

-- =====================================================
-- VERIFICACIÓN FINAL
-- =====================================================
SELECT '✅ EMPRESAS' AS tabla, COUNT(*) AS registros FROM empresas
UNION ALL
SELECT 'TIPOS MEMBRESIA', COUNT(*) FROM tipos_membresia
UNION ALL
SELECT 'TIPOS ESPACIO', COUNT(*) FROM tipos_espacio
UNION ALL
SELECT 'SERVICIOS ADICIONALES', COUNT(*) FROM servicios_adicionales
UNION ALL
SELECT 'USUARIOS', COUNT(*) FROM usuarios
UNION ALL
SELECT 'MEMBRESIAS', COUNT(*) FROM membresias
UNION ALL
SELECT 'HISTORIAL MEMBRESIAS', COUNT(*) FROM historial_membresias
UNION ALL
SELECT 'ESPACIOS', COUNT(*) FROM espacios
UNION ALL
SELECT 'RESERVAS', COUNT(*) FROM reservas
UNION ALL
SELECT 'RESERVA SERVICIOS', COUNT(*) FROM reserva_servicios
UNION ALL
SELECT 'PAGOS', COUNT(*) FROM pagos
UNION ALL
SELECT 'FACTURAS', COUNT(*) FROM facturas
UNION ALL
SELECT 'ACCESOS', COUNT(*) FROM accesos
UNION ALL
SELECT 'LOGS', COUNT(*) FROM logs;

SELECT ' Datos iniciales cargados correctamente' AS resultado;