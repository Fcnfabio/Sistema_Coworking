-- =====================================================
-- PROCEDIMIENTOS ALMACENADOS: MÓDULO MEMBRESÍAS (sp_1 a sp_4)
-- Proyecto: Sistema de Gestión de Coworking
-- =====================================================

USE coworking_db;
DELIMITER $$

-- =====================================================
-- SP 1: Registrar nueva membresía y asignarla a un usuario
-- =====================================================
CREATE PROCEDURE sp_registrar_membresia(
    IN p_usuario_id INT,
    IN p_tipo_membresia_id INT,
    IN p_precio_pagado DECIMAL(10,2)
)
BEGIN
    DECLARE v_duracion INT;
    DECLARE v_fecha_inicio DATE;
    DECLARE v_fecha_fin DATE;
    
    -- Obtener duración del tipo de membresía
    SELECT duracion_dias INTO v_duracion 
    FROM tipos_membresia 
    WHERE id = p_tipo_membresia_id;
    
    IF v_duracion IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tipo de membresía no encontrado';
    END IF;
    
    SET v_fecha_inicio = CURDATE();
    SET v_fecha_fin = DATE_ADD(v_fecha_inicio, INTERVAL v_duracion DAY);
    
    -- Iniciar transacción
    START TRANSACTION;
    
    -- Insertar membresía
    INSERT INTO membresias (usuario_id, tipo_membresia_id, fecha_inicio, fecha_fin, estado, precio_pagado, numero_renovaciones)
    VALUES (p_usuario_id, p_tipo_membresia_id, v_fecha_inicio, v_fecha_fin, 'Activa', p_precio_pagado, 0);
    
    -- Registrar en historial
    INSERT INTO historial_membresias (usuario_id, tipo_membresia_anterior_id, tipo_membresia_nueva_id, motivo)
    VALUES (p_usuario_id, NULL, p_tipo_membresia_id, 'Nueva membresía registrada');
    
    COMMIT;
    SELECT 'Membresía registrada exitosamente' AS resultado;
END $$

-- =====================================================
-- SP 2: Renovar una membresía existente
-- =====================================================
CREATE PROCEDURE sp_renovar_membresia(
    IN p_usuario_id INT
)
BEGIN
    DECLARE v_membresia_id INT;
    DECLARE v_tipo_id INT;
    DECLARE v_duracion INT;
    DECLARE v_nueva_fecha_fin DATE;
    DECLARE v_renovaciones_actuales INT;
    
    -- Obtener datos de la membresía actual
    SELECT id, tipo_membresia_id, fecha_fin, numero_renovaciones 
    INTO v_membresia_id, v_tipo_id, v_nueva_fecha_fin, v_renovaciones_actuales
    FROM membresias 
    WHERE usuario_id = p_usuario_id AND deleted_at IS NULL
    ORDER BY fecha_inicio DESC LIMIT 1;
    
    IF v_membresia_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario no tiene membresías registradas';
    END IF;
    
    SELECT duracion_dias INTO v_duracion FROM tipos_membresia WHERE id = v_tipo_id;
    SET v_nueva_fecha_fin = DATE_ADD(v_nueva_fecha_fin, INTERVAL v_duracion DAY);
    
    START TRANSACTION;
    
    UPDATE membresias 
    SET fecha_fin = v_nueva_fecha_fin, 
        numero_renovaciones = v_renovaciones_actuales + 1,
        estado = 'Activa'
    WHERE id = v_membresia_id;
    
    INSERT INTO historial_membresias (usuario_id, tipo_membresia_anterior_id, tipo_membresia_nueva_id, motivo)
    VALUES (p_usuario_id, v_tipo_id, v_tipo_id, 'Renovación de membresía');
    
    COMMIT;
    SELECT CONCAT('Membresía renovada. Nueva fecha fin: ', v_nueva_fecha_fin) AS resultado;
END $$

-- =====================================================
-- SP 3: Actualizar estado de membresías vencidas
-- =====================================================
CREATE PROCEDURE sp_actualizar_membresias_vencidas()
BEGIN
    UPDATE membresias 
    SET estado = 'Vencida' 
    WHERE estado = 'Activa' 
      AND fecha_fin < CURDATE() 
      AND deleted_at IS NULL;
      
    SELECT ROW_COUNT() AS membresias_vencidas_actualizadas;
END $$

-- =====================================================
-- SP 4: Suspender membresías con facturas impagas por más de X días
-- =====================================================
CREATE PROCEDURE sp_suspender_membresias_impagas(
    IN p_dias_atraso INT
)
BEGIN
    UPDATE membresias m
    JOIN usuarios u ON m.usuario_id = u.id
    JOIN facturas f ON u.id = f.usuario_id
    SET m.estado = 'Suspendida'
    WHERE m.estado = 'Activa' 
      AND f.estado IN ('Pendiente', 'Parcial')
      AND f.fecha_emision <= DATE_SUB(CURDATE(), INTERVAL p_dias_atraso DAY)
      AND m.deleted_at IS NULL AND f.deleted_at IS NULL;
      
    SELECT ROW_COUNT() AS membresias_suspendidas;
END $$

DELIMITER ;