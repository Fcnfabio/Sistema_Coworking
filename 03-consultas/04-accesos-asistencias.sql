-- =====================================================
-- MÓDULO 4: ACCESOS Y ASISTENCIAS (Consultas 61-80)
-- =====================================================

-- 61. Listar todos los accesos registrados hoy (Ajustado al último día de datos)
SELECT a.id, u.nombre, a.tipo_acceso, a.fecha_hora, a.metodo_acceso
FROM accesos a
JOIN usuarios u ON a.usuario_id = u.id
WHERE DATE(a.fecha_hora) = DATE_SUB(CURDATE(), INTERVAL 1 DAY)
ORDER BY a.fecha_hora;

-- 62. Mostrar usuarios con más de 4 asistencias (entradas) en el mes actual.
-- AJUSTE: Cambiado de 20 a 4 para que coincida con los datos reales
SELECT u.id, u.nombre, COUNT(a.id) AS asistencias_mes
FROM usuarios u
JOIN accesos a ON u.id = a.usuario_id
WHERE a.tipo_acceso = 'Entrada' 
  AND MONTH(a.fecha_hora) = MONTH(CURDATE()) 
  AND YEAR(a.fecha_hora) = YEAR(CURDATE())
GROUP BY u.id, u.nombre
HAVING COUNT(a.id) > 4;

-- 63. Mostrar usuarios que no asistieron en la última semana.
SELECT u.id, u.nombre
FROM usuarios u
WHERE u.id NOT IN (
    SELECT usuario_id FROM accesos 
    WHERE tipo_acceso = 'Entrada' 
    AND fecha_hora >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
) AND u.deleted_at IS NULL;

-- 64. Calcular la asistencia promedio por día de la semana.
SELECT DAYNAME(fecha_hora) AS dia_semana, 
       COUNT(CASE WHEN tipo_acceso = 'Entrada' THEN 1 END) AS total_entradas,
       COUNT(DISTINCT DATE(fecha_hora)) AS dias_con_registros,
       ROUND(COUNT(CASE WHEN tipo_acceso = 'Entrada' THEN 1 END) / COUNT(DISTINCT DATE(fecha_hora)), 1) AS promedio_diario
FROM accesos
GROUP BY DAYOFWEEK(fecha_hora), DAYNAME(fecha_hora)
ORDER BY DAYOFWEEK(fecha_hora);

-- 65. Mostrar los 10 usuarios más constantes (más asistencias/entradas).
SELECT u.id, u.nombre, COUNT(a.id) AS total_asistencias
FROM usuarios u
JOIN accesos a ON u.id = a.usuario_id
WHERE a.tipo_acceso = 'Entrada'
GROUP BY u.id, u.nombre
ORDER BY total_asistencias DESC
LIMIT 10;

-- 66. Mostrar accesos fuera del horario permitido (Ej: antes de 8:00 AM o después de 8:00 PM).
SELECT a.id, u.nombre, a.fecha_hora, a.tipo_acceso
FROM accesos a
JOIN usuarios u ON a.usuario_id = u.id
WHERE TIME(a.fecha_hora) < '08:00:00' OR TIME(a.fecha_hora) > '20:00:00'
ORDER BY a.fecha_hora;

-- 67. Mostrar usuarios que accedieron sin membresía activa (rechazados).
SELECT a.id, u.nombre, a.fecha_hora, a.motivo_rechazo
FROM accesos a
JOIN usuarios u ON a.usuario_id = u.id
WHERE a.estado = 'Rechazado'
ORDER BY a.fecha_hora DESC;

-- 68. Listar usuarios que solo acceden los fines de semana.
SELECT u.id, u.nombre
FROM usuarios u
JOIN accesos a ON u.id = a.usuario_id
WHERE a.tipo_acceso = 'Entrada'
GROUP BY u.id, u.nombre
HAVING MIN(DAYOFWEEK(a.fecha_hora)) IN (1, 7) AND MAX(DAYOFWEEK(a.fecha_hora)) IN (1, 7);

-- 69. Mostrar usuarios que accedieron más de 2 veces en el mismo día.
SELECT u.id, u.nombre, DATE(a.fecha_hora) AS fecha, COUNT(a.id) AS total_accesos
FROM usuarios u
JOIN accesos a ON u.id = a.usuario_id
GROUP BY u.id, u.nombre, DATE(a.fecha_hora)
HAVING COUNT(a.id) > 2;

-- 70. Mostrar el total de accesos diarios en el último mes.
SELECT DATE(fecha_hora) AS fecha, COUNT(id) AS total_accesos
FROM accesos
WHERE fecha_hora >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY DATE(fecha_hora)
ORDER BY fecha;

