-- =====================================================
-- MÓDULO 5: CONSULTAS AVANZADAS (Consultas 81-100)
-- =====================================================

-- 81. Mostrar los usuarios con el mayor gasto acumulado (subconsulta con SUM).
SELECT u.id, u.nombre, gastos.total_gastado
FROM usuarios u
JOIN (
    SELECT usuario_id, SUM(monto) AS total_gastado
    FROM pagos
    WHERE estado = 'Pagado' AND deleted_at IS NULL
    GROUP BY usuario_id
) AS gastos ON u.id = gastos.usuario_id
ORDER BY gastos.total_gastado DESC
LIMIT 5;

-- 82. Mostrar los espacios más ocupados considerando reservas confirmadas y asistencias reales.
SELECT esp.id, esp.nombre, 
       COUNT(DISTINCT r.id) AS reservas_confirmadas,
       COUNT(DISTINCT a.usuario_id) AS usuarios_asistieron
FROM espacios esp
LEFT JOIN reservas r ON esp.id = r.espacio_id AND r.estado IN ('Confirmada', 'Completada') AND r.deleted_at IS NULL
LEFT JOIN accesos a ON r.usuario_id = a.usuario_id AND DATE(a.fecha_hora) = r.fecha_reserva AND a.tipo_acceso = 'Entrada'
WHERE esp.deleted_at IS NULL
GROUP BY esp.id, esp.nombre
ORDER BY usuarios_asistieron DESC;

-- 83. Calcular el promedio de ingresos por usuario usando subconsultas.
SELECT ROUND(AVG(total_ingresos), 2) AS promedio_ingresos_por_usuario
FROM (
    SELECT usuario_id, SUM(monto) AS total_ingresos
    FROM pagos
    WHERE estado = 'Pagado' AND deleted_at IS NULL
    GROUP BY usuario_id
) AS sub;

-- 84. Listar usuarios que tienen reservas activas y facturas pendientes.
SELECT DISTINCT u.id, u.nombre
FROM usuarios u
JOIN reservas r ON u.id = r.usuario_id AND r.estado = 'Confirmada' AND r.deleted_at IS NULL
JOIN facturas f ON u.id = f.usuario_id AND f.estado IN ('Pendiente', 'Parcial') AND f.deleted_at IS NULL;

-- 85. Mostrar empresas cuyos empleados generan más del 20% de los ingresos totales.
SELECT e.nombre AS empresa, SUM(p.monto) AS ingresos_empresa,
       (SELECT SUM(monto) FROM pagos WHERE estado = 'Pagado' AND deleted_at IS NULL) AS ingresos_totales,
       ROUND((SUM(p.monto) / (SELECT SUM(monto) FROM pagos WHERE estado = 'Pagado' AND deleted_at IS NULL)) * 100, 2) AS porcentaje
FROM empresas e
JOIN usuarios u ON e.id = u.empresa_id
JOIN pagos p ON u.id = p.usuario_id
WHERE p.estado = 'Pagado' AND p.deleted_at IS NULL
GROUP BY e.id, e.nombre
HAVING porcentaje > 20;

-- 86. Mostrar el top 5 de usuarios que más usan servicios adicionales.
SELECT u.id, u.nombre, COUNT(rs.id) AS servicios_contratados
FROM usuarios u
JOIN reservas r ON u.id = r.usuario_id AND r.deleted_at IS NULL
JOIN reserva_servicios rs ON r.id = rs.reserva_id
GROUP BY u.id, u.nombre
ORDER BY servicios_contratados DESC
LIMIT 5;

-- 87. Mostrar usuarios cuyas facturas de reservas superan el promedio
SELECT u.nombre, f.total AS total_factura, f.numero_factura
FROM usuarios u
JOIN facturas f ON u.id = f.usuario_id
JOIN pagos p ON f.pago_id = p.id
WHERE p.concepto = 'Reserva' 
  AND f.total > (SELECT AVG(total) FROM facturas WHERE deleted_at IS NULL)
  AND f.deleted_at IS NULL AND p.deleted_at IS NULL;

