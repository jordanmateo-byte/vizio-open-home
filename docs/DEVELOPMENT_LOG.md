# Historia del desarrollo: de una pantalla regional bloqueada a Home local

Esta reconstrucción usa los resultados guardados durante las sesiones del 21 y 22 de octubre de 2026 y las confirmaciones del propietario. Se publican conclusiones y rutas necesarias, no dumps privados ni fotos con identificadores.

## 1. El problema no era que todas las apps fallaran

La Vizio M657-G0 mostraba «VIZIO Home no está disponible en su región» en México. Netflix, YouTube y Prime podían abrirse por otros medios. El Fire Stick servía como alternativa, pero el objetivo era una TV autónoma: **sin PC, sin Fire Stick, sin abrir la carcasa**, conservando HDMI y volumen como prioridad.

Se confirmó modelo M657-G0, plataforma SX7B, firmware 7.0.120.1-1 y grupo 271. No se aplicaron procedimientos del TCL Android TV que también tenía el propietario.

## 2. API, PIN y el bloqueo regional

La API externa de SmartCast en 7345 se emparejó con un PIN mostrado en pantalla. Se leyó la información del dispositivo y se investigó la configuración del inicio. El Home consultaba una lista `AllowedCountries` que excluía MX, y había una consulta de ubicación por IP que devolvía México.

Cambiar el país en un endpoint devolvió aceptación, pero la lectura posterior no mostró un cambio real. Los datos de prueba que incluían MX pertenecían a rutas de desarrollo: no demostraban que se pudieran activar en esta TV. No se obtuvo una modificación efectiva de esa lista en memoria.

El usuario no quería depender de una VPN en la PC. Por eso no se fingió que cambiar idioma, DNS o una respuesta `SUCCESS` hubiera eliminado el bloqueo. La solución final sustituye Home localmente; no falsifica la autorización regional de cada servicio.

## 3. Primer menú propio, todavía en la PC

Se creó una página web navegable con el control. La primera apertura quedó negra: la TV no llegaba al servidor de pruebas de la PC. Una regla de firewall temporal, limitada a la IP de la TV y al puerto del proceso, permitió que apareciera el menú.

Los botones inicialmente solo decían «Abriendo Netflix». Después se conectaron a la API y se comprobó cómo obtener la credencial interna dentro del navegador de la TV. Al enviar las órdenes desde ese contexto, el menú pudo abrir apps directamente, sin un proxy permanente en la PC.

Se probó además una URL `data:`; apareció un error Code 9. Se recuperó la navegación abriendo una app conocida. Ese error no fue prueba de firmware dañado.

## 4. Dejar de depender de la PC: la USB

Una USB preparada como FAT32 fue reconocida. Las primeras rutas `file:` y suposiciones sobre el punto de montaje produjeron pantalla negra. Lo que funcionó fue el servidor de la propia TV:

```text
http://127.0.0.1:12345/usbparts/sda1/index.html
```

Se mostró primero una página mínima y después el launcher. El usuario confirmó que navegaba con el control y abría apps desde la USB. Esto aún no resolvía Home ni el encendido.

## 5. Diagnóstico y root

La investigación USB pública de ELTON permitió plantear un CGI de diagnóstico con operaciones fijas. El resultado en pantalla fue `uid=0(root) gid=0(root)`. Se generaron mapas de procesos, montajes y rutas; no se instaló una shell permanente.

Se localizaron `/data/tv/save/sc-config.json`, assets servidos por `/tmp/scfs`, scripts de arranque y el HTML del Home. Un reporte escrito a USB llegó a leerse vacío, aunque la respuesta del CGI contenía datos completos; se conservaron ambas observaciones y se siguió verificando el contenido recibido.

## 6. Puente temporal: no mover la USB a cada cambio

La TV abría `puente.html` desde USB. Esa página consultaba un servidor de la PC, recibía operaciones autorizadas, hacía solicitudes a CGI del mismo origen y devolvía resultados. El PC tenía una clave temporal, lista de nombres de archivo y acceso de firewall limitado a esa TV.

