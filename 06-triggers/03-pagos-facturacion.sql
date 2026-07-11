-- =====================================================
-- TRIGGERS: MÓDULO PAGOS Y FACTURACIÓN (tr_11 a tr_15)
-- =====================================================

USE coworking_db;
DELIMITER $$

-- =====================================================
-- TRIGGER 11: Crear factura automáticamente al registrar un pago
-- =====================================================
CREATE TRIGGER tr_crear_factura_al_pagar
AFTER INSERT ON pagos
FOR EACH ROW
BEGIN
    DECLARE v_subtotal DECIMAL(10,2);
    DECLARE v_impuestos DECIMAL(10,2);
    DECLARE v_numero VARCHAR(50);
    
    IF NEW.estado = 'Pagado' THEN
        SET v_subtotal = NEW.monto / 1.19;
        SET v_impuestos = NEW.monto - v_subtotal;
        SET v_numero = CONCAT('FAC-AUTO-', NEW.id, '-', UNIX_TIMESTAMP());
        
        INSERT INTO facturas (usuario_id, pago_id, numero_factura, fecha_emision, subtotal, impuestos, total, estado, saldo_pendiente)
        VALUES (NEW.usuario_id, NEW.id, v_numero, CURDATE(), v_subtotal, v_impuestos, NEW.monto, 'Pagada', 0.00);
    END IF;
END $$

-- =====================================================
-- TRIGGER 12: Actualizar factura a "Pagada" cuando se confirma el pago
-- =====================================================
CREATE TRIGGER tr_pagado_factura_al_confirmar_pago
AFTER UPDATE ON pagos
FOR EACH ROW
BEGIN
    IF NEW.estado = 'Pagado' AND OLD.estado != 'Pagado' THEN
        UPDATE facturas 
        SET estado = 'Pagada', saldo_pendiente = 0.00
        WHERE pago_id = NEW.id AND deleted_at IS NULL;
    END IF;
END $$

-- =====================================================
-- TRIGGER 13: Bloquear eliminación (soft delete) de pago si tiene factura
-- =====================================================
CREATE TRIGGER tr_bloquear_eliminacion_pago
BEFORE UPDATE ON pagos
FOR EACH ROW
BEGIN
    DECLARE v_facturas_asociadas INT;
    
    IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
        SELECT COUNT(*) INTO v_facturas_asociadas
        FROM facturas
        WHERE pago_id = NEW.id AND deleted_at IS NULL;
        
        IF v_facturas_asociadas > 0 THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'No se puede eliminar el pago: existe una factura asociada.';
        END IF;
    END IF;
END $$

-- =====================================================
-- TRIGGER 14: Actualizar saldo pendiente en pagos parciales
-- =====================================================
CREATE TRIGGER tr_actualizar_saldo_pendiente
AFTER INSERT ON facturas
FOR EACH ROW
BEGIN
    DECLARE v_pagado DECIMAL(10,2);
    
    -- Si la factura se creó con un pago asociado, calcular el saldo
    IF NEW.pago_id IS NOT NULL THEN
        SELECT IFNULL(SUM(monto), 0) INTO v_pagado
        FROM pagos 
        WHERE id = NEW.pago_id AND estado = 'Pagado';
        
        IF v_pagado < NEW.total THEN
            UPDATE facturas 
            SET estado = 'Parcial', saldo_pendiente = NEW.total - v_pagado
            WHERE id = NEW.id;
        END IF;
    END IF;
END $$

-- =====================================================
-- TRIGGER 15: Log automático de pagos anulados/cancelados
-- =====================================================
CREATE TRIGGER tr_log_pago_anulado
AFTER UPDATE ON pagos
FOR EACH ROW
BEGIN
    IF NEW.estado = 'Cancelado' AND OLD.estado != 'Cancelado' THEN
        INSERT INTO logs (usuario_id, tabla_afectada, registro_id, accion, descripcion, datos_anteriores, datos_nuevos)
        VALUES (
            NEW.usuario_id, 'pagos', NEW.id, 'UPDATE', 
            'Pago anulado/cancelado',
            JSON_OBJECT('estado_anterior', OLD.estado),
            JSON_OBJECT('estado_nuevo', NEW.estado)
        );
    END IF;
END $$

DELIMITER ;