-- 88. Calcular el porcentaje de ocupación global del coworking por mes.
-- (Asumiendo 12 espacios y 12 horas de operación por día)
SELECT DATE_FORMAT(r.fecha_reserva, '%Y-%m') AS mes,
       COUNT(DISTINCT r.id) AS total_reservas,
       COUNT(DISTINCT r.fecha_reserva) * 12 AS horas_disponibles_totales, -- 12 espacios * 1 día (simplificado)
       SUM(TIMESTAMPDIFF(HOUR, r.hora_inicio, r.hora_fin)) AS horas_reservadas,
       ROUND((SUM(TIMESTAMPDIFF(HOUR, r.hora_inicio, r.hora_fin)) / (COUNT(DISTINCT r.fecha_reserva) * 12 * 12)) * 100, 2) AS porcentaje_ocupacion_global
FROM reservas r
WHERE r.estado IN ('Confirmada', 'Completada') AND r.deleted_at IS NULL
GROUP BY DATE_FORMAT(r.fecha_reserva, '%Y-%m');

-- 89. Mostrar usuarios que tienen más horas de reserva que el promedio del sistema.
SELECT u.id, u.nombre, SUM(TIMESTAMPDIFF(HOUR, r.hora_inicio, r.hora_fin)) AS horas_totales
FROM usuarios u
JOIN reservas r ON u.id = r.usuario_id
WHERE r.estado IN ('Confirmada', 'Completada') AND r.deleted_at IS NULL
GROUP BY u.id, u.nombre
HAVING horas_totales > (
    SELECT AVG(horas_usuario) FROM (
        SELECT SUM(TIMESTAMPDIFF(HOUR, hora_inicio, hora_fin)) AS horas_usuario
        FROM reservas
        WHERE estado IN ('Confirmada', 'Completada') AND deleted_at IS NULL
        GROUP BY usuario_id
    ) AS sub
);

-- 90. Mostrar el top 3 de salas más usadas en el último trimestre.
SELECT esp.nombre, COUNT(r.id) AS usos
FROM espacios esp
JOIN reservas r ON esp.id = r.espacio_id
WHERE r.fecha_reserva >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH) 
  AND r.estado IN ('Confirmada', 'Completada') AND r.deleted_at IS NULL
GROUP BY esp.id, esp.nombre
ORDER BY usos DESC
LIMIT 3;

-- 91. Calcular ingresos promedio por tipo de membresía (agrupado con AVG).
SELECT tm.nombre AS tipo_membresia, AVG(m.precio_pagado) AS ingreso_promedio
FROM tipos_membresia tm
JOIN membresias m ON tm.id = m.tipo_membresia_id
WHERE m.deleted_at IS NULL
GROUP BY tm.id, tm.nombre;

-- 92. Mostrar usuarios que pagan solo con un método de pago (subconsulta).
SELECT u.id, u.nombre, p.metodo_pago
FROM usuarios u
JOIN pagos p ON u.id = p.usuario_id
WHERE p.estado = 'Pagado' AND p.deleted_at IS NULL
GROUP BY u.id, u.nombre, p.metodo_pago
HAVING COUNT(DISTINCT p.metodo_pago) = 1;

-- 93. Mostrar reservas canceladas por usuarios que nunca asistieron.
SELECT r.id, u.nombre, r.fecha_reserva, r.motivo
FROM reservas r
JOIN usuarios u ON r.usuario_id = u.id
WHERE r.estado = 'Cancelada' 
  AND r.deleted_at IS NULL
  AND NOT EXISTS (
      SELECT 1 FROM accesos a 
      WHERE a.usuario_id = r.usuario_id AND a.tipo_acceso = 'Entrada'
  );

-- 94. Mostrar facturas con pagos parciales y calcular saldo pendiente.
SELECT f.numero_factura, u.nombre, f.total, f.saldo_pendiente, 
       (f.total - f.saldo_pendiente) AS monto_pagado
FROM facturas f
JOIN usuarios u ON f.usuario_id = u.id
WHERE f.estado = 'Parcial' AND f.deleted_at IS NULL;

