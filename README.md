# Astro Starter Kit: Minimal

```sh
npm create astro@latest -- --template minimal
```

> 🧑‍🚀 **Seasoned astronaut?** Delete this file. Have fun!

## 🚀 Project Structure

Inside of your Astro project, you'll see the following folders and files:

```text
/
├── public/
├── src/
│   └── pages/
│       └── index.astro
└── package.json
```

Astro looks for `.astro` or `.md` files in the `src/pages/` directory. Each page is exposed as a route based on its file name.

There's nothing special about `src/components/`, but that's where we like to put any Astro/React/Vue/Svelte/Preact components.

Any static assets, like images, can be placed in the `public/` directory.

## 🚀 Inicio Rápido

### Desarrollo Local

```bash
npm install              # Primera vez solamente
npm run dev             # Inicia servidor en localhost:4321
```

### Actualizar Contenido en Producción

```bash
./update.sh             # Build + Deploy automatizado
./update.sh --clean     # Con limpieza de cache
```

## 📁 Estructura del Proyecto

```
alejandrogracia_web/
├── src/
│   ├── content/
│   │   ├── config.ts                    # Schema de validación de proyectos
│   │   └── projects/                    # Archivos .mdx de cada proyecto
│   │       └── torre-reforma-bbva.mdx
│   ├── pages/
│   │   ├── index.astro                  # Página principal
│   │   └── proyectos/
│   │       ├── index.astro              # Lista de proyectos
│   │       └── [slug].astro             # Template de proyecto
│   └── layouts/
│       └── Layout.astro                 # Layout base
├── public/
│   └── projects/                        # Imágenes de proyectos
│       └── torre-reforma-bbva/
├── update.sh                            # Script de deploy
├── DEPLOYMENT_NOTES.md                  # Documentación detallada
└── package.json
```

## 📝 Casos de Uso Comunes

### 1. Editar texto de un proyecto

```bash
nano src/content/projects/torre-reforma-bbva.mdx
./update.sh
```

### 2. Añadir/Eliminar fotos

```bash
# Modificar fotos en public/projects/nombre-proyecto/
# Editar el array de imágenes en el .mdx correspondiente
./update.sh
```

### 3. Añadir nuevo proyecto

```bash
# 1. Copiar fotos a public/projects/nuevo-proyecto/
# 2. Crear src/content/projects/nuevo-proyecto.mdx
./update.sh
# 3. Acceder a https://www.alejandrogracia.com/proyectos/nuevo-proyecto
```

## 🔧 Comandos Disponibles

| Comando                   | Acción                                           |
| :------------------------ | :----------------------------------------------- |
| `npm install`             | Instala dependencias                            |
| `npm run dev`             | Servidor desarrollo en `localhost:4321`          |
| `npm run build`           | Build de producción en `./dist/`                |
| `npm run preview`         | Preview del build localmente                     |
| `./update.sh`             | Build + Deploy automatizado                      |
| `./check-https.sh`        | Verificar configuración HTTPS/SSL                |
| `pm2 logs alejandrogracia_web` | Ver logs en tiempo real                 |
| `pm2 restart alejandrogracia_web` | Reiniciar servicio                   |

## 📚 Documentación

- **[DEPLOYMENT_NOTES.md](./DEPLOYMENT_NOTES.md)** - Documentación completa de despliegue y troubleshooting
- **[CLOUDFLARE_SSL_SETUP.md](./CLOUDFLARE_SSL_SETUP.md)** - Configuración de HTTPS/SSL con Cloudflare Tunnel
- **[EJEMPLO_NUEVO_PROYECTO.md](./EJEMPLO_NUEVO_PROYECTO.md)** - Tutorial completo para añadir proyectos
- **[Astro Docs](https://docs.astro.build)** - Documentación oficial de Astro
- **[Tailwind CSS](https://tailwindcss.com/docs)** - Documentación de Tailwind

## 🌐 URLs

- **Producción**: https://www.alejandrogracia.com
- **Servidor**: Puerto 4321 (PM2)

## 🐛 Troubleshooting

### Web no muestra cambios después de actualizar

```bash
# 1. Hard reload en el navegador (Ctrl+Shift+R)

# 2. Si no funciona, rebuild limpio:
rm -rf .astro dist
npm run build
pm2 restart alejandrogracia_web
```

### HTTP no redirige automáticamente a HTTPS

```bash
# 1. Verificar estado actual
./check-https.sh

# 2. Si falta redirección, activar en Cloudflare:
# Dashboard → SSL/TLS → Edge Certificates → "Always Use HTTPS" ON
```

Para más ayuda, consulta [DEPLOYMENT_NOTES.md](./DEPLOYMENT_NOTES.md) o [CLOUDFLARE_SSL_SETUP.md](./CLOUDFLARE_SSL_SETUP.md).
