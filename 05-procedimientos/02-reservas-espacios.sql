-- =====================================================
-- PROCEDIMIENTOS ALMACENADOS: RESERVAS Y ESPACIOS (sp_5 a sp_9)
-- =====================================================

USE coworking_db;
DELIMITER $$

-- =====================================================
-- SP 5: Verificar disponibilidad de un espacio
-- =====================================================
CREATE PROCEDURE sp_verificar_disponibilidad(
    IN p_espacio_id INT,
    IN p_fecha DATE,
    IN p_hora_inicio TIME,
    IN p_hora_fin TIME,
    OUT p_disponible BOOLEAN
)
BEGIN
    DECLARE v_solapamientos INT;
    
    SELECT COUNT(*) INTO v_solapamientos
    FROM reservas
    WHERE espacio_id = p_espacio_id 
      AND fecha_reserva = p_fecha
      AND estado NOT IN ('Cancelada', 'No Show')
      AND deleted_at IS NULL
      AND (hora_inicio < p_hora_fin AND hora_fin > p_hora_inicio);
      
    SET p_disponible = (v_solapamientos = 0);
END $$

-- =====================================================
-- SP 6: Crear una nueva reserva de espacio
-- =====================================================
CREATE PROCEDURE sp_crear_reserva(
    IN p_usuario_id INT,
    IN p_espacio_id INT,
    IN p_fecha DATE,
    IN p_hora_inicio TIME,
    IN p_hora_fin TIME,
    IN p_numero_personas INT,
    IN p_motivo VARCHAR(255),
    IN p_precio_total DECIMAL(10,2)
)
BEGIN
    DECLARE v_disponible BOOLEAN;
    
    CALL sp_verificar_disponibilidad(p_espacio_id, p_fecha, p_hora_inicio, p_hora_fin, v_disponible);
    
    IF NOT v_disponible THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El espacio no está disponible en el horario solicitado';
    END IF;
    
    INSERT INTO reservas (usuario_id, espacio_id, fecha_reserva, hora_inicio, hora_fin, estado, numero_personas, motivo, precio_total)
    VALUES (p_usuario_id, p_espacio_id, p_fecha, p_hora_inicio, p_hora_fin, 'Pendiente', p_numero_personas, p_motivo, p_precio_total);
    
    SELECT LAST_INSERT_ID() AS nueva_reserva_id;
END $$

-- =====================================================
-- SP 7: Confirmar reserva con pago
-- =====================================================
CREATE PROCEDURE sp_confirmar_reserva_con_pago(
    IN p_reserva_id INT,
    IN p_pago_id INT
)
BEGIN
    UPDATE reservas 
    SET estado = 'Confirmada' 
    WHERE id = p_reserva_id AND deleted_at IS NULL;
    
    SELECT 'Reserva confirmada exitosamente' AS resultado;
END $$

-- =====================================================
-- SP 8: Cancelar reserva con opción de reembolso parcial
-- =====================================================
CREATE PROCEDURE sp_cancelar_reserva(
    IN p_reserva_id INT,
    IN p_motivo VARCHAR(255),
    IN p_reembolsar BOOLEAN
)
BEGIN
    DECLARE v_usuario_id INT;
    DECLARE v_precio DECIMAL(10,2);
    
    SELECT usuario_id, precio_total INTO v_usuario_id, v_precio
    FROM reservas WHERE id = p_reserva_id;
    
    UPDATE reservas 
    SET estado = 'Cancelada', motivo = p_motivo 
    WHERE id = p_reserva_id;
    
    IF p_reembolsar THEN
        INSERT INTO pagos (usuario_id, monto, metodo_pago, estado, concepto, referencia_transaccion)
        VALUES (v_usuario_id, v_precio, 'Transferencia', 'Reembolsado', 'Reserva', CONCAT('REB-', p_reserva_id));
    END IF;
    
    SELECT 'Reserva cancelada' AS resultado;
END $$

-- =====================================================
-- SP 9: Liberar reservas no confirmadas después de X horas
-- =====================================================
CREATE PROCEDURE sp_liberar_reservas_pendientes(
    IN p_horas INT
)
BEGIN
    UPDATE reservas 
    SET estado = 'Cancelada', motivo = 'Liberada automáticamente por inactividad'
    WHERE estado = 'Pendiente' 
      AND created_at < DATE_SUB(NOW(), INTERVAL p_horas HOUR)
      AND deleted_at IS NULL;
      
    SELECT ROW_COUNT() AS reservas_liberadas;
END $$

DELIMITER ;