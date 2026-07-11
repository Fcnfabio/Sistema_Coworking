-- =====================================================
-- PROCEDIMIENTOS ALMACENADOS: CORPORATIVOS Y ADMIN (sp_18 a sp_20)
-- =====================================================

USE coworking_db;
DELIMITER $$

-- =====================================================
-- SP 18: Registrar lote de empleados con membresía corporativa
-- (Usa JSON_TABLE de MySQL 8.0 para parsear el array)
-- =====================================================
CREATE PROCEDURE sp_registrar_lote_empleados_corporativos(
    IN p_empresa_id INT,
    IN p_empleados_json JSON,
    IN p_tipo_membresia_id INT
)
BEGIN
    DECLARE v_duracion INT;
    DECLARE v_fecha_inicio DATE;
    DECLARE v_fecha_fin DATE;
    
    SELECT duracion_dias INTO v_duracion FROM tipos_membresia WHERE id = p_tipo_membresia_id;
    SET v_fecha_inicio = CURDATE();
    SET v_fecha_fin = DATE_ADD(v_fecha_inicio, INTERVAL v_duracion DAY);
    
    -- Insertar usuarios desde el JSON
    INSERT INTO usuarios (empresa_id, nombre, apellidos, email, telefono, tipo_documento, numero_documento)
    SELECT 
        p_empresa_id,
        emp.nombre,
        emp.apellidos,
        emp.email,
        emp.telefono,
        'CC',
        emp.documento
    FROM JSON_TABLE(
        p_empleados_json,
        '$[*]' COLUMNS (
            nombre VARCHAR(100) PATH '$.nombre',
            apellidos VARCHAR(100) PATH '$.apellidos',
            email VARCHAR(100) PATH '$.email',
            telefono VARCHAR(50) PATH '$.telefono',
            documento VARCHAR(50) PATH '$.documento'
        )
    ) AS emp;
    
    -- Asignar membresías a los nuevos usuarios de la empresa
    INSERT INTO membresias (usuario_id, tipo_membresia_id, fecha_inicio, fecha_fin, estado, precio_pagado, numero_renovaciones)
    SELECT id, p_tipo_membresia_id, v_fecha_inicio, v_fecha_fin, 'Activa', (SELECT precio FROM tipos_membresia WHERE id = p_tipo_membresia_id), 0
    FROM usuarios 
    WHERE empresa_id = p_empresa_id 
      AND created_at >= CURDATE() 
      AND deleted_at IS NULL;
      
    SELECT ROW_COUNT() AS empleados_procesados;
END $$

-- =====================================================
-- SP 19: Cancelar reservas futuras al eliminar membresía
-- =====================================================
CREATE PROCEDURE sp_cancelar_reservas_al_eliminar_membresia(
    IN p_usuario_id INT
)
BEGIN
    UPDATE reservas 
    SET estado = 'Cancelada', motivo = 'Cancelada por eliminación de membresía'
    WHERE usuario_id = p_usuario_id 
      AND fecha_reserva > CURDATE() 
      AND estado IN ('Pendiente', 'Confirmada')
      AND deleted_at IS NULL;
      
    SELECT ROW_COUNT() AS reservas_canceladas;
END $$

-- =====================================================
-- SP 20: Generar reporte de ingresos mensuales acumulados
-- =====================================================
CREATE PROCEDURE sp_reporte_ingresos_mensuales_acumulados(
    IN p_anio INT
)
BEGIN
    WITH ingresos_mensuales AS (
        SELECT 
            MONTH(fecha_pago) AS mes,
            SUM(monto) AS ingresos_mes
        FROM pagos
        WHERE YEAR(fecha_pago) = p_anio 
          AND estado = 'Pagado' 
          AND deleted_at IS NULL
        GROUP BY MONTH(fecha_pago)
    )
    SELECT 
        mes,
        ingresos_mes,
        SUM(ingresos_mes) OVER (ORDER BY mes) AS ingresos_acumulados_anio
    FROM ingresos_mensuales
    ORDER BY mes;
END $$

DELIMITER ;