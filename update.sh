#!/bin/bash

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Iniciando Actualización de alejandrogracia.com ===${NC}"

# Verificar directorio
if [ ! -f "astro.config.mjs" ]; then
    echo -e "${RED}Error: No estás en el directorio raíz del proyecto web.${NC}"
    exit 1
fi

# Argumentos
CLEAN=false
if [[ "$1" == "--clean" ]]; then
    CLEAN=true
fi

# Limpieza opcional
if [ "$CLEAN" = true ]; then
    echo -e "${BLUE}Limpiando cache...${NC}"
    rm -rf dist .astro
    echo -e "${GREEN}Cache limpia.${NC}"
fi

# Build
echo -e "${BLUE}Generando sitio estático (npm run build)...${NC}"
npm run build

if [ $? -ne 0 ]; then
    echo -e "${RED}Error: El build falló. Revisa los errores arriba.${NC}"
    exit 1
fi
echo -e "${GREEN}Build completado con éxito.${NC}"

# Reiniciar PM2
echo -e "${BLUE}Reiniciando servidor PM2...${NC}"
pm2 restart alejandrogracia_web

if [ $? -ne 0 ]; then
    echo -e "${RED}Error: No se pudo reiniciar PM2.${NC}"
    exit 1
fi
echo -e "${GREEN}PM2 reiniciado.${NC}"

# Verificación final
echo -e "${BLUE}Verificando estado...${NC}"
pm2 status alejandrogracia_web

echo -e "\n${GREEN}=== ¡Actualización Completada! ===${NC}"
echo -e "Tu web debería estar actualizada en: https://www.alejandrogracia.com"