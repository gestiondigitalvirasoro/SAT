-- Tabla: Empresas
CREATE TABLE IF NOT EXISTS public.empresas (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre TEXT NOT NULL,
  razon_social TEXT,
  ruc TEXT,
  email TEXT,
  telefono TEXT,
  estado BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Tabla: Locaciones
CREATE TABLE IF NOT EXISTS public.locaciones (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  empresa_id UUID NOT NULL REFERENCES public.empresas(id) ON DELETE CASCADE,
  nombre TEXT NOT NULL,
  direccion TEXT,
  ciudad TEXT,
  provincia TEXT,
  estado BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Tabla: Planes de Acción
CREATE TABLE IF NOT EXISTS public.planes_accion (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  empresa_id UUID NOT NULL REFERENCES public.empresas(id) ON DELETE CASCADE,
  locacion_id UUID NOT NULL REFERENCES public.locaciones(id) ON DELETE CASCADE,
  fecha DATE NOT NULL,
  descripcion TEXT,
  estado TEXT DEFAULT 'pendiente', -- pendiente, en-proceso, completado
  responsable TEXT,
  fecha_vencimiento DATE,
  observaciones TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Índices para mejorar performance
CREATE INDEX IF NOT EXISTS idx_planes_accion_empresa_id ON public.planes_accion(empresa_id);
CREATE INDEX IF NOT EXISTS idx_planes_accion_locacion_id ON public.planes_accion(locacion_id);
CREATE INDEX IF NOT EXISTS idx_planes_accion_fecha ON public.planes_accion(fecha);
CREATE INDEX IF NOT EXISTS idx_planes_accion_estado ON public.planes_accion(estado);
CREATE INDEX IF NOT EXISTS idx_locaciones_empresa_id ON public.locaciones(empresa_id);

-- Habilitar Row Level Security (RLS) si es necesario
ALTER TABLE public.empresas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.locaciones ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.planes_accion ENABLE ROW LEVEL SECURITY;
