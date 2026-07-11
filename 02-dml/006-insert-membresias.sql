-- =====================================================
-- DATOS INICIALES: MEMBRESÍAS
-- 20 membresías con diferentes estados y tipos
-- =====================================================

-- Membresías ACTIVAS
INSERT INTO membresias (usuario_id, tipo_membresia_id, fecha_inicio, fecha_fin, estado, precio_pagado, numero_renovaciones) VALUES
(1, 2, '2026-06-15', '2026-07-15', 'Activa', 299.00, 3),   -- Carlos - Mensual
(2, 4, '2026-06-01', '2026-07-01', 'Activa', 499.00, 5),   -- Ana - Premium
(3, 2, '2026-07-01', '2026-07-31', 'Activa', 299.00, 1),   -- Luis - Mensual
(4, 3, '2026-06-10', '2026-07-10', 'Activa', 249.00, 2),   -- María - Corporativa
(5, 4, '2026-06-20', '2026-07-20', 'Activa', 499.00, 8),   -- Jorge - Premium
(6, 2, '2026-07-05', '2026-08-04', 'Activa', 299.00, 0),   -- Laura - Mensual
(7, 1, '2026-07-10', '2026-07-11', 'Activa', 25.00, 0),    -- Pedro - Diaria
(8, 3, '2026-06-15', '2026-07-15', 'Activa', 249.00, 4),   -- Sofía - Corporativa
(13, 3, '2026-06-01', '2026-07-01', 'Activa', 249.00, 6),  -- Roberto - Corporativa
(14, 3, '2026-06-01', '2026-07-01', 'Activa', 249.00, 6),  -- Patricia - Corporativa
(15, 3, '2026-06-01', '2026-07-01', 'Activa', 249.00, 6),  -- Fernando - Corporativa
(16, 3, '2026-06-15', '2026-07-15', 'Activa', 249.00, 3),  -- Isabel - Corporativa
(17, 3, '2026-06-15', '2026-07-15', 'Activa', 249.00, 3),  -- Ricardo - Corporativa
(18, 3, '2026-06-20', '2026-07-20', 'Activa', 249.00, 2),  -- Gabriela - Corporativa
(19, 3, '2026-06-25', '2026-07-25', 'Activa', 249.00, 1),  -- Mauricio - Corporativa
(20, 3, '2026-06-25', '2026-07-25', 'Activa', 249.00, 1);  -- Natalia - Corporativa

-- Membresías VENCIDAS
INSERT INTO membresias (usuario_id, tipo_membresia_id, fecha_inicio, fecha_fin, estado, precio_pagado, numero_renovaciones) VALUES
(9, 2, '2026-05-01', '2026-06-01', 'Vencida', 299.00, 2),  -- Diego - Mensual vencida
(10, 1, '2026-06-30', '2026-07-01', 'Vencida', 25.00, 0);  -- Valentina - Diaria vencida

-- Membresías SUSPENDIDAS
INSERT INTO membresias (usuario_id, tipo_membresia_id, fecha_inicio, fecha_fin, estado, precio_pagado, numero_renovaciones) VALUES
(11, 2, '2026-05-15', '2026-06-15', 'Suspendida', 299.00, 1),  -- Andrés - Mensual suspendida
(12, 4, '2026-05-20', '2026-06-20', 'Suspendida', 499.00, 3);  -- Camila - Premium suspendida

SELECT '✅ 20 membresías insertadas (16 activas, 2 vencidas, 2 suspendidas)' AS resultado;