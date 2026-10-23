# Arquitectura

## Separación de capas

- `src/index.template.html`: interfaz, estilos, recursos embebidos y avisos de la adaptación visual.
- `src/runtime.js`: integración con la TV, navegación, entradas, biblioteca, reordenación, persistencia y paneles.
- `data/catalog.json`: snapshot del catálogo público SmartCast con configuración de lanzamiento e imágenes de biblioteca.
- `dist/index.html`: HTML autocontenido generado, que se copia a USB o almacenamiento interno. Los logos de las tarjetas iniciales y Outfit están incluidos; las imágenes de apps añadidas desde la biblioteca usan sus URLs del catálogo y muestran un fallback si fallan.
- `tools/`: emparejamiento externo, kit USB, puente, firewall y planes locales de instalación/restauración.

El launcher usa la API interna `http://127.0.0.1:7346` dentro del navegador de la TV. Obtiene una credencial de ejecución con `/app/get_auth_token` y envía las órdenes desde ese contexto. No contiene el token de emparejamiento de una TV ni depende de un proxy en la PC al usarse diariamente.

La API externa `https://IP_TV:7345` se utiliza durante preparación y recuperación, con PIN. La excepción de certificado autofirmado está limitada a esa solicitud dirigida a una IP privada; no se cambia la política TLS del sistema ni se desactiva la validación global de otros servicios.

## Preferencias

Se guardan en `localStorage` del origen de la TV:

- `vizioHome.lastSelected`: última app seleccionada.
- `vizioHome.cards.v1`: once tarjetas configurables, con orden y datos de lanzamiento.

La duodécima tarjeta, «Más apps», permanece fija. Añadir desde la biblioteca sustituye una tarjeta; no cambia el tamaño 4 × 3 ni instala una aplicación del sistema. Los recursos y la interfaz son independientes de esos datos personales. El paquete público elimina la migración puntual que restauró Plex en la TV del autor para no alterar preferencias de futuros usuarios.

El origen `http://127.0.0.1:12345` se mantiene tanto en la fase USB como en la interna. Por eso se conservó el almacenamiento local al migrar. Borrar datos del navegador o cambiar de origen puede perder esas preferencias.

## Control remoto

OK corto abre; OK largo muestra acciones. El estado de tecla se limpia al perder foco. Flechas navegan en cuatro columnas. Se escalan coordenadas de diseño 1920 × 1080 al viewport, conservando relación de aspecto y márgenes. Las filas se desplazan bajo una banda de enfoque mientras el nombre de la app permanece visible.

El Chromium de referencia requirió evitar `gap` de flexbox y depender de `top/left/width/height` explícitos en vez de `inset`. Los tests de DOM no sustituyen comprobar tipografía, tiempos de pulsación y recortes en el panel real.

Wi-Fi es informativo; no cambia red ni DNS. Ajustes envía la orden de menú del control. Entradas obtiene la lista actual, sus nombres y metadatos que informe la TV; no inventa estados de conexión que no se hayan reportado.

## Persistencia y reversión

El Home del proveedor en `/tmp/scfs/sctv/main.html` recibe una redirección local. La copia interna vive en `/tmp/scfs/codex-home/index.html`. En la TV probada, ese árbol se sirve desde una partición persistente de datos.

La interfaz de Vizio sigue siendo la alternativa si la comprobación del launcher local falla. Eso puede mostrar nuevamente el bloqueo regional; es un fallback, no un mecanismo garantizado de recuperación de firmware. Restaurar copia de vuelta el documento respaldado y se compara en la PC.

Las actualizaciones OTA pueden reemplazar los assets. No se prometió persistencia ante OTA ni se deshabilitaron actualizaciones.
