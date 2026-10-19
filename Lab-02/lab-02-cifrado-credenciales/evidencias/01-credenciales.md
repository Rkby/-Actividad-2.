# Evidencia 01 — Protección de credenciales

## Objetivo
Comparar el almacenamiento inseguro de una contraseña en texto claro con el almacenamiento de un hash generado mediante `pgcrypto`.

## Comandos o procedimiento
Se ejecutó `sql/01-credenciales.sql` por bloques:
1. Consulta de `usuarios_insegura`.
2. Dos consultas `crypt('Password123', gen_salt('bf'))` para comparar los hashes.
3. Consulta de `usuarios_segura`.
4. Verificación de una contraseña correcta y otra incorrecta.

## Resultado obtenido
**Completar después de ejecutar en PostgreSQL:**
- En la tabla insegura, la columna `password` permite leer `Password123` directamente.
- Los dos hashes generados de la misma contraseña deben ser diferentes porque cada llamada genera una sal aleatoria.
- En `usuarios_segura` se almacena una cadena hash, no la contraseña original.
- La consulta de verificación debe devolver `contrasena_correcta = true` y `contrasena_incorrecta = false`.
- Pega aquí los resultados textuales o añade una captura si es necesaria.

## Análisis
Una contraseña en texto claro queda expuesta a cualquiera que consiga leer la tabla. El hash con sal está diseñado para verificar la contraseña sin poder recuperar directamente el texto original. `gen_salt()` crea la sal y `crypt()` genera o comprueba la representación correspondiente; el mecanismo utilizado en este laboratorio no es cifrado reversible.

## Conclusión
Las contraseñas no deben almacenarse en texto claro ni cifrarse para poder recuperarlas. En aplicaciones reales conviene utilizar el mecanismo de derivación de contraseñas recomendado por el framework y la política de seguridad vigente.
