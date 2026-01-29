# Notas de Despliegue - alejandrogracia.com

## Configuración de Hosts Permitidos (Astro 5.x)

### Problema

Al acceder a la web vía `www.alejandrogracia.com`, se devuelve el error:

```
Blocked request. This host ("www.alejandrogracia.com") is not allowed.
To allow this host, add "www.alejandrogracia.com" to `preview.allowedHosts` in vite.config.js.
```

### Causa Raíz

**BUG CONOCIDO**: En Astro 5.x existe un bug donde `vite.preview.allowedHosts` NO funciona correctamente ([Issue #13060](https://github.com/withastro/astro/issues/13060)).

Sin embargo, Astro 5.4+ introdujo una nueva opción `server.allowedHosts` directamente en la configuración de Astro que **SÍ funciona** tanto para `dev` como para `preview`.

### Solución ✅

Usar `server.allowedHosts` directamente en la configuración de Astro (NO dentro de `vite`):

```javascript
// astro.config.mjs
export default defineConfig({
  server: {
    host: true,
    port: 4321,
    // Esta opción funciona tanto para 'dev' como 'preview' en Astro 5.4+
    allowedHosts: [
      'alejandrogracia.com',
      'www.alejandrogracia.com',
      'host.docker.internal',
      'localhost'
    ]
  },
  vite: {
    plugins: [tailwindcss()]
  },
  integrations: [mdx()]
});
```

**IMPORTANTE**: NO uses `vite.preview.allowedHosts` ya que no funciona en Astro 5.x debido al bug mencionado.

### Comando de Despliegue con PM2

```bash
# 1. Build del proyecto
npm run build

# 2. Eliminar proceso anterior (si existe)
pm2 delete alejandrogracia_web

# 3. Iniciar nuevo proceso
pm2 start npm --name "alejandrogracia_web" -- run preview

# 4. Guardar configuración
pm2 save
```

**Notas importantes:**
- NO uses flags `--allowed-hosts` en la línea de comandos, no funcionan correctamente
- La configuración de hosts debe estar en `astro.config.mjs`
- El script `preview` en `package.json` debe ser: `"preview": "astro preview --host 0.0.0.0 --port 4321"`

### Verificación

1. Check del servicio: `pm2 list`
2. Logs en tiempo real: `pm2 logs alejandrogracia_web`
3. Probar acceso:
   - http://localhost:4321
   - http://alejandrogracia.com
   - http://www.alejandrogracia.com

---

## Actualización de Contenido

### Flujo General de Actualización

Cuando hagas cambios en el contenido (texto, imágenes, proyectos), tienes dos opciones:

#### Opción A: Script automatizado (RECOMENDADO)

```bash
cd /mnt/d/dev_projects/alejandrogracia/alejandrogracia_web
./update.sh

# Si quieres limpiar cache antes de rebuildir:
./update.sh --clean
```

El script `update.sh` hace todo automáticamente: build + restart PM2 + verificación.

#### Opción B: Manual

```bash
# 1. Navegar al directorio del proyecto
cd /mnt/d/dev_projects/alejandrogracia/alejandrogracia_web

# 2. Rebuild del proyecto (regenera los archivos estáticos)
npm run build

# 3. Reiniciar PM2 para servir el nuevo build
pm2 restart alejandrogracia_web

# 4. Verificar que los cambios se aplicaron
pm2 logs alejandrogracia_web --lines 20
```

### Casos de Uso Específicos

#### 1. Editar texto de un proyecto existente

**Ejemplo**: Modificar la descripción de Torre Reforma BBVA

```bash
# 1. Editar el archivo del proyecto
nano src/content/projects/torre-reforma-bbva.mdx
# (o usa tu editor preferido)

# 2. Rebuild + reinicio
npm run build && pm2 restart alejandrogracia_web
```

#### 2. Añadir/Eliminar fotos de un proyecto

**Ejemplo**: Eliminar 5 fotos de Torre Reforma o añadir nuevas

```bash
# 1. Modificar las imágenes en la carpeta del proyecto
cd public/projects/torre-reforma-bbva/
rm foto1.jpg foto2.jpg  # Eliminar fotos
# O copiar nuevas fotos a esta carpeta

# 2. Editar el archivo .mdx para actualizar la lista de imágenes
nano ../../src/content/projects/torre-reforma-bbva.mdx
# Actualizar el array de imágenes en el frontmatter

# 3. Volver al directorio raíz, rebuild + reinicio
cd ../../../
npm run build && pm2 restart alejandrogracia_web
```

**IMPORTANTE**: Las imágenes se optimizan automáticamente durante el build. Si añades muchas imágenes nuevas, el build tardará más (1-2 minutos).

#### 3. Añadir un nuevo proyecto

**Ejemplo**: Añadir proyecto "Dubai Fascias 2016"

```bash
# 1. Crear carpeta para las imágenes del proyecto
mkdir -p public/projects/dubai-fascias-2016

# 2. Copiar las fotos del proyecto a la carpeta
cp /ruta/a/tus/fotos/* public/projects/dubai-fascias-2016/

# 3. Crear el archivo .mdx del proyecto
nano src/content/projects/dubai-fascias-2016.mdx
# Copiar la estructura de torre-reforma-bbva.mdx como plantilla

# 4. Rebuild + reinicio
npm run build && pm2 restart alejandrogracia_web

# 5. Verificar que el nuevo proyecto aparece
# Acceder a: https://www.alejandrogracia.com/proyectos/dubai-fascias-2016
```

#### 4. Cambios en la página principal (index.astro)

```bash
# 1. Editar index.astro
nano src/pages/index.astro

# 2. Rebuild + reinicio
npm run build && pm2 restart alejandrogracia_web
```

### Verificación de Cambios

Después de actualizar, verifica que los cambios se aplicaron:

```bash
# Ver logs para detectar errores
pm2 logs alejandrogracia_web --lines 30

# Probar la URL en el navegador (Ctrl+Shift+R para bypass cache)
# https://www.alejandrogracia.com

# Verificar tiempo de build en los logs (buscar "Completed in XXs")
```

### Troubleshooting

**Problema**: Los cambios no se reflejan en el navegador

```bash
# Solución 1: Limpiar caché del navegador
# En Chrome/Edge: Ctrl+Shift+R (hard reload)
# En Firefox: Ctrl+F5

# Solución 2: Limpiar build cache de Astro y rebuildir
rm -rf .astro dist
npm run build
pm2 restart alejandrogracia_web
```

**Problema**: Error durante el build

```bash
# Ver el error completo
npm run build

# Revisar sintaxis de archivos .mdx
# Asegurarse de que todas las imágenes referenciadas existen
```

**Problema**: PM2 muestra "online" pero la web no responde

```bash
# Verificar que el puerto 4321 está escuchando
netstat -tlnp | grep 4321

# Reiniciar completamente el proceso
pm2 delete alejandrogracia_web
pm2 start npm --name "alejandrogracia_web" -- run preview
pm2 save
```

### Resumen de Comandos PM2

```bash
# Ver estado
pm2 list
pm2 show alejandrogracia_web

# Ver logs
pm2 logs alejandrogracia_web --lines 50

# Reiniciar
pm2 restart alejandrogracia_web

# Detener
pm2 stop alejandrogracia_web

# Guardar configuración
pm2 save
```

---

## Configuración SSL/HTTPS

La web usa **Cloudflare Tunnel** para exponer el servidor local de forma segura.

### Estado Actual ✅

- ✅ **HTTPS funciona**: `https://www.alejandrogracia.com` (HTTP/2 200)
- ✅ **HTTP redirige a HTTPS**: HTTP 301 → HTTPS automáticamente
- ✅ **Certificado SSL válido** de Cloudflare
- ✅ **"Always Use HTTPS" activado** en Cloudflare
- ✅ **Ambos dominios funcionan**: con y sin www

### Verificación

Para verificar el estado de HTTPS en cualquier momento:

```bash
./check-https.sh
```

**Documentación completa**: Ver [CLOUDFLARE_SSL_SETUP.md](./CLOUDFLARE_SSL_SETUP.md)

---

## Referencias

- [Astro Issue #13060: preview doesn't respect vite preview allowedHostnames](https://github.com/withastro/astro/issues/13060)
- [Astro 5.4 Release Notes: server.allowedHosts](https://astro.build/blog/astro-540/)
- [Astro Configuration Reference](https://docs.astro.build/en/reference/configuration-reference/)
- [Cloudflare Always Use HTTPS](https://developers.cloudflare.com/ssl/edge-certificates/additional-options/always-use-https/)

---

---

## Script de Actualización Rápida

Para facilitar el proceso de actualización, se ha creado el script `update.sh`:

### Uso

```bash
cd /mnt/d/dev_projects/alejandrogracia/alejandrogracia_web

# Actualización normal
./update.sh

# Actualización con limpieza de cache
./update.sh --clean
```

### ¿Qué hace el script?

1. ✓ Valida que estés en el directorio correcto
2. ✓ Limpia cache (si usas `--clean`)
3. ✓ Ejecuta `npm run build`
4. ✓ Reinicia PM2 automáticamente
5. ✓ Verifica que el servicio esté online
6. ✓ Muestra comandos útiles al finalizar

**Ventaja**: Todo en un solo comando, con salida coloreada y manejo de errores.

---

## Resumen Visual de Flujos de Trabajo

### Actualizar contenido existente
```
Editar archivos → ./update.sh → ¡Listo!
```

### Añadir nuevo proyecto
```
1. Copiar fotos a public/projects/nombre-proyecto/
2. Crear src/content/projects/nombre-proyecto.mdx
3. ./update.sh
4. Verificar en navegador
```

### Cambios en la página principal
```
Editar src/pages/index.astro → ./update.sh → ¡Listo!
```

---

## Historial de Cambios

- **2026-01-12**:
  - Solucionado problema de `allowedHosts` usando `server.allowedHosts` (Astro 5.4+)
  - Añadida documentación completa de actualización de contenido
  - Creado script `update.sh` para automatizar el proceso de despliegue
  - Configurado "Always Use HTTPS" en Cloudflare
  - Creado script `check-https.sh` para verificación automática de SSL/HTTPS
  - Añadida documentación completa de configuración SSL (CLOUDFLARE_SSL_SETUP.md)
