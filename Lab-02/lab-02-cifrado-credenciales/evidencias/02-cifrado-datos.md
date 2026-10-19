# Evidencia 02 — Cifrado de información sensible

## Objetivo
Demostrar cifrado simétrico reversible de un dato sensible (RFC ficticio) con las funciones `pgp_sym_encrypt()` y `pgp_sym_decrypt()` de `pgcrypto`.

## Comandos o procedimiento
Se ejecutó `sql/02-cifrado-datos.sql` por bloques. Se consultó el valor cifrado como hexadecimal y después se descifró mediante la clave ficticia exclusiva del laboratorio.

## Resultado obtenido
**Confirmar con la ejecución local:**
- La tabla contiene el nombre y el campo `rfc_cifrado` de tipo `BYTEA`; la consulta hexadecimal muestra datos cifrados, no el RFC legible.
- Con la clave de laboratorio correcta, el descifrado debe devolver el RFC ficticio `LOPA900101ABC`.
- Una clave incorrecta debe provocar un error de descifrado o impedir recuperar correctamente el dato.
- Añadir el resultado de las consultas o una captura si resulta útil.

## Análisis
`pgp_sym_encrypt()` transforma el dato en contenido cifrado que puede recuperarse mediante `pgp_sym_decrypt()` con la clave correcta. A diferencia de `crypt()` usado para contraseñas, el cifrado es reversible. La clave incluida en el script es una clave didáctica ficticia; no debe reutilizarse ni sustituye una gestión segura de claves.

## Conclusión
El cifrado resulta apropiado para datos que deban recuperarse con autorización. La protección depende tanto del algoritmo como de la custodia de la clave.
