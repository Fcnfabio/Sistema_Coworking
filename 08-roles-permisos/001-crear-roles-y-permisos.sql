-- =====================================================
-- ROLES Y PERMISOS (Versión Optimizada)
-- MySQL 8.0+
-- =====================================================
USE coworking_db;

-- 1. CREAR LOS 5 ROLES
CREATE ROLE IF NOT EXISTS 'administrador', 'recepcionista', 'usuario', 'gerente_corporativo', 'contador';

-- 2. ASIGNAR PERMISOS

-- ADMINISTRADOR: Acceso total
GRANT ALL PRIVILEGES ON coworking_db.* TO 'administrador';

-- RECEPCIONISTA: Lectura total + Escritura en operaciones diarias + Ejecución de lógica
GRANT SELECT ON coworking_db.* TO 'recepcionista';
GRANT INSERT, UPDATE ON coworking_db.usuarios, coworking_db.membresias, coworking_db.reservas, 
                        coworking_db.pagos, coworking_db.facturas, coworking_db.accesos TO 'recepcionista';
GRANT EXECUTE ON PROCEDURE coworking_db.* TO 'recepcionista';
GRANT EXECUTE ON FUNCTION coworking_db.* TO 'recepcionista';

-- USUARIO: Solo lectura de catálogos + Ejecución de sus propios procedimientos/funciones
GRANT SELECT ON coworking_db.espacios, coworking_db.tipos_espacio, coworking_db.servicios_adicionales TO 'usuario';
GRANT EXECUTE ON PROCEDURE sp_verificar_disponibilidad, sp_crear_reserva, sp_cancelar_reserva TO 'usuario';
GRANT EXECUTE ON FUNCTION fn_membresia_activa, fn_dias_restantes_membresia, fn_tipo_membresia, 
       fn_estado_membresia, fn_total_reservas, fn_horas_reservadas, fn_reservas_activas, 
       fn_total_pagado, fn_total_asistencias, fn_ultima_asistencia TO 'usuario';

-- GERENTE CORPORATIVO: Lectura de datos de empleados y facturación + Reportes
GRANT SELECT ON coworking_db.usuarios, coworking_db.empresas, coworking_db.facturas, coworking_db.pagos TO 'gerente_corporativo';
GRANT EXECUTE ON PROCEDURE sp_generar_factura_consolidada_empresa TO 'gerente_corporativo';
GRANT EXECUTE ON FUNCTION fn_ingresos_por_empresa TO 'gerente_corporativo';

-- CONTADOR: Lectura financiera total + Ajustes de facturas/pagos + Reportes
GRANT SELECT ON coworking_db.* TO 'contador';
GRANT UPDATE ON coworking_db.facturas, coworking_db.pagos TO 'contador';
GRANT EXECUTE ON PROCEDURE sp_reporte_ingresos_mensuales_acumulados, sp_generar_factura_consolidada_empresa, 
       sp_aplicar_recargos_facturas_vencidas TO 'contador';
GRANT EXECUTE ON FUNCTION fn_total_pagado, fn_ingresos_por_mes, fn_ingresos_por_membresias, 
       fn_ingresos_por_reservas, fn_ingresos_por_empresa TO 'contador';

SELECT '✅ Roles y permisos creados de forma optimizada' AS resultado;