# Créditos

## Proyecto y desarrollo

**Jordan** — autor y responsable del proyecto: idea, objetivo de recuperar el inicio de su TV en México, dirección visual, selección y orden de apps, validación con el control, pruebas de funcionamiento y decisión de compartir el resultado.

**Codex, de OpenAI** — asistente de IA utilizado para investigar la plataforma, escribir y depurar el launcher y las herramientas, analizar resultados, preparar comprobaciones y redactar documentación. Esta atribución reconoce asistencia técnica; no implica que OpenAI publique, certifique o patrocine el proyecto.

La solución de launcher web para esta TV, API interna, persistencia, biblioteca, reemplazo y reordenación, migración interna, puente temporal, verificación y procedimiento de restauración se construyó en esta colaboración. Los conceptos existentes y recursos ajenos conservan sus créditos.

## Interfaz visual

**Gathin / CleanYourTV v2.5.0**, MIT: https://github.com/Gathin23/cleanyourtv

Se consultaron `activity_main.xml`, `AppAdapter.java`, `DockDecoration.java`, estilos y una captura de la instalación de referencia en una TCL. De ahí se adaptaron la composición visual, reloj, tipografía, proporción 180:101, columnas, espacios, dock, resaltado y presentación de menús a HTML/CSS. No se reutilizó su APK para ejecutar la Vizio ni su implementación Android como backend del proyecto. Los avisos MIT se conservan en `licenses/CleanYourTV-MIT.txt` y en el código de la interfaz.

## Investigación de seguridad y protocolos

- **ELTON, advisory L9-44-477**: investigación previa del acceso a CGI desde una USB dentro del servidor local de Vizio. Fue una referencia para lograr ejecución root en la unidad de este proyecto; no es un hallazgo original nuestro. https://www.eltoncyber.com/advisories/vizio-tv-code-execution-from-a-usb-drive
- **Exploitee.rs / cj_000, ViziOwn (2021)**: contexto técnico de SmartCast, SCPL y su plataforma. El endpoint `/install` de ese trabajo no funcionó en nuestra unidad. https://blog.exploitee.rs/2021/viziown-exploiting-vizio-smartcast/
- **exiva / Vizio_SmartCast_API** y **raman325 / pyvizio**: documentación comunitaria de emparejamiento, lanzamiento y códigos del control. https://github.com/exiva/Vizio_SmartCast_API · https://github.com/raman325/pyvizio
- Se consultó además investigación pública de https://github.com/vindeckyy/smartcast-backdoor como referencia de interfaces internas en otros modelos; no se afirma que su cadena completa se haya reproducido aquí.

## Recursos

- **Outfit Project Authors**: tipografía Outfit, SIL OFL 1.1. Se usa un subconjunto de caracteres latinos con peso ligero, no un dibujo nuevo de la fuente. Licencia completa en `licenses/Outfit-OFL.txt`.
- **Vizio / SmartCast**: catálogo y recursos gráficos de marcas obtenidos del catálogo público y el isotipo del sitio oficial de Vizio.
- Netflix, YouTube, Prime Video, Disney+, HBO Max, Apple TV, Plex, ViX, MUBI y Tubi: marcas y recursos gráficos de sus respectivos titulares; no son diseños originales del proyecto.

El crédito principal del proyecto corresponde a Jordan, con asistencia de Codex. Atribuir correctamente el diseño visual, la fuente, las marcas y la investigación de seguridad previa no transfiere la autoría del launcher a esos proyectos.
