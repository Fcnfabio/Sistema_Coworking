-- =====================================================
-- CREACIÓN DE VISTAS (VIEWS)
-- Las vistas simplifican las consultas complejas uniendo 
-- varias tablas relacionadas.
-- =====================================================

-- 1. VISTA: USUARIOS CON MEMBRESÍA ACTUAL
-- Muestra el usuario junto con los detalles de su membresía actual.
CREATE OR REPLACE VIEW v_usuarios_membresia AS
SELECT 
    u.id AS usuario_id,
    u.nombre,
    u.apellidos,
    u.email,
    u.telefono,
    e.nombre AS empresa,
    m.id AS membresia_id,
    tm.nombre AS tipo_membresia,
    m.fecha_inicio,
    m.fecha_fin,
    m.estado AS estado_membresia
FROM usuarios u
LEFT JOIN empresas e ON u.empresa_id = e.id
LEFT JOIN membresias m ON u.id = m.usuario_id
LEFT JOIN tipos_membresia tm ON m.tipo_membresia_id = tm.id
WHERE m.deleted_at IS NULL;

-- 2. VISTA: RESERVAS DETALLADAS
-- Muestra la reserva con los datos del usuario, espacio y tipo de espacio.
CREATE OR REPLACE VIEW v_reservas_detalladas AS
SELECT 
    r.id AS reserva_id,
    u.nombre AS usuario_nombre,
    u.apellidos AS usuario_apellidos,
    esp.nombre AS espacio_nombre,
    te.nombre AS tipo_espacio,
    r.fecha_reserva,
    r.hora_inicio,
    r.hora_fin,
    r.estado AS estado_reserva,
    r.precio_total
FROM reservas r
JOIN usuarios u ON r.usuario_id = u.id
JOIN espacios esp ON r.espacio_id = esp.id
JOIN tipos_espacio te ON esp.tipo_espacio_id = te.id
WHERE r.deleted_at IS NULL;

-- 3. VISTA: FACTURAS Y PAGOS
-- Une las facturas con su respectivo pago y usuario para reportes financieros.
CREATE OR REPLACE VIEW v_facturas_pagos AS
SELECT 
    f.id AS factura_id,
    f.numero_factura,
    f.fecha_emision,
    f.total,
    f.estado AS estado_factura,
    f.saldo_pendiente,
    u.nombre AS usuario_nombre,
    p.metodo_pago,
    p.fecha_pago,
    p.estado AS estado_pago
FROM facturas f
JOIN usuarios u ON f.usuario_id = u.id
LEFT JOIN pagos p ON f.pago_id = p.id
WHERE f.deleted_at IS NULL;

-- 4. VISTA: ACCESOS Y ASISTENCIAS
-- Muestra el historial de entradas y salidas con el nombre del usuario.
CREATE OR REPLACE VIEW v_accesos_asistencias AS
SELECT 
    a.id AS acceso_id,
    u.nombre AS usuario_nombre,
    u.apellidos AS usuario_apellidos,
    a.tipo_acceso,
    a.fecha_hora,
    a.metodo_acceso,
    a.estado AS estado_acceso,
    a.motivo_rechazo
FROM accesos a
JOIN usuarios u ON a.usuario_id = u.id
WHERE u.deleted_at IS NULL;

-- 5. VISTA: OCUPACIÓN DE ESPACIOS
-- Resumen rápido de la capacidad y el tipo de cada espacio.
CREATE OR REPLACE VIEW v_espacios_resumen AS
SELECT 
    esp.id AS espacio_id,
    esp.nombre,
    te.nombre AS tipo_espacio,
    esp.capacidad_maxima,
    esp.ubicacion,
    esp.precio_hora
FROM espacios esp
JOIN tipos_espacio te ON esp.tipo_espacio_id = te.id
WHERE esp.deleted_at IS NULL;