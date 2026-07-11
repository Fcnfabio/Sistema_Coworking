-- =====================================================
-- DATOS INICIALES: ACCESOS (ASISTENCIAS)
-- 80 accesos con diferentes escenarios
-- =====================================================

-- Accesos APROBADOS - Entradas y Salidas (últimos 10 días)
INSERT INTO accesos (usuario_id, tipo_acceso, fecha_hora, metodo_acceso, estado) VALUES
-- Día 11 de julio (hoy) - Accesos de la mañana
(1, 'Entrada', '2026-07-11 08:30:00', 'QR', 'Aprobado'),
(2, 'Entrada', '2026-07-11 09:00:00', 'RFID', 'Aprobado'),
(3, 'Entrada', '2026-07-11 09:15:00', 'QR', 'Aprobado'),
(5, 'Entrada', '2026-07-11 08:45:00', 'RFID', 'Aprobado'),
(13, 'Entrada', '2026-07-11 09:30:00', 'RFID', 'Aprobado'),
(14, 'Entrada', '2026-07-11 09:35:00', 'RFID', 'Aprobado'),
(16, 'Entrada', '2026-07-11 10:00:00', 'QR', 'Aprobado'),
(1, 'Salida', '2026-07-11 12:30:00', 'QR', 'Aprobado'),
(2, 'Salida', '2026-07-11 13:00:00', 'RFID', 'Aprobado'),
(3, 'Salida', '2026-07-11 17:30:00', 'QR', 'Aprobado'),

-- Día 10 de julio
(1, 'Entrada', '2026-07-10 09:00:00', 'QR', 'Aprobado'),
(2, 'Entrada', '2026-07-10 08:30:00', 'RFID', 'Aprobado'),
(4, 'Entrada', '2026-07-10 10:00:00', 'QR', 'Aprobado'),
(5, 'Entrada', '2026-07-10 09:00:00', 'RFID', 'Aprobado'),
(6, 'Entrada', '2026-07-10 11:00:00', 'QR', 'Aprobado'),
(13, 'Entrada', '2026-07-10 09:00:00', 'RFID', 'Aprobado'),
(15, 'Entrada', '2026-07-10 09:30:00', 'RFID', 'Aprobado'),
(17, 'Entrada', '2026-07-10 10:00:00', 'QR', 'Aprobado'),
(1, 'Salida', '2026-07-10 18:00:00', 'QR', 'Aprobado'),
(2, 'Salida', '2026-07-10 17:30:00', 'RFID', 'Aprobado'),
(5, 'Salida', '2026-07-10 19:00:00', 'RFID', 'Aprobado'),

-- Día 9 de julio
(1, 'Entrada', '2026-07-09 09:00:00', 'QR', 'Aprobado'),
(2, 'Entrada', '2026-07-09 08:45:00', 'RFID', 'Aprobado'),
(3, 'Entrada', '2026-07-09 10:00:00', 'QR', 'Aprobado'),
(5, 'Entrada', '2026-07-09 09:00:00', 'RFID', 'Aprobado'),
(8, 'Entrada', '2026-07-09 14:00:00', 'QR', 'Aprobado'),
(13, 'Entrada', '2026-07-09 09:00:00', 'RFID', 'Aprobado'),
(14, 'Entrada', '2026-07-09 09:15:00', 'RFID', 'Aprobado'),
(18, 'Entrada', '2026-07-09 09:30:00', 'QR', 'Aprobado'),
(1, 'Salida', '2026-07-09 17:00:00', 'QR', 'Aprobado'),
(2, 'Salida', '2026-07-09 18:00:00', 'RFID', 'Aprobado'),
(5, 'Salida', '2026-07-09 18:30:00', 'RFID', 'Aprobado'),

-- Día 8 de julio
(1, 'Entrada', '2026-07-08 09:00:00', 'QR', 'Aprobado'),
(2, 'Entrada', '2026-07-08 09:00:00', 'RFID', 'Aprobado'),
(5, 'Entrada', '2026-07-08 08:30:00', 'RFID', 'Aprobado'),
(7, 'Entrada', '2026-07-08 10:00:00', 'Manual', 'Aprobado'),
(13, 'Entrada', '2026-07-08 09:00:00', 'RFID', 'Aprobado'),
(16, 'Entrada', '2026-07-08 10:00:00', 'QR', 'Aprobado'),
(19, 'Entrada', '2026-07-08 14:00:00', 'QR', 'Aprobado'),
(1, 'Salida', '2026-07-08 17:30:00', 'QR', 'Aprobado'),
(2, 'Salida', '2026-07-08 17:00:00', 'RFID', 'Aprobado'),
(5, 'Salida', '2026-07-08 18:00:00', 'RFID', 'Aprobado'),

-- Día 7 de julio
(1, 'Entrada', '2026-07-07 09:00:00', 'QR', 'Aprobado'),
(2, 'Entrada', '2026-07-07 08:30:00', 'RFID', 'Aprobado'),
(3, 'Entrada', '2026-07-07 09:30:00', 'QR', 'Aprobado'),
(4, 'Entrada', '2026-07-07 10:00:00', 'QR', 'Aprobado'),
(5, 'Entrada', '2026-07-07 09:00:00', 'RFID', 'Aprobado'),
(6, 'Entrada', '2026-07-07 11:00:00', 'QR', 'Aprobado'),
(13, 'Entrada', '2026-07-07 09:00:00', 'RFID', 'Aprobado'),
(14, 'Entrada', '2026-07-07 09:30:00', 'RFID', 'Aprobado'),
(15, 'Entrada', '2026-07-07 09:00:00', 'RFID', 'Aprobado'),
(17, 'Entrada', '2026-07-07 10:00:00', 'QR', 'Aprobado'),
(1, 'Salida', '2026-07-07 18:00:00', 'QR', 'Aprobado'),
(2, 'Salida', '2026-07-07 17:30:00', 'RFID', 'Aprobado'),
(5, 'Salida', '2026-07-07 19:00:00', 'RFID', 'Aprobado'),

