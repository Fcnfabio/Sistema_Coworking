-- =====================================================
-- DATOS INICIALES: RESERVAS
-- 35 reservas con diferentes estados y fechas
-- =====================================================

-- Reservas CONFIRMADAS (pasadas y futuras)
INSERT INTO reservas (usuario_id, espacio_id, fecha_reserva, hora_inicio, hora_fin, estado, numero_personas, motivo, precio_total) VALUES
-- Reservas pasadas confirmadas
(1, 1, '2026-07-01', '09:00:00', '12:00:00', 'Confirmada', 1, 'Trabajo individual', 15.00),
(1, 9, '2026-07-02', '14:00:00', '16:00:00', 'Confirmada', 4, 'Reunión de equipo', 60.00),
(2, 7, '2026-07-03', '10:00:00', '14:00:00', 'Confirmada', 3, 'Sesión de trabajo', 140.00),
(2, 10, '2026-07-05', '09:00:00', '11:00:00', 'Confirmada', 8, 'Workshop', 60.00),
(3, 2, '2026-07-06', '08:00:00', '17:00:00', 'Confirmada', 1, 'Jornada completa', 45.00),
(4, 11, '2026-07-07', '10:00:00', '12:00:00', 'Confirmada', 4, 'Reunión cliente', 30.00),
(5, 12, '2026-07-08', '09:00:00', '18:00:00', 'Confirmada', 30, 'Evento corporativo', 720.00),
(5, 8, '2026-07-09', '14:00:00', '18:00:00', 'Confirmada', 6, 'Reunión estratégica', 180.00),
(6, 3, '2026-07-10', '09:00:00', '13:00:00', 'Confirmada', 1, 'Trabajo remoto', 20.00),
(13, 9, '2026-07-01', '09:00:00', '11:00:00', 'Confirmada', 6, 'Reunión Tech Solutions', 60.00),
(13, 10, '2026-07-03', '14:00:00', '17:00:00', 'Confirmada', 10, 'Presentación proyecto', 90.00),
(14, 11, '2026-07-02', '10:00:00', '12:00:00', 'Confirmada', 4, 'Entrevistas', 30.00),
(15, 7, '2026-07-04', '09:00:00', '13:00:00', 'Confirmada', 4, 'Sprint planning', 100.00),
(16, 10, '2026-07-05', '10:00:00', '12:00:00', 'Confirmada', 6, 'Reunión InnovateCorp', 40.00),
(17, 9, '2026-07-06', '15:00:00', '17:00:00', 'Confirmada', 6, 'Review mensual', 60.00),
(18, 11, '2026-07-07', '09:00:00', '11:00:00', 'Confirmada', 4, 'Reunión Digital Minds', 30.00),
(19, 10, '2026-07-08', '14:00:00', '16:00:00', 'Confirmada', 8, 'Workshop startup', 40.00),
(20, 9, '2026-07-09', '10:00:00', '12:00:00', 'Confirmada', 6, 'Reunión Global Services', 60.00),
-- Reservas futuras confirmadas
(1, 10, '2026-07-15', '09:00:00', '11:00:00', 'Confirmada', 8, 'Reunión importante', 60.00),
(2, 12, '2026-07-20', '10:00:00', '18:00:00', 'Confirmada', 40, 'Evento Premium', 640.00),
(5, 8, '2026-07-25', '09:00:00', '17:00:00', 'Confirmada', 6, 'Retiro estratégico', 360.00);

-- Reservas PENDIENTES
INSERT INTO reservas (usuario_id, espacio_id, fecha_reserva, hora_inicio, hora_fin, estado, numero_personas, motivo, precio_total) VALUES
(3, 9, '2026-07-14', '10:00:00', '12:00:00', 'Pendiente', 6, 'Reunión pendiente confirmación', 60.00),
(6, 11, '2026-07-16', '14:00:00', '16:00:00', 'Pendiente', 4, 'Entrevistas pendientes', 30.00),
(7, 1, '2026-07-12', '09:00:00', '12:00:00', 'Pendiente', 1, 'Trabajo freelance', 15.00),
(8, 10, '2026-07-18', '09:00:00', '11:00:00', 'Pendiente', 8, 'Taller corporativo', 60.00);

-- Reservas CANCELADAS
INSERT INTO reservas (usuario_id, espacio_id, fecha_reserva, hora_inicio, hora_fin, estado, numero_personas, motivo, precio_total) VALUES
(9, 7, '2026-06-25', '10:00:00', '12:00:00', 'Cancelada', 3, 'Reunión cancelada por cliente', 70.00),
(10, 2, '2026-06-28', '09:00:00', '17:00:00', 'Cancelada', 1, 'Usuario no pudo asistir', 40.00),
(11, 9, '2026-07-01', '14:00:00', '16:00:00', 'Cancelada', 6, 'Conflicto de horario', 60.00);

-- Reservas COMPLETADAS
INSERT INTO reservas (usuario_id, espacio_id, fecha_reserva, hora_inicio, hora_fin, estado, numero_personas, motivo, precio_total) VALUES
(1, 3, '2026-06-20', '09:00:00', '12:00:00', 'Completada', 1, 'Trabajo finalizado', 15.00),
(2, 10, '2026-06-22', '10:00:00', '14:00:00', 'Completada', 8, 'Workshop completado', 120.00),
(5, 12, '2026-06-25', '09:00:00', '18:00:00', 'Completada', 45, 'Evento exitoso', 720.00),
(13, 11, '2026-06-28', '09:00:00', '11:00:00', 'Completada', 4, 'Reunión completada', 30.00);

-- Reservas NO SHOW (reservaron pero no asistieron)
INSERT INTO reservas (usuario_id, espacio_id, fecha_reserva, hora_inicio, hora_fin, estado, numero_personas, motivo, precio_total) VALUES
(12, 8, '2026-06-30', '10:00:00', '12:00:00', 'No Show', 4, 'No se presentó', 100.00),
(4, 9, '2026-07-02', '14:00:00', '16:00:00', 'No Show', 6, 'Olvidó la reserva', 60.00);

-- Reserva que excede capacidad (para prueba de consulta #28)
INSERT INTO reservas (usuario_id, espacio_id, fecha_reserva, hora_inicio, hora_fin, estado, numero_personas, motivo, precio_total) VALUES
(7, 1, '2026-07-11', '10:00:00', '12:00:00', 'Confirmada', 5, 'Reserva que excede capacidad (cap=1)', 10.00);

SELECT '✅ 35 reservas insertadas (21 confirmadas, 4 pendientes, 3 canceladas, 4 completadas, 2 no show, 1 excede capacidad)' AS resultado;