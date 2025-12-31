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

-- Insertar datos de ejemplo
INSERT INTO empresas (nombre) VALUES
  ('LINOR SRL'),
  ('TecnoPalet')
ON CONFLICT (nombre) DO NOTHING;

-- Obtener IDs de empresas para usarlas en locaciones
DO $$
DECLARE
  linor_id UUID;
  tecnopalet_id UUID;
BEGIN
  SELECT id INTO linor_id FROM empresas WHERE nombre = 'LINOR SRL';
  SELECT id INTO tecnopalet_id FROM empresas WHERE nombre = 'TecnoPalet';

  -- Insertar locaciones
  INSERT INTO locaciones (empresa_id, nombre) VALUES
    (linor_id, 'ASERRADERO'),
    (linor_id, 'OFICINA'),
    (tecnopalet_id, 'Aserradero')
  ON CONFLICT DO NOTHING;

  -- Insertar sectores
  INSERT INTO sectores (nombre) VALUES
    ('Aserradero'),
    ('Administracion'),
    ('Almacen')
  ON CONFLICT (nombre) DO NOTHING;

  -- Insertar equipos
  INSERT INTO equipos (empresa_id, locacion_id, sector_id, nro_equipo, marca, tipo_capacidad, ubicacion, puesto, vida_util)
  SELECT 
    linor_id,
    (SELECT id FROM locaciones WHERE nombre = 'ASERRADERO' AND empresa_id = linor_id),
    (SELECT id FROM sectores WHERE nombre = 'Aserradero'),
    1,
    'GEORGIA',
    'PQS ABC-10',
    'Armado de pallets',
    2,
    2040
  WHERE NOT EXISTS (SELECT 1 FROM equipos WHERE nro_equipo = 1 AND empresa_id = linor_id);

  INSERT INTO equipos (empresa_id, locacion_id, sector_id, nro_equipo, marca, tipo_capacidad, ubicacion, puesto, vida_util)
  SELECT 
    linor_id,
    (SELECT id FROM locaciones WHERE nombre = 'ASERRADERO' AND empresa_id = linor_id),
    (SELECT id FROM sectores WHERE nombre = 'Aserradero'),
    1,
    'GEORGIA',
    'PQS ABC-5',
    'Linea 3 de aserrado',
    4,
    2040
  WHERE NOT EXISTS (SELECT 1 FROM equipos WHERE nro_equipo = 1 AND empresa_id = linor_id AND puesto = 4);

  INSERT INTO equipos (empresa_id, locacion_id, sector_id, nro_equipo, marca, tipo_capacidad, ubicacion, puesto, vida_util)
  SELECT 
    tecnopalet_id,
    (SELECT id FROM locaciones WHERE nombre = 'Aserradero' AND empresa_id = tecnopalet_id),
    (SELECT id FROM sectores WHERE nombre = 'Administracion'),
    8,
    'ANTARTIDA',
    'HCFC 123 ABC-10',
    'oficina',
    8,
    2045
  WHERE NOT EXISTS (SELECT 1 FROM equipos WHERE nro_equipo = 8 AND empresa_id = tecnopalet_id);

  -- Insertar vencimientos
  INSERT INTO vencimientos (equipo_id, fecha_carga, fecha_ph, estado)
  SELECT 
    (SELECT id FROM equipos WHERE nro_equipo = 1 AND empresa_id = linor_id AND puesto = 2 LIMIT 1),
    '2024-05-01',
    '2025-05-01',
    'vigente';

  INSERT INTO vencimientos (equipo_id, fecha_carga, fecha_ph, estado)
  SELECT 
    (SELECT id FROM equipos WHERE nro_equipo = 1 AND empresa_id = linor_id AND puesto = 4 LIMIT 1),
    '2024-05-01',
    '2025-05-01',
    'vigente';

  INSERT INTO vencimientos (equipo_id, fecha_carga, fecha_ph, estado)
  SELECT 
    (SELECT id FROM equipos WHERE nro_equipo = 8 AND empresa_id = tecnopalet_id LIMIT 1),
    '2025-05-01',
    '2025-05-01',
    'vigente';

END $$;

-- Crear índices para mejorar performance
CREATE INDEX IF NOT EXISTS idx_equipos_empresa ON equipos(empresa_id);
CREATE INDEX IF NOT EXISTS idx_equipos_locacion ON equipos(locacion_id);
CREATE INDEX IF NOT EXISTS idx_equipos_sector ON equipos(sector_id);
CREATE INDEX IF NOT EXISTS idx_vencimientos_equipo ON vencimientos(equipo_id);
CREATE INDEX IF NOT EXISTS idx_vencimientos_fecha ON vencimientos(fecha_ph);
CREATE INDEX IF NOT EXISTS idx_locaciones_empresa ON locaciones(empresa_id);