Se prepararon receptores `head`, `dd` y `cat`. `head` falló al recibir; otras variantes avanzaban hasta fallar al guardar. Al retirar una opción del movimiento de archivos se consiguió transferir y recuperar un texto idéntico con `dd`. Esa correlación se conserva como observación, no como diagnóstico definitivo de todos los binarios de Vizio.

Después hubo respuestas HTTP 413 para documentos grandes. Se dividió el HTML en segmentos menores, se ensambló en USB y se leyó de vuelta completo. El tamaño real aceptado por el servidor era más importante que el límite escrito en nuestro CGI. No se aumentaron límites del servidor de la TV.

También se corrigió el aislamiento de red del proceso del PC: un servidor iniciado en un contexto que la TV no alcanzaba no servía para la prueba. Si Windows cancelaba UAC, se dejaba pendiente la copia, se regresaba al menú anterior y no se afirmaba que el cambio estuviera instalado.

## 7. Recuperar Home desde la USB

Se respaldó el JSON de configuración y se comparó byte a byte. Se capturó el Home original y se observó que `/scfs/sctv/main.html` cargaba la experiencia del proveedor.

Se añadió una redirección local al menú USB, conservando el resto del documento como alternativa si faltaba el launcher. El propietario confirmó que Home lo abría y que el menú aparecía después de apagar y encender con USB. Se conservó la posibilidad de restaurar el documento anterior.

## 8. La interfaz no salió bien a la primera

Las primeras versiones inspiradas en Apple TV tenían márgenes inconsistentes. Se tomó como referencia concreta el código CleanYourTV v2.5.0 y una captura del TCL del propietario: reloj a la izquierda, Outfit, tarjetas 180:101, dock y espacios.

Se corrigieron diferencias del Chromium antiguo: separación `gap` que no se veía como se esperaba, centrado que dependía de `inset`, recortes y fondos de logos, texto de respaldo encima de imágenes y el icono AirPlay perdido al regenerar tarjetas.

Se incorporaron tres filas, «Más apps» fijo, biblioteca, sustitución y reordenación, última tarjeta y orden en almacenamiento local, Entradas, Wi-Fi informativo y Ajustes nativos. Se depuraron reemplazos repetidos Plex → Amazon Music → Plex. Los mensajes «Abriendo…» se eliminaron al quedarse pegados; las instrucciones y errores útiles se conservaron. El saludo terminó siendo genérico y en mayúsculas para compartir el proyecto.

## 9. Probar apps, no confundir aceptación con funcionamiento

ViX, MUBI y Tubi cargaron según las comprobaciones visuales del propietario. Pluto TV abrió pero mostró un error persistente; Paramount+ falló. Se añadieron las que cargaron. No se certificó reproducción completa de todos sus contenidos, cuentas o DRM. El catálogo de la biblioteca no es una lista de compatibilidad garantizada para México.

## 10. Migración a memoria interna y corrección de un falso éxito

Se preparó `/tmp/scfs/codex-home/index.html`. La primera rutina no creó la carpeta y mostró errores de copia, pero también imprimió un marcador de éxito. Se restauró inmediatamente el Home de USB, se creó la carpeta explícitamente, se copió otra vez y se devolvió el archivo completo al PC.

La lectura fue idéntica: **173.219 bytes** de launcher. Solo después se aplicó y comparó la nueva redirección de Home a la ruta interna. Este incidente es la razón por la que el paquete exige verificaciones en el PC y separa copiar de cambiar Home.

Finalmente, con el puente y la regla de firewall retirados, el propietario quitó la USB, apagó y encendió la TV y confirmó: menú al encender, Home funcional, HDMI funcional y volumen funcional. Ese es el resultado autónomo comprobado.

## Lo que no se probó

No se abrió la TV, no se usó UART, no se flasheó firmware y no se ensayó recuperación de un brick. Se descargó un ZIP oficial de referencia, se verificó su integridad y se dejó sin instalar. No se demostró downgrade ni un USB booteable. Tampoco se probó la supervivencia del parche a una actualización OTA o a todos los tipos de arranque frío.

El resultado no depende de que un investigador futuro repita los callejones sin salida: la documentación de instalación se centra en el camino que sí funcionó y conserva respaldos y verificaciones.
