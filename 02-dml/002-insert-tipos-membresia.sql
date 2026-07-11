-- =====================================================
-- DATOS INICIALES: TIPOS DE MEMBRESÍA
-- 4 tipos: Diaria, Mensual, Corporativa, Premium
-- =====================================================

INSERT INTO tipos_membresia (nombre, descripcion, precio, duracion_dias) VALUES
('Diaria', 'Acceso por un día completo a cualquier espacio flexible', 25.00, 1),
('Mensual', 'Acceso ilimitado durante 30 días a espacios flexibles', 299.00, 30),
('Corporativa', 'Plan para empresas con múltiples empleados y beneficios exclusivos', 249.00, 30),
('Premium', 'Acceso VIP a todos los espacios incluyendo salas privadas y eventos', 499.00, 30);

SELECT '✅ 4 tipos de membresía insertados' AS resultado;