# EOCA y Bender: guía y registro

App de una sola página (HTML, CSS y JS sin build) para guiar y registrar la EOCA (Visca) y el Bender (Koppitz).
Sin configurar nada funciona igual y guarda solo en el navegador. Con Supabase, además se puede guardar en la nube.

Archivos:
- `index.html`: la app.
- `schema.sql`: tabla y permisos de Supabase.
- `_headers`: cabeceras de seguridad para Cloudflare Pages.
- `robots.txt`: pide que no se indexe.

## 1. Supabase

1. Creá un proyecto (o usá uno existente).
2. SQL Editor: pegá y ejecutá `schema.sql`.
3. Project Settings > API: copiá la **Project URL** y la clave **anon (publishable)**.
   Nunca pongas la clave `service_role` en el frontend.
4. Abrí `index.html` y completá, cerca del inicio del script:
   ```js
   const CLOUD_CFG={url:'https://TU-PROYECTO.supabase.co',key:'TU_CLAVE_ANON'};
   ```
   La clave anon es pública por diseño: lo que protege los datos son las políticas RLS de `schema.sql`.

## 2. Cloudflare Pages

Opción A, con GitHub (la que ya usás):
1. Subí esta carpeta a un repositorio.
2. Cloudflare > Workers y Pages > Create > Pages > Connect to Git.
3. Framework: None. Build command: vacío. Output directory: `/`.

Opción B, sin Git: Create > Pages > Upload assets, y arrastrá la carpeta (o el zip).

## 3. Volver a Supabase con la URL final

Authentication > URL Configuration:
- **Site URL**: la dirección de Cloudflare (por ejemplo `https://tu-app.pages.dev`).
- **Redirect URLs**: agregá la misma dirección.

Sin esto el enlace de acceso del correo no vuelve a la app.

## 4. Cerrar el acceso (recomendado)

La app guarda datos de un niño, aunque sea con nombre ficticio.
1. Authentication > Users > Add user: creá tu usuario con tu correo.
2. Authentication > Sign In / Providers: desactivá "Allow new users to sign up".
   Así solo vos podés entrar con el enlace por correo.

## Uso

Pestaña Exportar > Nube: ingresá tu correo, abrí el enlace que te llega, y usá "Subir a la nube" o "Traer de la nube".
"Subir automáticamente" guarda cada pocos segundos. Es una sola copia por usuario: el último que sube pisa al anterior.

## Privacidad

- Usá nombre ficticio. No cargues apellido, domicilio ni nombre de la escuela, como pide la guía de la cátedra.
- Tené claro quién tiene acceso a tu proyecto de Supabase y a tu cuenta de correo.
- Las producciones del niño (hojas del Bender) no se suben: se guardan aparte.
