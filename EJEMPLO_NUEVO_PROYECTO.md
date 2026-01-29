# Ejemplo: Cómo Añadir un Nuevo Proyecto

Este documento muestra paso a paso cómo añadir un nuevo proyecto a tu web.

## Ejemplo Real: Añadir "Dubai Fascias 2016"

### Paso 1: Preparar las Imágenes

```bash
# 1. Crear carpeta para el proyecto
mkdir -p public/projects/dubai-fascias-2016

# 2. Copiar tus fotos a la carpeta
# Puedes usar nombres originales o renombrarlas
cp ~/mis-fotos-dubai/*.jpg public/projects/dubai-fascias-2016/

# Las fotos pueden ser JPG, PNG, WebP, etc.
# Astro las optimizará automáticamente durante el build
```

### Paso 2: Crear el Archivo MDX del Proyecto

Crea el archivo `src/content/projects/dubai-fascias-2016.mdx`:

```mdx
---
title: "Dubai Fascias - Mall of the Emirates"
client: "Cliente Confidencial"
year: "2016"
location: "Dubai, Emiratos Árabes Unidos"
category: "Retail"
role: "Project Manager Internacional"
featured: true
description: "Gestión integral de instalación de fascias digitales en uno de los centros comerciales más emblemáticos de Oriente Medio."
coverImage: "../../public/projects/dubai-fascias-2016/foto-principal.jpg"
---

## Contexto del Proyecto

En agosto de 2016, lideré la gestión de un proyecto de instalación de fascias digitales de gran formato en el Mall of the Emirates, uno de los destinos comerciales más icónicos de Dubai.

### Desafíos

- **Logística Internacional**: Coordinación de equipos entre España, Dubai y fabricantes asiáticos
- **Timeframe Ajustado**: Instalación en 2 semanas durante horario nocturno
- **Normativa Local**: Cumplimiento de estrictas regulaciones de construcción emiratíes
- **Coordinación Multi-cultural**: Gestión de equipos de 4 nacionalidades diferentes

## Mi Rol

Como Project Manager, mis responsabilidades incluyeron:

1. **Pre-instalación**:
   - Coordinación con arquitectos locales para permisos
   - Gestión de importación de materiales y equipos
   - Planificación logística de transporte especializado

2. **Ejecución**:
   - Supervisión in-situ de instalación nocturna
   - Control de calidad en tiempo real
   - Resolución de incidencias técnicas

3. **Cierre**:
   - Entrega de documentación técnica
   - Formación a equipo de mantenimiento local
   - Reporting final a cliente y dirección

## Resultados

✓ Instalación completada en **12 días** (2 días antes del plazo)
✓ **Cero incidencias** de seguridad
✓ **100% de tasa de éxito** en pruebas de funcionamiento
✓ Cliente renovó contrato para 3 ubicaciones adicionales en 2017

## Galería de Fotos

Las siguientes imágenes documentan el proceso de instalación:
```

### Paso 3: Configurar las Imágenes en el Frontmatter

Tienes dos opciones para gestionar las imágenes:

#### Opción A: Lista Manual (Más Control)

```mdx
---
title: "Dubai Fascias"
# ... otros campos ...
images:
  - src: "foto1.jpg"
    alt: "Vista exterior del Mall"
  - src: "foto2.jpg"
    alt: "Equipo de instalación"
  - src: "foto3.jpg"
    alt: "Fascia instalada"
---
```

#### Opción B: Todas las Imágenes de la Carpeta (Automático)

El template actual en `[slug].astro` lee automáticamente todas las imágenes de la carpeta del proyecto. Solo asegúrate de que las fotos estén en:

```
public/projects/dubai-fascias-2016/
```

### Paso 4: Desplegar

```bash
cd /mnt/d/dev_projects/alejandrogracia/alejandrogracia_web
./update.sh
```

### Paso 5: Verificar

Accede a:
```
https://www.alejandrogracia.com/proyectos/dubai-fascias-2016
```

---

## Estructura Completa de un Proyecto MDX

