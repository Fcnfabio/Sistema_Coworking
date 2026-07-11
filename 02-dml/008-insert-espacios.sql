-- =====================================================
-- DATOS INICIALES: ESPACIOS FÍSICOS
-- 12 espacios distribuidos en las 4 categorías
-- =====================================================

-- Escritorios Flexibles (tipo_espacio_id = 1)
INSERT INTO espacios (tipo_espacio_id, nombre, capacidad_maxima, precio_hora, ubicacion) VALUES
(1, 'Escritorio A1', 1, 5.00, 'Piso 1, Zona Norte'),
(1, 'Escritorio A2', 1, 5.00, 'Piso 1, Zona Norte'),
(1, 'Escritorio A3', 1, 5.00, 'Piso 1, Zona Norte'),
(1, 'Escritorio B1', 1, 5.00, 'Piso 1, Zona Sur'),
(1, 'Escritorio B2', 1, 5.00, 'Piso 1, Zona Sur');

-- Oficinas Privadas (tipo_espacio_id = 2)
INSERT INTO espacios (tipo_espacio_id, nombre, capacidad_maxima, precio_hora, ubicacion) VALUES
(2, 'Oficina Privada 101', 4, 25.00, 'Piso 2, Ala Este'),
(2, 'Oficina Privada 102', 6, 35.00, 'Piso 2, Ala Este'),
(2, 'Oficina Privada 201', 8, 45.00, 'Piso 2, Ala Oeste');

-- Salas de Reuniones (tipo_espacio_id = 3)
INSERT INTO espacios (tipo_espacio_id, nombre, capacidad_maxima, precio_hora, ubicacion) VALUES
(3, 'Sala de Juntas Alpha', 10, 30.00, 'Piso 3, Centro'),
(3, 'Sala de Juntas Beta', 6, 20.00, 'Piso 3, Centro'),
(3, 'Sala de Juntas Gamma', 4, 15.00, 'Piso 3, Centro');

-- Sala de Eventos (tipo_espacio_id = 4)
INSERT INTO espacios (tipo_espacio_id, nombre, capacidad_maxima, precio_hora, ubicacion) VALUES
(4, 'Auditorio Principal', 50, 80.00, 'Piso 1, Entrada');

SELECT '✅ 12 espacios físicos insertados' AS resultado;