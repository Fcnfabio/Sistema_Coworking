-- =====================================================
-- DATOS INICIALES: TIPOS DE ESPACIO
-- 4 categorías de espacios disponibles
-- =====================================================

INSERT INTO tipos_espacio (nombre, descripcion) VALUES
('Escritorio Flexible', 'Espacio compartido en área abierta, ideal para trabajo individual'),
('Oficina Privada', 'Oficina cerrada para equipos pequeños con acceso 24/7'),
('Sala de Reuniones', 'Espacio equipado para reuniones y videoconferencias'),
('Sala de Eventos', 'Espacio amplio para workshops, presentaciones y eventos');

SELECT '✅ 4 tipos de espacio insertados' AS resultado;