```mdx
---
# OBLIGATORIOS
title: "Nombre del Proyecto"
description: "Descripción breve del proyecto (160 caracteres)"

# RECOMENDADOS
client: "Nombre del Cliente"
year: "2016"
location: "Ciudad, País"
category: "Retail" | "Corporativo" | "Arquitectura" | "Tecnología"
role: "Tu rol en el proyecto"

# OPCIONALES
featured: true              # Aparecerá en página principal
tags: ["tag1", "tag2"]      # Para futuro filtrado
coverImage: "ruta/imagen"   # Imagen de portada específica
---

## Contenido del Proyecto

Escribe aquí tu contenido en Markdown/MDX.

### Puedes usar:
- Listas
- **Negrita** e *cursiva*
- Enlaces: [texto](https://ejemplo.com)
- Imágenes inline: ![alt](ruta)
- Código: `código inline`

### Secciones Recomendadas:
1. **Contexto**: ¿Cuál era el problema/objetivo?
2. **Tu Rol**: ¿Qué hiciste específicamente?
3. **Desafíos**: Obstáculos superados
4. **Resultados**: Métricas, logros cuantificables
5. **Aprendizajes**: Qué te llevaste del proyecto

## Galería

Las fotos aparecerán automáticamente al final.
```

---

## Consejos de Contenido

### ✅ Buenas Prácticas

1. **Sé específico**: "Reducción de 30% en tiempos de entrega" > "Mejoramos la eficiencia"
2. **Cuantifica**: Números, porcentajes, fechas
3. **Enfócate en tu rol**: ¿Qué hiciste TÚ? No el equipo en general
4. **Usa verbos de acción**: Lideré, Implementé, Diseñé, Optimicé
5. **Contexto internacional**: Si trabajaste cross-border, menciónalo

### ❌ Evita

- Información confidencial del cliente (si aplicable)
- Descripciones genéricas: "proyecto exitoso", "gran desafío"
- Listados de tecnologías sin contexto de uso
- Texto demasiado técnico sin traducción al valor de negocio

---

## Optimización de Imágenes

### Recomendaciones de Formato

- **Formato**: JPG para fotos, PNG para gráficos con transparencia
- **Resolución**: 1920px de ancho máximo (Astro generará versiones responsive)
- **Peso**: Objetivo < 1MB por imagen (Astro las comprimirá automáticamente)
- **Nombres**: Usa nombres descriptivos: `instalacion-nocturna.jpg` > `IMG_1234.jpg`

### Astro se Encarga de:

✓ Conversión automática a WebP
✓ Generación de thumbnails
✓ Lazy loading
✓ Responsive images (srcset)

No necesitas optimizar las imágenes manualmente.

---

## Troubleshooting

### "Mi proyecto no aparece en /proyectos"

```bash
# Verifica que el archivo .mdx esté en la ubicación correcta
ls src/content/projects/

# Debe devolver:
# torre-reforma-bbva.mdx
# tu-nuevo-proyecto.mdx

# Rebuild
npm run build
```

### "Las imágenes no cargan"

```bash
# Verifica que las imágenes estén en public/
ls public/projects/nombre-proyecto/

# Las rutas en Astro son relativas a public/
# Correcto: "/projects/nombre/foto.jpg"
# Incorrecto: "/public/projects/nombre/foto.jpg"
```

### "Error de validación del schema"

Revisa que todos los campos obligatorios estén en el frontmatter:
- `title`
- `description`

Usa comillas para valores con caracteres especiales:
```mdx
title: "Dubai Fascias - Mall of the Emirates"  # ✓ Correcto
title: Dubai Fascias - Mall of the Emirates    # ✗ Puede fallar
```

---

## Siguiente Paso

Una vez que domines añadir proyectos, puedes:

1. **Añadir filtros**: Por categoría, año, cliente
2. **Mejorar el template**: Sección de "Proyectos Relacionados"
3. **SEO**: Optimizar meta tags por proyecto
4. **Analytics**: Trackear qué proyectos son más visitados

Para implementar estas mejoras, consulta la documentación de Astro o contacta soporte.
