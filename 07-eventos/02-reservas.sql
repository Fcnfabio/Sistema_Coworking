-- =====================================================
-- EVENTOS: MÓDULO RESERVAS (ev_6 a ev_10)
-- =====================================================

USE coworking_db;
DELIMITER $$

-- =====================================================
-- EVENTO 6: Cancelar reservas no confirmadas después de 2 horas
-- =====================================================
CREATE EVENT IF NOT EXISTS ev_cancelar_reservas_pendientes
ON SCHEDULE EVERY 1 HOUR
DO
BEGIN
    UPDATE reservas 
    SET estado = 'Cancelada', motivo = 'Cancelada automáticamente por inactividad (2 horas)'
    WHERE estado = 'Pendiente' 
      AND created_at < DATE_SUB(NOW(), INTERVAL 2 HOUR)
      AND deleted_at IS NULL;
END $$

-- =====================================================
-- EVENTO 7: Recordatorio 1 hora antes de la reserva
-- =====================================================
CREATE EVENT IF NOT EXISTS ev_recordatorio_reserva_1_hora
ON SCHEDULE EVERY 1 HOUR
DO
BEGIN
    INSERT INTO logs (usuario_id, tabla_afectada, accion, descripcion)
    SELECT usuario_id, 'reservas', 'UPDATE', 'Sistema: Recordatorio enviado - Tu reserva inicia en 1 hora'
    FROM reservas
    WHERE estado IN ('Confirmada', 'Pendiente')
      AND fecha_reserva = CURDATE()
      AND hora_inicio = DATE_FORMAT(DATE_ADD(NOW(), INTERVAL 1 HOUR), '%H:%i:00')
      AND deleted_at IS NULL;
END $$

-- =====================================================
-- EVENTO 8: Eliminar (soft delete) reservas pasadas no asistidas después de 7 días
-- =====================================================
CREATE EVENT IF NOT EXISTS ev_eliminar_reservas_pasadas
ON SCHEDULE EVERY 1 DAY
STARTS CURDATE() + INTERVAL 1 DAY
DO
BEGIN
    UPDATE reservas 
    SET deleted_at = NOW()
    WHERE fecha_reserva < DATE_SUB(CURDATE(), INTERVAL 7 DAY)
      AND estado IN ('Confirmada', 'No Show', 'Completada')
      AND deleted_at IS NULL;
      
    INSERT INTO logs (tabla_afectada, accion, descripcion)
    VALUES ('reservas', 'DELETE', CONCAT('Sistema: Reservas pasadas archivadas (soft delete). Total: ', ROW_COUNT()));
END $$

-- =====================================================
-- EVENTO 9: Reporte semanal de ocupación de espacios
-- =====================================================
CREATE EVENT IF NOT EXISTS ev_reporte_semanal_ocupacion
ON SCHEDULE EVERY 1 WEEK
STARTS CURDATE() + INTERVAL 1 DAY
DO
BEGIN
    DECLARE v_reservas_semana INT;
    
    SELECT COUNT(*) INTO v_reservas_semana 
    FROM reservas 
    WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) AND deleted_at IS NULL;
    
    INSERT INTO logs (tabla_afectada, accion, descripcion)
    VALUES ('reservas', 'SELECT', CONCAT('Sistema: Reporte semanal de ocupación - Total reservas esta semana: ', v_reservas_semana));
END $$

-- =====================================================
-- EVENTO 10: Liberar reservas bloqueadas si no se inicia en 15 minutos
-- =====================================================
CREATE EVENT IF NOT EXISTS ev_liberar_reservas_no_iniciadas
ON SCHEDULE EVERY 15 MINUTE
DO
BEGIN
    UPDATE reservas 
    SET estado = 'Cancelada', motivo = 'Liberada: No se inició en los primeros 15 minutos'
    WHERE estado = 'Pendiente' 
      AND fecha_reserva = CURDATE()
      AND hora_inicio <= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 15 MINUTE), '%H:%i:00')
      AND deleted_at IS NULL;
END $$

DELIMITER ;