-- Días anteriores (5, 4, 3, 2, 1 de julio) - Accesos variados
(1, 'Entrada', '2026-07-05 09:00:00', 'QR', 'Aprobado'),
(2, 'Entrada', '2026-07-05 09:00:00', 'RFID', 'Aprobado'),
(5, 'Entrada', '2026-07-05 08:30:00', 'RFID', 'Aprobado'),
(13, 'Entrada', '2026-07-05 10:00:00', 'RFID', 'Aprobado'),
(1, 'Salida', '2026-07-05 17:00:00', 'QR', 'Aprobado'),
(2, 'Salida', '2026-07-05 18:00:00', 'RFID', 'Aprobado'),
(5, 'Salida', '2026-07-05 18:30:00', 'RFID', 'Aprobado'),

(1, 'Entrada', '2026-07-03 09:00:00', 'QR', 'Aprobado'),
(2, 'Entrada', '2026-07-03 09:30:00', 'RFID', 'Aprobado'),
(3, 'Entrada', '2026-07-03 10:00:00', 'QR', 'Aprobado'),
(5, 'Entrada', '2026-07-03 09:00:00', 'RFID', 'Aprobado'),
(14, 'Entrada', '2026-07-03 10:00:00', 'RFID', 'Aprobado'),
(16, 'Entrada', '2026-07-03 10:30:00', 'QR', 'Aprobado'),
(1, 'Salida', '2026-07-03 17:30:00', 'QR', 'Aprobado'),
(2, 'Salida', '2026-07-03 17:00:00', 'RFID', 'Aprobado'),
(5, 'Salida', '2026-07-03 18:00:00', 'RFID', 'Aprobado'),

(1, 'Entrada', '2026-07-01 09:00:00', 'QR', 'Aprobado'),
(2, 'Entrada', '2026-07-01 08:30:00', 'RFID', 'Aprobado'),
(5, 'Entrada', '2026-07-01 09:00:00', 'RFID', 'Aprobado'),
(13, 'Entrada', '2026-07-01 09:00:00', 'RFID', 'Aprobado'),
(14, 'Entrada', '2026-07-01 09:15:00', 'RFID', 'Aprobado'),
(15, 'Entrada', '2026-07-01 09:30:00', 'RFID', 'Aprobado'),
(1, 'Salida', '2026-07-01 12:30:00', 'QR', 'Aprobado'),
(2, 'Salida', '2026-07-01 14:30:00', 'RFID', 'Aprobado'),
(5, 'Salida', '2026-07-01 18:00:00', 'RFID', 'Aprobado');

-- Accesos RECHAZADOS (membresía vencida/suspendida o QR inválido)
INSERT INTO accesos (usuario_id, tipo_acceso, fecha_hora, metodo_acceso, estado, motivo_rechazo) VALUES
(9, 'Entrada', '2026-07-10 09:00:00', 'QR', 'Rechazado', 'Membresía vencida'),
(10, 'Entrada', '2026-07-09 10:00:00', 'QR', 'Rechazado', 'Membresía vencida'),
(11, 'Entrada', '2026-07-08 09:00:00', 'RFID', 'Rechazado', 'Membresía suspendida'),
(12, 'Entrada', '2026-07-07 10:00:00', 'QR', 'Rechazado', 'Membresía suspendida'),
(1, 'Entrada', '2026-07-06 09:00:00', 'QR', 'Rechazado', 'QR inválido - código expirado'),
(3, 'Entrada', '2026-07-05 08:30:00', 'RFID', 'Rechazado', 'QR inválido - tarjeta no reconocida');

-- Accesos fuera de horario (para consulta #66)
INSERT INTO accesos (usuario_id, tipo_acceso, fecha_hora, metodo_acceso, estado) VALUES
(5, 'Entrada', '2026-07-10 22:30:00', 'RFID', 'Aprobado'),
(5, 'Salida', '2026-07-11 02:00:00', 'RFID', 'Aprobado'),
(2, 'Entrada', '2026-07-09 21:00:00', 'RFID', 'Aprobado'),
(2, 'Salida', '2026-07-09 23:30:00', 'RFID', 'Aprobado');

-- Usuario que accede más de 2 veces en el mismo día (consulta #69)
INSERT INTO accesos (usuario_id, tipo_acceso, fecha_hora, metodo_acceso, estado) VALUES
(1, 'Entrada', '2026-07-10 09:00:00', 'QR', 'Aprobado'),
(1, 'Salida', '2026-07-10 12:00:00', 'QR', 'Aprobado'),
(1, 'Entrada', '2026-07-10 14:00:00', 'QR', 'Aprobado'),
(1, 'Salida', '2026-07-10 18:00:00', 'QR', 'Aprobado');

SELECT '✅ 86 accesos insertados (78 aprobados, 6 rechazados, 4 fuera de horario, 4 doble entrada)' AS resultado;