#!/bin/bash

# Script de verificación de configuración HTTPS
# Uso: ./check-https.sh

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Verificación de HTTPS para alejandrogracia.com ===${NC}\n"

# Test 1: HTTPS directo
echo -e "${YELLOW}Test 1: Verificando acceso HTTPS...${NC}"
HTTPS_STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://www.alejandrogracia.com/ 2>&1)

if [ "$HTTPS_STATUS" = "200" ]; then
    echo -e "${GREEN}✓ HTTPS funciona correctamente (HTTP $HTTPS_STATUS)${NC}"
else
    echo -e "${RED}✗ HTTPS no funciona (HTTP $HTTPS_STATUS)${NC}"
fi

# Test 2: HTTP con redirección
echo -e "\n${YELLOW}Test 2: Verificando redirección HTTP → HTTPS...${NC}"
HTTP_RESPONSE=$(curl -s -I http://www.alejandrogracia.com/ 2>&1)
HTTP_STATUS=$(echo "$HTTP_RESPONSE" | head -1)

if echo "$HTTP_STATUS" | grep -q "301\|302\|307\|308"; then
    # Hay redirección
    LOCATION=$(echo "$HTTP_RESPONSE" | grep -i "^location:" | awk '{print $2}' | tr -d '\r\n')
    if echo "$LOCATION" | grep -q "^https://"; then
        echo -e "${GREEN}✓ HTTP redirige correctamente a HTTPS${NC}"
        echo -e "  Redirección: $LOCATION"
    else
        echo -e "${RED}✗ HTTP redirige pero NO a HTTPS${NC}"
        echo -e "  Redirección: $LOCATION"
    fi
elif echo "$HTTP_STATUS" | grep -q "200"; then
    # No hay redirección, pero funciona
    echo -e "${RED}✗ HTTP funciona pero NO redirige a HTTPS${NC}"
    echo -e "${YELLOW}  Acción requerida: Activa 'Always Use HTTPS' en Cloudflare${NC}"
    echo -e "  1. Ve a: https://dash.cloudflare.com"
    echo -e "  2. Selecciona: alejandrogracia.com"
    echo -e "  3. Ve a: SSL/TLS → Edge Certificates"
    echo -e "  4. Activa: 'Always Use HTTPS'"
else
    echo -e "${RED}✗ HTTP no funciona (Estado: $HTTP_STATUS)${NC}"
fi

# Test 3: SSL Certificate
echo -e "\n${YELLOW}Test 3: Verificando certificado SSL...${NC}"
CERT_INFO=$(curl -s -vI https://www.alejandrogracia.com/ 2>&1 | grep -E "SSL certificate verify|Server certificate")

if echo "$CERT_INFO" | grep -q "SSL certificate verify ok"; then
    echo -e "${GREEN}✓ Certificado SSL válido${NC}"
else
    echo -e "${YELLOW}⚠ No se pudo verificar el certificado completamente${NC}"
fi

# Test 4: Cloudflare Detection
echo -e "\n${YELLOW}Test 4: Verificando que pasa por Cloudflare...${NC}"
CF_HEADERS=$(curl -s -I https://www.alejandrogracia.com/ 2>&1 | grep -i "^cf-\|^server:")

if echo "$CF_HEADERS" | grep -q "cloudflare"; then
    echo -e "${GREEN}✓ Tráfico pasa correctamente por Cloudflare${NC}"
    echo "$CF_HEADERS" | grep -i "server:" | sed 's/^/  /'
    CF_RAY=$(echo "$CF_HEADERS" | grep -i "cf-ray:" | awk '{print $2}')
    if [ -n "$CF_RAY" ]; then
        echo -e "  CF-RAY: $CF_RAY"
    fi
else
    echo -e "${RED}✗ El tráfico NO pasa por Cloudflare${NC}"
fi

# Test 5: Test sin www
echo -e "\n${YELLOW}Test 5: Verificando dominio sin www...${NC}"
NOWWW_STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://alejandrogracia.com/ 2>&1)

if [ "$NOWWW_STATUS" = "200" ] || [ "$NOWWW_STATUS" = "301" ] || [ "$NOWWW_STATUS" = "308" ]; then
    echo -e "${GREEN}✓ alejandrogracia.com (sin www) funciona (HTTP $NOWWW_STATUS)${NC}"
else
    echo -e "${YELLOW}⚠ alejandrogracia.com (sin www) retorna HTTP $NOWWW_STATUS${NC}"
fi

# Resumen
echo -e "\n${BLUE}=== Resumen ===${NC}"

if [ "$HTTPS_STATUS" = "200" ] && echo "$HTTP_STATUS" | grep -q "301\|302\|307\|308"; then
    echo -e "${GREEN}✓ Configuración HTTPS completa y correcta${NC}"
    echo -e "  Tu web está accesible de forma segura en:"
    echo -e "  - https://www.alejandrogracia.com"
    echo -e "  - https://alejandrogracia.com"
elif [ "$HTTPS_STATUS" = "200" ]; then
    echo -e "${YELLOW}⚠ HTTPS funciona pero falta configurar redirección automática${NC}"
    echo -e "  Ver: ${BLUE}CLOUDFLARE_SSL_SETUP.md${NC} para activar 'Always Use HTTPS'"
else
    echo -e "${RED}✗ Hay problemas con la configuración HTTPS${NC}"
    echo -e "  Consulta: ${BLUE}CLOUDFLARE_SSL_SETUP.md${NC} para troubleshooting"
fi

echo ""
