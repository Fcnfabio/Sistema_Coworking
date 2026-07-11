-- =====================================================
-- TRIGGERS: MÓDULO RESERVAS (tr_6 a tr_10)
-- =====================================================

USE coworking_db;
DELIMITER $$

-- =====================================================
-- TRIGGER 6: Validar que no existan reservas duplicadas (solapamiento)
-- =====================================================
CREATE TRIGGER tr_validar_disponibilidad_reserva
BEFORE INSERT ON reservas
FOR EACH ROW
BEGIN
    DECLARE v_solapamientos INT;
    
    SELECT COUNT(*) INTO v_solapamientos
    FROM reservas
    WHERE espacio_id = NEW.espacio_id 
      AND fecha_reserva = NEW.fecha_reserva
      AND estado NOT IN ('Cancelada', 'No Show')
      AND deleted_at IS NULL
      AND (hora_inicio < NEW.hora_fin AND hora_fin > NEW.hora_inicio);
      
    IF v_solapamientos > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El espacio ya está reservado en el horario solicitado.';
    END IF;
END $$

-- =====================================================
-- TRIGGER 7: Asignar estado "Pendiente" por defecto al crear
-- =====================================================
CREATE TRIGGER tr_asignar_estado_pendiente
BEFORE INSERT ON reservas
FOR EACH ROW
BEGIN
    IF NEW.estado IS NULL THEN
        SET NEW.estado = 'Pendiente';
    END IF;
END $$

-- =====================================================
-- TRIGGER 8: Confirmar reserva automáticamente al pagarse
-- =====================================================
CREATE TRIGGER tr_confirmar_reserva_al_pagar
AFTER UPDATE ON pagos
FOR EACH ROW
BEGIN
    IF NEW.estado = 'Pagado' AND OLD.estado != 'Pagado' AND NEW.concepto = 'Reserva' THEN
        UPDATE reservas 
        SET estado = 'Confirmada'
        WHERE usuario_id = NEW.usuario_id 
          AND fecha_reserva >= CURDATE()
          AND estado = 'Pendiente'
          AND deleted_at IS NULL
        ORDER BY created_at DESC LIMIT 1;
    END IF;
END $$

-- =====================================================
-- TRIGGER 9: Cancelar reservas futuras si la membresía se suspende/vence
-- =====================================================
CREATE TRIGGER tr_cancelar_reservas_al_suspender
AFTER UPDATE ON membresias
FOR EACH ROW
BEGIN
    IF NEW.estado IN ('Suspendida', 'Vencida') AND OLD.estado = 'Activa' THEN
        UPDATE reservas 
        SET estado = 'Cancelada', motivo = 'Cancelada por suspensión/vencimiento de membresía'
        WHERE usuario_id = NEW.usuario_id 
          AND fecha_reserva > CURDATE() 
          AND estado IN ('Pendiente', 'Confirmada')
          AND deleted_at IS NULL;
    END IF;
END $$

-- =====================================================
-- TRIGGER 10: Log automático al cancelar una reserva
-- =====================================================
CREATE TRIGGER tr_log_cancelacion_reserva
AFTER UPDATE ON reservas
FOR EACH ROW
BEGIN
    IF NEW.estado = 'Cancelada' AND OLD.estado != 'Cancelada' THEN
        INSERT INTO logs (usuario_id, tabla_afectada, registro_id, accion, descripcion, datos_anteriores, datos_nuevos)
        VALUES (
            NEW.usuario_id, 'reservas', NEW.id, 'UPDATE', 
            CONCAT('Reserva cancelada. Motivo: ', IFNULL(NEW.motivo, 'No especificado')),
            JSON_OBJECT('estado_anterior', OLD.estado),
            JSON_OBJECT('estado_nuevo', NEW.estado, 'motivo', NEW.motivo)
        );
    END IF;
END $$

DELIMITER ;