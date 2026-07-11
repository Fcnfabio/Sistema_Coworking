-- =====================================================
-- DATOS INICIALES: EMPRESAS
-- 5 empresas de ejemplo (algunas con varios empleados)
-- =====================================================

INSERT INTO empresas (nombre, nit_rut, direccion, telefono, email) VALUES
('Tech Solutions S.A.S.', '900123456-1', 'Calle 100 #15-20, Bogotá', '+57 301 555 1001', 'contacto@techsolutions.com'),
('InnovateCorp', '900234567-2', 'Av. El Dorado #70-30, Bogotá', '+57 301 555 1002', 'info@innovatecorp.com'),
('Digital Minds Ltda.', '900345678-3', 'Carrera 7 #45-12, Medellín', '+57 301 555 1003', 'admin@digitalminds.co'),
('StartUp Hub', '900456789-4', 'Calle 85 #20-50, Bogotá', '+57 301 555 1004', 'hola@startuphub.com'),
('Global Services Inc.', '900567890-5', 'Av. 68 #90-15, Bogotá', '+57 301 555 1005', 'contact@globalservices.com');

SELECT '✅ 5 empresas insertadas' AS resultado;