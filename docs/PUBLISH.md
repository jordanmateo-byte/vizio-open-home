# Preparar una publicación

El directorio de este repositorio se creó mediante una selección de archivos públicos. **No subas el directorio de trabajo entero** del desarrollo ni una imagen de la USB de recuperación.

## Incluido

Launcher, catálogo público, scripts genéricos con parámetros, pruebas, documentación, licencias y un resumen de resultados sin identificadores privados. Los ejemplos de red usan direcciones ilustrativas distintas del dispositivo de referencia.

## Excluido

- Credenciales de emparejamiento, PIN y claves del puente.
- `sc-config.json`, respuestas completas de inicialización y otros dumps de la TV: pueden contener secretos aunque parezcan configuración.
- Series, ESN, MAC, SSID, direcciones del usuario y registros completos de red.
- Backups de Home reales, reportes privados, fotos con reflejos o identificadores y datos del navegador.
- Firmware ZIP/UTV, ROMs, APKs ajenos y dependencias `node_modules`.

`.private/`, `usb-kit/` y `node_modules/` están en `.gitignore`, pero eso no sustituye revisar qué archivos se preparan para commit.

## Comprobaciones

```sh
npm ci --ignore-scripts
npm run build
npm test
npm run check
git init
git add .
git diff --cached --stat
git diff --cached
```

`npm run check` es una barrera básica contra artefactos privados comunes y datos de emparejamiento; no es un detector universal de secretos. Revisa también cualquier archivo nuevo y las capturas antes de publicar. No incluyas `.private` en un ZIP aunque Git lo ignore.

Los métodos operativos de root y la migración se validaron en una unidad. El nuevo empaquetado público tiene tests locales, no una segunda instalación física de validación. Conserva esa distinción en el release y en el README.

Este trabajo prepara una publicación, pero no crea un repositorio remoto, no inicia sesión en GitHub, no sube archivos y no crea una licencia sobre recursos gráficos de terceros. Al publicar, conserva `LICENSE`, `CREDITS.md`, `THIRD_PARTY_NOTICES.md` y `licenses/`.
