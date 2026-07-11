-- =====================================================
-- DATOS INICIALES: RESERVA_SERVICIOS
-- Servicios adicionales contratados en reservas específicas
-- =====================================================

INSERT INTO reserva_servicios (reserva_id, servicio_id, cantidad, precio_unitario) VALUES
-- Reserva #2 (Reunión de equipo) - Café + Proyector
(2, 3, 4, 10.00),   -- Café ilimitado x4 personas
(2, 5, 1, 25.00),   -- Proyector 2 horas

-- Reserva #4 (Workshop) - Proyector + Videoconferencia
(4, 5, 2, 25.00),   -- Proyector 2 horas
(4, 6, 2, 35.00),   -- Videoconferencia 2 horas

-- Reserva #7 (Evento corporativo) - Múltiples servicios
(7, 3, 30, 10.00),  -- Café ilimitado x30 personas
(7, 5, 9, 25.00),   -- Proyector 9 horas
(7, 6, 9, 35.00),   -- Videoconferencia 9 horas
(7, 8, 20, 8.00),   -- Estacionamiento x20

-- Reserva #8 (Reunión estratégica) - Café + Videoconferencia
(8, 3, 6, 10.00),   -- Café ilimitado x6
(8, 6, 4, 35.00),   -- Videoconferencia 4 horas

-- Reserva #10 (Reunión Tech Solutions) - Café + Proyector
(10, 3, 6, 10.00),
(10, 5, 2, 25.00),

-- Reserva #12 (Entrevistas) - Café
(12, 3, 4, 10.00),

-- Reserva #20 (Reunión importante) - Café + Proyector + Videoconferencia
(20, 3, 8, 10.00),
(20, 5, 2, 25.00),
(20, 6, 2, 35.00),

-- Reserva #21 (Evento Premium) - Todos los servicios
(21, 1, 1, 15.00),  -- Internet Premium
(21, 3, 40, 10.00), -- Café x40
(21, 5, 8, 25.00),  -- Proyector 8 horas
(21, 6, 8, 35.00),  -- Videoconferencia 8 horas
(21, 7, 1, 12.00),  -- Asistencia virtual
(21, 8, 30, 8.00);  -- Estacionamiento x30

SELECT '✅ 24 servicios de reserva insertados' AS resultado;