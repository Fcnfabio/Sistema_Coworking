-- =====================================================
-- DATOS INICIALES: SERVICIOS ADICIONALES
-- Servicios extra que los usuarios pueden contratar
-- =====================================================

INSERT INTO servicios_adicionales (nombre, descripcion, precio, tipo, disponible) VALUES
('Internet Premium', 'Conexión de alta velocidad 500Mbps dedicada', 15.00, 'Fijo', TRUE),
('Locker Personal', 'Casillero seguro para pertenencias personales', 20.00, 'Fijo', TRUE),
('Café Ilimitado', 'Acceso ilimitado a café, té y bebidas calientes', 10.00, 'Fijo', TRUE),
('Impresiones', 'Impresión a color o blanco y negro', 0.50, 'PorUnidad', TRUE),
('Uso de Proyector', 'Proyector HD para presentaciones', 25.00, 'PorHora', TRUE),
('Videoconferencia Equipada', 'Sala con cámara, micrófono y pantalla 4K', 35.00, 'PorHora', TRUE),
('Asistencia Virtual', 'Recepción de paquetes y llamadas', 12.00, 'Fijo', TRUE),
('Estacionamiento', 'Parqueadero privado por día', 8.00, 'Fijo', TRUE);

SELECT '✅ 8 servicios adicionales insertados' AS resultado;