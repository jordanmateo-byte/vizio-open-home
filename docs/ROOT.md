# ROOT: lo que confirmamos y cómo

La prueba decisiva fue la salida de un diagnóstico ejecutado en la TV:

```text
uid=0(root) gid=0(root)
Linux viziocasttv 3.10.0 ... armv7l
Directorio de trabajo: /tmp/usbparts/sda1
```

Esto es **ejecución de código con privilegios root**, no solo acceso a una API de control remoto. Permitió inspeccionar montajes, leer la configuración, copiar archivos a datos persistentes y sustituir el punto de entrada web de Home. No se instaló Magisk, `su`, SSH, ADB ni una bind shell; esta Vizio no se trató como un Android TV.

## La vía USB

El punto de partida fue el advisory público [ELTON L9-44-477](https://www.eltoncyber.com/advisories/vizio-tv-code-execution-from-a-usb-drive). Describe acceso a CGI en una memoria USB dentro del servidor local de Vizio. Su investigación es anterior a este proyecto y sus modelos publicados son distintos; aquí se confirmó el comportamiento en la M657-G0 de referencia.

En nuestro caso funcionó esta URL, abierta desde la propia TV mediante la API de lanzamiento:

```text
http://127.0.0.1:12345/usbparts/sda1/diagnostico.cgi
```

El archivo era un CGI de shell con operaciones fijas. Primero imprimió identidad y datos de solo lectura. No se abrió un puerto de shell ni se introdujo un ejecutable de administración remota. Después se ampliaron las inspecciones y, con respaldo, se autorizaron cambios limitados al launcher y Home.

El dato importante no era «la USB arranca Linux»: **la TV ya estaba ejecutando Linux y su servidor interpretó el CGI de la USB con identidad root**. No se arrancó un sistema operativo externo.

## Qué no funcionó

- La vía `/install` descrita en [ViziOwn / Exploitee.rs](https://blog.exploitee.rs/2021/viziown-exploiting-vizio-smartcast/) devolvió 404 en nuestra TV. No se ejecutó la inyección ni se cargó un paquete de instalación de esa cadena.
- SSH y ADB no estaban disponibles como vías funcionales de acceso.
- Activar opciones de depuración consultadas en la API no abrió los puertos probados. No apareció una sesión de depuración Chromium utilizable.
- Las primeras rutas supuestas de configuración dieron resultados incompletos. Se continuó con mapas reales del sistema en vez de asumir rutas de otros modelos.

## Límites de ese root

`/system` se observó como solo lectura. `/data` y el almacenamiento servido en `/tmp/scfs` permitieron escribir. No se remontó `/system`, no se tocó bootloader, no se cambiaron particiones y no se demostró que aceptar un CGI equivalga a poder flashear firmware arbitrario.

El parche final consiste en archivos de datos y una redirección web. La vulnerabilidad del proveedor no desaparece al restaurar Home, y «root confirmado» no significa «todo root es persistente» ni «recuperación garantizada».

Estas herramientas se preparan para TVs propias y una LAN controlada, con acceso físico al USB y emparejamiento con PIN. No publiques las claves temporales, no reenvíes los puertos al exterior y retira el puente cuando termine la instalación. El launcher final no requiere el puente ni una shell permanente.
