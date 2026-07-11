-- =====================================================
-- EVENTOS: MÓDULO ACCESOS Y ASISTENCIAS (ev_16 a ev_20)
-- =====================================================

USE coworking_db;
DELIMITER $$

-- =====================================================
-- EVENTO 16: Eliminar accesos antiguos (más de 1 año)
-- =====================================================
CREATE EVENT IF NOT EXISTS ev_eliminar_accesos_antiguos
ON SCHEDULE EVERY 1 MONTH
STARTS CURDATE() + INTERVAL 1 DAY
DO
BEGIN
    -- La tabla accesos no tiene 'deleted_at', por lo que se hace un hard delete
    DELETE FROM accesos 
    WHERE fecha_hora < DATE_SUB(NOW(), INTERVAL 1 YEAR);
    
    INSERT INTO logs (tabla_afectada, accion, descripcion)
    VALUES ('accesos', 'DELETE', CONCAT('Sistema: Accesos antiguos (> 1 año) eliminados. Total: ', ROW_COUNT()));
END $$

-- =====================================================
-- EVENTO 17: Reporte diario de asistencias al administrador
-- =====================================================
CREATE EVENT IF NOT EXISTS ev_reporte_diario_asistencias
ON SCHEDULE EVERY 1 DAY
STARTS CURDATE() + INTERVAL 1 DAY
DO
BEGIN
    DECLARE v_entradas INT;
    DECLARE v_unicos INT;
    
    SELECT COUNT(*), COUNT(DISTINCT usuario_id) INTO v_entradas, v_unicos
    FROM accesos 
    WHERE tipo_acceso = 'Entrada' 
      AND estado = 'Aprobado'
      AND DATE(fecha_hora) = DATE_SUB(CURDATE(), INTERVAL 1 DAY);
      
    INSERT INTO logs (tabla_afectada, accion, descripcion)
    VALUES ('accesos', 'SELECT', CONCAT('Sistema: Reporte diario asistencias - Entradas: ', v_entradas, ', Usuarios únicos: ', v_unicos));
END $$

-- =====================================================
-- EVENTO 18: Reporte semanal de usuarios inactivos (sin accesos en 7 días)
-- =====================================================
CREATE EVENT IF NOT EXISTS ev_reporte_semanal_inactivos
ON SCHEDULE EVERY 1 WEEK
STARTS CURDATE() + INTERVAL 1 DAY
DO
BEGIN
    INSERT INTO logs (usuario_id, tabla_afectada, accion, descripcion)
    SELECT u.id, 'usuarios', 'SELECT', 'Sistema: Reporte semanal - Usuario inactivo (sin accesos en 7 días)'
    FROM usuarios u
    LEFT JOIN accesos a ON u.id = a.usuario_id 
      AND a.tipo_acceso = 'Entrada' 
      AND a.fecha_hora >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
    WHERE a.id IS NULL AND u.deleted_at IS NULL;
END $$

-- =====================================================
-- EVENTO 19: Alertar accesos fuera de horario laboral (08:00 - 20:00)
-- =====================================================
CREATE EVENT IF NOT EXISTS ev_alertar_accesos_fuera_horario
ON SCHEDULE EVERY 1 DAY
STARTS CURDATE() + INTERVAL 1 DAY
DO
BEGIN
    INSERT INTO logs (usuario_id, tabla_afectada, accion, descripcion)
    SELECT usuario_id, 'accesos', 'INSERT', 'Sistema: Alerta - Acceso registrado fuera de horario laboral (08:00 - 20:00)'
    FROM accesos
    WHERE DATE(fecha_hora) = DATE_SUB(CURDATE(), INTERVAL 1 DAY)
      AND (TIME(fecha_hora) < '08:00:00' OR TIME(fecha_hora) > '20:00:00')
      AND estado = 'Aprobado';
END $$

-- =====================================================
-- EVENTO 20: Reporte top 10 usuarios más frecuentes (cada mes)
-- =====================================================
CREATE EVENT IF NOT EXISTS ev_reporte_top_10_usuarios
ON SCHEDULE EVERY 1 MONTH
STARTS LAST_DAY(CURDATE()) + INTERVAL 1 DAY
DO
BEGIN
    INSERT INTO logs (usuario_id, tabla_afectada, accion, descripcion)
    SELECT usuario_id, 'accesos', 'SELECT', CONCAT('Sistema: Top 10 mensual - Total asistencias mes anterior: ', total_asistencias)
    FROM (
        SELECT usuario_id, COUNT(*) AS total_asistencias
        FROM accesos
        WHERE tipo_acceso = 'Entrada' 
          AND estado = 'Aprobado'
          AND MONTH(fecha_hora) = MONTH(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
          AND YEAR(fecha_hora) = YEAR(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
        GROUP BY usuario_id
        ORDER BY total_asistencias DESC
        LIMIT 10
    ) AS top_usuarios;
END $$

DELIMITER ;