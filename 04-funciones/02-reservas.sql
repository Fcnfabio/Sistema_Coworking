-- =====================================================
-- FUNCIONES SQL: MÓDULO RESERVAS (fn_6 a fn_10)
-- Proyecto: Sistema de Gestión de Coworking
-- Descripción: Funciones escalares para consultar
--              información de reservas y espacios.
-- =====================================================

USE coworking_db;

DELIMITER $$

-- =====================================================
-- FUNCIÓN 6: fn_total_reservas
-- Cuenta la cantidad total de reservas de un usuario.
-- Parámetro: p_usuario_id (INT)
-- Retorna: INT - Total de reservas
-- =====================================================
CREATE FUNCTION fn_total_reservas(p_usuario_id INT)
RETURNS INT
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    DECLARE v_total INT;
    
    SELECT IFNULL(COUNT(*), 0) INTO v_total
    FROM reservas
    WHERE usuario_id = p_usuario_id 
      AND deleted_at IS NULL;
    
    RETURN v_total;
END $$

-- =====================================================
-- FUNCIÓN 7: fn_horas_reservadas
-- Calcula el total de horas reservadas en un período.
-- Parámetros: p_usuario_id (INT), p_mes (INT), p_anio (INT)
-- Retorna: DECIMAL(10,2) - Total de horas
-- =====================================================
CREATE FUNCTION fn_horas_reservadas(p_usuario_id INT, p_mes INT, p_anio INT)
RETURNS DECIMAL(10,2)
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    DECLARE v_horas DECIMAL(10,2);
    
    SELECT IFNULL(SUM(TIME_TO_SEC(TIMEDIFF(hora_fin, hora_inicio)) / 3600), 0) INTO v_horas
    FROM reservas
    WHERE usuario_id = p_usuario_id 
      AND MONTH(fecha_reserva) = p_mes 
      AND YEAR(fecha_reserva) = p_anio
      AND estado IN ('Confirmada', 'Completada') 
      AND deleted_at IS NULL;
    
    RETURN v_horas;
END $$

-- =====================================================
-- FUNCIÓN 8: fn_espacio_mas_reservado
-- Retorna el ID del espacio con más reservas confirmadas.
-- Parámetros: Ninguno
-- Retorna: INT - ID del espacio más usado
-- =====================================================
CREATE FUNCTION fn_espacio_mas_reservado()
RETURNS INT
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    DECLARE v_espacio_id INT;
    
    SELECT espacio_id INTO v_espacio_id
    FROM reservas
    WHERE estado IN ('Confirmada', 'Completada') 
      AND deleted_at IS NULL
    GROUP BY espacio_id
    ORDER BY COUNT(*) DESC
    LIMIT 1;
    
    RETURN v_espacio_id;
END $$

-- =====================================================
-- FUNCIÓN 9: fn_reservas_activas
-- Cuenta las reservas pendientes o confirmadas de un usuario.
-- Parámetro: p_usuario_id (INT)
-- Retorna: INT - Cantidad de reservas activas
-- =====================================================
CREATE FUNCTION fn_reservas_activas(p_usuario_id INT)
RETURNS INT
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    DECLARE v_activas INT;
    
    SELECT IFNULL(COUNT(*), 0) INTO v_activas
    FROM reservas
    WHERE usuario_id = p_usuario_id 
      AND estado IN ('Pendiente', 'Confirmada') 
      AND deleted_at IS NULL;
    
    RETURN v_activas;
END $$

-- =====================================================
-- FUNCIÓN 10: fn_duracion_promedio_reservas
-- Calcula el promedio de duración de reservas en un espacio.
-- Parámetro: p_espacio_id (INT)
-- Retorna: DECIMAL(10,2) - Promedio en horas
-- =====================================================
CREATE FUNCTION fn_duracion_promedio_reservas(p_espacio_id INT)
RETURNS DECIMAL(10,2)
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    DECLARE v_promedio DECIMAL(10,2);
    
    SELECT IFNULL(AVG(TIME_TO_SEC(TIMEDIFF(hora_fin, hora_inicio)) / 3600), 0) INTO v_promedio
    FROM reservas
    WHERE espacio_id = p_espacio_id 
      AND estado IN ('Confirmada', 'Completada') 
      AND deleted_at IS NULL;
    
    RETURN v_promedio;
END $$

DELIMITER ;

-- =====================================================
-- EJEMPLOS DE USO
-- =====================================================
-- SELECT fn_total_reservas(1);                      -- Esperado: 5 reservas
-- SELECT fn_horas_reservadas(1, 7, 2026);           -- Esperado: horas en julio 2026
-- SELECT fn_espacio_mas_reservado();                -- Esperado: ID del espacio más usado
-- SELECT fn_reservas_activas(1);                    -- Esperado: reservas pendientes/confirmadas
-- SELECT fn_duracion_promedio_reservas(10);         -- Esperado: promedio horas en Sala Beta

SELECT '✅ Funciones de reservas creadas correctamente (fn_6 a fn_10)' AS resultado;