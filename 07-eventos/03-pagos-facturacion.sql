-- =====================================================
-- EVENTOS: MÓDULO PAGOS Y FACTURACIÓN (ev_11 a ev_15)
-- =====================================================

USE coworking_db;
DELIMITER $$

-- =====================================================
-- EVENTO 11: Recordatorio de pago pendiente cada 3 días
-- =====================================================
CREATE EVENT IF NOT EXISTS ev_recordatorio_pago_pendiente
ON SCHEDULE EVERY 3 DAY
STARTS CURDATE() + INTERVAL 3 DAY
DO
BEGIN
    INSERT INTO logs (usuario_id, tabla_afectada, accion, descripcion)
    SELECT usuario_id, 'pagos', 'UPDATE', 'Sistema: Recordatorio de pago pendiente enviado'
    FROM pagos
    WHERE estado = 'Pendiente' AND deleted_at IS NULL;
END $$

-- =====================================================
-- EVENTO 12: Bloquear servicios si factura vencida > 10 días
-- =====================================================
CREATE EVENT IF NOT EXISTS ev_bloquear_servicios_factura_vencida
ON SCHEDULE EVERY 1 DAY
STARTS CURDATE() + INTERVAL 1 DAY
DO
BEGIN
    INSERT INTO logs (usuario_id, tabla_afectada, accion, descripcion)
    SELECT DISTINCT f.usuario_id, 'servicios', 'UPDATE', 'Sistema: Servicios bloqueados por factura vencida > 10 días'
    FROM facturas f
    WHERE f.estado IN ('Pendiente', 'Parcial')
      AND f.fecha_emision <= DATE_SUB(CURDATE(), INTERVAL 10 DAY)
      AND f.deleted_at IS NULL;
END $$

-- =====================================================
-- EVENTO 13: Resumen de facturación mensual (último día del mes)
-- =====================================================
CREATE EVENT IF NOT EXISTS ev_resumen_facturacion_mensual
ON SCHEDULE EVERY 1 MONTH
STARTS LAST_DAY(CURDATE()) + INTERVAL 1 DAY
DO
BEGIN
    DECLARE v_total_mes DECIMAL(10,2);
    
    SELECT IFNULL(SUM(monto), 0) INTO v_total_mes
    FROM pagos 
    WHERE estado = 'Pagado' 
      AND MONTH(fecha_pago) = MONTH(CURDATE()) 
      AND YEAR(fecha_pago) = YEAR(CURDATE())
      AND deleted_at IS NULL;
      
    INSERT INTO logs (tabla_afectada, accion, descripcion)
    VALUES ('facturas', 'SELECT', CONCAT('Sistema: Resumen facturación mes actual - Total recaudado: $', v_total_mes));
END $$

-- =====================================================
-- EVENTO 14: Aplicar recargos a facturas vencidas > 15 días (10% de recargo)
-- =====================================================
CREATE EVENT IF NOT EXISTS ev_aplicar_recargos_facturas
ON SCHEDULE EVERY 1 DAY
STARTS CURDATE() + INTERVAL 1 DAY
DO
BEGIN
    UPDATE facturas
    SET total = total + (total * 0.10),
        saldo_pendiente = saldo_pendiente + (saldo_pendiente * 0.10)
    WHERE estado IN ('Pendiente', 'Parcial')
      AND fecha_emision <= DATE_SUB(CURDATE(), INTERVAL 15 DAY)
      AND deleted_at IS NULL;
      
    INSERT INTO logs (tabla_afectada, accion, descripcion)
    VALUES ('facturas', 'UPDATE', CONCAT('Sistema: Recargo del 10% aplicado a facturas vencidas. Total afectadas: ', ROW_COUNT()));
END $$

-- =====================================================
-- EVENTO 15: Reporte de ingresos acumulados al contador (fin de mes)
-- =====================================================
CREATE EVENT IF NOT EXISTS ev_reporte_ingresos_contador
ON SCHEDULE EVERY 1 MONTH
STARTS LAST_DAY(CURDATE()) + INTERVAL 1 DAY
DO
BEGIN
    DECLARE v_acumulado_anio DECIMAL(10,2);
    
    SELECT IFNULL(SUM(monto), 0) INTO v_acumulado_anio
    FROM pagos 
    WHERE estado = 'Pagado' 
      AND YEAR(fecha_pago) = YEAR(CURDATE())
      AND deleted_at IS NULL;
      
    INSERT INTO logs (tabla_afectada, accion, descripcion)
    VALUES ('pagos', 'SELECT', CONCAT('Sistema: Reporte para contador - Ingresos acumulados año ', YEAR(CURDATE()), ': $', v_acumulado_anio));
END $$

DELIMITER ;