# Configuración de Supabase para POTENCIA ACTIVA

## Pasos para configurar la base de datos:

### 1. Crear proyecto en Supabase
1. Ve a https://supabase.com
2. Crea una cuenta o inicia sesión
3. Clic en "New Project"
4. Elige un nombre: `potencia-activa-sat`
5. Crea una contraseña segura para la base de datos
6. Selecciona una región (preferiblemente cerca de tu ubicación)
7. Clic en "Create new project"

### 2. Obtener las credenciales
1. Una vez creado el proyecto, ve a Settings > API
2. Copia la **Project URL** 
3. Copia la **anon public** key
4. Pega estos valores en el archivo `.env`:
   ```
   SUPABASE_URL=tu_project_url_aqui
   SUPABASE_ANON_KEY=tu_anon_key_aqui
   ```

### 3. Ejecutar el script de base de datos
1. En Supabase, ve a SQL Editor
2. Crea un nuevo query
3. Copia y pega el contenido del archivo `database/init.sql`
4. Ejecuta el script con "Run"
5. Verifica que se creó la tabla `users` en Database > Tables

### 4. Usuarios de prueba:

**Modo Demo (sin Supabase configurado):**
- Email: `admin@potenciaactiva.com` - Contraseña: `admin123`
- Email: `usuario@potenciaactiva.com` - Contraseña: `user123`
- Email: `demo@demo.com` - Contraseña: `demo123`

**Con Supabase configurado:**
- Email: `admin@potenciaactiva.com` - Contraseña: `admin123` (Administrador)
- Email: `usuario@potenciaactiva.com` - Contraseña: `user123` (Usuario normal)

### 5. Iniciar el servidor
```bash
npm run dev
```

### 6. Probar el login
1. Ve a http://localhost:3000/login
2. Usa cualquiera de las credenciales de arriba
3. Deberías ser redirigido al dashboard

## Notas importantes:
- Las contraseñas están encriptadas con bcrypt
- Las sesiones duran 24 horas
- Row Level Security está habilitado para mayor seguridad
- Solo usuarios autenticados pueden acceder al dashboard