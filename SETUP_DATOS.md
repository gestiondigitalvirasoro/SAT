# Configuración de Datos en Supabase

## Pasos para cargar los datos en la base de datos

### 1. Acceder a Supabase
1. Ve a https://supabase.com
2. Inicia sesión en tu proyecto `potencia-activa-sat`
3. Dirígete a **SQL Editor** (icono de código en el lado izquierdo)

### 2. Ejecutar el script de base de datos
1. Haz clic en **+ New Query** (o usa **New**)
2. En el panel derecho, selecciona **Database Script** si es necesario
3. Abre el archivo `database/init.sql` de este proyecto
4. Copia TODO el contenido del archivo
5. Pégalo en el SQL Editor de Supabase
6. Haz clic en **Run** (botón azul en la esquina inferior derecha)
7. Espera a que se complete la ejecución (verás un mensaje de éxito)

### 3. Verificar que se crearon las tablas
1. Ve a **Database** en el menú izquierdo
2. Expande **Tables** 
3. Deberías ver las siguientes tablas:
   - `users` (usuarios)
   - `empresas` (5 registros)
   - `locaciones` (8 registros)
   - `planes_accion` (8 registros)
   - `visitas_formulario` (11 registros)
   - `vencimientos_equipos` (5 registros)

### 4. Datos cargados automáticamente

#### Empresas (5):
- Carpal
- LINOR SRL
- TecnoPalet
- Distribuidora González
- Metalúrgica del Sur

#### Planes de Acción (8 planes con fechas, estados y empresas asignadas)

#### Visitas por Formulario (11 registros con datos por mes y tipo de formulario)

#### Vencimientos de Equipos (5 equipos con información completa)

### 5. Credenciales de acceso
Usuario por defecto:
- **Email**: admin@potenciaactiva.com
- **Contraseña**: admin123

### 6. Pruebas locales
Si quieres probar localmente primero:
```bash
cd proyect-main
npm run dev
```
Accede a http://localhost:3000 y verás que automáticamente usa los datos de demostración si Supabase no está configurado.

### 7. Recargar datos
Si necesitas limpiar y recargar todo:
1. Ve a **SQL Editor** en Supabase
2. Ejecuta este script:
```sql
DROP TABLE IF EXISTS vencimientos_equipos CASCADE;
DROP TABLE IF EXISTS visitas_formulario CASCADE;
DROP TABLE IF EXISTS planes_accion CASCADE;
DROP TABLE IF EXISTS locaciones CASCADE;
DROP TABLE IF EXISTS empresas CASCADE;
```
3. Luego ejecuta nuevamente el script de `init.sql`

### Notas
- Los datos de demostración están integrados en las vistas como fallback
- Si Supabase no está disponible, las páginas mostrarán datos de demostración automáticamente
- Todos los datos están correctamente relacionados por `empresa_id` y `locacion_id`
