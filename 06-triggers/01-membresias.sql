-- =====================================================
-- TRIGGERS: MÓDULO MEMBRESÍAS (tr_1 a tr_5)
-- Proyecto: Sistema de Gestión de Coworking
-- =====================================================

USE coworking_db;
DELIMITER $$

-- =====================================================
-- TRIGGER 1: Calcular fecha de vencimiento automáticamente
-- =====================================================
CREATE TRIGGER tr_calcular_fecha_vencimiento
BEFORE INSERT ON membresias
FOR EACH ROW
BEGIN
    DECLARE v_duracion INT;
    
    -- Si no se proporciona fecha_fin, calcularla basada en el tipo de membresía
    IF NEW.fecha_fin IS NULL THEN
        SELECT duracion_dias INTO v_duracion 
        FROM tipos_membresia WHERE id = NEW.tipo_membresia_id;
        
        SET NEW.fecha_fin = DATE_ADD(NEW.fecha_inicio, INTERVAL v_duracion DAY);
    END IF;
END $$

-- =====================================================
-- TRIGGER 2: Activar membresía al registrar un pago exitoso
-- =====================================================
CREATE TRIGGER tr_activar_membresia_al_pagar
AFTER INSERT ON pagos
FOR EACH ROW
BEGIN
    IF NEW.concepto = 'Membresia' AND NEW.estado = 'Pagado' THEN
        UPDATE membresias 
        SET estado = 'Activa',
            fecha_fin = DATE_ADD(CURDATE(), INTERVAL (SELECT duracion_dias FROM tipos_membresia WHERE id = tipo_membresia_id) DAY)
        WHERE usuario_id = NEW.usuario_id 
          AND deleted_at IS NULL
        ORDER BY fecha_inicio DESC LIMIT 1;
    END IF;
END $$

-- =====================================================
-- TRIGGER 3: Suspender membresía si hay facturas vencidas
-- =====================================================
CREATE TRIGGER tr_suspender_por_facturas_vencidas
BEFORE UPDATE ON membresias
FOR EACH ROW
BEGIN
    DECLARE v_facturas_vencidas INT;
    
    -- Si se intenta activar una membresía, verificar si tiene facturas vencidas
    IF NEW.estado = 'Activa' AND OLD.estado != 'Activa' THEN
        SELECT COUNT(*) INTO v_facturas_vencidas
        FROM facturas
        WHERE usuario_id = NEW.usuario_id 
          AND estado IN ('Pendiente', 'Parcial')
          AND fecha_emision < DATE_SUB(CURDATE(), INTERVAL 15 DAY)
          AND deleted_at IS NULL;
          
        IF v_facturas_vencidas > 0 THEN
            SET NEW.estado = 'Suspendida';
        END IF;
    END IF;
END $$

-- =====================================================
-- TRIGGER 4: Log al cambiar el tipo de membresía
-- =====================================================
CREATE TRIGGER tr_log_cambio_tipo_membresia
AFTER UPDATE ON membresias
FOR EACH ROW
BEGIN
    IF OLD.tipo_membresia_id != NEW.tipo_membresia_id THEN
        INSERT INTO logs (usuario_id, tabla_afectada, registro_id, accion, descripcion, datos_anteriores, datos_nuevos)
        VALUES (
            NEW.usuario_id, 'membresias', NEW.id, 'UPDATE', 
            'Cambio de tipo de membresía',
            JSON_OBJECT('tipo_anterior', OLD.tipo_membresia_id),
            JSON_OBJECT('tipo_nuevo', NEW.tipo_membresia_id)
        );
        
        INSERT INTO historial_membresias (usuario_id, tipo_membresia_anterior_id, tipo_membresia_nueva_id, motivo)
        VALUES (NEW.usuario_id, OLD.tipo_membresia_id, NEW.tipo_membresia_id, 'Cambio de plan automático');
    END IF;
END $$

-- =====================================================
-- TRIGGER 5: Bloquear eliminación (soft delete) si hay reservas activas
-- =====================================================
CREATE TRIGGER tr_bloquear_eliminacion_membresia
BEFORE UPDATE ON membresias
FOR EACH ROW
BEGIN
    DECLARE v_reservas_activas INT;
    
    -- Detectar soft delete
    IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
        SELECT COUNT(*) INTO v_reservas_activas
        FROM reservas
        WHERE usuario_id = NEW.usuario_id 
          AND estado IN ('Pendiente', 'Confirmada')
          AND fecha_reserva >= CURDATE()
          AND deleted_at IS NULL;
          
        IF v_reservas_activas > 0 THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'No se puede eliminar la membresía: el usuario tiene reservas futuras activas.';
        END IF;
    END IF;
END $$

DELIMITER ;