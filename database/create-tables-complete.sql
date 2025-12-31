-- ============================================
-- SCRIPT COMPLETO PARA CREAR TABLAS Y DATOS
-- ============================================

-- Crear tabla empresas
CREATE TABLE IF NOT EXISTS empresas (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre VARCHAR(255) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Crear tabla locaciones
CREATE TABLE IF NOT EXISTS locaciones (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  empresa_id UUID NOT NULL REFERENCES empresas(id),
  nombre VARCHAR(255) NOT NULL,
  direccion TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Crear tabla sectores
CREATE TABLE IF NOT EXISTS sectores (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre VARCHAR(255) NOT NULL UNIQUE,
  descripcion TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Crear tabla equipos
CREATE TABLE IF NOT EXISTS equipos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  empresa_id UUID NOT NULL REFERENCES empresas(id),
  locacion_id UUID NOT NULL REFERENCES locaciones(id),
  sector_id UUID REFERENCES sectores(id),
  nro_equipo INTEGER NOT NULL,
  marca VARCHAR(100) NOT NULL,
  tipo_capacidad VARCHAR(100) NOT NULL,
  ubicacion VARCHAR(255),
  puesto INTEGER,
  vida_util INTEGER,
  fecha_instalacion DATE,
  estado VARCHAR(50) DEFAULT 'activo',
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Crear tabla vencimientos
CREATE TABLE IF NOT EXISTS vencimientos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  equipo_id UUID NOT NULL REFERENCES equipos(id),
  fecha_carga DATE NOT NULL,
  fecha_ph DATE NOT NULL,
  ultima_revision DATE,
  proxima_revision DATE,
  estado VARCHAR(50) DEFAULT 'vigente',
  notas TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- INSERTAR DATOS FICTICIOS
-- ============================================

-- Insertar empresas
INSERT INTO empresas (nombre) VALUES
  ('LINOR SRL'),
  ('TecnoPalet'),
  ('Industrias Gómez'),
  ('Construcciones Martínez')
ON CONFLICT (nombre) DO NOTHING;

-- Insertar sectores
INSERT INTO sectores (nombre, descripcion) VALUES
  ('Aserradero', 'Área de procesamiento de madera'),
  ('Administración', 'Oficinas administrativas'),
  ('Almacén', 'Depósito y almacenamiento'),
  ('Producción', 'Línea de producción'),
  ('Seguridad', 'Área de seguridad'),
  ('Mantenimiento', 'Taller de mantenimiento')
ON CONFLICT (nombre) DO NOTHING;

-- Insertar locaciones para LINOR SRL
INSERT INTO locaciones (empresa_id, nombre, direccion) VALUES
  ((SELECT id FROM empresas WHERE nombre = 'LINOR SRL'), 'ASERRADERO', 'Ruta Nacional 2, km 45'),
  ((SELECT id FROM empresas WHERE nombre = 'LINOR SRL'), 'OFICINA', 'Av. Principal 123')
ON CONFLICT DO NOTHING;

-- Insertar locaciones para TecnoPalet
INSERT INTO locaciones (empresa_id, nombre, direccion) VALUES
  ((SELECT id FROM empresas WHERE nombre = 'TecnoPalet'), 'Aserradero', 'Ruta 5, km 12'),
  ((SELECT id FROM empresas WHERE nombre = 'TecnoPalet'), 'Planta Norte', 'Calle Industrial 456')
ON CONFLICT DO NOTHING;

-- Insertar locaciones para Industrias Gómez
INSERT INTO locaciones (empresa_id, nombre, direccion) VALUES
  ((SELECT id FROM empresas WHERE nombre = 'Industrias Gómez'), 'Planta Principal', 'Av. Comercial 789'),
  ((SELECT id FROM empresas WHERE nombre = 'Industrias Gómez'), 'Depósito', 'Calle Secundaria 321')
ON CONFLICT DO NOTHING;

-- Insertar locaciones para Construcciones Martínez
INSERT INTO locaciones (empresa_id, nombre, direccion) VALUES
  ((SELECT id FROM empresas WHERE nombre = 'Construcciones Martínez'), 'Sede Central', 'Av. Obras Públicas 654')
ON CONFLICT DO NOTHING;

-- Insertar equipos para LINOR SRL - ASERRADERO
INSERT INTO equipos (empresa_id, locacion_id, sector_id, nro_equipo, marca, tipo_capacidad, ubicacion, puesto, vida_util, fecha_instalacion, estado) VALUES
  ((SELECT id FROM empresas WHERE nombre = 'LINOR SRL'),
   (SELECT id FROM locaciones WHERE nombre = 'ASERRADERO' AND empresa_id = (SELECT id FROM empresas WHERE nombre = 'LINOR SRL')),
   (SELECT id FROM sectores WHERE nombre = 'Aserradero'),
   1, 'GEORGIA', 'PQS ABC-10', 'Armado de pallets', 2, 2040, '2020-05-15', 'activo'),
  
  ((SELECT id FROM empresas WHERE nombre = 'LINOR SRL'),
   (SELECT id FROM locaciones WHERE nombre = 'ASERRADERO' AND empresa_id = (SELECT id FROM empresas WHERE nombre = 'LINOR SRL')),
   (SELECT id FROM sectores WHERE nombre = 'Aserradero'),
   2, 'GEORGIA', 'PQS ABC-5', 'Línea 3 de aserrado', 4, 2040, '2020-06-10', 'activo'),
  
  ((SELECT id FROM empresas WHERE nombre = 'LINOR SRL'),
   (SELECT id FROM locaciones WHERE nombre = 'ASERRADERO' AND empresa_id = (SELECT id FROM empresas WHERE nombre = 'LINOR SRL')),
   (SELECT id FROM sectores WHERE nombre = 'Aserradero'),
   3, 'ANTARTIDA', 'HCFC 123 ABC-10', 'Zona de empaque', 5, 2045, '2020-07-20', 'activo'),
  
  ((SELECT id FROM empresas WHERE nombre = 'LINOR SRL'),
   (SELECT id FROM locaciones WHERE nombre = 'ASERRADERO' AND empresa_id = (SELECT id FROM empresas WHERE nombre = 'LINOR SRL')),
   (SELECT id FROM sectores WHERE nombre = 'Aserradero'),
   4, 'GEORGIA', 'PQS ABC-10', 'Entrada principal', 1, 2040, '2020-08-05', 'activo'),
  
  ((SELECT id FROM empresas WHERE nombre = 'LINOR SRL'),
   (SELECT id FROM locaciones WHERE nombre = 'ASERRADERO' AND empresa_id = (SELECT id FROM empresas WHERE nombre = 'LINOR SRL')),
   (SELECT id FROM sectores WHERE nombre = 'Administración'),
   5, 'GEORGIA', 'PQS ABC-5', 'Comedor', 3, 2040, '2020-09-12', 'activo'),
  
  ((SELECT id FROM empresas WHERE nombre = 'LINOR SRL'),
   (SELECT id FROM locaciones WHERE nombre = 'ASERRADERO' AND empresa_id = (SELECT id FROM empresas WHERE nombre = 'LINOR SRL')),
   (SELECT id FROM sectores WHERE nombre = 'Seguridad'),
   6, 'ANTARTIDA', 'HCFC 123 ABC-5', 'Sanitarios', 7, 2043, '2020-10-18', 'activo'),
  
  ((SELECT id FROM empresas WHERE nombre = 'LINOR SRL'),
   (SELECT id FROM locaciones WHERE nombre = 'ASERRADERO' AND empresa_id = (SELECT id FROM empresas WHERE nombre = 'LINOR SRL')),
   (SELECT id FROM sectores WHERE nombre = 'Mantenimiento'),
   7, 'GEORGIA', 'PQS ABC-10', 'Taller de mantenimiento', 8, 2040, '2020-11-22', 'activo')
ON CONFLICT DO NOTHING;

-- Insertar equipos para LINOR SRL - OFICINA
INSERT INTO equipos (empresa_id, locacion_id, sector_id, nro_equipo, marca, tipo_capacidad, ubicacion, puesto, vida_util, fecha_instalacion, estado) VALUES
  ((SELECT id FROM empresas WHERE nombre = 'LINOR SRL'),
   (SELECT id FROM locaciones WHERE nombre = 'OFICINA' AND empresa_id = (SELECT id FROM empresas WHERE nombre = 'LINOR SRL')),
   (SELECT id FROM sectores WHERE nombre = 'Administración'),
   8, 'GEORGIA', 'PQS ABC-5', 'Recepción', 1, 2040, '2021-01-10', 'activo'),
  
  ((SELECT id FROM empresas WHERE nombre = 'LINOR SRL'),
   (SELECT id FROM locaciones WHERE nombre = 'OFICINA' AND empresa_id = (SELECT id FROM empresas WHERE nombre = 'LINOR SRL')),
   (SELECT id FROM sectores WHERE nombre = 'Administración'),
   9, 'GEORGIA', 'PQS ABC-5', 'Gerencia', 2, 2040, '2021-02-15', 'activo')
ON CONFLICT DO NOTHING;

-- Insertar equipos para TecnoPalet
INSERT INTO equipos (empresa_id, locacion_id, sector_id, nro_equipo, marca, tipo_capacidad, ubicacion, puesto, vida_util, fecha_instalacion, estado) VALUES
  ((SELECT id FROM empresas WHERE nombre = 'TecnoPalet'),
   (SELECT id FROM locaciones WHERE nombre = 'Aserradero' AND empresa_id = (SELECT id FROM empresas WHERE nombre = 'TecnoPalet')),
   (SELECT id FROM sectores WHERE nombre = 'Administración'),
   10, 'ANTARTIDA', 'HCFC 123 ABC-10', 'Oficina', 8, 2045, '2021-03-20', 'activo'),
  
  ((SELECT id FROM empresas WHERE nombre = 'TecnoPalet'),
   (SELECT id FROM locaciones WHERE nombre = 'Planta Norte' AND empresa_id = (SELECT id FROM empresas WHERE nombre = 'TecnoPalet')),
   (SELECT id FROM sectores WHERE nombre = 'Producción'),
   11, 'GEORGIA', 'PQS ABC-10', 'Línea 1', 2, 2040, '2021-04-25', 'activo'),
  
  ((SELECT id FROM empresas WHERE nombre = 'TecnoPalet'),
   (SELECT id FROM locaciones WHERE nombre = 'Planta Norte' AND empresa_id = (SELECT id FROM empresas WHERE nombre = 'TecnoPalet')),
   (SELECT id FROM sectores WHERE nombre = 'Almacén'),
   12, 'GEORGIA', 'PQS ABC-5', 'Almacén', 5, 2040, '2021-05-30', 'activo')
ON CONFLICT DO NOTHING;

-- Insertar equipos para Industrias Gómez
INSERT INTO equipos (empresa_id, locacion_id, sector_id, nro_equipo, marca, tipo_capacidad, ubicacion, puesto, vida_util, fecha_instalacion, estado) VALUES
  ((SELECT id FROM empresas WHERE nombre = 'Industrias Gómez'),
   (SELECT id FROM locaciones WHERE nombre = 'Planta Principal' AND empresa_id = (SELECT id FROM empresas WHERE nombre = 'Industrias Gómez')),
   (SELECT id FROM sectores WHERE nombre = 'Producción'),
   13, 'GEORGIA', 'PQS ABC-10', 'Línea A', 3, 2040, '2021-06-15', 'activo'),
  
  ((SELECT id FROM empresas WHERE nombre = 'Industrias Gómez'),
   (SELECT id FROM locaciones WHERE nombre = 'Planta Principal' AND empresa_id = (SELECT id FROM empresas WHERE nombre = 'Industrias Gómez')),
   (SELECT id FROM sectores WHERE nombre = 'Producción'),
   14, 'ANTARTIDA', 'HCFC 123 ABC-10', 'Línea B', 4, 2045, '2021-07-20', 'activo'),
  
  ((SELECT id FROM empresas WHERE nombre = 'Industrias Gómez'),
   (SELECT id FROM locaciones WHERE nombre = 'Depósito' AND empresa_id = (SELECT id FROM empresas WHERE nombre = 'Industrias Gómez')),
   (SELECT id FROM sectores WHERE nombre = 'Almacén'),
   15, 'GEORGIA', 'PQS ABC-5', 'Entrada', 1, 2040, '2021-08-10', 'activo')
ON CONFLICT DO NOTHING;

-- Insertar equipos para Construcciones Martínez
INSERT INTO equipos (empresa_id, locacion_id, sector_id, nro_equipo, marca, tipo_capacidad, ubicacion, puesto, vida_util, fecha_instalacion, estado) VALUES
  ((SELECT id FROM empresas WHERE nombre = 'Construcciones Martínez'),
   (SELECT id FROM locaciones WHERE nombre = 'Sede Central' AND empresa_id = (SELECT id FROM empresas WHERE nombre = 'Construcciones Martínez')),
   (SELECT id FROM sectores WHERE nombre = 'Seguridad'),
   16, 'GEORGIA', 'PQS ABC-10', 'Hall principal', 1, 2040, '2021-09-05', 'activo'),
  
  ((SELECT id FROM empresas WHERE nombre = 'Construcciones Martínez'),
   (SELECT id FROM locaciones WHERE nombre = 'Sede Central' AND empresa_id = (SELECT id FROM empresas WHERE nombre = 'Construcciones Martínez')),
   (SELECT id FROM sectores WHERE nombre = 'Administración'),
   17, 'ANTARTIDA', 'HCFC 123 ABC-5', 'Oficinas', 2, 2043, '2021-10-12', 'activo')
ON CONFLICT DO NOTHING;

-- Insertar vencimientos para equipos
INSERT INTO vencimientos (equipo_id, fecha_carga, fecha_ph, estado) VALUES
  -- Mayo 2025 (4 equipos)
  ((SELECT id FROM equipos WHERE nro_equipo = 1 LIMIT 1), '2024-05-01', '2025-05-01', 'vigente'),
  ((SELECT id FROM equipos WHERE nro_equipo = 2 LIMIT 1), '2024-05-01', '2025-05-01', 'vigente'),
  ((SELECT id FROM equipos WHERE nro_equipo = 3 LIMIT 1), '2024-05-10', '2025-05-10', 'vigente'),
  ((SELECT id FROM equipos WHERE nro_equipo = 4 LIMIT 1), '2024-05-15', '2025-05-15', 'vigente'),
  
  -- Septiembre 2025 (4 equipos)
  ((SELECT id FROM equipos WHERE nro_equipo = 5 LIMIT 1), '2024-09-01', '2025-09-01', 'vigente'),
  ((SELECT id FROM equipos WHERE nro_equipo = 6 LIMIT 1), '2024-09-05', '2025-09-05', 'vigente'),
  ((SELECT id FROM equipos WHERE nro_equipo = 7 LIMIT 1), '2024-09-12', '2025-09-12', 'vigente'),
  ((SELECT id FROM equipos WHERE nro_equipo = 8 LIMIT 1), '2024-09-20', '2025-09-20', 'vigente'),
  
  -- Octubre 2025 (3 equipos)
  ((SELECT id FROM equipos WHERE nro_equipo = 9 LIMIT 1), '2024-10-01', '2025-10-01', 'vigente'),
  ((SELECT id FROM equipos WHERE nro_equipo = 10 LIMIT 1), '2024-10-10', '2025-10-10', 'vigente'),
  ((SELECT id FROM equipos WHERE nro_equipo = 11 LIMIT 1), '2024-10-15', '2025-10-15', 'vigente'),
  
  -- Noviembre 2025 (3 equipos)
  ((SELECT id FROM equipos WHERE nro_equipo = 12 LIMIT 1), '2024-11-01', '2025-11-01', 'vigente'),
  ((SELECT id FROM equipos WHERE nro_equipo = 13 LIMIT 1), '2024-11-05', '2025-11-05', 'vigente'),
  ((SELECT id FROM equipos WHERE nro_equipo = 14 LIMIT 1), '2024-11-12', '2025-11-12', 'vigente'),
  
  -- Diciembre 2025 (4 equipos)
  ((SELECT id FROM equipos WHERE nro_equipo = 15 LIMIT 1), '2024-12-01', '2025-12-01', 'vigente'),
  ((SELECT id FROM equipos WHERE nro_equipo = 16 LIMIT 1), '2024-12-05', '2025-12-05', 'vigente'),
  ((SELECT id FROM equipos WHERE nro_equipo = 17 LIMIT 1), '2024-12-10', '2025-12-10', 'vigente'),
  ((SELECT id FROM equipos WHERE nro_equipo = 1 LIMIT 1), '2024-12-15', '2025-12-15', 'vigente')
ON CONFLICT DO NOTHING;

-- Crear índices para mejorar performance
CREATE INDEX IF NOT EXISTS idx_equipos_empresa ON equipos(empresa_id);
CREATE INDEX IF NOT EXISTS idx_equipos_locacion ON equipos(locacion_id);
CREATE INDEX IF NOT EXISTS idx_equipos_sector ON equipos(sector_id);
CREATE INDEX IF NOT EXISTS idx_vencimientos_equipo ON vencimientos(equipo_id);
CREATE INDEX IF NOT EXISTS idx_vencimientos_fecha ON vencimientos(fecha_ph);
CREATE INDEX IF NOT EXISTS idx_locaciones_empresa ON locaciones(empresa_id);
