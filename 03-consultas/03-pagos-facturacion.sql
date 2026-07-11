-- =====================================================
-- MÓDULO 3: PAGOS Y FACTURACIÓN (Consultas 41-60)
-- =====================================================

-- 41. Listar todos los pagos realizados con método tarjeta.
SELECT p.id, u.nombre, p.monto, p.fecha_pago, p.referencia_transaccion
FROM pagos p
JOIN usuarios u ON p.usuario_id = u.id
WHERE p.metodo_pago = 'Tarjeta' AND p.estado = 'Pagado' AND p.deleted_at IS NULL;

-- 42. Listar pagos pendientes de usuarios.
SELECT p.id, u.nombre, p.monto, p.fecha_pago, p.concepto
FROM pagos p
JOIN usuarios u ON p.usuario_id = u.id
WHERE p.estado = 'Pendiente' AND p.deleted_at IS NULL;

-- 43. Mostrar pagos cancelados en los últimos 3 meses.
SELECT p.id, u.nombre, p.monto, p.fecha_pago, p.concepto
FROM pagos p
JOIN usuarios u ON p.usuario_id = u.id
WHERE p.estado = 'Cancelado' 
  AND p.fecha_pago >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
  AND p.deleted_at IS NULL;

-- 44. Listar facturas generadas por membresías.
SELECT f.numero_factura, u.nombre, f.total, f.fecha_emision
FROM facturas f
JOIN usuarios u ON f.usuario_id = u.id
JOIN pagos p ON f.pago_id = p.id
WHERE p.concepto = 'Membresia' AND f.deleted_at IS NULL;

-- 45. Listar facturas generadas por reservas.
SELECT f.numero_factura, u.nombre, f.total, f.fecha_emision
FROM facturas f
JOIN usuarios u ON f.usuario_id = u.id
JOIN pagos p ON f.pago_id = p.id
WHERE p.concepto = 'Reserva' AND f.deleted_at IS NULL;

-- 46. Mostrar el total de ingresos por membresías en el último mes.
SELECT SUM(p.monto) AS ingresos_membresias_mes
FROM pagos p
WHERE p.concepto = 'Membresia' 
  AND p.estado = 'Pagado' 
  AND p.fecha_pago >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
  AND p.deleted_at IS NULL;

-- 47. Mostrar el total de ingresos por reservas en el último mes.
SELECT SUM(p.monto) AS ingresos_reservas_mes
FROM pagos p
WHERE p.concepto = 'Reserva' 
  AND p.estado = 'Pagado' 
  AND p.fecha_pago >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
  AND p.deleted_at IS NULL;

-- 48. Mostrar el total de ingresos por servicios adicionales.
SELECT SUM(rs.cantidad * rs.precio_unitario) AS ingresos_servicios_adicionales
FROM reserva_servicios rs
JOIN reservas r ON rs.reserva_id = r.id
WHERE r.estado IN ('Confirmada', 'Completada') AND r.deleted_at IS NULL;

-- 49. Identificar usuarios que nunca han pagado con PayPal.
SELECT u.id, u.nombre
FROM usuarios u
WHERE u.id NOT IN (SELECT usuario_id FROM pagos WHERE metodo_pago = 'PayPal' AND deleted_at IS NULL)
  AND u.deleted_at IS NULL;

-- 50. Calcular el promedio de gasto por usuario.
SELECT ROUND(AVG(total_gastado), 2) AS promedio_gasto_usuario
FROM (
    SELECT usuario_id, SUM(monto) AS total_gastado
    FROM pagos
    WHERE estado = 'Pagado' AND deleted_at IS NULL
    GROUP BY usuario_id
) AS subquery;

-- 51. Mostrar el top 5 de usuarios que más han pagado en total.
SELECT u.id, u.nombre, SUM(p.monto) AS total_pagado
FROM usuarios u
JOIN pagos p ON u.id = p.usuario_id
WHERE p.estado = 'Pagado' AND p.deleted_at IS NULL
GROUP BY u.id, u.nombre
ORDER BY total_pagado DESC
LIMIT 5;

-- 52. Mostrar facturas con monto mayor a $1000.
SELECT f.numero_factura, u.nombre, f.total, f.fecha_emision
FROM facturas f
JOIN usuarios u ON f.usuario_id = u.id
WHERE f.total > 1000 AND f.deleted_at IS NULL;

-- 53. Listar pagos realizados después de la fecha de vencimiento de la factura.
-- (Asumiendo que la fecha de vencimiento es 15 días después de la emisión, o comparando con fecha_fin de membresia)
SELECT p.id, u.nombre, f.numero_factura, f.fecha_emision, p.fecha_pago
FROM pagos p
JOIN facturas f ON p.id = f.pago_id
JOIN usuarios u ON p.usuario_id = u.id
WHERE p.fecha_pago > DATE_ADD(f.fecha_emision, INTERVAL 15 DAY) 
  AND p.deleted_at IS NULL AND f.deleted_at IS NULL;

-- 54. Calcular el total recaudado en el año actual.
SELECT SUM(monto) AS total_recaudado_anio
FROM pagos
WHERE estado = 'Pagado' 
  AND YEAR(fecha_pago) = YEAR(CURDATE())
  AND deleted_at IS NULL;

-- 55. Mostrar facturas anuladas y su motivo.
SELECT f.numero_factura, u.nombre, f.total, f.motivo_anulacion, f.fecha_emision
FROM facturas f
JOIN usuarios u ON f.usuario_id = u.id
WHERE f.estado = 'Anulada' AND f.deleted_at IS NULL;

-- 56. Mostrar usuarios con facturas pendientes mayores a $200.
SELECT u.id, u.nombre, SUM(f.saldo_pendiente) AS total_pendiente
FROM usuarios u
JOIN facturas f ON u.id = f.usuario_id
WHERE f.estado IN ('Pendiente', 'Parcial') AND f.deleted_at IS NULL
GROUP BY u.id, u.nombre
HAVING SUM(f.saldo_pendiente) > 200;

-- 57. Mostrar usuarios que han pagado más de una vez el mismo servicio (concepto).
SELECT u.nombre, p.concepto, COUNT(p.id) AS veces_pagado
FROM usuarios u
JOIN pagos p ON u.id = p.usuario_id
WHERE p.estado = 'Pagado' AND p.deleted_at IS NULL
GROUP BY u.id, u.nombre, p.concepto
HAVING COUNT(p.id) > 1;

-- 58. Listar ingresos por cada método de pago.
SELECT metodo_pago, SUM(monto) AS total_ingresos
FROM pagos
WHERE estado = 'Pagado' AND deleted_at IS NULL
GROUP BY metodo_pago;

-- 59. Mostrar facturación acumulada por empresa.
SELECT e.nombre AS empresa, SUM(f.total) AS facturacion_total
FROM empresas e
JOIN usuarios u ON e.id = u.empresa_id
JOIN facturas f ON u.id = f.usuario_id
WHERE f.deleted_at IS NULL AND u.deleted_at IS NULL
GROUP BY e.id, e.nombre;

-- 60. Mostrar ingresos netos por mes del último año.
SELECT DATE_FORMAT(fecha_pago, '%Y-%m') AS mes, SUM(monto) AS ingresos_netos
FROM pagos
WHERE estado = 'Pagado' 
  AND fecha_pago >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
  AND deleted_at IS NULL
GROUP BY DATE_FORMAT(fecha_pago, '%Y-%m')
ORDER BY mes;