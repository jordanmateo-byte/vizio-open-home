# Firmware y recuperación investigada

Durante el desarrollo se obtuvo el ZIP oficial del mismo firmware de la unidad de referencia:

- Modelo: M657-G0, grupo 271.
- Archivo: `7.0.120.1-1MG271.zip`.
- Fuente: `https://cdn.vizio.com/misc/FW/MG271/7.0.120.1-1MG271.zip`.
- Tamaño observado: 387.680.609 bytes.
- SHA-256 observado: `D775ABE9689F6BFC8421083C9F98D779E602C359BC9604C0D6205B4A7FC88405`.
- Contenido observado: un UTV y la referencia de actualización correspondiente; la prueba de integridad del ZIP pasó.

**No se instaló.** Este repositorio no contiene el ZIP ni el UTV. La coincidencia de modelo y un ZIP íntegro no demuestran que el bootloader permita downgrade, que se pueda flashear un UTV modificado o que ese archivo recupere una TV sin arrancar.

Se analizaron encabezados del contenedor fuera de la TV. No se obtuvo un procedimiento de firmware modificado ni se confirmó una ruta de desbrickeo. Tampoco se abrió la carcasa ni se usó UART.

Para revertir este proyecto se usa el respaldo del HTML de Home, no un flasheo. Si la partición o el hardware dejan de funcionar, conservar HDMI como fallback cotidiano no equivale a disponer de una recuperación de bajo nivel.
