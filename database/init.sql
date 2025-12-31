-- Script SQL para crear las tablas en Supabase
-- Ejecutar este script en el SQL Editor de Supabase

-- Crear tabla de usuarios
CREATE TABLE IF NOT EXISTS users (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) DEFAULT 'user',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Crear índice para email (optimizar búsquedas)
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- Crear tabla de empresas
CREATE TABLE IF NOT EXISTS empresas (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL UNIQUE,
    ruc VARCHAR(20),
    telefono VARCHAR(20),
    email VARCHAR(255),
    direccion TEXT,
    contacto_principal VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Crear tabla de locaciones
CREATE TABLE IF NOT EXISTS locaciones (
    id SERIAL PRIMARY KEY,
    empresa_id INTEGER NOT NULL REFERENCES empresas(id) ON DELETE CASCADE,
    nombre VARCHAR(255) NOT NULL,
    direccion TEXT,
    provincia VARCHAR(100),
    telefono VARCHAR(20),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Crear tabla de planes de acción
CREATE TABLE IF NOT EXISTS planes_accion (
    id SERIAL PRIMARY KEY,
    empresa_id INTEGER NOT NULL REFERENCES empresas(id) ON DELETE CASCADE,
    locacion_id INTEGER REFERENCES locaciones(id) ON DELETE SET NULL,
    fecha DATE NOT NULL,
    descripcion TEXT NOT NULL,
    estado VARCHAR(50) DEFAULT 'pendiente',
    responsable VARCHAR(255),
    fecha_vencimiento DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Crear tabla de visitas por formulario
CREATE TABLE IF NOT EXISTS visitas_formulario (
    id SERIAL PRIMARY KEY,
    empresa_id INTEGER NOT NULL REFERENCES empresas(id) ON DELETE CASCADE,
    mes DATE NOT NULL,
    tipo_formulario VARCHAR(50) NOT NULL,
    cantidad INTEGER DEFAULT 1,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Crear tabla de vencimientos de equipos
CREATE TABLE IF NOT EXISTS vencimientos_equipos (
    id SERIAL PRIMARY KEY,
    empresa_id INTEGER NOT NULL REFERENCES empresas(id) ON DELETE CASCADE,
    locacion_id INTEGER REFERENCES locaciones(id) ON DELETE SET NULL,
    cliente VARCHAR(255) NOT NULL,
    numero_equipo VARCHAR(100),
    ubicacion VARCHAR(255),
    sector VARCHAR(100),
    marca VARCHAR(100),
    tipo_capacidad VARCHAR(100),
    vida_util VARCHAR(50),
    vencimiento_carga DATE,
    vencimiento_ph DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Crear función para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear triggers para actualizar updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_empresas_updated_at BEFORE UPDATE ON empresas FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_locaciones_updated_at BEFORE UPDATE ON locaciones FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_planes_accion_updated_at BEFORE UPDATE ON planes_accion FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_visitas_formulario_updated_at BEFORE UPDATE ON visitas_formulario FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_vencimientos_equipos_updated_at BEFORE UPDATE ON vencimientos_equipos FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insertar usuario administrador por defecto (contraseña: admin123)
INSERT INTO users (name, email, password, role) 
VALUES (
    'Administrador',
    'admin@potenciaactiva.com',
    '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
    'admin'
) ON CONFLICT (email) DO NOTHING;

-- Insertar usuario de prueba (contraseña: user123)
INSERT INTO users (name, email, password, role) 
VALUES (
    'Usuario Prueba',
    'usuario@potenciaactiva.com',
    '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
    'user'
) ON CONFLICT (email) DO NOTHING;

-- Insertar empresas
INSERT INTO empresas (nombre, ruc, telefono, email, contacto_principal) VALUES
('Carpal', '80123456', '0381-4123456', 'contacto@carpal.com', 'Juan García'),
('LINOR SRL', '80654321', '0381-4654321', 'info@linor.com', 'María López'),
('TecnoPalet', '80555666', '0381-4555666', 'ventas@tecnopalet.com', 'Carlos Rodríguez'),
('Distribuidora González', '80777888', '0381-4777888', 'contacto@gonzalez.com', 'Ana González'),
('Metalúrgica del Sur', '80999000', '0381-4999000', 'info@metalurgica.com', 'Roberto Martínez')
ON CONFLICT (nombre) DO NOTHING;

-- Insertar locaciones
INSERT INTO locaciones (empresa_id, nombre, direccion, provincia) VALUES
((SELECT id FROM empresas WHERE nombre = 'Carpal'), 'Almacén Principal', 'Av. Belgrano 1234', 'Misiones'),
((SELECT id FROM empresas WHERE nombre = 'Carpal'), 'Oficina Administrativa', 'Mitre 567', 'Misiones'),
((SELECT id FROM empresas WHERE nombre = 'LINOR SRL'), 'Planta A', 'Ruta 12 km 45', 'Misiones'),
((SELECT id FROM empresas WHERE nombre = 'LINOR SRL'), 'Depósito', 'Independencia 890', 'Misiones'),
((SELECT id FROM empresas WHERE nombre = 'TecnoPalet'), 'Zona de carga', 'San Martín 2345', 'Misiones'),
((SELECT id FROM empresas WHERE nombre = 'TecnoPalet'), 'Planta B', 'Rivadavia 456', 'Misiones'),
((SELECT id FROM empresas WHERE nombre = 'Distribuidora González'), 'Oficinas', 'Junín 789', 'Corrientes'),
((SELECT id FROM empresas WHERE nombre = 'Metalúrgica del Sur'), 'Taller', 'Sarmiento 1111', 'Misiones')
ON CONFLICT DO NOTHING;

-- Insertar planes de acción
INSERT INTO planes_accion (empresa_id, locacion_id, fecha, descripcion, estado, responsable) VALUES
((SELECT id FROM empresas WHERE nombre = 'Carpal'), (SELECT id FROM locaciones WHERE nombre = 'Almacén Principal'), '2025-12-15', 'Implementar sistema de seguridad', 'en-proceso', 'Juan García'),
((SELECT id FROM empresas WHERE nombre = 'LINOR SRL'), (SELECT id FROM locaciones WHERE nombre = 'Planta A'), '2025-12-20', 'Mantenimiento preventivo de maquinaria', 'pendiente', 'Carlos Pérez'),
((SELECT id FROM empresas WHERE nombre = 'TecnoPalet'), (SELECT id FROM locaciones WHERE nombre = 'Zona de carga'), '2025-12-10', 'Capacitación de personal de seguridad', 'completado', 'María López'),
((SELECT id FROM empresas WHERE nombre = 'Distribuidora González'), (SELECT id FROM locaciones WHERE nombre = 'Oficinas'), '2025-12-25', 'Auditoría de procesos', 'pendiente', 'Ana González'),
((SELECT id FROM empresas WHERE nombre = 'Metalúrgica del Sur'), (SELECT id FROM locaciones WHERE nombre = 'Taller'), '2025-12-05', 'Revisión de equipos de protección', 'completado', 'Roberto Martínez'),
((SELECT id FROM empresas WHERE nombre = 'Carpal'), (SELECT id FROM locaciones WHERE nombre = 'Oficina Administrativa'), '2025-11-30', 'Actualizar procedimientos', 'en-proceso', 'Juan García'),
((SELECT id FROM empresas WHERE nombre = 'LINOR SRL'), (SELECT id FROM locaciones WHERE nombre = 'Depósito'), '2025-12-18', 'Inspección de instalaciones eléctricas', 'pendiente', 'Carlos Pérez'),
((SELECT id FROM empresas WHERE nombre = 'TecnoPalet'), (SELECT id FROM locaciones WHERE nombre = 'Planta B'), '2025-12-08', 'Implementar mejoras sugeridas', 'en-proceso', 'María López')
ON CONFLICT DO NOTHING;

-- Insertar visitas por formulario
INSERT INTO visitas_formulario (empresa_id, mes, tipo_formulario, cantidad) VALUES
((SELECT id FROM empresas WHERE nombre = 'Carpal'), '2025-05-01', 'GE', 0),
((SELECT id FROM empresas WHERE nombre = 'Carpal'), '2025-05-01', 'RU', 1),
((SELECT id FROM empresas WHERE nombre = 'Carpal'), '2025-05-01', 'ER', 1),
((SELECT id FROM empresas WHERE nombre = 'Forestal San Matteo'), '2025-05-01', 'VL', 1),
((SELECT id FROM empresas WHERE nombre = 'LINOR SRL'), '2025-05-01', 'GE', 1),
((SELECT id FROM empresas WHERE nombre = 'Carpal'), '2025-06-01', 'GE', 1),
((SELECT id FROM empresas WHERE nombre = 'Carpal'), '2025-06-01', 'RO', 1),
((SELECT id FROM empresas WHERE nombre = 'LINOR SRL'), '2025-06-01', 'RU', 1),
((SELECT id FROM empresas WHERE nombre = 'Carpal'), '2025-07-01', 'RU', 1),
((SELECT id FROM empresas WHERE nombre = 'Carpal'), '2025-07-01', 'TI', 1),
((SELECT id FROM empresas WHERE nombre = 'TecnoPalet'), '2025-07-01', 'IL', 1)
ON CONFLICT DO NOTHING;

-- Insertar vencimientos de equipos
INSERT INTO vencimientos_equipos (empresa_id, locacion_id, cliente, numero_equipo, ubicacion, sector, marca, tipo_capacidad, vida_util, vencimiento_carga, vencimiento_ph) VALUES
((SELECT id FROM empresas WHERE nombre = 'Carpal'), (SELECT id FROM locaciones WHERE nombre = 'Almacén Principal'), 'Carpal', 'EQ-001', 'Zona A', 'Almacén', 'ABAC', '100 Lt', '5 años', '2025-05-15', '2025-08-20'),
((SELECT id FROM empresas WHERE nombre = 'LINOR SRL'), (SELECT id FROM locaciones WHERE nombre = 'Planta A'), 'LINOR SRL', 'EQ-002', 'Taller', 'Producción', 'Atlas', '150 Lt', '10 años', '2025-09-10', '2025-10-30'),
((SELECT id FROM empresas WHERE nombre = 'TecnoPalet'), (SELECT id FROM locaciones WHERE nombre = 'Zona de carga'), 'TecnoPalet', 'EQ-003', 'Plataforma', 'Carga', 'Kaeser', '200 Lt', '15 años', '2025-10-05', '2025-11-15'),
((SELECT id FROM empresas WHERE nombre = 'Distribuidora González'), (SELECT id FROM locaciones WHERE nombre = 'Oficinas'), 'Distribuidora González', 'EQ-004', 'Oficina', 'Administrativo', 'Fini', '50 Lt', '3 años', '2025-11-20', '2025-12-10'),
((SELECT id FROM empresas WHERE nombre = 'Metalúrgica del Sur'), (SELECT id FROM locaciones WHERE nombre = 'Taller'), 'Metalúrgica del Sur', 'EQ-005', 'Taller Soldadura', 'Producción', 'Ingersoll', '250 Lt', '20 años', '2025-12-25', '2026-01-15')
ON CONFLICT DO NOTHING;

-- Habilitar Row Level Security (RLS)
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Crear políticas de seguridad
-- Los usuarios solo pueden leer/actualizar sus propios datos
CREATE POLICY "Users can view own data" ON users
    FOR SELECT USING (auth.uid() = id::text OR auth.role() = 'service_role');

CREATE POLICY "Users can update own data" ON users
    FOR UPDATE USING (auth.uid() = id::text OR auth.role() = 'service_role');

-- Solo admins pueden insertar nuevos usuarios
CREATE POLICY "Only service can insert users" ON users
    FOR INSERT WITH CHECK (auth.role() = 'service_role');