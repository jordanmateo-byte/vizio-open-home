# Instalación controlada

## Alcance del paquete

El método terminó funcionando en **M657-G0 / SX7B / 7.0.120.1-1 / grupo 271**. El nuevo empaquetado público no se volvió a ejecutar sobre la TV ya funcional. Sus scripts y verificaciones tienen tests locales; confirma cada lectura y conserva el respaldo de tu unidad. Otro firmware puede cambiar rutas, permisos o la forma de lanzar el navegador.

No hay flasheo, desbloqueo de bootloader ni reemplazo del sistema. No se modifican ajustes de HDMI, CEC, audio ni volumen. Sí se escribe en el almacenamiento de datos que contiene el inicio web.

Necesitas Node.js 24, PC y TV en la misma LAN, control de la TV, acceso físico y una USB FAT32. Los ejemplos usan **192.168.50.90 para la TV** y **192.168.50.40 para la PC**; sustitúyelos. No son direcciones del equipo original.

## 1. Preparar el proyecto y emparejar

Desde la raíz del repositorio:

```sh
npm ci --ignore-scripts
npm run build
npm test
node tools/tv.mjs pair --tv 192.168.50.90
node tools/tv.mjs info --tv 192.168.50.90
```

El PIN se muestra en la TV y se introduce localmente. La credencial queda en `.private/`, ignorada por Git. Comprueba modelo y firmware antes de seguir. No se necesita ADB.

## 2. Preparar USB y confirmar root

```sh
node tools/usb-kit.mjs --tv 192.168.50.90 --host 192.168.50.40 --out usb-kit
```

Copia **el contenido** de `usb-kit/` a la raíz de una USB FAT32. El comando no formatea ni borra unidades; rechaza una carpeta de salida no vacía. Conecta la USB a la TV y ejecuta:

```sh
node tools/tv.mjs launch --tv 192.168.50.90 --url http://127.0.0.1:12345/usbparts/sda1/diagnostico.cgi
```

La pantalla debe mostrar **`uid=0(root)`**. Esto confirma la identidad del proceso CGI; no significa que se haya instalado una shell permanente. Si la ruta no abre o no aparece root, detente: el perfil no es compatible todavía. No pruebes payloads de otro modelo a ciegas.

Prueba el menú desde USB:

```sh
node tools/tv.mjs launch --tv 192.168.50.90 --url http://127.0.0.1:12345/usbparts/sda1/index.html
```

Comprueba control, apps y entradas. Que una orden devuelva `SUCCESS` no confirma que la app reproduzca contenido.

## 3. Puente temporal, sin mover la USB

Terminal A:

```sh
node tools/bridge-server.cjs
```

En Windows, abre **otra PowerShell como administrador**, entra al repositorio y ejecuta:

```powershell
.\tools\windows-firewall.ps1 -TvIp 192.168.50.90 -Minutes 10
```

Deja esa consola abierta. La regla admite exclusivamente esa IP, TCP 8099 y el ejecutable Node detectado. Tiene límite temporal y se elimina en `finally`; comprueba su retirada al terminar. Si Windows cancela el permiso, no se puede asumir que el puente funcionará. En otros sistemas, configura un acceso equivalente limitado a tu TV; este paquete no automatiza sus firewalls.

Terminal C:

```sh
node tools/tv.mjs launch --tv 192.168.50.90 --url http://127.0.0.1:12345/usbparts/sda1/puente.html
node tools/job.mjs --op run --name respaldo-home.cgi --out .private/home-report.txt
node tools/job.mjs --op get --name sc-config.private.json --out .private/sc-config.original.json
node tools/job.mjs --op get --name home-original.private.html --out .private/home-usb-backup.html
```

La respuesta del respaldo debe contener root, un Home completo y tamaños coherentes. Los archivos `*.private.*` de la USB y `.private/` del PC son privados: el JSON de configuración puede contener secretos del fabricante. No los adjuntes a un issue.

## 4. Preparar una migración en dos etapas

El plan toma el Home **de tu TV**, no un HTML de otra unidad:

```sh
node tools/plan.mjs prepare --report .private/home-report.txt --model M657-G0 --firmware 7.0.120.1-1
node tools/job.mjs --op put --name inspeccion.cgi --file .private/stage.cgi
node tools/job.mjs --op run --name inspeccion.cgi --out .private/stage-report.txt
node tools/plan.mjs verify-stage --report .private/stage-report.txt
```

La etapa copia el launcher a `/tmp/scfs/codex-home/index.html`, respalda el inicio en `/data/tv/save/open-home-original.html` y la USB, y devuelve el contenido para compararlo en el PC. **No cambia Home todavía.** Solo si el respaldo y el launcher leído de vuelta coinciden exactamente se generan `apply.cgi` y `restore.cgi`.

Si falló un `mkdir`, `cp` o la lectura, no avances por ver un mensaje de éxito: durante el desarrollo una operación imprimió éxito aun con la carpeta ausente. La comparación independiente en el PC es el requisito real.

## 5. Aplicar Home y verificar

```sh
node tools/job.mjs --op put --name inspeccion.cgi --file .private/apply.cgi
node tools/job.mjs --op run --name inspeccion.cgi --out .private/home-applied.txt
node tools/plan.mjs verify-home --report .private/home-applied.txt
node tools/tv.mjs launch --tv 192.168.50.90 --url http://127.0.0.1:12345/scfs/codex-home/index.html
node tools/tv.mjs home --tv 192.168.50.90
```

No se cambian país, `AllowedCountries`, DNS, firmware ni preferencias de HDMI/volumen. El Home original conserva su contenido y recibe una redirección local que comprueba la presencia del launcher antes de navegar a él.

## 6. Retirar el puente y probar sin USB

```sh
node tools/stop.mjs
```

Cierra el servidor de la terminal A con Ctrl+C. En Windows, `.private/firewall-status` debe decir `REMOVED`. Si la consola de firewall terminó de forma anormal, revisa y elimina únicamente la regla `VizioOpenHomeTemporary8099` que creó este proyecto.

Retira la USB, pulsa Home, abre una app y vuelve, apaga y enciende con el control. Comprueba HDMI y volumen. No declares terminada la instalación por un `SUCCESS` de la API. Conserva la USB y los respaldos para recuperación.

## Si necesitas actualizar el launcher

La instalación ya hecha no debe repetirse como si fuera nueva: el plan rechaza un Home marcado por el proyecto para no sustituir el respaldo original. Para actualizar, conserva el Home y su respaldo, prueba el nuevo `dist/index.html` desde USB, copia únicamente el launcher a su carpeta interna y compara el contenido leído de vuelta. Ese flujo de actualización no está automatizado en esta primera versión pública.
