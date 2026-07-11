-- =====================================================
-- DATOS INICIALES: HISTORIAL DE MEMBRESÍAS
-- Registro de cambios de membresía de algunos usuarios
-- =====================================================

INSERT INTO historial_membresias (usuario_id, tipo_membresia_anterior_id, tipo_membresia_nueva_id, fecha_cambio, motivo) VALUES
(1, 1, 2, '2026-04-15 10:30:00', 'Upgrade de Diaria a Mensual'),
(1, 2, 2, '2026-05-15 09:00:00', 'Renovación mensual'),
(1, 2, 2, '2026-06-15 09:15:00', 'Renovación mensual'),
(2, 2, 4, '2026-02-01 14:20:00', 'Upgrade a Premium'),
(2, 4, 4, '2026-03-01 10:00:00', 'Renovación Premium'),
(2, 4, 4, '2026-04-01 10:00:00', 'Renovación Premium'),
(2, 4, 4, '2026-05-01 10:00:00', 'Renovación Premium'),
(2, 4, 4, '2026-06-01 10:00:00', 'Renovación Premium'),
(5, 2, 4, '2025-12-20 16:45:00', 'Upgrade a Premium'),
(5, 4, 4, '2026-01-20 09:30:00', 'Renovación Premium'),
(5, 4, 4, '2026-02-20 09:30:00', 'Renovación Premium'),
(5, 4, 4, '2026-03-20 09:30:00', 'Renovación Premium'),
(5, 4, 4, '2026-04-20 09:30:00', 'Renovación Premium'),
(5, 4, 4, '2026-05-20 09:30:00', 'Renovación Premium'),
(5, 4, 4, '2026-06-20 09:30:00', 'Renovación Premium'),
(11, 1, 2, '2026-04-15 11:00:00', 'Upgrade a Mensual'),
(11, 2, 2, '2026-05-15 11:00:00', 'Renovación mensual'),
(12, 2, 4, '2026-02-20 15:30:00', 'Upgrade a Premium'),
(12, 4, 4, '2026-03-20 10:00:00', 'Renovación Premium'),
(12, 4, 4, '2026-04-20 10:00:00', 'Renovación Premium'),
(12, 4, 4, '2026-05-20 10:00:00', 'Renovación Premium');

SELECT '✅ 21 registros de historial de membresías insertados' AS resultado;