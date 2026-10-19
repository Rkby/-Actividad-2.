# Evidencia 04 — Verificación de TLS

## Objetivo
Comprobar la configuración del servidor PostgreSQL y si la sesión actual utiliza TLS para proteger los datos en tránsito.

## Comandos o procedimiento
Ejecutar por separado los bloques de `sql/03-verificacion-tls.sql`, en especial `SHOW ssl;`, `SHOW ssl_min_protocol_version;` y la consulta a `pg_stat_ssl` filtrada por `pg_backend_pid()`.

## Resultado obtenido — completar con datos reales
- `SHOW ssl`: **[anotar el valor devuelto]**
- `ssl_min_protocol_version`: **[anotar el valor devuelto]**
- Puerto: **[anotar el valor devuelto]**
- `listen_addresses`: **[anotar el valor devuelto]**
- `pg_stat_ssl.ssl`: **[true/false]**
- Versión TLS: **[valor o NULL]**
- Cifrado: **[valor o NULL]**

No se deben inventar estos valores: dependen de la instalación y de la conexión real utilizada al ejecutar las consultas.

## Análisis
`SHOW ssl` indica si el servidor tiene habilitada la funcionalidad TLS. `pg_stat_ssl` comprueba si la sesión actual está protegida: `ssl = true` indica que esta conexión usa TLS; si es `false`, la conexión actual no está cifrada por TLS. `sslmode=require` solicita TLS, pero por sí solo no valida completamente la identidad del servidor. `verify-full` también valida la autoridad certificadora y la coincidencia del nombre del servidor con el certificado.

## Conclusión
TLS protege la confidencialidad y la integridad de la comunicación y, con validación apropiada de certificados, permite autenticar al servidor. No reemplaza usuarios, roles ni permisos de PostgreSQL.
