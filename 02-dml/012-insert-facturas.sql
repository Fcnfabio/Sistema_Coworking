-- =====================================================
-- DATOS INICIALES: FACTURAS
-- 22 facturas asociadas a pagos y usuarios
-- =====================================================

-- Facturas de MEMBRESÍAS (Pagadas)
INSERT INTO facturas (usuario_id, pago_id, numero_factura, fecha_emision, subtotal, impuestos, total, estado, saldo_pendiente) VALUES
(1, 1, 'FAC-2026-0001', '2026-06-15', 251.26, 47.74, 299.00, 'Pagada', 0.00),
(2, 2, 'FAC-2026-0002', '2026-06-01', 419.33, 79.67, 499.00, 'Pagada', 0.00),
(3, 3, 'FAC-2026-0003', '2026-07-01', 251.26, 47.74, 299.00, 'Pagada', 0.00),
(4, 4, 'FAC-2026-0004', '2026-06-10', 209.24, 39.76, 249.00, 'Pagada', 0.00),
(5, 5, 'FAC-2026-0005', '2026-06-20', 419.33, 79.67, 499.00, 'Pagada', 0.00),
(6, 6, 'FAC-2026-0006', '2026-07-05', 251.26, 47.74, 299.00, 'Pagada', 0.00),
(7, 7, 'FAC-2026-0007', '2026-07-10', 21.01, 3.99, 25.00, 'Pagada', 0.00),
(8, 8, 'FAC-2026-0008', '2026-06-15', 209.24, 39.76, 249.00, 'Pagada', 0.00),
(13, 13, 'FAC-2026-0013', '2026-06-01', 209.24, 39.76, 249.00, 'Pagada', 0.00),
(14, 14, 'FAC-2026-0014', '2026-06-01', 209.24, 39.76, 249.00, 'Pagada', 0.00),
(15, 15, 'FAC-2026-0015', '2026-06-01', 209.24, 39.76, 249.00, 'Pagada', 0.00);

-- Facturas de RESERVAS (Pagadas)
INSERT INTO facturas (usuario_id, pago_id, numero_factura, fecha_emision, subtotal, impuestos, total, estado, saldo_pendiente) VALUES
(1, 21, 'FAC-2026-0021', '2026-07-01', 12.61, 2.39, 15.00, 'Pagada', 0.00),
(1, 22, 'FAC-2026-0022', '2026-07-02', 50.42, 9.58, 60.00, 'Pagada', 0.00),
(2, 23, 'FAC-2026-0023', '2026-07-03', 117.65, 22.35, 140.00, 'Pagada', 0.00),
(5, 24, 'FAC-2026-0024', '2026-07-08', 605.04, 114.96, 720.00, 'Pagada', 0.00),
(13, 26, 'FAC-2026-0026', '2026-07-01', 50.42, 9.58, 60.00, 'Pagada', 0.00);

-- Facturas PENDIENTES
INSERT INTO facturas (usuario_id, pago_id, numero_factura, fecha_emision, subtotal, impuestos, total, estado, saldo_pendiente) VALUES
(3, 27, 'FAC-2026-0027', '2026-07-14', 50.42, 9.58, 60.00, 'Pendiente', 60.00),
(6, 28, 'FAC-2026-0028', '2026-07-16', 25.21, 4.79, 30.00, 'Pendiente', 30.00),
(11, 29, 'FAC-2026-0029', '2026-06-15', 251.26, 47.74, 299.00, 'Pendiente', 299.00);

-- Facturas ANULADAS
INSERT INTO facturas (usuario_id, pago_id, numero_factura, fecha_emision, subtotal, impuestos, total, estado, saldo_pendiente, motivo_anulacion) VALUES
(9, 30, 'FAC-2026-0030', '2026-06-25', 58.82, 11.18, 70.00, 'Anulada', 0.00, 'Reserva cancelada por el cliente'),
(10, 31, 'FAC-2026-0031', '2026-06-28', 33.61, 6.39, 40.00, 'Anulada', 0.00, 'Reserva cancelada - usuario no asistió');

-- Factura con pago PARCIAL
INSERT INTO facturas (usuario_id, pago_id, numero_factura, fecha_emision, subtotal, impuestos, total, estado, saldo_pendiente) VALUES
(12, NULL, 'FAC-2026-0032', '2026-05-20', 419.33, 79.67, 499.00, 'Parcial', 200.00);

SELECT '✅ 22 facturas insertadas (17 pagadas, 3 pendientes, 2 anuladas, 1 parcial)' AS resultado;