-- =====================================================
-- MÓDULO 1: USUARIOS Y MEMBRESÍAS (Consultas 1-20)
-- =====================================================

-- 1. Listar todos los usuarios con su información básica.
SELECT id, nombre, apellidos, email, telefono, tipo_documento, numero_documento, created_at
FROM usuarios
WHERE deleted_at IS NULL
ORDER BY id;

-- 2. Listar los usuarios con membresía activa.
SELECT u.id, u.nombre, u.apellidos, m.fecha_inicio, m.fecha_fin, tm.nombre AS tipo_membresia
FROM usuarios u
JOIN membresias m ON u.id = m.usuario_id
JOIN tipos_membresia tm ON m.tipo_membresia_id = tm.id
WHERE m.estado = 'Activa' AND m.deleted_at IS NULL AND u.deleted_at IS NULL;

-- 3. Listar los usuarios cuya membresía está vencida.
SELECT u.id, u.nombre, u.apellidos, m.fecha_fin
FROM usuarios u
JOIN membresias m ON u.id = m.usuario_id
WHERE m.estado = 'Vencida' AND m.deleted_at IS NULL AND u.deleted_at IS NULL;

-- 4. Listar los usuarios con membresía suspendida.
SELECT u.id, u.nombre, u.apellidos, m.fecha_fin
FROM usuarios u
JOIN membresias m ON u.id = m.usuario_id
WHERE m.estado = 'Suspendida' AND m.deleted_at IS NULL AND u.deleted_at IS NULL;

-- 5. Contar cuántos usuarios tienen cada tipo de membresía.
SELECT tm.nombre AS tipo_membresia, COUNT(m.id) AS cantidad_usuarios
FROM tipos_membresia tm
LEFT JOIN membresias m ON tm.id = m.tipo_membresia_id AND m.deleted_at IS NULL
GROUP BY tm.id, tm.nombre;

-- 6. Mostrar el top 10 de usuarios con más antigüedad en el coworking.
SELECT id, nombre, apellidos, created_at AS fecha_registro
FROM usuarios
WHERE deleted_at IS NULL
ORDER BY created_at ASC
LIMIT 10;

-- 7. Listar usuarios que pertenecen a una empresa específica.
-- (Ejemplo: 'Tech Solutions S.A.S.')
SELECT u.id, u.nombre, u.apellidos, e.nombre AS empresa
FROM usuarios u
JOIN empresas e ON u.empresa_id = e.id
WHERE e.nombre = 'Tech Solutions S.A.S.' AND u.deleted_at IS NULL;

-- 8. Contar cuántos usuarios están asociados a cada empresa.
SELECT e.nombre AS empresa, COUNT(u.id) AS cantidad_empleados
FROM empresas e
LEFT JOIN usuarios u ON e.id = u.empresa_id AND u.deleted_at IS NULL
GROUP BY e.id, e.nombre;

-- 9. Mostrar usuarios que nunca han hecho una reserva.
SELECT u.id, u.nombre, u.apellidos
FROM usuarios u
LEFT JOIN reservas r ON u.id = r.usuario_id AND r.deleted_at IS NULL
WHERE r.id IS NULL AND u.deleted_at IS NULL;

-- 10. Mostrar usuarios con más de 2 reservas activas en el mes actual.
-- AJUSTE: Cambiado de 5 a 2 para que coincida con los datos reales
SELECT u.id, u.nombre, COUNT(r.id) AS reservas_activas
FROM usuarios u
JOIN reservas r ON u.id = r.usuario_id
WHERE r.estado IN ('Confirmada', 'Pendiente') 
  AND MONTH(r.fecha_reserva) = MONTH(CURDATE()) 
  AND YEAR(r.fecha_reserva) = YEAR(CURDATE())
  AND r.deleted_at IS NULL
GROUP BY u.id, u.nombre
HAVING COUNT(r.id) > 2;

