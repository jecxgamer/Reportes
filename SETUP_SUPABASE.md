# Configuración de Supabase

Este documento explica cómo configurar las variables de entorno necesarias para conectar la aplicación con Supabase.

## Variables de Entorno

La aplicación requiere las siguientes variables de entorno para funcionar con Supabase:

1. **VITE_SUPABASE_URL**: La URL de tu proyecto de Supabase
2. **VITE_SUPABASE_ANON_KEY**: La clave anónima (anon key) de tu proyecto

## Cómo Obtener las Credenciales

1. Ve a tu proyecto en [Supabase Dashboard](https://app.supabase.com)
2. En el menú lateral, haz clic en "Settings" (Configuración)
3. Selecciona "API"
4. Copia los siguientes valores:
   - **Project URL**: Esta es tu `VITE_SUPABASE_URL`
   - **anon public**: Esta es tu `VITE_SUPABASE_ANON_KEY`

## Configuración Local

1. Crea un archivo `.env` en la raíz del proyecto (si no existe)
2. Copia el contenido de `.env.example` al archivo `.env`
3. Reemplaza los valores de ejemplo con tus credenciales reales:

```env
VITE_SUPABASE_URL=https://tu-proyecto.supabase.co
VITE_SUPABASE_ANON_KEY=tu-anon-key-aqui
```

4. Guarda el archivo `.env`
5. Reinicia el servidor de desarrollo si está corriendo

## Migraciones de Base de Datos

Las migraciones necesarias ya se han aplicado y crearon la tabla `app_users` con:
- Campos: id, username, password_hash, display_name, role, is_active, created_at, updated_at
- Políticas de seguridad RLS configuradas
- Usuarios iniciales: admin y empleado (contraseña: paradero)

## Funcionalidades

El sistema de gestión de usuarios permite:
- Ver lista de usuarios
- Crear nuevos usuarios con usuario y contraseña
- Editar usuarios existentes
- Eliminar usuarios (excepto el usuario actual)
- Cambiar roles (admin/employee)
- Activar/desactivar usuarios
- Solo administradores tienen acceso a esta sección

## Seguridad

- Las contraseñas se almacenan tal cual en password_hash (en producción deberías usar bcrypt u otro sistema de hash)
- Las políticas RLS garantizan que solo los administradores puedan gestionar usuarios
- Los usuarios solo pueden ver su propia información a menos que sean administradores
