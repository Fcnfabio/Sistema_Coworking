-- =====================================================
-- FUNCIONES SQL: MÓDULO MEMBRESÍAS (fn_1 a fn_5)
-- Proyecto: Sistema de Gestión de Coworking
-- Descripción: Funciones escalares para consultar
--              información de membresías de usuarios.
-- =====================================================

USE coworking_db;

DELIMITER $$

-- =====================================================
-- FUNCIÓN 1: fn_membresia_activa
-- Devuelve TRUE (1) si el usuario tiene membresía activa.
-- Parámetro: p_usuario_id (INT)
-- Retorna: TINYINT(1) - 1 si está activa, 0 si no
-- =====================================================
CREATE FUNCTION fn_membresia_activa(p_usuario_id INT)
RETURNS TINYINT(1)
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    DECLARE v_activa TINYINT(1);
    
    SELECT IF(COUNT(*) > 0, 1, 0) INTO v_activa
    FROM membresias
    WHERE usuario_id = p_usuario_id 
      AND estado = 'Activa' 
      AND deleted_at IS NULL;
    
    RETURN v_activa;
END $$

-- =====================================================
-- FUNCIÓN 2: fn_dias_restantes_membresia
-- Calcula los días restantes de vigencia de la membresía.
-- Parámetro: p_usuario_id (INT)
-- Retorna: INT - Días restantes (0 o negativo si venció)
-- =====================================================
CREATE FUNCTION fn_dias_restantes_membresia(p_usuario_id INT)
RETURNS INT
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    DECLARE v_dias INT;
    
    SELECT IFNULL(DATEDIFF(fecha_fin, CURDATE()), 0) INTO v_dias
    FROM membresias
    WHERE usuario_id = p_usuario_id 
      AND estado = 'Activa' 
      AND deleted_at IS NULL
    ORDER BY fecha_fin DESC 
    LIMIT 1;
    
    RETURN IFNULL(v_dias, 0);
END $$

-- =====================================================
-- FUNCIÓN 3: fn_tipo_membresia
-- Retorna el nombre del tipo actual de membresía.
-- Parámetro: p_usuario_id (INT)
-- Retorna: VARCHAR(50) - Nombre del tipo o 'Sin membresía'
-- =====================================================
CREATE FUNCTION fn_tipo_membresia(p_usuario_id INT)
RETURNS VARCHAR(50)
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    DECLARE v_tipo VARCHAR(50);
    
    SELECT tm.nombre INTO v_tipo
    FROM membresias m
    JOIN tipos_membresia tm ON m.tipo_membresia_id = tm.id
    WHERE m.usuario_id = p_usuario_id 
      AND m.deleted_at IS NULL
    ORDER BY m.fecha_inicio DESC 
    LIMIT 1;
    
    RETURN IFNULL(v_tipo, 'Sin membresía');
END $$

-- =====================================================
-- FUNCIÓN 4: fn_renovaciones_membresia
-- Cuenta el número total de veces que el usuario renovó.
-- Parámetro: p_usuario_id (INT)
-- Retorna: INT - Número de renovaciones
-- =====================================================
CREATE FUNCTION fn_renovaciones_membresia(p_usuario_id INT)
RETURNS INT
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    DECLARE v_renovaciones INT;
    
    SELECT IFNULL(SUM(numero_renovaciones), 0) INTO v_renovaciones
    FROM membresias
    WHERE usuario_id = p_usuario_id 
      AND deleted_at IS NULL;
    
    RETURN v_renovaciones;
END $$

-- =====================================================
-- FUNCIÓN 5: fn_estado_membresia
-- Devuelve el estado actual de la membresía del usuario.
-- Parámetro: p_usuario_id (INT)
-- Retorna: VARCHAR(20) - 'Activa', 'Suspendida', 'Vencida' o 'Ninguno'
-- =====================================================
CREATE FUNCTION fn_estado_membresia(p_usuario_id INT)
RETURNS VARCHAR(20)
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    DECLARE v_estado VARCHAR(20);
    
    SELECT estado INTO v_estado
    FROM membresias
    WHERE usuario_id = p_usuario_id 
      AND deleted_at IS NULL
    ORDER BY fecha_inicio DESC 
    LIMIT 1;
    
    RETURN IFNULL(v_estado, 'Ninguno');
END $$

DELIMITER ;

-- =====================================================
-- EJEMPLOS DE USO
-- =====================================================
-- SELECT fn_membresia_activa(1);                    -- Esperado: 1 (TRUE)
-- SELECT fn_dias_restantes_membresia(1);            -- Esperado: días hasta 15-jul-2026
-- SELECT fn_tipo_membresia(5);                      -- Esperado: 'Premium'
-- SELECT fn_renovaciones_membresia(5);              -- Esperado: 8
-- SELECT fn_estado_membresia(11);                   -- Esperado: 'Suspendida'

SELECT '✅ Funciones de membresías creadas correctamente (fn_1 a fn_5)' AS resultado;