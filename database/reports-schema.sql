-- Tabla de Visitas por Formulario
CREATE TABLE IF NOT EXISTS visitas_formulario (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    empresa_id UUID REFERENCES empresas(id) ON DELETE CASCADE,
    tipo_formulario VARCHAR(255) NOT NULL,
    cantidad INTEGER DEFAULT 1,
    fecha DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Vencimientos de Equipos
CREATE TABLE IF NOT EXISTS vencimientos_equipos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    empresa_id UUID REFERENCES empresas(id) ON DELETE CASCADE,
    locacion_id UUID REFERENCES locaciones(id) ON DELETE CASCADE,
    tipo_equipo VARCHAR(255) NOT NULL,
    descripcion TEXT,
    ultima_revision DATE,
    proximo_vencimiento DATE NOT NULL,
    estado VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Calendario de Eventos
CREATE TABLE IF NOT EXISTS calendario_eventos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    empresa_id UUID REFERENCES empresas(id) ON DELETE CASCADE,
    tipo VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    fecha DATE NOT NULL,
    hora TIME,
    ubicacion VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Notificaciones de Servicios
CREATE TABLE IF NOT EXISTS notificaciones_servicios (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    titulo VARCHAR(255) NOT NULL,
    descripcion TEXT,
    tipo VARCHAR(50) NOT NULL,
    estado VARCHAR(50) NOT NULL DEFAULT 'pendiente',
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear índices para mejor rendimiento
CREATE INDEX IF NOT EXISTS idx_visitas_empresa ON visitas_formulario(empresa_id);
CREATE INDEX IF NOT EXISTS idx_visitas_fecha ON visitas_formulario(fecha);
CREATE INDEX IF NOT EXISTS idx_vencimientos_empresa ON vencimientos_equipos(empresa_id);
CREATE INDEX IF NOT EXISTS idx_vencimientos_estado ON vencimientos_equipos(proximo_vencimiento);
CREATE INDEX IF NOT EXISTS idx_calendario_empresa ON calendario_eventos(empresa_id);
CREATE INDEX IF NOT EXISTS idx_calendario_fecha ON calendario_eventos(fecha);
CREATE INDEX IF NOT EXISTS idx_notificaciones_estado ON notificaciones_servicios(estado);

-- Datos de prueba: Visitas por Formulario
INSERT INTO visitas_formulario (empresa_id, tipo_formulario, cantidad, fecha) 
SELECT 
    (SELECT id FROM empresas LIMIT 1),
    'Inspección',
    3,
    '2024-01-15'::date
UNION ALL SELECT (SELECT id FROM empresas LIMIT 1), 'Mantenimiento', 2, '2024-01-16'::date
UNION ALL SELECT (SELECT id FROM empresas LIMIT 1), 'Reparación', 1, '2024-01-17'::date
UNION ALL SELECT (SELECT id FROM empresas LIMIT 1 OFFSET 1), 'Inspección', 4, '2024-01-15'::date
UNION ALL SELECT (SELECT id FROM empresas LIMIT 1 OFFSET 1), 'Capacitación', 2, '2024-01-18'::date
UNION ALL SELECT (SELECT id FROM empresas LIMIT 1), 'Inspección', 5, '2024-01-20'::date
UNION ALL SELECT (SELECT id FROM empresas LIMIT 1 OFFSET 1), 'Mantenimiento', 3, '2024-01-21'::date;

-- Datos de prueba: Vencimientos de Equipos
INSERT INTO vencimientos_equipos (empresa_id, locacion_id, tipo_equipo, descripcion, ultima_revision, proximo_vencimiento, estado) 
SELECT 
    (SELECT id FROM empresas LIMIT 1),
    (SELECT id FROM locaciones WHERE empresa_id = (SELECT id FROM empresas LIMIT 1) LIMIT 1),
    'Extintor',
    'Extintor tipo ABC - Sala 101',
    '2023-12-01'::date,
    '2024-06-01'::date,
    'vigente'
UNION ALL SELECT (SELECT id FROM empresas LIMIT 1), (SELECT id FROM locaciones WHERE empresa_id = (SELECT id FROM empresas LIMIT 1) LIMIT 1), 'Extintor', 'Extintor tipo CO2 - Sala Servidores', '2023-11-15'::date, '2024-02-15'::date, 'proximo'
UNION ALL SELECT (SELECT id FROM empresas LIMIT 1), (SELECT id FROM locaciones WHERE empresa_id = (SELECT id FROM empresas LIMIT 1) LIMIT 1 OFFSET 1), 'Extintor', 'Extintor tipo ABC - Almacén', '2023-10-01'::date, '2023-12-01'::date, 'vencido'
UNION ALL SELECT (SELECT id FROM empresas LIMIT 1 OFFSET 1), (SELECT id FROM locaciones WHERE empresa_id = (SELECT id FROM empresas LIMIT 1 OFFSET 1) LIMIT 1), 'Extintor', 'Extintor tipo ABC - Oficina Principal', '2023-12-20'::date, '2024-07-20'::date, 'vigente'
UNION ALL SELECT (SELECT id FROM empresas LIMIT 1 OFFSET 1), (SELECT id FROM locaciones WHERE empresa_id = (SELECT id FROM empresas LIMIT 1 OFFSET 1) LIMIT 1), 'Extintor', 'Extintor tipo ABC - Taller', '2023-09-01'::date, '2024-01-30'::date, 'proximo'
UNION ALL SELECT (SELECT id FROM empresas LIMIT 1), (SELECT id FROM locaciones WHERE empresa_id = (SELECT id FROM empresas LIMIT 1) LIMIT 1), 'Detector de Humo', 'Detector 3er piso', '2024-01-10'::date, '2024-04-10'::date, 'vigente'
UNION ALL SELECT (SELECT id FROM empresas LIMIT 1 OFFSET 1), (SELECT id FROM locaciones WHERE empresa_id = (SELECT id FROM empresas LIMIT 1 OFFSET 1) LIMIT 1), 'Detector de Humo', 'Detector planta baja', '2023-12-15'::date, '2024-03-15'::date, 'vigente';

-- Datos de prueba: Calendario de Eventos
INSERT INTO calendario_eventos (empresa_id, tipo, descripcion, fecha, hora, ubicacion) 
SELECT 
    (SELECT id FROM empresas LIMIT 1),
    'cliente',
    'Visita cliente - ABC Corp',
    '2024-01-25'::date,
    '09:00'::time,
    'Sala de Juntas A'
UNION ALL SELECT (SELECT id FROM empresas LIMIT 1), 'cliente', 'Inspección de seguridad', '2024-01-26'::date, '14:00'::time, 'Almacén Central'
UNION ALL SELECT (SELECT id FROM empresas LIMIT 1 OFFSET 1), 'cliente', 'Reunión mensual - XYZ Ltd', '2024-01-27'::date, '10:30'::time, 'Oficina Gerencial'
UNION ALL SELECT (SELECT id FROM empresas LIMIT 1), 'servicio', 'Mantenimiento correctivo', '2024-02-01'::date, '08:00'::time, 'Cuarto de máquinas'
UNION ALL SELECT (SELECT id FROM empresas LIMIT 1), 'servicio', 'Capacitación en seguridad', '2024-02-05'::date, '15:00'::time, 'Aula de capacitación'
UNION ALL SELECT (SELECT id FROM empresas LIMIT 1 OFFSET 1), 'servicio', 'Revisión de sistemas', '2024-02-10'::date, '09:30'::time, 'Centro de datos'
UNION ALL SELECT (SELECT id FROM empresas LIMIT 1), 'cliente', 'Auditoría anual', '2024-02-15'::date, '11:00'::time, 'Oficina Administrativa'
UNION ALL SELECT (SELECT id FROM empresas LIMIT 1 OFFSET 1), 'cliente', 'Visita de verificación', '2024-02-20'::date, '13:00'::time, 'Instalaciones';

-- Datos de prueba: Notificaciones de Servicios
INSERT INTO notificaciones_servicios (titulo, descripcion, tipo, estado, fecha) VALUES
('Mantenimiento próximo vencimiento', 'El extintor de la sala 101 vence el 1 de febrero', 'alerta', 'pendiente', NOW() - INTERVAL '2 hours'),
('Recordatorio de inspección', 'Inspección mensual pendiente en locación Almacén Central', 'recordatorio', 'pendiente', NOW() - INTERVAL '1 day'),
('Confirmación de servicio', 'Servicio de mantenimiento completado exitosamente', 'confirmacion', 'leida', NOW() - INTERVAL '3 days'),
('Alerta de vencimiento', 'Equipo vencido: Detector de humo planta baja', 'alerta', 'pendiente', NOW()),
('Recordatorio de capacitación', 'Próxima sesión de capacitación en seguridad', 'recordatorio', 'enviada', NOW() - INTERVAL '5 hours'),
('Confirmación de compra', 'Nuevo extintor adquirido para almacén sur', 'confirmacion', 'leida', NOW() - INTERVAL '2 weeks'),
('Alerta sistema', 'Anomalía detectada en datos de seguridad', 'alerta', 'leida', NOW() - INTERVAL '1 week'),
('Recordatorio auditoría', 'Auditoría anual programada para el 15 de febrero', 'recordatorio', 'enviada', NOW() - INTERVAL '4 days');