-- 95. Calcular la facturación total de cada empresa y ordenarla de mayor a menor.
SELECT e.nombre AS empresa, SUM(f.total) AS facturacion_total
FROM empresas e
JOIN usuarios u ON e.id = u.empresa_id
JOIN facturas f ON u.id = f.usuario_id
WHERE f.deleted_at IS NULL AND u.deleted_at IS NULL
GROUP BY e.id, e.nombre
ORDER BY facturacion_total DESC;

-- 96. Identificar usuarios que superan en reservas al promedio de su empresa.
SELECT u.id, u.nombre, e.nombre AS empresa, COUNT(r.id) AS reservas_usuario
FROM usuarios u
JOIN empresas e ON u.empresa_id = e.id
JOIN reservas r ON u.id = r.usuario_id AND r.deleted_at IS NULL
GROUP BY u.id, u.nombre, e.id, e.nombre
HAVING COUNT(r.id) > (
    SELECT AVG(reservas_emp) FROM (
        SELECT COUNT(r2.id) AS reservas_emp
        FROM usuarios u2
        JOIN reservas r2 ON u2.id = r2.usuario_id AND r2.deleted_at IS NULL
        WHERE u2.empresa_id = e.id
        GROUP BY u2.id
    ) AS sub
);

-- 97. Mostrar las 3 empresas con más empleados activos en el coworking.
SELECT e.nombre AS empresa, COUNT(u.id) AS empleados_activos
FROM empresas e
JOIN usuarios u ON e.id = u.empresa_id
JOIN membresias m ON u.id = m.usuario_id AND m.estado = 'Activa'
WHERE u.deleted_at IS NULL AND m.deleted_at IS NULL
GROUP BY e.id, e.nombre
ORDER BY empleados_activos DESC
LIMIT 3;

-- 98. Calcular el porcentaje de usuarios activos frente al total de registrados.
SELECT 
    (SELECT COUNT(*) FROM usuarios WHERE deleted_at IS NULL) AS total_registrados,
    (SELECT COUNT(DISTINCT u.id) FROM usuarios u JOIN membresias m ON u.id = m.usuario_id WHERE m.estado = 'Activa' AND u.deleted_at IS NULL AND m.deleted_at IS NULL) AS usuarios_activos,
    ROUND(
        (SELECT COUNT(DISTINCT u.id) FROM usuarios u JOIN membresias m ON u.id = m.usuario_id WHERE m.estado = 'Activa' AND u.deleted_at IS NULL AND m.deleted_at IS NULL) / 
        (SELECT COUNT(*) FROM usuarios WHERE deleted_at IS NULL) * 100, 2
    ) AS porcentaje_activos;

-- 99. Mostrar ingresos mensuales acumulados con función de ventana (OVER)
WITH ingresos_mensuales AS (
    SELECT DATE_FORMAT(fecha_pago, '%Y-%m') AS mes, SUM(monto) AS ingresos_mes
    FROM pagos
    WHERE estado = 'Pagado' AND deleted_at IS NULL
    GROUP BY DATE_FORMAT(fecha_pago, '%Y-%m')
)
SELECT mes, ingresos_mes,
       SUM(ingresos_mes) OVER (ORDER BY mes) AS ingresos_acumulados
FROM ingresos_mensuales
ORDER BY mes;

-- 100. Mostrar usuarios con más de 10 reservas, más de $500 en facturación y membresía activa (con múltiples joins).
SELECT u.id, u.nombre, COUNT(r.id) AS total_reservas, SUM(f.total) AS total_facturado
FROM usuarios u
JOIN membresias m ON u.id = m.usuario_id AND m.estado = 'Activa' AND m.deleted_at IS NULL
JOIN reservas r ON u.id = r.usuario_id AND r.deleted_at IS NULL
JOIN facturas f ON u.id = f.usuario_id AND f.deleted_at IS NULL
WHERE u.deleted_at IS NULL
GROUP BY u.id, u.nombre
HAVING COUNT(r.id) > 10 AND SUM(f.total) > 500;