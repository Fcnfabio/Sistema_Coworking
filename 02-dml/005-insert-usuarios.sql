-- =====================================================
-- DATOS INICIALES: USUARIOS
-- 20 usuarios: algunos individuales, otros corporativos
-- =====================================================

-- Usuarios INDIVIDUALES (sin empresa)
INSERT INTO usuarios (empresa_id, nombre, apellidos, fecha_nacimiento, email, telefono, tipo_documento, numero_documento) VALUES
(NULL, 'Carlos', 'Martínez López', '1990-05-15', 'carlos.martinez@email.com', '+57 300 111 2233', 'CC', '1001234567'),
(NULL, 'Ana', 'Gómez Ramírez', '1988-11-22', 'ana.gomez@email.com', '+57 300 222 3344', 'CC', '1002345678'),
(NULL, 'Luis', 'Rodríguez Pérez', '1995-03-08', 'luis.rodriguez@email.com', '+57 300 333 4455', 'CC', '1003456789'),
(NULL, 'María', 'Fernández Torres', '1992-07-30', 'maria.fernandez@email.com', '+57 300 444 5566', 'CC', '1004567890'),
(NULL, 'Jorge', 'Silva Castro', '1987-01-12', 'jorge.silva@email.com', '+57 300 555 6677', 'CC', '1005678901'),
(NULL, 'Laura', 'Mendoza Ruiz', '1993-09-25', 'laura.mendoza@email.com', '+57 300 666 7788', 'CC', '1006789012'),
(NULL, 'Pedro', 'Vargas Díaz', '1991-12-03', 'pedro.vargas@email.com', '+57 300 777 8899', 'CC', '1007890123'),
(NULL, 'Sofía', 'Herrera Morales', '1996-04-18', 'sofia.herrera@email.com', '+57 300 888 9900', 'CC', '1008901234'),
(NULL, 'Diego', 'Ortiz Jiménez', '1989-08-07', 'diego.ortiz@email.com', '+57 300 999 0011', 'CC', '1009012345'),
(NULL, 'Valentina', 'Rojas Sánchez', '1994-02-14', 'valentina.rojas@email.com', '+57 301 000 1122', 'CC', '1010123456'),
(NULL, 'Andrés', 'Cruz Nieto', '1997-06-21', 'andres.cruz@email.com', '+57 301 111 2233', 'CC', '1011234567'),
(NULL, 'Camila', 'Paredes Vega', '1990-10-09', 'camila.paredes@email.com', '+57 301 222 3344', 'CC', '1012345678');

-- Usuarios CORPORATIVOS (asociados a empresas)
INSERT INTO usuarios (empresa_id, nombre, apellidos, fecha_nacimiento, email, telefono, tipo_documento, numero_documento) VALUES
(1, 'Roberto', 'Castillo Guzmán', '1985-03-20', 'roberto.castillo@techsolutions.com', '+57 310 100 1001', 'CC', '1020123456'),
(1, 'Patricia', 'Navarro Flores', '1991-07-11', 'patricia.navarro@techsolutions.com', '+57 310 100 1002', 'CC', '1020234567'),
(1, 'Fernando', 'Aguilar Ríos', '1988-12-05', 'fernando.aguilar@techsolutions.com', '+57 310 100 1003', 'CC', '1020345678'),
(2, 'Isabel', 'Montoya Herrera', '1993-05-28', 'isabel.montoya@innovatecorp.com', '+57 310 200 2001', 'CC', '1030123456'),
(2, 'Ricardo', 'Salazar Pinto', '1986-09-16', 'ricardo.salazar@innovatecorp.com', '+57 310 200 2002', 'CC', '1030234567'),
(3, 'Gabriela', 'Córdoba Luna', '1992-01-23', 'gabriela.cordoba@digitalminds.co', '+57 310 300 3001', 'CC', '1040123456'),
(4, 'Mauricio', 'Delgado Soto', '1990-11-30', 'mauricio.delgado@startuphub.com', '+57 310 400 4001', 'CC', '1050123456'),
(5, 'Natalia', 'Espinoza Reyes', '1994-04-07', 'natalia.espinoza@globalservices.com', '+57 310 500 5001', 'CC', '1060123456');

SELECT '✅ 20 usuarios insertados (12 individuales + 8 corporativos)' AS resultado;