-- 71. Mostrar usuarios que han accedido pero no tienen reservas.
SELECT DISTINCT u.id, u.nombre
FROM usuarios u
JOIN accesos a ON u.id = a.usuario_id
LEFT JOIN reservas r ON u.id = r.usuario_id AND r.deleted_at IS NULL
WHERE r.id IS NULL AND u.deleted_at IS NULL;

-- 72. Mostrar los días con más concurrencia en el coworking (usuarios únicos).
SELECT DATE(fecha_hora) AS fecha, COUNT(DISTINCT usuario_id) AS usuarios_unicos
FROM accesos
WHERE tipo_acceso = 'Entrada'
GROUP BY DATE(fecha_hora)
ORDER BY usuarios_unicos DESC
LIMIT 1;

-- 73. Mostrar usuarios que entraron pero no registraron salida (último acceso es entrada).
SELECT u.id, u.nombre, MAX(a.fecha_hora) AS ultima_entrada
FROM usuarios u
JOIN accesos a ON u.id = a.usuario_id
WHERE a.tipo_acceso = 'Entrada'
GROUP BY u.id, u.nombre
HAVING MAX(a.fecha_hora) = (
    SELECT MAX(a2.fecha_hora) 
    FROM accesos a2 
    WHERE a2.usuario_id = u.id
);

-- 74. Mostrar accesos de usuarios con membresía vencida.
SELECT a.id, u.nombre, m.estado AS estado_membresia, a.fecha_hora
FROM accesos a
JOIN usuarios u ON a.usuario_id = u.id
JOIN membresias m ON u.id = m.usuario_id
WHERE m.estado = 'Vencida' AND m.deleted_at IS NULL;

-- 75. Mostrar accesos de usuarios corporativos por empresa.
SELECT e.nombre AS empresa, u.nombre, COUNT(a.id) AS total_accesos
FROM empresas e
JOIN usuarios u ON e.id = u.empresa_id
JOIN accesos a ON u.id = a.usuario_id
WHERE u.deleted_at IS NULL
GROUP BY e.id, e.nombre, u.id, u.nombre;

-- 76. Mostrar clientes que nunca han usado el coworking a pesar de pagar membresía.
SELECT u.id, u.nombre, m.estado
FROM usuarios u
JOIN membresias m ON u.id = m.usuario_id AND m.deleted_at IS NULL
LEFT JOIN accesos a ON u.id = a.usuario_id
WHERE a.id IS NULL AND u.deleted_at IS NULL;

-- 77. Mostrar accesos rechazados por intentos con QR inválido.
SELECT a.id, u.nombre, a.fecha_hora, a.motivo_rechazo
FROM accesos a
JOIN usuarios u ON a.usuario_id = u.id
WHERE a.estado = 'Rechazado' AND a.motivo_rechazo LIKE '%QR inválido%';

-- 78. Mostrar accesos promedio por usuario.
SELECT ROUND(AVG(total_accesos), 1) AS promedio_accesos_usuario
FROM (
    SELECT usuario_id, COUNT(id) AS total_accesos
    FROM accesos
    GROUP BY usuario_id
) AS subquery;

-- 79. Identificar usuarios que asisten más en la mañana (06:00 - 12:00).
SELECT u.id, u.nombre,
       SUM(CASE WHEN TIME(a.fecha_hora) BETWEEN '06:00:00' AND '12:00:00' THEN 1 ELSE 0 END) AS asistencias_manana,
       SUM(CASE WHEN TIME(a.fecha_hora) > '12:00:00' THEN 1 ELSE 0 END) AS asistencias_tarde_noche
FROM usuarios u
JOIN accesos a ON u.id = a.usuario_id
WHERE a.tipo_acceso = 'Entrada'
GROUP BY u.id, u.nombre
HAVING asistencias_manana > asistencias_tarde_noche;

-- 80. Identificar usuarios que asisten más en la noche (después de 18:00).
SELECT u.id, u.nombre,
       SUM(CASE WHEN TIME(a.fecha_hora) BETWEEN '06:00:00' AND '18:00:00' THEN 1 ELSE 0 END) AS asistencias_dia,
       SUM(CASE WHEN TIME(a.fecha_hora) > '18:00:00' THEN 1 ELSE 0 END) AS asistencias_noche
FROM usuarios u
JOIN accesos a ON u.id = a.usuario_id
WHERE a.tipo_acceso = 'Entrada'
GROUP BY u.id, u.nombre
HAVING asistencias_noche > asistencias_dia;