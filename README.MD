# Proyecto SQL Prueba - Sistema de Gestión de Coworking

## 1. Descripción del Proyecto

Este repositorio contiene una implementación completa de una base de datos relacional en MySQL para gestionar un sistema de coworking. El proyecto incluye la creación de la estructura de base de datos, la carga de datos iniciales, consultas analíticas, funciones, procedimientos almacenados, triggers, eventos programados y roles de usuario con permisos. Su propósito es demostrar cómo modelar y automatizar una solución de negocio realista usando SQL y MySQL 8.0+.

## 2. Requisitos del Sistema

Para ejecutar correctamente este proyecto se requiere:

- MySQL Server 8.0 o superior.
- MySQL Workbench o un cliente SQL como la línea de comandos de MySQL.
- Permisos de administrador o usuario con capacidad para crear bases de datos, tablas, procedimientos y roles.
- Un entorno donde se pueda ejecutar el motor de base de datos y cargar scripts SQL.

## 3. Instalación y Configuración

### 3.1. Clonar o descargar el proyecto

Descarga o clona este repositorio en tu equipo local.

### 3.2. Crear y cargar la estructura de la base de datos

Desde MySQL Workbench o la consola de MySQL, ejecuta los scripts del directorio 01-ddl en este orden:

```sql
SOURCE 01-ddl/001-create-database.sql;
SOURCE 01-ddl/002-create-tables.sql;
SOURCE 01-ddl/003-create-views.sql;
```

### 3.3. Cargar los datos iniciales

Ejecuta el script maestro de datos iniciales:

```sql
SOURCE 02-dml/000-run-all.sql;
```

Este archivo invoca los inserts de los demás scripts SQL del directorio 02-dml.

### 3.4. Ejecutar consultas

Las consultas se encuentran en la carpeta 03-consultas. Puedes ejecutarlas una por una, por ejemplo:

```sql
SOURCE 03-consultas/01-usuarios-membresias.sql;
SOURCE 03-consultas/02-espacios-reservas.sql;
```

### 3.5. Cargar funciones y procedimientos

Ejecuta los scripts de funciones y procedimientos almacenados:

```sql
SOURCE 04-funciones/01-membresias.sql;
SOURCE 04-funciones/02-reservas.sql;
SOURCE 04-funciones/03-pagos-facturacion.sql;
SOURCE 04-funciones/04-accesos-asistencias.sql;

SOURCE 05-procedimientos/01-membresias.sql;
SOURCE 05-procedimientos/02-reservas-espacios.sql;
SOURCE 05-procedimientos/03-pagos-facturacion.sql;
SOURCE 05-procedimientos/04-accesos-asistencias.sql;
SOURCE 05-procedimientos/05-corporativos-admin.sql;
```

### 3.6. Activar triggers y eventos

```sql
SOURCE 06-triggers/01-membresias.sql;
SOURCE 06-triggers/02-reservas.sql;
SOURCE 06-triggers/03-pagos-facturacion.sql;
SOURCE 06-triggers/04-accesos.sql;

SOURCE 07-eventos/01-membresias.sql;
SOURCE 07-eventos/02-reservas.sql;
SOURCE 07-eventos/03-pagos-facturacion.sql;
SOURCE 07-eventos/04-accesos-asistencias.sql;
```

### 3.7. Crear roles y usuarios de ejemplo

```sql
SOURCE 08-roles-permisos/001-crear-roles-y-permisos.sql;
SOURCE 08-roles-permisos/002-crear-usuarios-ejemplo.sql;
```

## 4. Estructura de la Base de Datos

La base de datos está organizada en torno a entidades clave para la gestión operativa y financiera del coworking:

- empresas: información de las compañías asociadas al sistema.
- tipos_membresia: planes de membresía disponibles.
- usuarios: personas que hacen uso del espacio.
- tipos_espacio y espacios: categorías y ubicaciones físicas del coworking.
- membresias y historial_membresias: control del estado actual y cambios históricos de membresías.
- reservas y reserva_servicios: gestión de uso de espacios y servicios adicionales.
- pagos y facturas: registro de transacciones y documentos fiscales.
- accesos: control de entradas y salidas del coworking.
- logs: auditoría y trazabilidad de eventos importantes.

