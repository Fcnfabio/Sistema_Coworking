-- =====================================================
-- CREACIÓN DE TABLAS BASE (PARTE 1)
-- Estas tablas son la fundación y no tienen claves foráneas complejas.
-- =====================================================

-- 1. TABLA: EMPRESAS
-- Almacena la información de las empresas que contratan membresías corporativas.
CREATE TABLE empresas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    nit_rut VARCHAR(50) UNIQUE NOT NULL,
    direccion VARCHAR(255),
    telefono VARCHAR(50),
    email VARCHAR(100) NOT NULL,
    -- Campos de auditoría
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME NULL -- Para "borrado lógico" (soft delete)
) ENGINE=InnoDB;

-- 2. TABLA: TIPOS DE MEMBRESÍA
-- Define los planes disponibles (Diaria, Mensual, Corporativa, Premium).
CREATE TABLE tipos_membresia (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    duracion_dias INT NOT NULL, -- Ej: 1 para diaria, 30 para mensual
    -- Campos de auditoría
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME NULL
) ENGINE=InnoDB;

-- 3. TABLA: USUARIOS
-- Información de las personas que usan el coworking.
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    empresa_id INT NULL, -- NULL si es usuario individual
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(50),
    tipo_documento VARCHAR(20) NOT NULL, -- DNI, Pasaporte, etc.
    numero_documento VARCHAR(50) NOT NULL UNIQUE,
    -- Campos de auditoría
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME NULL,
    -- Clave foránea
    FOREIGN KEY (empresa_id) REFERENCES empresas(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- 4. TABLA: TIPOS DE ESPACIO
-- Categorías de espacios (Escritorio flexible, Oficina privada, Sala de reuniones, etc.)
CREATE TABLE tipos_espacio (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    -- Campos de auditoría
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME NULL
) ENGINE=InnoDB;

-- 5. TABLA: ESPACIOS FÍSICOS
-- Los espacios reales y tangibles del coworking.
CREATE TABLE espacios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo_espacio_id INT NOT NULL,
    nombre VARCHAR(100) NOT NULL, -- Ej: "Sala de Juntas A", "Escritorio 05"
    capacidad_maxima INT NOT NULL DEFAULT 1,
    precio_hora DECIMAL(10, 2) NOT NULL,
    ubicacion VARCHAR(100), -- Ej: "Piso 2, Ala Norte"
    -- Campos de auditoría
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME NULL,
    -- Clave foránea
    FOREIGN KEY (tipo_espacio_id) REFERENCES tipos_espacio(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =====================================================
-- CREACIÓN DE TABLAS RELACIONALES (PARTE 2)
-- Estas tablas contienen la lógica de negocio principal.
-- =====================================================

-- 6. TABLA: MEMBRESÍAS
-- Representa la membresía ACTUAL de un usuario.
CREATE TABLE membresias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    tipo_membresia_id INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    estado ENUM('Activa', 'Suspendida', 'Vencida') NOT NULL DEFAULT 'Activa',
    precio_pagado DECIMAL(10, 2) NOT NULL,
    numero_renovaciones INT DEFAULT 0,
    -- Campos de auditoría
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME NULL,
    -- Claves foráneas
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (tipo_membresia_id) REFERENCES tipos_membresia(id) ON DELETE RESTRICT,
    -- Índice para búsquedas rápidas por estado y fecha
    INDEX idx_membresia_estado_fecha (estado, fecha_fin)
) ENGINE=InnoDB;

-- 7. TABLA: HISTORIAL DE MEMBRESÍAS
-- Log de todos los cambios de membresía de un usuario.
CREATE TABLE historial_membresias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    tipo_membresia_anterior_id INT NULL,
    tipo_membresia_nueva_id INT NOT NULL,
    fecha_cambio TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    motivo VARCHAR(255),
    -- Campos de auditoría
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- Clave foránea
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 8. TABLA: SERVICIOS ADICIONALES
-- Catálogo de servicios extra (internet premium, café, impresiones, etc.)
CREATE TABLE servicios_adicionales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    tipo ENUM('Fijo', 'PorHora', 'PorUnidad') NOT NULL DEFAULT 'Fijo',
    disponible BOOLEAN DEFAULT TRUE,
    -- Campos de auditoría
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME NULL
) ENGINE=InnoDB;

