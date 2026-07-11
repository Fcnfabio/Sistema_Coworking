-- =====================================================
-- FUNCIONES SQL: MÓDULO ACCESOS Y ASISTENCIAS (fn_16 a fn_20)
-- Proyecto: Sistema de Gestión de Coworking
-- Descripción: Funciones escalares para consultar
--              información de asistencias y accesos.
-- =====================================================

USE coworking_db;

DELIMITER $$

-- =====================================================
-- FUNCIÓN 16: fn_total_asistencias
-- Cuenta el total de asistencias (entradas aprobadas) de un usuario.
-- Parámetro: p_usuario_id (INT)
-- Retorna: INT - Total de asistencias
-- =====================================================
CREATE FUNCTION fn_total_asistencias(p_usuario_id INT)
RETURNS INT
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    DECLARE v_total INT;
    
    SELECT IFNULL(COUNT(*), 0) INTO v_total
    FROM accesos
    WHERE usuario_id = p_usuario_id 
      AND tipo_acceso = 'Entrada' 
      AND estado = 'Aprobado';
    
    RETURN v_total;
END $$

-- =====================================================
-- FUNCIÓN 17: fn_asistencias_mes
-- Cuenta las asistencias en un mes y año específicos.
-- Parámetros: p_usuario_id (INT), p_mes (INT), p_anio (INT)
-- Retorna: INT - Total de asistencias en el período
-- =====================================================
CREATE FUNCTION fn_asistencias_mes(p_usuario_id INT, p_mes INT, p_anio INT)
RETURNS INT
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    DECLARE v_total INT;
    
    SELECT IFNULL(COUNT(*), 0) INTO v_total
    FROM accesos
    WHERE usuario_id = p_usuario_id 
      AND tipo_acceso = 'Entrada' 
      AND estado = 'Aprobado'
      AND MONTH(fecha_hora) = p_mes 
      AND YEAR(fecha_hora) = p_anio;
    
    RETURN v_total;
END $$

-- =====================================================
-- FUNCIÓN 18: fn_top_usuario_asistencias
-- Retorna el ID del usuario con más accesos aprobados.
-- Parámetros: Ninguno
-- Retorna: INT - ID del usuario más frecuente
-- =====================================================
CREATE FUNCTION fn_top_usuario_asistencias()
RETURNS INT
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    DECLARE v_usuario_id INT;
    
    SELECT usuario_id INTO v_usuario_id
    FROM accesos
    WHERE tipo_acceso = 'Entrada' 
      AND estado = 'Aprobado'
    GROUP BY usuario_id
    ORDER BY COUNT(*) DESC
    LIMIT 1;
    
    RETURN v_usuario_id;
END $$

-- =====================================================
-- FUNCIÓN 19: fn_ultima_asistencia
-- Retorna la fecha y hora de la última asistencia del usuario.
-- Parámetro: p_usuario_id (INT)
-- Retorna: DATETIME - Fecha de última entrada (NULL si no tiene)
-- =====================================================
CREATE FUNCTION fn_ultima_asistencia(p_usuario_id INT)
RETURNS DATETIME
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    DECLARE v_fecha DATETIME;
    
    SELECT MAX(fecha_hora) INTO v_fecha
    FROM accesos
    WHERE usuario_id = p_usuario_id 
      AND tipo_acceso = 'Entrada' 
      AND estado = 'Aprobado';
    
    RETURN v_fecha;
END $$

-- =====================================================
-- FUNCIÓN 20: fn_promedio_asistencias
-- Calcula el promedio de asistencias por usuario en el sistema.
-- Parámetros: Ninguno
-- Retorna: DECIMAL(10,2) - Promedio de asistencias
-- =====================================================
CREATE FUNCTION fn_promedio_asistencias()
RETURNS DECIMAL(10,2)
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    DECLARE v_promedio DECIMAL(10,2);
    
    SELECT IFNULL(AVG(total_entradas), 0) INTO v_promedio
    FROM (
        SELECT COUNT(*) AS total_entradas
        FROM accesos
        WHERE tipo_acceso = 'Entrada' 
          AND estado = 'Aprobado'
        GROUP BY usuario_id
    ) AS subquery;
    
    RETURN v_promedio;
END $$

DELIMITER ;

-- =====================================================
-- EJEMPLOS DE USO
-- =====================================================
-- SELECT fn_total_asistencias(1);                   -- Esperado: 8 asistencias
-- SELECT fn_asistencias_mes(1, 7, 2026);            -- Esperado: asistencias en julio
-- SELECT fn_top_usuario_asistencias();              -- Esperado: ID del usuario top
-- SELECT fn_ultima_asistencia(1);                   -- Esperado: 2026-07-11 08:30:00
-- SELECT fn_promedio_asistencias();                 -- Esperado: promedio del sistema

SELECT '✅ Funciones de accesos y asistencias creadas correctamente (fn_16 a fn_20)' AS resultado;