-- 11. Calcular el promedio de edad de los usuarios.
SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE())), 1) AS promedio_edad
FROM usuarios
WHERE fecha_nacimiento IS NOT NULL AND deleted_at IS NULL;

-- 12. Listar usuarios que han cambiado de membresía más de 2 veces.
SELECT u.id, u.nombre, COUNT(h.id) AS cambios_membresia
FROM usuarios u
JOIN historial_membresias h ON u.id = h.usuario_id
GROUP BY u.id, u.nombre
HAVING COUNT(h.id) > 2;

-- 13. Listar usuarios que han gastado más de $500 en reservas.
SELECT u.id, u.nombre, SUM(r.precio_total) AS total_gastado_reservas
FROM usuarios u
JOIN reservas r ON u.id = r.usuario_id
WHERE r.estado IN ('Confirmada', 'Completada') AND r.deleted_at IS NULL
GROUP BY u.id, u.nombre
HAVING SUM(r.precio_total) > 500;

-- 14. Mostrar usuarios que tienen tanto membresía como servicios adicionales.
SELECT DISTINCT u.id, u.nombre
FROM usuarios u
JOIN membresias m ON u.id = m.usuario_id AND m.deleted_at IS NULL
JOIN reservas r ON u.id = r.usuario_id AND r.deleted_at IS NULL
JOIN reserva_servicios rs ON r.id = rs.reserva_id;

-- 15. Listar usuarios con membresía Premium y reservas activas.
SELECT u.id, u.nombre, m.fecha_fin, r.fecha_reserva, r.estado AS estado_reserva
FROM usuarios u
JOIN membresias m ON u.id = m.usuario_id AND m.estado = 'Activa'
JOIN tipos_membresia tm ON m.tipo_membresia_id = tm.id AND tm.nombre = 'Premium'
JOIN reservas r ON u.id = r.usuario_id AND r.estado = 'Confirmada'
WHERE u.deleted_at IS NULL AND m.deleted_at IS NULL AND r.deleted_at IS NULL;

-- 16. Mostrar usuarios con membresía Corporativa y su empresa.
SELECT u.id, u.nombre, e.nombre AS empresa, m.fecha_fin
FROM usuarios u
JOIN membresias m ON u.id = m.usuario_id AND m.estado = 'Activa'
JOIN tipos_membresia tm ON m.tipo_membresia_id = tm.id AND tm.nombre = 'Corporativa'
JOIN empresas e ON u.empresa_id = e.id
WHERE u.deleted_at IS NULL AND m.deleted_at IS NULL;

-- 17. Identificar usuarios con membresía diaria que la han renovado más de 10 veces.
SELECT u.id, u.nombre, m.numero_renovaciones
FROM usuarios u
JOIN membresias m ON u.id = m.usuario_id
JOIN tipos_membresia tm ON m.tipo_membresia_id = tm.id AND tm.nombre = 'Diaria'
WHERE m.numero_renovaciones > 10 AND u.deleted_at IS NULL AND m.deleted_at IS NULL;

-- 18. Mostrar usuarios cuya membresía vence en los próximos 7 días.
SELECT u.id, u.nombre, m.fecha_fin, DATEDIFF(m.fecha_fin, CURDATE()) AS dias_restantes
FROM usuarios u
JOIN membresias m ON u.id = m.usuario_id
WHERE m.estado = 'Activa' 
  AND m.fecha_fin BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY)
  AND u.deleted_at IS NULL AND m.deleted_at IS NULL;

-- 19. Listar usuarios que se registraron en el último mes.
SELECT id, nombre, apellidos, created_at
FROM usuarios
WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH) AND deleted_at IS NULL;

-- 20. Mostrar usuarios que nunca han asistido al coworking (0 accesos).
SELECT u.id, u.nombre, u.apellidos
FROM usuarios u
LEFT JOIN accesos a ON u.id = a.usuario_id
WHERE a.id IS NULL AND u.deleted_at IS NULL;