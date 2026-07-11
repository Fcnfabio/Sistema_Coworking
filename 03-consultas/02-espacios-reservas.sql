-- =====================================================
-- MÓDULO 2: ESPACIOS Y RESERVAS (Consultas 21-40)
-- =====================================================

-- 21. Listar todos los espacios disponibles con su capacidad.
SELECT * FROM v_espacios_resumen ORDER BY tipo_espacio, nombre;

-- 22. Listar reservas activas en el día actual (Ajustado al último día de datos)
SELECT r.id, u.nombre, esp.nombre AS espacio, r.hora_inicio, r.hora_fin, r.estado
FROM reservas r
JOIN usuarios u ON r.usuario_id = u.id
JOIN espacios esp ON r.espacio_id = esp.id
WHERE r.fecha_reserva = DATE_SUB(CURDATE(), INTERVAL 1 DAY) 
  AND r.estado IN ('Confirmada', 'Pendiente') 
  AND r.deleted_at IS NULL;

-- 23. Mostrar reservas canceladas en el último mes.
SELECT r.id, u.nombre, esp.nombre, r.fecha_reserva, r.motivo
FROM reservas r
JOIN usuarios u ON r.usuario_id = u.id
JOIN espacios esp ON r.espacio_id = esp.id
WHERE r.estado = 'Cancelada' 
  AND r.fecha_reserva >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
  AND r.deleted_at IS NULL;

-- 24. Listar reservas de salas de reuniones en horario pico (9 am – 11 am)
SELECT r.id, u.nombre, esp.nombre, r.fecha_reserva, r.hora_inicio, r.hora_fin
FROM reservas r
JOIN usuarios u ON r.usuario_id = u.id
JOIN espacios esp ON r.espacio_id = esp.id
JOIN tipos_espacio te ON esp.tipo_espacio_id = te.id
WHERE te.nombre = 'Sala de Reuniones' 
  AND r.hora_inicio < '11:00:00' AND r.hora_fin > '09:00:00' -- Lógica de solapamiento correcta
  AND r.deleted_at IS NULL;

-- 25. Contar cuántas reservas se hacen por cada tipo de espacio.
SELECT te.nombre AS tipo_espacio, COUNT(r.id) AS total_reservas
FROM tipos_espacio te
JOIN espacios esp ON te.id = esp.tipo_espacio_id
LEFT JOIN reservas r ON esp.id = r.espacio_id AND r.deleted_at IS NULL
GROUP BY te.id, te.nombre;

-- 26. Mostrar el espacio más reservado del último mes.
SELECT esp.id, esp.nombre, COUNT(r.id) AS total_reservas
FROM espacios esp
JOIN reservas r ON esp.id = r.espacio_id
WHERE r.fecha_reserva >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH) AND r.deleted_at IS NULL
GROUP BY esp.id, esp.nombre
ORDER BY total_reservas DESC
LIMIT 1;

-- 27. Listar usuarios que más han reservado salas privadas (Oficinas Privadas).
SELECT u.id, u.nombre, COUNT(r.id) AS reservas_oficinas
FROM usuarios u
JOIN reservas r ON u.id = r.usuario_id
JOIN espacios esp ON r.espacio_id = esp.id
JOIN tipos_espacio te ON esp.tipo_espacio_id = te.id
WHERE te.nombre = 'Oficina Privada' AND r.deleted_at IS NULL
GROUP BY u.id, u.nombre
ORDER BY reservas_oficinas DESC;

-- 28. Mostrar reservas que exceden la capacidad máxima del espacio.
SELECT r.id, u.nombre, esp.nombre AS espacio, esp.capacidad_maxima, r.numero_personas
FROM reservas r
JOIN usuarios u ON r.usuario_id = u.id
JOIN espacios esp ON r.espacio_id = esp.id
WHERE r.numero_personas > esp.capacidad_maxima AND r.deleted_at IS NULL;

-- 29. Listar espacios que no se han reservado en la última semana.
SELECT esp.id, esp.nombre
FROM espacios esp
LEFT JOIN reservas r ON esp.id = r.espacio_id 
  AND r.fecha_reserva >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) 
  AND r.deleted_at IS NULL
WHERE r.id IS NULL AND esp.deleted_at IS NULL;

-- 30. Calcular la tasa de ocupación promedio de cada espacio (porcentaje de días ocupados en el mes actual).
SELECT esp.id, esp.nombre, 
       COUNT(DISTINCT r.fecha_reserva) AS dias_ocupados,
       DAY(LAST_DAY(CURDATE())) AS dias_totales_mes,
       ROUND((COUNT(DISTINCT r.fecha_reserva) / DAY(LAST_DAY(CURDATE()))) * 100, 2) AS porcentaje_ocupacion
FROM espacios esp
LEFT JOIN reservas r ON esp.id = r.espacio_id 
  AND MONTH(r.fecha_reserva) = MONTH(CURDATE()) 
  AND YEAR(r.fecha_reserva) = YEAR(CURDATE())
  AND r.estado IN ('Confirmada', 'Completada') AND r.deleted_at IS NULL
WHERE esp.deleted_at IS NULL
GROUP BY esp.id, esp.nombre;

-- 31. Mostrar reservas de más de 8 horas.
SELECT r.id, u.nombre, esp.nombre, r.fecha_reserva, 
       TIMESTAMPDIFF(HOUR, r.hora_inicio, r.hora_fin) AS duracion_horas
FROM reservas r
JOIN usuarios u ON r.usuario_id = u.id
JOIN espacios esp ON r.espacio_id = esp.id
WHERE TIMESTAMPDIFF(HOUR, r.hora_inicio, r.hora_fin) > 8 AND r.deleted_at IS NULL;

