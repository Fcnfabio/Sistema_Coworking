-- =====================================================
-- EVENTOS: MÓDULO MEMBRESÍAS (ev_1 a ev_5)
-- Proyecto: Sistema de Gestión de Coworking
-- =====================================================

-- ⚠️ Asegurar que el Event Scheduler esté activo
SET GLOBAL event_scheduler = ON;

USE coworking_db;
DELIMITER $$

-- =====================================================
-- EVENTO 1: Revisar diariamente membresías vencidas
-- =====================================================
CREATE EVENT IF NOT EXISTS ev_actualizar_membresias_vencidas
ON SCHEDULE EVERY 1 DAY
STARTS CURDATE() + INTERVAL 1 DAY
DO
BEGIN
    UPDATE membresias 
    SET estado = 'Vencida' 
    WHERE estado = 'Activa' 
      AND fecha_fin < CURDATE() 
      AND deleted_at IS NULL;
      
    INSERT INTO logs (tabla_afectada, accion, descripcion)
    VALUES ('membresias', 'UPDATE', CONCAT('Sistema: Membresías vencidas actualizadas. Total: ', ROW_COUNT()));
END $$

-- =====================================================
-- EVENTO 2: Recordatorio de renovación 5 días antes
-- =====================================================
CREATE EVENT IF NOT EXISTS ev_recordatorio_renovacion
ON SCHEDULE EVERY 1 DAY
STARTS CURDATE() + INTERVAL 1 DAY
DO
BEGIN
    INSERT INTO logs (usuario_id, tabla_afectada, accion, descripcion)
    SELECT usuario_id, 'membresias', 'UPDATE', 'Sistema: Recordatorio de renovación enviado (5 días para vencer)'
    FROM membresias
    WHERE estado = 'Activa' 
      AND fecha_fin = DATE_ADD(CURDATE(), INTERVAL 5 DAY)
      AND deleted_at IS NULL;
END $$

-- =====================================================
-- EVENTO 3: Suspender membresías sin pago en 30 días
-- =====================================================
CREATE EVENT IF NOT EXISTS ev_suspender_membresias_inactivas
ON SCHEDULE EVERY 1 DAY
STARTS CURDATE() + INTERVAL 1 DAY
DO
BEGIN
    UPDATE membresias m
    SET estado = 'Suspendida'
    WHERE m.estado = 'Activa'
      AND m.deleted_at IS NULL
      AND m.usuario_id NOT IN (
          SELECT p.usuario_id 
          FROM pagos p 
          WHERE p.usuario_id = m.usuario_id 
            AND p.estado = 'Pagado' 
            AND p.fecha_pago >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
      );
      
    INSERT INTO logs (tabla_afectada, accion, descripcion)
    VALUES ('membresias', 'UPDATE', CONCAT('Sistema: Membresías suspendidas por inactividad de pagos. Total: ', ROW_COUNT()));
END $$

-- =====================================================
-- EVENTO 4: Reporte semanal de nuevas membresías
-- =====================================================
CREATE EVENT IF NOT EXISTS ev_reporte_semanal_nuevas_membresias
ON SCHEDULE EVERY 1 WEEK
STARTS CURDATE() + INTERVAL 1 DAY
DO
BEGIN
    DECLARE v_nuevas INT;
    
    SELECT COUNT(*) INTO v_nuevas 
    FROM membresias 
    WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) AND deleted_at IS NULL;
    
    INSERT INTO logs (tabla_afectada, accion, descripcion)
    VALUES ('membresias', 'SELECT', CONCAT('Sistema: Reporte semanal - Nuevas membresías en los últimos 7 días: ', v_nuevas));
END $$

-- =====================================================
-- EVENTO 5: Notificar membresías suspendidas a recepción
-- =====================================================
CREATE EVENT IF NOT EXISTS ev_notificar_suspendidas_recepcion
ON SCHEDULE EVERY 1 DAY
STARTS CURDATE() + INTERVAL 1 DAY
DO
BEGIN
    INSERT INTO logs (usuario_id, tabla_afectada, accion, descripcion)
    SELECT usuario_id, 'membresias', 'UPDATE', 'Sistema: Notificación a recepción - Membresía actualmente suspendida'
    FROM membresias
    WHERE estado = 'Suspendida' AND deleted_at IS NULL;
END $$

DELIMITER ;