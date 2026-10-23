# Puente temporal y firewall

## Diseño

1. La PC atiende TCP 8099 durante una sesión limitada.
2. La TV abre `/usbparts/sda1/puente.html` desde su propio servidor HTTP.
3. La página consulta `/job` en la PC con una clave aleatoria de 24 bytes.
4. Ejecuta una operación permitida mediante un CGI local de USB.
5. Devuelve estado, texto y errores a `/result` en la PC.

No se instaló un servidor root persistente en la TV. El servidor de la PC desaparece al cerrar el proceso y el Home interno no lo consulta para funcionar.

`bridge-server.cjs` solo admite la IP configurada de la TV y loopback, exige clave y limita encolado a loopback. La clave del CGI caduca a las dos horas; el servidor a los 30 minutos; el firewall por defecto a los 10. Son límites distintos. La hora incorrecta de la TV puede afectar la comprobación del CGI.

La lista de nombres de archivo reduce las operaciones accidentales. **No convierte en inofensivo un CGI raíz**: `inspeccion.cgi` puede contener un plan de instalación explícito del propietario. No recibas ni ejecutes CGIs desconocidos de terceros.

## Receptores y tamaño

El receptor de referencia es `puente-dd.cgi`. Se conservan las variantes `head` y `cat` como alternativas de diagnóstico, no como compatibilidad prometida.

Aunque el CGI permite hasta 128 KiB, el servidor de esta TV devolvió 413 en transferencias mayores que otras que sí aceptó. La herramienta pública envía como máximo 58.000 bytes por archivo. Para un launcher mayor, divídelo en segmentos y ensámblalo en USB mediante un CGI de operaciones fijas. Después compara la lectura completa con el archivo original en la PC.

La instalación inicial evita esa transferencia grande: se copia `dist/index.html` a la USB desde la PC al preparar el kit, y el plan interno copia ese archivo local ya completo.

## Windows

`windows-firewall.ps1` necesita una PowerShell de administrador. Restringe TCP 8099 a una IPv4 privada concreta y al Node detectado. No desactiva Windows Firewall, no abre rangos de red y no crea redirecciones en el router.

Termina con `node tools/stop.mjs` y cierra el servidor. Verifica `REMOVED` en `.private/firewall-status`. Si el sistema mata la consola antes de `finally`, revisa la regla por su nombre exacto y retírala; el temporizador es un proceso local, no una garantía ante apagados o cierres forzados.

## Renovación y recuperación

Si recibes `410 Gone`, genera una nueva sesión y copia los archivos renovados a la USB. La misma clave no debe hacerse permanente. Los respaldos de la TV y el launcher existente se conservan; no formatees ni borres la USB para renovar el puente.

Si el PC recibe `Sin respuesta`, revisa IP, red local, programa permitido, firewall y que la TV tenga abierta la página del puente. Si el CGI devuelve 200 pero el cuerpo contiene errores de copia, la operación falló: el estado HTTP por sí solo no valida los datos.
