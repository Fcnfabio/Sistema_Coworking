-- =====================================================
-- TRIGGERS: MÓDULO ACCESOS Y ASISTENCIAS (tr_16 a tr_20)
-- =====================================================

USE coworking_db;
DELIMITER $$

-- =====================================================
-- TRIGGER 16: Log de asistencia aprobada
-- =====================================================
CREATE TRIGGER tr_log_asistencia_aprobada
AFTER INSERT ON accesos
FOR EACH ROW
BEGIN
    IF NEW.estado = 'Aprobado' AND NEW.tipo_acceso = 'Entrada' THEN
        INSERT INTO logs (usuario_id, tabla_afectada, registro_id, accion, descripcion)
        VALUES (NEW.usuario_id, 'accesos', NEW.id, 'INSERT', 'Asistencia registrada exitosamente');
    END IF;
END $$

-- =====================================================
-- TRIGGER 17: Bloquear acceso si no hay membresía activa ni reserva
-- =====================================================
CREATE TRIGGER tr_validar_acceso_membresia
BEFORE INSERT ON accesos
FOR EACH ROW
BEGIN
    DECLARE v_membresia_activa INT;
    DECLARE v_reserva_hoy INT;
    
    IF NEW.tipo_acceso = 'Entrada' THEN
        SELECT COUNT(*) INTO v_membresia_activa
        FROM membresias 
        WHERE usuario_id = NEW.usuario_id AND estado = 'Activa' AND deleted_at IS NULL;
        
        SELECT COUNT(*) INTO v_reserva_hoy
        FROM reservas 
        WHERE usuario_id = NEW.usuario_id 
          AND fecha_reserva = CURDATE() 
          AND estado IN ('Confirmada', 'Pendiente') 
          AND deleted_at IS NULL;
          
        IF v_membresia_activa = 0 AND v_reserva_hoy = 0 THEN
            SET NEW.estado = 'Rechazado';
            SET NEW.motivo_rechazo = 'Acceso denegado: Sin membresía activa ni reserva para hoy.';
        END IF;
    END IF;
END $$

-- =====================================================
-- TRIGGER 18: Actualizar última fecha de acceso (Log de auditoría)
-- =====================================================
CREATE TRIGGER tr_actualizar_ultima_asistencia
AFTER INSERT ON accesos
FOR EACH ROW
BEGIN
    IF NEW.estado = 'Aprobado' AND NEW.tipo_acceso = 'Entrada' THEN
        -- Como la tabla usuarios no tiene el campo 'ultima_asistencia', 
        -- lo registramos en la tabla logs para auditoría.
        INSERT INTO logs (usuario_id, tabla_afectada, accion, descripcion)
        VALUES (NEW.usuario_id, 'usuarios', 'UPDATE', 
                CONCAT('Última fecha de acceso actualizada a: ', NEW.fecha_hora));
    END IF;
END $$

-- =====================================================
-- TRIGGER 19: Registrar salida automática si re-ingresa sin salir
-- =====================================================
CREATE TRIGGER tr_salida_automatica_reingreso
BEFORE INSERT ON accesos
FOR EACH ROW
BEGIN
    DECLARE v_ultimo_tipo VARCHAR(20);
    
    IF NEW.tipo_acceso = 'Entrada' THEN
        SELECT tipo_acceso INTO v_ultimo_tipo
        FROM accesos
        WHERE usuario_id = NEW.usuario_id
        ORDER BY fecha_hora DESC LIMIT 1;
        
        -- Si el último registro fue una Entrada, forzamos una Salida
        IF v_ultimo_tipo = 'Entrada' THEN
            SET NEW.tipo_acceso = 'Salida';
            SET NEW.motivo_rechazo = 'Salida automática forzada por re-ingreso sin registro de salida previo.';
        END IF;
    END IF;
END $$

-- =====================================================
-- TRIGGER 20: Log de intentos de acceso rechazados
-- =====================================================
CREATE TRIGGER tr_log_acceso_rechazado
AFTER INSERT ON accesos
FOR EACH ROW
BEGIN
    IF NEW.estado = 'Rechazado' THEN
        INSERT INTO logs (usuario_id, tabla_afectada, registro_id, accion, descripcion, datos_nuevos)
        VALUES (
            NEW.usuario_id, 'accesos', NEW.id, 'INSERT', 
            CONCAT('Intento de acceso rechazado. Motivo: ', IFNULL(NEW.motivo_rechazo, 'Desconocido')),
            JSON_OBJECT('metodo', NEW.metodo_acceso, 'motivo', NEW.motivo_rechazo)
        );
    END IF;
END $$

DELIMITER ;