# Evidencia 07 — Protección en reposo y en tránsito

## Objetivo
Elegir un mecanismo apropiado según el tipo de información y el riesgo que se necesita reducir.

## Comparación
| Situación | Mecanismo apropiado | ¿Qué protege? |
|---|---|---|
| Contraseña de usuario | Hash/derivación de contraseñas con sal | Evita guardar la contraseña original y permite verificarla sin recuperarla directamente. |
| RFC almacenado en una tabla | Cifrado de la columna, cuando exista justificación para recuperarlo | Protege el contenido almacenado frente a lectura directa no autorizada, siempre que la clave esté protegida. |
| Consulta enviada desde cliente a servidor | TLS | Protege los datos mientras viajan por la conexión. |
| Respaldo de una base de datos | Cifrado del archivo de respaldo y controles de acceso | Reduce la exposición si se copia o pierde el archivo. |
| Clave criptográfica | Gestor de secretos/KMS o mecanismo seguro equivalente | Limita quién puede leer y utilizar la clave; debe incluir controles de acceso, rotación y recuperación. |

## Análisis
Estos mecanismos resuelven problemas diferentes y se complementan. El hash de contraseña no es reversible; el cifrado de datos sí permite recuperación con la clave; TLS protege el trayecto de comunicación; el cifrado de respaldos protege archivos almacenados. Ninguno elimina la necesidad de permisos, auditoría y gestión correcta de secretos.

## Conclusión
La protección debe seleccionarse según el activo y dónde puede quedar expuesto: credenciales, datos almacenados, tráfico de red, respaldos o claves.