Estas tablas interactúan entre sí mediante claves foráneas y reglas de negocio implementadas mediante triggers y procedimientos.

## 5. Ejemplos de Consultas

A continuación se muestran algunos ejemplos de consultas que se pueden ejecutar:

### Consulta básica: usuarios con membresía activa

```sql
SELECT u.id, u.nombre, u.apellidos, m.estado, tm.nombre AS tipo_membresia
FROM usuarios u
JOIN membresias m ON u.id = m.usuario_id
JOIN tipos_membresia tm ON m.tipo_membresia_id = tm.id
WHERE m.estado = 'Activa';
```

### Consulta intermedia: reservas detalladas

```sql
SELECT r.id, u.nombre, esp.nombre AS espacio, r.fecha_reserva, r.hora_inicio, r.hora_fin, r.estado
FROM reservas r
JOIN usuarios u ON r.usuario_id = u.id
JOIN espacios esp ON r.espacio_id = esp.id;
```

### Consulta avanzada: ingresos por método de pago

```sql
SELECT metodo_pago, SUM(monto) AS total_ingresos
FROM pagos
WHERE estado = 'Pagado'
GROUP BY metodo_pago;
```

## 6. Procedimientos, Funciones, Triggers y Eventos

### Procedimientos almacenados

Se han implementado procedimientos para operaciones como:

- Registrar una membresía.
- Renovar una membresía.
- Verificar disponibilidad de un espacio.
- Crear y cancelar reservas.
- Generar facturas.
- Registrar accesos y registrar no-shows.

Ejemplo:

```sql
CALL sp_registrar_membresia(1, 2, 150.00);
```

### Funciones

Las funciones permiten obtener información derivada de manera rápida, por ejemplo:

```sql
SELECT fn_membresia_activa(1);
SELECT fn_total_reservas(1);
SELECT fn_total_pagado(1);
```

### Triggers

Los triggers automatizan validaciones y procesos del sistema, por ejemplo:

- Actualizar el estado de una membresía al registrar un pago.
- Evitar reservas solapadas en el mismo espacio y horario.
- Generar facturas automáticamente al confirmar un pago.
- Registrar eventos de auditoría en la tabla logs.

### Eventos

Los eventos programados ejecutan tareas periódicas, como:

- Actualizar membresías vencidas.
- Recordar renovaciones de membresía.
- Cancelar reservas pendientes que no se confirman.
- Generar reportes mensuales de facturación y asistencia.

## 7. Roles de Usuario y Permisos

El proyecto incluye cinco roles con permisos diferenciados:

- administrador: acceso total a la base de datos.
- recepcionista: lectura general y escritura sobre operaciones diarias como usuarios, membresías, reservas, pagos y accesos.
- usuario: permisos limitados para consultar catálogos y ejecutar procedimientos o funciones propias.
- gerente_corporativo: acceso a datos de empresas, usuarios, facturas y pagos para reportes y consolidación.
- contador: acceso a información financiera con permisos para consultar y ajustar facturas y pagos.

### Crear usuarios y asignar roles

Ejemplo en MySQL:

```sql
CREATE USER 'nuevo_usuario'@'%' IDENTIFIED BY 'ContraseñaSegura123!';
GRANT 'recepcionista' TO 'nuevo_usuario'@'%';
SET DEFAULT ROLE ALL TO 'nuevo_usuario'@'%';
```

También puedes ejecutar los scripts incluidos en la carpeta 08-roles-permisos para crear usuarios de ejemplo.

## 8. Contribuciones

Si este proyecto fue desarrollado en equipo, cada integrante puede registrar su participación aquí:

- Nombre del integrante 1: diseño del modelo de datos y estructura DDL.
- Nombre del integrante 2: carga de datos iniciales y scripts DML.
- Nombre del integrante 3: consultas, funciones y procedimientos almacenados.
- Nombre del integrante 4: triggers, eventos y control de permisos.

## 9. Licencia y Contacto

- Licencia: Fabio Capacho, Michael Santos, Nikolás Tolosa, Miguel Hernández
- Contacto: fabiocapachom@gmail.com 
