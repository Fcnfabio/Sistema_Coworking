
---

## 📄 Archivo 2: `09-documentacion/diccionario-datos.md`

```markdown
# 📖 Diccionario de Datos

## Proyecto: Sistema de Gestión de Coworking
**Base de Datos:** `coworking_db`  
**Motor:** MySQL 8.0+  
**Charset:** utf8mb4_unicode_ci

---

## 1. Tabla: `empresas`

Almacena la información de las empresas que contratan membresías corporativas.

| Campo | Tipo | Nulo | Clave | Descripción |
|-------|------|------|-------|-------------|
| `id` | INT AUTO_INCREMENT | NO | PK | Identificador único |
| `nombre` | VARCHAR(150) | NO | | Nombre de la empresa |
| `nit_rut` | VARCHAR(50) | NO | UK | Número de identificación tributaria |
| `direccion` | VARCHAR(255) | SÍ | | Dirección física |
| `telefono` | VARCHAR(50) | SÍ | | Teléfono de contacto |
| `email` | VARCHAR(100) | NO | | Correo electrónico corporativo |
| `created_at` | TIMESTAMP | SÍ | | Fecha de creación |
| `updated_at` | TIMESTAMP | SÍ | | Fecha de última actualización |
| `deleted_at` | DATETIME | SÍ | | Fecha de borrado lógico |

**Restricciones:**
- `PRIMARY KEY (id)`
- `UNIQUE (nit_rut)`

---

## 2. Tabla: `tipos_membresia`

Define los planes de membresía disponibles (Diaria, Mensual, Corporativa, Premium).

| Campo | Tipo | Nulo | Clave | Descripción |
|-------|------|------|-------|-------------|
| `id` | INT AUTO_INCREMENT | NO | PK | Identificador único |
| `nombre` | VARCHAR(50) | NO | UK | Nombre del plan |
| `descripcion` | TEXT | SÍ | | Descripción detallada |
| `precio` | DECIMAL(10,2) | NO | | Precio base del plan |
| `duracion_dias` | INT | NO | | Duración en días (1, 30, etc.) |
| `created_at` | TIMESTAMP | SÍ | | Fecha de creación |
| `updated_at` | TIMESTAMP | SÍ | | Fecha de última actualización |
| `deleted_at` | DATETIME | SÍ | | Fecha de borrado lógico |

**Valores ENUM implícitos (nombre):** Diaria, Mensual, Corporativa, Premium

---

## 3. Tabla: `usuarios`

Información de las personas que usan el coworking (individuales o corporativos).

| Campo | Tipo | Nulo | Clave | Descripción |
|-------|------|------|-------|-------------|
| `id` | INT AUTO_INCREMENT | NO | PK | Identificador único |
| `empresa_id` | INT | SÍ | FK | ID de la empresa (NULL si es individual) |
| `nombre` | VARCHAR(100) | NO | | Nombre del usuario |
| `apellidos` | VARCHAR(100) | NO | | Apellidos del usuario |
| `fecha_nacimiento` | DATE | SÍ | | Fecha de nacimiento |
| `email` | VARCHAR(100) | NO | UK | Correo electrónico |
| `telefono` | VARCHAR(50) | SÍ | | Teléfono de contacto |
| `tipo_documento` | VARCHAR(20) | NO | | Tipo de documento (CC, Pasaporte) |
| `numero_documento` | VARCHAR(50) | NO | UK | Número de documento |
| `created_at` | TIMESTAMP | SÍ | | Fecha de registro |
| `updated_at` | TIMESTAMP | SÍ | | Fecha de última actualización |
| `deleted_at` | DATETIME | SÍ | | Fecha de borrado lógico |

**Restricciones:**
- `FOREIGN KEY (empresa_id) REFERENCES empresas(id) ON DELETE SET NULL`
- `UNIQUE (email)`
- `UNIQUE (numero_documento)`

---

## 4. Tabla: `tipos_espacio`

Categorías de espacios disponibles en el coworking.

| Campo | Tipo | Nulo | Clave | Descripción |
|-------|------|------|-------|-------------|
| `id` | INT AUTO_INCREMENT | NO | PK | Identificador único |
| `nombre` | VARCHAR(100) | NO | UK | Nombre de la categoría |
| `descripcion` | TEXT | SÍ | | Descripción de la categoría |
| `created_at` | TIMESTAMP | SÍ | | Fecha de creación |
| `updated_at` | TIMESTAMP | SÍ | | Fecha de última actualización |
| `deleted_at` | DATETIME | SÍ | | Fecha de borrado lógico |

**Valores:** Escritorio Flexible, Oficina Privada, Sala de Reuniones, Sala de Eventos

---

## 5. Tabla: `espacios`

Espacios físicos reales del coworking.

| Campo | Tipo | Nulo | Clave | Descripción |
|-------|------|------|-------|-------------|
| `id` | INT AUTO_INCREMENT | NO | PK | Identificador único |
| `tipo_espacio_id` | INT | NO | FK | Categoría del espacio |
| `nombre` | VARCHAR(100) | NO | | Nombre del espacio |
| `capacidad_maxima` | INT | NO | | Capacidad máxima de personas |
| `precio_hora` | DECIMAL(10,2) | NO | | Precio por hora de uso |
| `ubicacion` | VARCHAR(100) | SÍ | | Ubicación física (piso, ala) |
| `created_at` | TIMESTAMP | SÍ | | Fecha de creación |
| `updated_at` | TIMESTAMP | SÍ | | Fecha de última actualización |
| `deleted_at` | DATETIME | SÍ | | Fecha de borrado lógico |

**Restricciones:**
- `FOREIGN KEY (tipo_espacio_id) REFERENCES tipos_espacio(id) ON DELETE RESTRICT`

---

## 6. Tabla: `membresias`

Membresía actual de un usuario.

| Campo | Tipo | Nulo | Clave | Descripción |
|-------|------|------|-------|-------------|
| `id` | INT AUTO_INCREMENT | NO | PK | Identificador único |
| `usuario_id` | INT | NO | FK | Usuario propietario |
| `tipo_membresia_id` | INT | NO | FK | Tipo de membresía |
| `fecha_inicio` | DATE | NO | | Fecha de inicio |
| `fecha_fin` | DATE | NO | | Fecha de vencimiento |
| `estado` | ENUM | NO | | Estado: Activa, Suspendida, Vencida |
| `precio_pagado` | DECIMAL(10,2) | NO | | Precio realmente pagado |
| `numero_renovaciones` | INT | SÍ | | Cantidad de renovaciones |
| `created_at` | TIMESTAMP | SÍ | | Fecha de creación |
| `updated_at` | TIMESTAMP | SÍ | | Fecha de última actualización |
| `deleted_at` | DATETIME | SÍ | | Fecha de borrado lógico |

**Restricciones:**
- `FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE`
- `FOREIGN KEY (tipo_membresia_id) REFERENCES tipos_membresia(id) ON DELETE RESTRICT`
- `INDEX idx_membresia_estado_fecha (estado, fecha_fin)`

---

## 7. Tabla: `historial_membresias`

Log de cambios de membresía de un usuario.

| Campo | Tipo | Nulo | Clave | Descripción |
|-------|------|------|-------|-------------|
| `id` | INT AUTO_INCREMENT | NO | PK | Identificador único |
| `usuario_id` | INT | NO | FK | Usuario |
| `tipo_membresia_anterior_id` | INT | SÍ | | Tipo anterior (NULL si es nueva) |
| `tipo_membresia_nueva_id` | INT | NO | | Nuevo tipo |
| `fecha_cambio` | TIMESTAMP | NO | | Fecha del cambio |
| `motivo` | VARCHAR(255) | SÍ | | Motivo del cambio |
| `created_at` | TIMESTAMP | SÍ | | Fecha de registro |

**Restricciones:**
- `FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE`

---

## 8. Tabla: `servicios_adicionales`

Catálogo de servicios extra disponibles.

| Campo | Tipo | Nulo | Clave | Descripción |
|-------|------|------|-------|-------------|
| `id` | INT AUTO_INCREMENT | NO | PK | Identificador único |
| `nombre` | VARCHAR(100) | NO | UK | Nombre del servicio |
| `descripcion` | TEXT | SÍ | | Descripción |
| `precio` | DECIMAL(10,2) | NO | | Precio base |
| `tipo` | ENUM | NO | | Fijo, PorHora, PorUnidad |
| `disponible` | BOOLEAN | SÍ | | Disponibilidad actual |
| `created_at` | TIMESTAMP | SÍ | | Fecha de creación |
| `updated_at` | TIMESTAMP | SÍ | | Fecha de última actualización |
| `deleted_at` | DATETIME | SÍ | | Fecha de borrado lógico |

---

## 9. Tabla: `reservas`

Reservas de espacios realizadas por usuarios.

| Campo | Tipo | Nulo | Clave | Descripción |
|-------|------|------|-------|-------------|
| `id` | INT AUTO_INCREMENT | NO | PK | Identificador único |
| `usuario_id` | INT | NO | FK | Usuario que reserva |
| `espacio_id` | INT | NO | FK | Espacio reservado |
| `fecha_reserva` | DATE | NO | | Fecha de la reserva |
| `hora_inicio` | TIME | NO | | Hora de inicio |
| `hora_fin` | TIME | NO | | Hora de fin |
| `estado` | ENUM | NO | | Pendiente, Confirmada, Cancelada, Completada, No Show |
| `numero_personas` | INT | NO | | Cantidad de personas |
| `motivo` | VARCHAR(255) | SÍ | | Motivo de la reserva |
| `precio_total` | DECIMAL(10,2) | NO | | Precio total |
| `created_at` | TIMESTAMP | SÍ | | Fecha de creación |
| `updated_at` | TIMESTAMP | SÍ | | Fecha de última actualización |
| `deleted_at` | DATETIME | SÍ | | Fecha de borrado lógico |

**Restricciones:**
- `FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE`
- `FOREIGN KEY (espacio_id) REFERENCES espacios(id) ON DELETE RESTRICT`
- `INDEX idx_reserva_disponibilidad (espacio_id, fecha_reserva, hora_inicio, hora_fin)`
- `INDEX idx_reserva_estado (estado)`
- `INDEX idx_reserva_usuario_fecha (usuario_id, fecha_reserva)`

---

## 10. Tabla: `reserva_servicios`

Tabla intermedia N:M entre reservas y servicios adicionales.

| Campo | Tipo | Nulo | Clave | Descripción |
|-------|------|------|-------|-------------|
| `id` | INT AUTO_INCREMENT | NO | PK | Identificador único |
| `reserva_id` | INT | NO | FK | Reserva asociada |
| `servicio_id` | INT | NO | FK | Servicio contratado |
| `cantidad` | INT | NO | | Cantidad contratada |
| `precio_unitario` | DECIMAL(10,2) | NO | | Precio unitario al momento |
| `created_at` | TIMESTAMP | SÍ | | Fecha de creación |

**Restricciones:**
- `FOREIGN KEY (reserva_id) REFERENCES reservas(id) ON DELETE CASCADE`
- `FOREIGN KEY (servicio_id) REFERENCES servicios_adicionales(id) ON DELETE RESTRICT`

---

## 11. Tabla: `pagos`

Registro de todas las transacciones de pago.

| Campo | Tipo | Nulo | Clave | Descripción |
|-------|------|------|-------|-------------|
| `id` | INT AUTO_INCREMENT | NO | PK | Identificador único |
| `usuario_id` | INT | NO | FK | Usuario que paga |
| `monto` | DECIMAL(10,2) | NO | | Monto del pago |
| `fecha_pago` | DATETIME | NO | | Fecha y hora del pago |
| `metodo_pago` | ENUM | NO | | Efectivo, Tarjeta, Transferencia, PayPal |
| `estado` | ENUM | NO | | Pagado, Pendiente, Cancelado, Reembolsado |
| `referencia_transaccion` | VARCHAR(100) | SÍ | | ID de transacción externa |
| `concepto` | ENUM | NO | | Membresia, Reserva, ServicioAdicional, Mixto |
| `created_at` | TIMESTAMP | SÍ | | Fecha de creación |
| `updated_at` | TIMESTAMP | SÍ | | Fecha de última actualización |
| `deleted_at` | DATETIME | SÍ | | Fecha de borrado lógico |

**Restricciones:**
- `FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE`
- `INDEX idx_pago_usuario_fecha (usuario_id, fecha_pago)`
- `INDEX idx_pago_estado (estado)`

---

## 12. Tabla: `facturas`

Documentos fiscales generados por pagos.

| Campo | Tipo | Nulo | Clave | Descripción |
|-------|------|------|-------|-------------|
| `id` | INT AUTO_INCREMENT | NO | PK | Identificador único |
| `usuario_id` | INT | NO | FK | Usuario facturador |
| `pago_id` | INT | SÍ | FK | Pago asociado (NULL si consolidada) |
| `numero_factura` | VARCHAR(50) | NO | UK | Número único de factura |
| `fecha_emision` | DATE | NO | | Fecha de emisión |
| `subtotal` | DECIMAL(10,2) | NO | | Subtotal sin impuestos |
| `impuestos` | DECIMAL(10,2) | SÍ | | Monto de impuestos |
| `total` | DECIMAL(10,2) | NO | | Total con impuestos |
| `estado` | ENUM | NO | | Pagada, Pendiente, Anulada, Parcial |
| `saldo_pendiente` | DECIMAL(10,2) | SÍ | | Saldo por pagar |
| `motivo_anulacion` | VARCHAR(255) | SÍ | | Motivo si fue anulada |
| `created_at` | TIMESTAMP | SÍ | | Fecha de creación |
| `updated_at` | TIMESTAMP | SÍ | | Fecha de última actualización |
| `deleted_at` | DATETIME | SÍ | | Fecha de borrado lógico |

**Restricciones:**
- `FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE`
- `FOREIGN KEY (pago_id) REFERENCES pagos(id) ON DELETE SET NULL`
- `INDEX idx_factura_numero (numero_factura)`
- `INDEX idx_factura_estado (estado)`

---

## 13. Tabla: `accesos`

Registro de entradas y salidas al coworking.

| Campo | Tipo | Nulo | Clave | Descripción |
|-------|------|------|-------|-------------|
| `id` | INT AUTO_INCREMENT | NO | PK | Identificador único |
| `usuario_id` | INT | NO | FK | Usuario |
| `tipo_acceso` | ENUM | NO | | Entrada, Salida |
| `fecha_hora` | DATETIME | NO | | Fecha y hora del acceso |
| `metodo_acceso` | ENUM | NO | | RFID, QR, Manual |
| `estado` | ENUM | NO | | Aprobado, Rechazado |
| `motivo_rechazo` | VARCHAR(255) | SÍ | | Motivo si fue rechazado |
| `created_at` | TIMESTAMP | SÍ | | Fecha de registro |

**Restricciones:**
- `FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE`
- `INDEX idx_acceso_usuario_fecha (usuario_id, fecha_hora)`
- `INDEX idx_acceso_fecha (fecha_hora)`
- `INDEX idx_acceso_estado (estado)`

---

## 14. Tabla: `logs`

Registro centralizado de auditoría del sistema.

| Campo | Tipo | Nulo | Clave | Descripción |
|-------|------|------|-------|-------------|
| `id` | INT AUTO_INCREMENT | NO | PK | Identificador único |
| `usuario_id` | INT | SÍ | FK | Usuario (NULL si es sistema) |
| `tabla_afectada` | VARCHAR(50) | NO | | Tabla involucrada |
| `registro_id` | INT | SÍ | | ID del registro afectado |
| `accion` | ENUM | NO | | INSERT, UPDATE, DELETE, SELECT, ERROR |
| `descripcion` | TEXT | SÍ | | Descripción detallada |
| `datos_anteriores` | JSON | SÍ | | Snapshot antes del cambio |
| `datos_nuevos` | JSON | SÍ | | Snapshot después del cambio |
| `ip_address` | VARCHAR(45) | SÍ | | IP del usuario |
| `created_at` | TIMESTAMP | SÍ | | Fecha del evento |

**Restricciones:**
- `FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE SET NULL`
- `INDEX idx_logs_tabla_fecha (tabla_afectada, created_at)`

---

## 📊 Vistas (Views)

| Vista | Descripción |
|-------|-------------|
| `v_usuarios_membresia` | Usuarios con detalles de su membresía actual |
| `v_reservas_detalladas` | Reservas con datos de usuario, espacio y tipo |
| `v_facturas_pagos` | Facturas unidas con pagos y usuarios |
| `v_accesos_asistencias` | Historial de accesos con nombres de usuarios |
| `v_espacios_resumen` | Resumen de espacios con tipo y capacidad |

---

##  Convenciones de Nomenclatura

- **Tablas:** `snake_case` en plural (`usuarios`, `tipos_membresia`)
- **Campos:** `snake_case` (`fecha_nacimiento`, `numero_documento`)
- **Claves Primarias:** `id`
- **Claves Foráneas:** `[tabla_singular]_id` (`usuario_id`, `empresa_id`)
- **Índices:** `idx_[tabla]_[campo1]_[campo2]`
- **Vistas:** `v_[descripcion]`
- **Funciones:** `fn_[descripcion]`
- **Procedimientos:** `sp_[descripcion]`
- **Triggers:** `tr_[descripcion]`
- **Eventos:** `ev_[descripcion]`