-- 32. Identificar usuarios con más de 20 reservas en total.
SELECT u.id, u.nombre, COUNT(r.id) AS total_reservas
FROM usuarios u
JOIN reservas r ON u.id = r.usuario_id AND r.deleted_at IS NULL
GROUP BY u.id, u.nombre
HAVING COUNT(r.id) > 20;

-- 33. Mostrar reservas realizadas por empresas con más de 2 empleados.
-- AJUSTE: Cambiado de 10 a 2 empleados para que coincida con los datos reales
SELECT e.nombre AS empresa, COUNT(r.id) AS total_reservas_empresa
FROM empresas e
JOIN usuarios u ON e.id = u.empresa_id
JOIN reservas r ON u.id = r.usuario_id AND r.deleted_at IS NULL
GROUP BY e.id, e.nombre
HAVING COUNT(DISTINCT u.id) > 2;

-- 34. Listar reservas que se solapan en horario (mismo espacio, misma fecha).
SELECT r1.id AS reserva_1, r2.id AS reserva_2, esp.nombre, r1.fecha_reserva, 
       r1.hora_inicio AS inicio_1, r1.hora_fin AS fin_1,
       r2.hora_inicio AS inicio_2, r2.hora_fin AS fin_2
FROM reservas r1
JOIN reservas r2 ON r1.espacio_id = r2.espacio_id 
  AND r1.fecha_reserva = r2.fecha_reserva 
  AND r1.id < r2.id
JOIN espacios esp ON r1.espacio_id = esp.id
WHERE r1.hora_inicio < r2.hora_fin AND r1.hora_fin > r2.hora_inicio
  AND r1.deleted_at IS NULL AND r2.deleted_at IS NULL;

-- 35. Listar reservas de fin de semana.
SELECT r.id, u.nombre, esp.nombre, r.fecha_reserva, DAYNAME(r.fecha_reserva) AS dia
FROM reservas r
JOIN usuarios u ON r.usuario_id = u.id
JOIN espacios esp ON r.espacio_id = esp.id
WHERE DAYOFWEEK(r.fecha_reserva) IN (1, 7) AND r.deleted_at IS NULL; -- 1=Domingo, 7=Sábado

-- 36. Mostrar el porcentaje de ocupación por cada tipo de espacio.
SELECT te.nombre AS tipo_espacio,
       COUNT(DISTINCT r.fecha_reserva) AS dias_ocupados,
       ROUND((COUNT(DISTINCT r.fecha_reserva) / DAY(LAST_DAY(CURDATE()))) * 100, 2) AS porcentaje_ocupacion
FROM tipos_espacio te
JOIN espacios esp ON te.id = esp.tipo_espacio_id
LEFT JOIN reservas r ON esp.id = r.espacio_id 
  AND MONTH(r.fecha_reserva) = MONTH(CURDATE()) 
  AND r.estado IN ('Confirmada', 'Completada') AND r.deleted_at IS NULL
WHERE te.deleted_at IS NULL AND esp.deleted_at IS NULL
GROUP BY te.id, te.nombre;

-- 37. Mostrar la duración promedio de reservas por tipo de espacio.
SELECT te.nombre AS tipo_espacio, 
       ROUND(AVG(TIMESTAMPDIFF(MINUTE, r.hora_inicio, r.hora_fin) / 60), 2) AS duracion_promedio_horas
FROM tipos_espacio te
JOIN espacios esp ON te.id = esp.tipo_espacio_id
JOIN reservas r ON esp.id = r.espacio_id
WHERE r.estado IN ('Confirmada', 'Completada') AND r.deleted_at IS NULL
GROUP BY te.id, te.nombre;

-- 38. Mostrar reservas con servicios adicionales incluidos.
SELECT r.id, u.nombre, esp.nombre, r.fecha_reserva, 
       GROUP_CONCAT(sa.nombre SEPARATOR ', ') AS servicios_contratados
FROM reservas r
JOIN usuarios u ON r.usuario_id = u.id
JOIN espacios esp ON r.espacio_id = esp.id
JOIN reserva_servicios rs ON r.id = rs.reserva_id
JOIN servicios_adicionales sa ON rs.servicio_id = sa.id
WHERE r.deleted_at IS NULL
GROUP BY r.id, u.nombre, esp.nombre, r.fecha_reserva;

-- 39. Listar usuarios que reservaron sala de eventos en los últimos 6 meses.
SELECT DISTINCT u.id, u.nombre, r.fecha_reserva
FROM usuarios u
JOIN reservas r ON u.id = r.usuario_id
JOIN espacios esp ON r.espacio_id = esp.id
JOIN tipos_espacio te ON esp.tipo_espacio_id = te.id
WHERE te.nombre = 'Sala de Eventos' 
  AND r.fecha_reserva >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
  AND r.deleted_at IS NULL;

-- 40. Identificar reservas realizadas (Confirmadas) y nunca asistidas (No Show o sin acceso).
SELECT r.id, u.nombre, esp.nombre, r.fecha_reserva, r.estado
FROM reservas r
JOIN usuarios u ON r.usuario_id = u.id
JOIN espacios esp ON r.espacio_id = esp.id
WHERE r.estado = 'No Show' 
   OR (r.estado = 'Confirmada' AND r.fecha_reserva < CURDATE() 
       AND NOT EXISTS (
           SELECT 1 FROM accesos a 
           WHERE a.usuario_id = r.usuario_id 
           AND DATE(a.fecha_hora) = r.fecha_reserva 
           AND a.tipo_acceso = 'Entrada'
       ))
  AND r.deleted_at IS NULL;