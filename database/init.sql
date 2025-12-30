-- Script SQL para crear la tabla de usuarios en Supabase
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

-- Crear función para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear trigger para actualizar updated_at
CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

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