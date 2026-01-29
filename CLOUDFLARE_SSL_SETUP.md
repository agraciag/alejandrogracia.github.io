# Configuración SSL/HTTPS en Cloudflare

## Problema

Al acceder a `http://www.alejandrogracia.com` (sin HTTPS), el navegador no redirige automáticamente a la versión segura.

## Causa

Cloudflare tiene la opción "Always Use HTTPS" desactivada, lo que permite que las conexiones HTTP funcionen sin redirigir a HTTPS.

## Solución

### Paso 1: Activar "Always Use HTTPS"

1. Accede al **Dashboard de Cloudflare**: https://dash.cloudflare.com
2. Selecciona tu dominio: `alejandrogracia.com`
3. En el menú lateral izquierdo, ve a: **SSL/TLS** → **Edge Certificates**
4. Busca la sección **"Always Use HTTPS"**
5. Activa el toggle (debe quedar en color naranja/ON)

![Always Use HTTPS Toggle](https://developers.cloudflare.com/assets/always-use-https_hu07bc49bb5e1de4a39e5e17f6fc57df03_84803_1999x423_resize_q75_box-2b4dcec6.jpg)

**Resultado**: Cualquier petición HTTP será automáticamente redirigida a HTTPS.

---

### Paso 2: Verificar Modo SSL/TLS

Mientras estés en la configuración de SSL:

1. Ve a **SSL/TLS** → **Overview**
2. Asegúrate de que el modo SSL esté configurado como:
   - **"Full" (Recomendado)** o **"Full (strict)"**

**NO uses:**
- ❌ "Off" - Sin encriptación
- ❌ "Flexible" - Solo HTTPS entre navegador y Cloudflare (no seguro)

**Configuración recomendada para Cloudflare Tunnel:**
```
SSL/TLS encryption mode: Full
```

Esto garantiza encriptación end-to-end desde el navegador hasta tu servidor.

---

### Paso 3: Verificar que el Tunnel está Correctamente Configurado

Tu Cloudflare Tunnel ya está funcionando correctamente (contenedor `cloudflarePeten` está UP).

Verifica la configuración del tunnel:

```bash
# Ver logs del tunnel
docker logs cloudflarePeten --tail 50

# Debería mostrar:
# "Registered tunnel connection"
# "Route propagating"
```

Si ves errores de SSL en los logs, verifica que el tunnel esté configurado para conectarse a tu servidor local via HTTP (no HTTPS):

**Configuración del Tunnel (en Cloudflare Dashboard):**
- **Public hostname**: `www.alejandrogracia.com` y `alejandrogracia.com`
- **Service Type**: `HTTP`
- **URL**: `localhost:4321` o `host.docker.internal:4321`

---

## Verificación Final

Después de activar "Always Use HTTPS":

### 1. Test desde línea de comandos

```bash
# Debe devolver una redirección 301/308 a HTTPS
curl -I http://www.alejandrogracia.com/

# Esperado:
# HTTP/1.1 301 Moved Permanently
# Location: https://www.alejandrogracia.com/
```

### 2. Test desde navegador

1. Abre una ventana de incógnito
2. Escribe: `http://www.alejandrogracia.com` (sin https://)
3. Presiona Enter
4. La URL debe cambiar automáticamente a `https://www.alejandrogracia.com`
5. Debes ver el candado de seguridad en la barra de direcciones

---

## Configuración Avanzada (Opcional)

### HSTS (HTTP Strict Transport Security)

Para mayor seguridad, activa HSTS:

1. Ve a **SSL/TLS** → **Edge Certificates**
2. Busca **"HTTP Strict Transport Security (HSTS)"**
3. Click en "Enable HSTS"
4. Configuración recomendada:
   - **Max Age Header (max-age)**: 12 meses (31536000)
   - **Apply HSTS policy to subdomains (includeSubDomains)**: ✓ Activado
   - **Preload**: ❌ Desactivado (solo si estás 100% seguro)
   - **No-Sniff Header**: ✓ Activado

⚠️ **ADVERTENCIA**: HSTS es una configuración agresiva que fuerza HTTPS permanentemente en el navegador del usuario. Solo actívalo si estás seguro de que SIEMPRE usarás HTTPS.

### Automatic HTTPS Rewrites

También puedes activar:

1. Ve a **SSL/TLS** → **Edge Certificates**
2. Busca **"Automatic HTTPS Rewrites"**
3. Actívalo

Esto reescribirá automáticamente URLs inseguras (HTTP) a HTTPS en el HTML de tu página.

---

## Troubleshooting

### Problema: "Activé Always Use HTTPS pero sigue sin redirigir"

**Solución**:
1. Espera 2-5 minutos (propagación de Cloudflare)
2. Limpia caché del navegador o usa ventana de incógnito
3. Verifica que no tengas Page Rules conflictivas:
   - Ve a **Rules** → **Page Rules**
   - Asegúrate de que no haya reglas que desactiven SSL

### Problema: "ERR_TOO_MANY_REDIRECTS"

**Causa**: Loop de redirección (Cloudflare redirige a HTTPS, pero tu servidor redirige a HTTP)

**Solución**:
1. Cambia el modo SSL de "Flexible" a "Full"
2. Asegúrate de que tu servidor esté respondiendo correctamente a HTTPS

### Problema: "NET::ERR_CERT_AUTHORITY_INVALID"

**Causa**: Certificado SSL inválido o no trusted

**Solución**:
1. Ve a **SSL/TLS** → **Edge Certificates**
2. Espera a que el certificado de Cloudflare se active (puede tardar hasta 24h)
3. Si usas "Full (strict)", asegúrate de que tu servidor tenga un certificado válido

Con Cloudflare Tunnel, esto no debería ser problema ya que Cloudflare maneja el certificado.

---

## Resumen de Configuración Recomendada

```
SSL/TLS Settings:
├── SSL/TLS encryption mode: Full
├── Always Use HTTPS: ON
├── Automatic HTTPS Rewrites: ON
├── Minimum TLS Version: 1.2
└── HSTS: OFF (activar solo si estás seguro)

Cloudflare Tunnel:
├── Public Hostname: www.alejandrogracia.com, alejandrogracia.com
├── Service Type: HTTP
└── URL: localhost:4321
```

---

## Referencias

- [Cloudflare: Always Use HTTPS](https://developers.cloudflare.com/ssl/edge-certificates/additional-options/always-use-https/)
- [Cloudflare: SSL/TLS Encryption Modes](https://developers.cloudflare.com/ssl/origin-configuration/ssl-modes/)
- [Cloudflare Tunnel Documentation](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/)

---

## Estado Actual (2026-01-12)

- ✅ HTTPS funciona correctamente: `https://www.alejandrogracia.com`
- ✅ HTTP redirige automáticamente a HTTPS (HTTP 301)
- ✅ Cloudflare Tunnel activo (contenedor `cloudflarePeten`)
- ✅ **"Always Use HTTPS" ACTIVADO** en Cloudflare Dashboard
- ✅ Certificado SSL válido de Cloudflare
- ✅ Configuración completa y funcional

### Verificación

Para verificar el estado en cualquier momento:

```bash
./check-https.sh
```

Este script ejecuta 5 tests automáticos y te muestra el estado completo de la configuración HTTPS.
