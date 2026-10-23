# Pruebas automáticas en GitHub

Las nueve pruebas se ejecutaron localmente antes de publicar. La conexión usada para la primera subida no tenía permiso OAuth `workflow`, por lo que la plantilla se conserva en `docs/examples/github-actions-ci.yml`, sin activarla.

Para activar GitHub Actions, copia esa plantilla a `.github/workflows/ci.yml` desde una sesión con permiso para modificar workflows y guarda el cambio. Usa la raíz del repositorio, tal como indica la plantilla. No agregues credenciales de la TV: estas pruebas son locales y no necesitan ningún secreto.
