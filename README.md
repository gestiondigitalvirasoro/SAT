# SAT - Sistema de Alerta Temprana

Node.js + Express + Supabase starter para profesionales de Seguridad e Higiene. Usa EJS para vistas y proporciona rutas de ejemplo y un modelo `reports`.

## Estructura del Proyecto

```
proyect-main/
├── src/
│   ├── config/
│   │   ├── keys.js          # configuraciones generales
│   │   ├── database.js      # conexión a Supabase
│   │   └── passport.js      # autenticación (placeholder)
│   ├── routes/              # rutas (index, api)
│   ├── controllers/         # lógica de negocio
│   ├── models/              # definición de servicios a Supabase
│   ├── lib/                 # utilidades
│   ├── public/              # archivos estáticos (CSS, JS)
│   ├── views/               # vistas EJS
│   │   ├── layouts/         # layout principal
│   │   ├── partials/        # header, footer, navbar
│   │   └── pages/           # home, faq, about, etc.
│   └── index.js             # punto de entrada del servidor
├── .env                     # variables de entorno (crear desde .env.example)
├── .env.example             # ejemplo de variables
└── package.json
```

## Inicio Rápido

1. **Clonar y configurar:**
   ```bash
   git clone <tu-repo>
   cd proyect-main
   cp .env.example .env
   ```

2. **Configurar variables de entorno:**
   Edita `.env` con tus credenciales de Supabase:
   ```
   SUPABASE_URL=https://tu-proyecto.supabase.co
   SUPABASE_KEY=tu-key
   PORT=3000
   SESSION_SECRET=tu-secreto-seguro
   ```

3. **Instalar dependencias y ejecutar:**
   ```bash
   npm install
   npm run dev
   ```

4. **Crear tabla en Supabase:**
   Ejecuta este SQL en el SQL Editor de Supabase:
   ```sql
   create table public.reports (
     id uuid primary key default gen_random_uuid(),
     title text,
     description text,
     created_at timestamptz default now()
   );
   ```

## Scripts Disponibles

- `npm run dev` - Ejecutar en modo desarrollo (con nodemon)
- `npm start` - Ejecutar en modo producción

## Rutas Disponibles

### Web
- `GET /` - Página principal (landing SAT)
- `GET /faq` - Preguntas frecuentes
- `GET /about` - Acerca de

### API
- `GET /api/reports` - Listar todos los reportes
- `POST /api/reports` - Crear nuevo reporte
- `GET /api/reports/:id` - Obtener reporte por ID
- `PUT /api/reports/:id` - Actualizar reporte

### Reportes
- `GET /reports/planes-accion` - Planes de acción por fecha
- `GET /reports/visitas-formulario` - Totales de visitas por formulario
- `GET /reports/vencimientos-equipos` - Vencimientos de Equipos - Extintores
- `GET /reports/calendario-clientes` - Vista Calendario por clientes
- `GET /reports/calendario-servicios` - Vista Calendario por servicios
- `GET /reports/notificaciones-servicios` - Detalle de Notificaciones de Servicios

## Tecnologías

- **Backend:** Node.js + Express
- **Base de datos:** Supabase (PostgreSQL)
- **Vistas:** EJS
- **Desarrollo:** nodemon

## Configuración de Supabase

1. Crear proyecto en [supabase.com](https://supabase.com)
2. Obtener URL y Key del proyecto
3. Crear la tabla `reports` con el SQL proporcionado
4. Configurar las variables en `.env`

## Estructura de Vistas

Las vistas están divididas en:
- **Layout:** `layouts/main.ejs` (estructura principal)
- **Parciales:** `partials/header.ejs`, `partials/navbar.ejs`, `partials/footer.ejs`
- **Páginas:** `pages/home.ejs`, `pages/faq.ejs`, `pages/about.ejs`
