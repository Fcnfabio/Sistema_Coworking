-- =====================================================
-- PROCEDIMIENTOS ALMACENADOS: PAGOS Y FACTURACIÓN (sp_10 a sp_13)
-- =====================================================

USE coworking_db;
DELIMITER $$

-- =====================================================
-- SP 10: Generar factura por membresía
-- =====================================================
CREATE PROCEDURE sp_generar_factura_membresia(
    IN p_usuario_id INT,
    IN p_pago_id INT
)
BEGIN
    DECLARE v_monto DECIMAL(10,2);
    DECLARE v_subtotal DECIMAL(10,2);
    DECLARE v_impuestos DECIMAL(10,2);
    DECLARE v_total DECIMAL(10,2);
    DECLARE v_numero_factura VARCHAR(50);
    
    SELECT monto INTO v_monto FROM pagos WHERE id = p_pago_id;
    
    SET v_subtotal = v_monto / 1.19;
    SET v_impuestos = v_monto - v_subtotal;
    SET v_total = v_monto;
    SET v_numero_factura = CONCAT('FAC-', DATE_FORMAT(CURDATE(), '%Y'), '-', LPAD(FLOOR(RAND() * 9000) + 1000, 4, '0'));
    
    INSERT INTO facturas (usuario_id, pago_id, numero_factura, fecha_emision, subtotal, impuestos, total, estado, saldo_pendiente)
    VALUES (p_usuario_id, p_pago_id, v_numero_factura, CURDATE(), v_subtotal, v_impuestos, v_total, 'Pagada', 0.00);
    
    SELECT v_numero_factura AS factura_generada;
END $$

-- =====================================================
-- SP 11: Generar factura consolidada para empresa
-- =====================================================
CREATE PROCEDURE sp_generar_factura_consolidada_empresa(
    IN p_empresa_id INT,
    IN p_mes INT,
    IN p_anio INT
)
BEGIN
    DECLARE v_total_empresa DECIMAL(10,2);
    DECLARE v_usuario_admin INT;
    DECLARE v_numero_factura VARCHAR(50);
    
    -- Obtener el primer usuario de la empresa para cumplir con la FK (en un diseño real, facturas tendría empresa_id)
    SELECT MIN(id) INTO v_usuario_admin FROM usuarios WHERE empresa_id = p_empresa_id AND deleted_at IS NULL;
    
    SELECT IFNULL(SUM(f.total), 0) INTO v_total_empresa
    FROM facturas f
    JOIN usuarios u ON f.usuario_id = u.id
    WHERE u.empresa_id = p_empresa_id 
      AND MONTH(f.fecha_emision) = p_mes 
      AND YEAR(f.fecha_emision) = p_anio
      AND f.deleted_at IS NULL;
      
    SET v_numero_factura = CONCAT('FAC-EMP-', p_empresa_id, '-', p_anio, p_mes);
    
    INSERT INTO facturas (usuario_id, numero_factura, fecha_emision, subtotal, impuestos, total, estado, saldo_pendiente)
    VALUES (v_usuario_admin, v_numero_factura, CURDATE(), v_total_empresa/1.19, v_total_empresa - (v_total_empresa/1.19), v_total_empresa, 'Pendiente', v_total_empresa);
    
    SELECT v_numero_factura AS factura_consolidada, v_total_empresa AS total;
END $$

-- =====================================================
-- SP 12: Aplicar recargos a facturas vencidas
-- =====================================================
CREATE PROCEDURE sp_aplicar_recargos_facturas_vencidas(
    IN p_dias_vencimiento INT,
    IN p_porcentaje_recargo DECIMAL(5,2)
)
BEGIN
    UPDATE facturas
    SET total = total + (total * (p_porcentaje_recargo / 100)),
        saldo_pendiente = saldo_pendiente + (saldo_pendiente * (p_porcentaje_recargo / 100))
    WHERE estado IN ('Pendiente', 'Parcial')
      AND fecha_emision <= DATE_SUB(CURDATE(), INTERVAL p_dias_vencimiento DAY)
      AND deleted_at IS NULL;
      
    SELECT ROW_COUNT() AS facturas_con_recargo_aplicado;
END $$

-- =====================================================
-- SP 13: Bloquear servicios adicionales por falta de pago
-- =====================================================
CREATE PROCEDURE sp_bloquear_servicios_por_falta_pago(
    IN p_usuario_id INT,
    OUT p_bloqueado INT
)
BEGIN
    DECLARE v_facturas_pendientes INT;
    
    SELECT COUNT(*) INTO v_facturas_pendientes
    FROM facturas
    WHERE usuario_id = p_usuario_id 
      AND estado IN ('Pendiente', 'Parcial') 
      AND deleted_at IS NULL;
      
    IF v_facturas_pendientes > 0 THEN
        SET p_bloqueado = 1;
        INSERT INTO logs (usuario_id, tabla_afectada, accion, descripcion)
        VALUES (p_usuario_id, 'servicios', 'UPDATE', 'Servicios bloqueados por facturas pendientes');
    ELSE
        SET p_bloqueado = 0;
    END IF;
    
    SELECT p_bloqueado AS estado_bloqueo;
END $$

DELIMITER ;