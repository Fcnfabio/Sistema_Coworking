-- =====================================================
-- 1. Cambios de membresía
-- =====================================================
INSERT INTO logs (usuario_id, tabla_afectada, registro_id, accion, descripcion, datos_anteriores, datos_nuevos, ip_address) VALUES
(1, 'membresias', 1, 'UPDATE', 'Usuario cambió de Diaria a Mensual', '{"tipo_membresia_id": 1}', '{"tipo_membresia_id": 2}', '192.168.1.100'),
(2, 'membresias', 2, 'UPDATE', 'Usuario cambió de Mensual a Premium', '{"tipo_membresia_id": 2}', '{"tipo_membresia_id": 4}', '192.168.1.101'),
(5, 'membresias', 5, 'UPDATE', 'Usuario cambió de Mensual a Premium', '{"tipo_membresia_id": 2}', '{"tipo_membresia_id": 4}', '192.168.1.105');

-- =====================================================
-- 2. Reservas canceladas
-- =====================================================
INSERT INTO logs (usuario_id, tabla_afectada, registro_id, accion, descripcion, datos_anteriores, datos_nuevos, ip_address) VALUES
(9, 'reservas', 29, 'UPDATE', 'Reserva cancelada por el usuario', '{"estado": "Confirmada"}', '{"estado": "Cancelada"}', '192.168.1.109'),
(10, 'reservas', 30, 'UPDATE', 'Reserva cancelada - usuario no asistió', '{"estado": "Confirmada"}', '{"estado": "Cancelada"}', '192.168.1.110'),
(11, 'reservas', 31, 'UPDATE', 'Reserva cancelada por conflicto de horario', '{"estado": "Pendiente"}', '{"estado": "Cancelada"}', '192.168.1.111');

-- =====================================================
-- 3. Pagos anulados
-- =====================================================
INSERT INTO logs (usuario_id, tabla_afectada, registro_id, accion, descripcion, datos_anteriores, datos_nuevos, ip_address) VALUES
(9, 'pagos', 30, 'UPDATE', 'Pago anulado por cancelación de reserva', '{"estado": "Pagado"}', '{"estado": "Cancelado"}', '192.168.1.109'),
(10, 'pagos', 31, 'UPDATE', 'Pago anulado por no asistencia', '{"estado": "Pagado"}', '{"estado": "Cancelado"}', '192.168.1.110');

-- =====================================================
-- 4. Accesos rechazados
-- =====================================================
INSERT INTO logs (usuario_id, tabla_afectada, registro_id, accion, descripcion, datos_anteriores, datos_nuevos, ip_address) VALUES
(9, 'accesos', 79, 'INSERT', 'Acceso rechazado - membresía vencida', NULL, '{"estado": "Rechazado", "motivo": "Membresía vencida"}', '192.168.1.109'),
(11, 'accesos', 81, 'INSERT', 'Acceso rechazado - membresía suspendida', NULL, '{"estado": "Rechazado", "motivo": "Membresía suspendida"}', '192.168.1.111');

-- =====================================================
-- 5. Acciones del sistema (usuario_id = NULL)
-- =====================================================
INSERT INTO logs (usuario_id, tabla_afectada, registro_id, accion, descripcion, datos_anteriores, datos_nuevos, ip_address) VALUES
(NULL, 'membresias', 19, 'UPDATE', 'Sistema: Membresía marcada como Vencida automáticamente', '{"estado": "Activa"}', '{"estado": "Vencida"}', '127.0.0.1'),
(NULL, 'reservas', 33, 'UPDATE', 'Sistema: Reserva marcada como No Show', '{"estado": "Confirmada"}', '{"estado": "No Show"}', '127.0.0.1'),
(NULL, 'facturas', 22, 'UPDATE', 'Sistema: Factura marcada como Anulada', '{"estado": "Pendiente"}', '{"estado": "Anulada"}', '127.0.0.1');

SELECT '✅ 12 registros de logs insertados' AS resultado;