-- 9. TABLA: RESERVAS
-- Reservas de espacios realizadas por los usuarios.
CREATE TABLE reservas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    espacio_id INT NOT NULL,
    fecha_reserva DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    estado ENUM('Pendiente', 'Confirmada', 'Cancelada', 'Completada', 'No Show') NOT NULL DEFAULT 'Pendiente',
    numero_personas INT NOT NULL DEFAULT 1,
    motivo VARCHAR(255),
    precio_total DECIMAL(10, 2) NOT NULL,
    -- Campos de auditoría
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME NULL,
    -- Claves foráneas
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (espacio_id) REFERENCES espacios(id) ON DELETE RESTRICT,
    -- Índices para validación de disponibilidad
    INDEX idx_reserva_disponibilidad (espacio_id, fecha_reserva, hora_inicio, hora_fin),
    INDEX idx_reserva_estado (estado),
    INDEX idx_reserva_usuario_fecha (usuario_id, fecha_reserva)
) ENGINE=InnoDB;

-- 10. TABLA: RESERVA_SERVICIOS (Tabla Intermedia N:M)
-- Servicios adicionales contratados en una reserva específica.
CREATE TABLE reserva_servicios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    reserva_id INT NOT NULL,
    servicio_id INT NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    -- Campos de auditoría
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- Claves foráneas
    FOREIGN KEY (reserva_id) REFERENCES reservas(id) ON DELETE CASCADE,
    FOREIGN KEY (servicio_id) REFERENCES servicios_adicionales(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 11. TABLA: PAGOS
-- Registro de todas las transacciones de pago.
CREATE TABLE pagos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    monto DECIMAL(10, 2) NOT NULL,
    fecha_pago DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    metodo_pago ENUM('Efectivo', 'Tarjeta', 'Transferencia', 'PayPal') NOT NULL,
    estado ENUM('Pagado', 'Pendiente', 'Cancelado', 'Reembolsado') NOT NULL DEFAULT 'Pendiente',
    referencia_transaccion VARCHAR(100), -- ID de transacción del banco/PayPal
    concepto ENUM('Membresia', 'Reserva', 'ServicioAdicional', 'Mixto') NOT NULL,
    -- Campos de auditoría
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME NULL,
    -- Clave foránea
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    -- Índices
    INDEX idx_pago_usuario_fecha (usuario_id, fecha_pago),
    INDEX idx_pago_estado (estado)
) ENGINE=InnoDB;

-- 12. TABLA: FACTURAS
-- Documentos fiscales generados por pagos y servicios.
CREATE TABLE facturas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    pago_id INT NULL, -- Puede ser NULL si es factura consolidada
    numero_factura VARCHAR(50) NOT NULL UNIQUE,
    fecha_emision DATE NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    impuestos DECIMAL(10, 2) DEFAULT 0.00,
    total DECIMAL(10, 2) NOT NULL,
    estado ENUM('Pagada', 'Pendiente', 'Anulada', 'Parcial') NOT NULL DEFAULT 'Pendiente',
    saldo_pendiente DECIMAL(10, 2) DEFAULT 0.00,
    motivo_anulacion VARCHAR(255),
    -- Campos de auditoría
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME NULL,
    -- Claves foráneas
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (pago_id) REFERENCES pagos(id) ON DELETE SET NULL,
    -- Índices
    INDEX idx_factura_numero (numero_factura),
    INDEX idx_factura_estado (estado)
) ENGINE=InnoDB;

-- 13. TABLA: ACCESOS (ASISTENCIAS)
-- Registro de entradas y salidas al coworking.
CREATE TABLE accesos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    tipo_acceso ENUM('Entrada', 'Salida') NOT NULL,
    fecha_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    metodo_acceso ENUM('RFID', 'QR', 'Manual') NOT NULL,
    estado ENUM('Aprobado', 'Rechazado') NOT NULL DEFAULT 'Aprobado',
    motivo_rechazo VARCHAR(255),
    -- Campos de auditoría
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- Clave foránea
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    -- Índices para reportes rápidos
    INDEX idx_acceso_usuario_fecha (usuario_id, fecha_hora),
    INDEX idx_acceso_fecha (fecha_hora),
    INDEX idx_acceso_estado (estado)
) ENGINE=InnoDB;

-- 14. TABLA: LOGS (AUDITORÍA GENERAL)
-- Registro centralizado de eventos importantes del sistema.
CREATE TABLE logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NULL, -- NULL si es acción del sistema
    tabla_afectada VARCHAR(50) NOT NULL,
    registro_id INT NULL,
    accion ENUM('INSERT', 'UPDATE', 'DELETE', 'SELECT', 'ERROR') NOT NULL,
    descripcion TEXT,
    datos_anteriores JSON NULL, -- Snapshot del estado antes del cambio
    datos_nuevos JSON NULL, -- Snapshot del estado después del cambio
    ip_address VARCHAR(45),
    -- Campos de auditoría
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- Clave foránea
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE SET NULL,
    -- Índice
    INDEX idx_logs_tabla_fecha (tabla_afectada, created_at)
) ENGINE=InnoDB;