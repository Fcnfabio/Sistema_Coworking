-- =====================================================
-- DATOS INICIALES: PAGOS
-- 30 pagos con diferentes métodos y estados
-- =====================================================

-- Pagos de MEMBRESÍAS (Pagados)
INSERT INTO pagos (usuario_id, monto, fecha_pago, metodo_pago, estado, referencia_transaccion, concepto) VALUES
(1, 299.00, '2026-06-15 10:30:00', 'Tarjeta', 'Pagado', 'TX-001-2026', 'Membresia'),
(2, 499.00, '2026-06-01 09:00:00', 'PayPal', 'Pagado', 'PP-002-2026', 'Membresia'),
(3, 299.00, '2026-07-01 11:00:00', 'Transferencia', 'Pagado', 'TR-003-2026', 'Membresia'),
(4, 249.00, '2026-06-10 14:00:00', 'Tarjeta', 'Pagado', 'TX-004-2026', 'Membresia'),
(5, 499.00, '2026-06-20 10:00:00', 'Tarjeta', 'Pagado', 'TX-005-2026', 'Membresia'),
(6, 299.00, '2026-07-05 09:30:00', 'Efectivo', 'Pagado', 'EF-006-2026', 'Membresia'),
(7, 25.00, '2026-07-10 08:00:00', 'Efectivo', 'Pagado', 'EF-007-2026', 'Membresia'),
(8, 249.00, '2026-06-15 16:00:00', 'PayPal', 'Pagado', 'PP-008-2026', 'Membresia'),
(9, 299.00, '2026-05-01 10:00:00', 'Tarjeta', 'Pagado', 'TX-009-2026', 'Membresia'),
(10, 25.00, '2026-06-30 09:00:00', 'Efectivo', 'Pagado', 'EF-010-2026', 'Membresia'),
(11, 299.00, '2026-05-15 11:00:00', 'Transferencia', 'Pagado', 'TR-011-2026', 'Membresia'),
(12, 499.00, '2026-05-20 15:00:00', 'Tarjeta', 'Pagado', 'TX-012-2026', 'Membresia'),
(13, 249.00, '2026-06-01 09:00:00', 'Transferencia', 'Pagado', 'TR-013-2026', 'Membresia'),
(14, 249.00, '2026-06-01 09:05:00', 'Transferencia', 'Pagado', 'TR-014-2026', 'Membresia'),
(15, 249.00, '2026-06-01 09:10:00', 'Transferencia', 'Pagado', 'TR-015-2026', 'Membresia'),
(16, 249.00, '2026-06-15 10:00:00', 'PayPal', 'Pagado', 'PP-016-2026', 'Membresia'),
(17, 249.00, '2026-06-15 10:05:00', 'PayPal', 'Pagado', 'PP-017-2026', 'Membresia'),
(18, 249.00, '2026-06-20 11:00:00', 'Tarjeta', 'Pagado', 'TX-018-2026', 'Membresia'),
(19, 249.00, '2026-06-25 09:00:00', 'Transferencia', 'Pagado', 'TR-019-2026', 'Membresia'),
(20, 249.00, '2026-06-25 09:05:00', 'Transferencia', 'Pagado', 'TR-020-2026', 'Membresia');

-- Pagos de RESERVAS (Pagados)
INSERT INTO pagos (usuario_id, monto, fecha_pago, metodo_pago, estado, referencia_transaccion, concepto) VALUES
(1, 15.00, '2026-07-01 08:50:00', 'Tarjeta', 'Pagado', 'TX-R001', 'Reserva'),
(1, 60.00, '2026-07-02 13:50:00', 'Tarjeta', 'Pagado', 'TX-R002', 'Reserva'),
(2, 140.00, '2026-07-03 09:50:00', 'PayPal', 'Pagado', 'PP-R003', 'Reserva'),
(5, 720.00, '2026-07-08 08:50:00', 'Tarjeta', 'Pagado', 'TX-R005', 'Reserva'),
(5, 360.00, '2026-07-25 08:50:00', 'Tarjeta', 'Pendiente', NULL, 'Reserva'),
(13, 60.00, '2026-07-01 08:50:00', 'Transferencia', 'Pagado', 'TR-R013', 'Reserva');

-- Pagos PENDIENTES
INSERT INTO pagos (usuario_id, monto, fecha_pago, metodo_pago, estado, referencia_transaccion, concepto) VALUES
(3, 60.00, '2026-07-14 09:00:00', 'Tarjeta', 'Pendiente', NULL, 'Reserva'),
(6, 30.00, '2026-07-16 13:00:00', 'Efectivo', 'Pendiente', NULL, 'Reserva'),
(11, 299.00, '2026-06-15 11:00:00', 'Transferencia', 'Pendiente', NULL, 'Membresia');

-- Pagos CANCELADOS
INSERT INTO pagos (usuario_id, monto, fecha_pago, metodo_pago, estado, referencia_transaccion, concepto) VALUES
(9, 70.00, '2026-06-25 10:00:00', 'Tarjeta', 'Cancelado', 'TX-C009', 'Reserva'),
(10, 40.00, '2026-06-28 09:00:00', 'Efectivo', 'Cancelado', 'EF-C010', 'Reserva');

SELECT '✅ 30 pagos insertados (26 pagados, 3 pendientes, 2 cancelados)' AS resultado;