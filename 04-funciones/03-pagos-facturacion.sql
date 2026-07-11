-- =====================================================
-- FUNCIONES SQL: MÓDULO PAGOS Y FACTURACIÓN (fn_11 a fn_15)
-- Proyecto: Sistema de Gestión de Coworking
-- Descripción: Funciones escalares para consultar
--              información financiera y de pagos.
-- =====================================================

USE coworking_db;

DELIMITER $$

-- =====================================================
-- FUNCIÓN 11: fn_total_pagado
-- Calcula el total pagado por un usuario (solo pagados).
-- Parámetro: p_usuario_id (INT)
-- Retorna: DECIMAL(10,2) - Total pagado
-- =====================================================
CREATE FUNCTION fn_total_pagado(p_usuario_id INT)
RETURNS DECIMAL(10,2)
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    DECLARE v_total DECIMAL(10,2);
    
    SELECT IFNULL(SUM(monto), 0) INTO v_total
    FROM pagos
    WHERE usuario_id = p_usuario_id 
      AND estado = 'Pagado' 
      AND deleted_at IS NULL;
    
    RETURN v_total;
END $$

-- =====================================================
-- FUNCIÓN 12: fn_ingresos_por_mes
-- Calcula los ingresos totales en un mes y año específicos.
-- Parámetros: p_mes (INT), p_anio (INT)
-- Retorna: DECIMAL(10,2) - Total de ingresos
-- =====================================================
CREATE FUNCTION fn_ingresos_por_mes(p_mes INT, p_anio INT)
RETURNS DECIMAL(10,2)
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    DECLARE v_ingresos DECIMAL(10,2);
    
    SELECT IFNULL(SUM(monto), 0) INTO v_ingresos
    FROM pagos
    WHERE MONTH(fecha_pago) = p_mes 
      AND YEAR(fecha_pago) = p_anio 
      AND estado = 'Pagado' 
      AND deleted_at IS NULL;
    
    RETURN v_ingresos;
END $$

-- =====================================================
-- FUNCIÓN 13: fn_ingresos_por_membresias
-- Calcula el total de ingresos por concepto de membresías.
-- Parámetros: Ninguno
-- Retorna: DECIMAL(10,2) - Total de ingresos
-- =====================================================
CREATE FUNCTION fn_ingresos_por_membresias()
RETURNS DECIMAL(10,2)
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    DECLARE v_ingresos DECIMAL(10,2);
    
    SELECT IFNULL(SUM(monto), 0) INTO v_ingresos
    FROM pagos
    WHERE concepto = 'Membresia' 
      AND estado = 'Pagado' 
      AND deleted_at IS NULL;
    
    RETURN v_ingresos;
END $$

-- =====================================================
-- FUNCIÓN 14: fn_ingresos_por_reservas
-- Calcula el total de ingresos por concepto de reservas.
-- Parámetros: Ninguno
-- Retorna: DECIMAL(10,2) - Total de ingresos
-- =====================================================
CREATE FUNCTION fn_ingresos_por_reservas()
RETURNS DECIMAL(10,2)
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    DECLARE v_ingresos DECIMAL(10,2);
    
    SELECT IFNULL(SUM(monto), 0) INTO v_ingresos
    FROM pagos
    WHERE concepto = 'Reserva' 
      AND estado = 'Pagado' 
      AND deleted_at IS NULL;
    
    RETURN v_ingresos;
END $$

-- =====================================================
-- FUNCIÓN 15: fn_ingresos_por_empresa
-- Calcula los ingresos totales generados por una empresa.
-- Parámetro: p_empresa_id (INT)
-- Retorna: DECIMAL(10,2) - Total de ingresos
-- =====================================================
CREATE FUNCTION fn_ingresos_por_empresa(p_empresa_id INT)
RETURNS DECIMAL(10,2)
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    DECLARE v_ingresos DECIMAL(10,2);
    
    SELECT IFNULL(SUM(p.monto), 0) INTO v_ingresos
    FROM pagos p
    JOIN usuarios u ON p.usuario_id = u.id
    WHERE u.empresa_id = p_empresa_id 
      AND p.estado = 'Pagado' 
      AND p.deleted_at IS NULL 
      AND u.deleted_at IS NULL;
    
    RETURN v_ingresos;
END $$

DELIMITER ;

-- =====================================================
-- EJEMPLOS DE USO
-- =====================================================
-- SELECT fn_total_pagado(1);                        -- Esperado: 374.00 (299 + 15 + 60)
-- SELECT fn_ingresos_por_mes(7, 2026);              -- Esperado: ingresos de julio 2026
-- SELECT fn_ingresos_por_membresias();              -- Esperado: total membresías pagadas
-- SELECT fn_ingresos_por_reservas();                -- Esperado: total reservas pagadas
-- SELECT fn_ingresos_por_empresa(1);                -- Esperado: ingresos de Tech Solutions

SELECT '✅ Funciones de pagos y facturación creadas correctamente (fn_11 a fn_15)' AS resultado;