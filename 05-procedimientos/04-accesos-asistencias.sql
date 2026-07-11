-- =====================================================
-- PROCEDIMIENTOS ALMACENADOS: ACCESOS Y ASISTENCIAS (sp_14 a sp_17)
-- =====================================================

USE coworking_db;
DELIMITER $$

-- =====================================================
-- SP 14: Registrar acceso de usuario (entrada)
-- =====================================================
CREATE PROCEDURE sp_registrar_acceso_entrada(
    IN p_usuario_id INT,
    IN p_metodo_acceso ENUM('RFID', 'QR', 'Manual')
)
BEGIN
    DECLARE v_membresia_activa INT;
    DECLARE v_reserva_hoy INT;
    DECLARE v_estado ENUM('Aprobado', 'Rechazado');
    DECLARE v_motivo VARCHAR(255);
    
    SELECT COUNT(*) INTO v_membresia_activa FROM membresias WHERE usuario_id = p_usuario_id AND estado = 'Activa' AND deleted_at IS NULL;
    SELECT COUNT(*) INTO v_reserva_hoy FROM reservas WHERE usuario_id = p_usuario_id AND fecha_reserva = CURDATE() AND estado IN ('Confirmada', 'Pendiente') AND deleted_at IS NULL;
    
    IF v_membresia_activa > 0 OR v_reserva_hoy > 0 THEN
        SET v_estado = 'Aprobado';
        SET v_motivo = NULL;
    ELSE
        SET v_estado = 'Rechazado';
        SET v_motivo = 'Sin membresía activa ni reserva para hoy';
    END IF;
    
    INSERT INTO accesos (usuario_id, tipo_acceso, fecha_hora, metodo_acceso, estado, motivo_rechazo)
    VALUES (p_usuario_id, 'Entrada', NOW(), p_metodo_acceso, v_estado, v_motivo);
    
    SELECT v_estado AS resultado_acceso;
END $$

-- =====================================================
-- SP 15: Registrar salida de usuario
-- =====================================================
CREATE PROCEDURE sp_registrar_acceso_salida(
    IN p_usuario_id INT,
    IN p_metodo_acceso ENUM('RFID', 'QR', 'Manual')
)
BEGIN
    DECLARE v_ultima_entrada INT;
    
    SELECT COUNT(*) INTO v_ultima_entrada 
    FROM accesos 
    WHERE usuario_id = p_usuario_id 
      AND tipo_acceso = 'Entrada' 
      AND estado = 'Aprobado'
      AND fecha_hora = (SELECT MAX(fecha_hora) FROM accesos WHERE usuario_id = p_usuario_id);
      
    IF v_ultima_entrada > 0 THEN
        INSERT INTO accesos (usuario_id, tipo_acceso, fecha_hora, metodo_acceso, estado)
        VALUES (p_usuario_id, 'Salida', NOW(), p_metodo_acceso, 'Aprobado');
        SELECT 'Salida registrada' AS resultado;
    ELSE
        INSERT INTO accesos (usuario_id, tipo_acceso, fecha_hora, metodo_acceso, estado, motivo_rechazo)
        VALUES (p_usuario_id, 'Salida', NOW(), p_metodo_acceso, 'Rechazado', 'No se registró entrada previa');
        SELECT 'Salida rechazada: sin entrada previa' AS resultado;
    END IF;
END $$

-- =====================================================
-- SP 16: Generar reporte diario de asistencias
-- =====================================================
CREATE PROCEDURE sp_reporte_diario_asistencias(
    IN p_fecha DATE
)
BEGIN
    SELECT 
        COUNT(CASE WHEN tipo_acceso = 'Entrada' AND estado = 'Aprobado' THEN 1 END) AS total_ingresos,
        COUNT(DISTINCT CASE WHEN tipo_acceso = 'Entrada' AND estado = 'Aprobado' THEN usuario_id END) AS usuarios_unicos,
        TIME(MIN(CASE WHEN tipo_acceso = 'Entrada' AND estado = 'Aprobado' THEN fecha_hora END)) AS primera_entrada,
        TIME(MAX(CASE WHEN tipo_acceso = 'Salida' AND estado = 'Aprobado' THEN fecha_hora END)) AS ultima_salida
    FROM accesos
    WHERE DATE(fecha_hora) = p_fecha;
END $$

-- =====================================================
-- SP 17: Marcar reservas como “No Show” y generar penalización
-- =====================================================
CREATE PROCEDURE sp_marcar_no_show_y_penalizar(
    IN p_reserva_id INT
)
BEGIN
    DECLARE v_usuario_id INT;
    DECLARE v_precio_total DECIMAL(10,2);
    DECLARE v_penalizacion DECIMAL(10,2);
    
    SELECT usuario_id, precio_total INTO v_usuario_id, v_precio_total
    FROM reservas WHERE id = p_reserva_id;
    
    SET v_penalizacion = v_precio_total * 0.50; -- 50% de penalización
    
    UPDATE reservas SET estado = 'No Show', motivo = 'No Show - Penalización aplicada' WHERE id = p_reserva_id;
    
    INSERT INTO pagos (usuario_id, monto, metodo_pago, estado, concepto, referencia_transaccion)
    VALUES (v_usuario_id, v_penalizacion, 'Tarjeta', 'Pendiente', 'Reserva', CONCAT('PEN-', p_reserva_id));
    
    SELECT 'No Show registrado y penalización generada' AS resultado;
END $$

DELIMITER ;