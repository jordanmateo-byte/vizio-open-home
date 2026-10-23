# Restaurar el inicio anterior

La restauración devuelve el Home original que respaldaste de **tu propia TV**. No borra cuentas, no reinstala firmware y no intenta modificar HDMI ni volumen.

## Si instalaste con las herramientas de este repositorio

Conecta la USB de recuperación, inicia el puente temporal como en `INSTALL.md` y usa el `restore.cgi` generado en `.private/` al verificar la etapa:

```sh
node tools/job.mjs --op put --name inspeccion.cgi --file .private/restore.cgi
node tools/job.mjs --op run --name inspeccion.cgi --out .private/home-restored.txt
node tools/plan.mjs verify-restore --report .private/home-restored.txt
node tools/tv.mjs home --tv 192.168.50.90
node tools/stop.mjs
```

Después cierra el servidor y verifica que se eliminó la regla temporal. Prueba Home, HDMI y volumen. El menú original puede volver a mostrar el bloqueo regional: restaurar significa volver al estado anterior, no reparar el servicio regional de Vizio.

El script copia `/data/tv/save/open-home-original.html` a `/tmp/scfs/sctv/main.html` y devuelve el contenido para compararlo con `.private/home-original.html`. Si el respaldo no existe o no coincide, **no sustituyas ese archivo por una copia de otra TV**. Conserva el estado y revisa tu USB y respaldo local.

La carpeta del launcher puede quedar en la partición de datos sin ejecutarse. No hace falta borrarla para revertir Home. Tampoco es necesario borrar preferencias del navegador. No se incluye un borrado recursivo del almacenamiento de la TV.

## La instalación original del desarrollo usa otros nombres

En la unidad de Jordan ya funcional, los respaldos históricos son:

- `/data/tv/save/codex-home-original.html`: Home original anterior a los parches.
- `/data/tv/save/codex-home-before-internal.html`: Home que redirigía a USB, justo antes de migrar a memoria interna.
- USB: `home-original-main.html`, `home-before-internal.html` y una carpeta `respaldo-sc-FECHA/sc-config.json`.

Para volver al inicio de fábrica de esa unidad se usa **`codex-home-original.html`**. Para volver al launcher USB se usa **`codex-home-before-internal.html`**. Son dos restauraciones distintas. No renombres o sobreescribas esos respaldos con los del instalador público.

## Si no abre nuestro menú

1. Prueba el botón físico de entradas del control y vuelve al HDMI de tu reproductor externo. Ese es el recurso de uso diario que se validó en la unidad de referencia, no un desbrickeo de firmware.
2. Si la API responde, lanza directamente el diagnóstico de la USB o `puente.html`; no dependas de que Home abra el launcher para recuperar.
3. Si el puente expiró, genera un kit con clave nueva y actualiza sus archivos en la USB. No hagas permanente la clave anterior.
4. Si sigue sin haber API, HDMI o respuesta de la TV, este proyecto no ofrece una recuperación de bajo nivel verificada.

Se descargó y comprobó un ZIP oficial del firmware de referencia, pero **no se flasheó ni se ensayó desbrickeo o downgrade**. Un restablecimiento de fábrica no equivale a reescribir todas las particiones y no se presenta como procedimiento de recuperación garantizado.

Una actualización OTA puede reemplazar los assets y eliminar el parche. No se bloquearon actualizaciones automáticamente. Revisa el nuevo estado antes de volver a aplicar cualquier cambio.
