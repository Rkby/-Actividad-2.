# Evidencia 08 — Análisis de escenario de seguridad

## Objetivo
Analizar los riesgos de una empresa que tiene usuarios y permisos correctos, pero guarda contraseñas y RFC en texto claro, carece de validación adecuada del servidor TLS, incluye claves en SQL y no protege los respaldos.

## Pregunta 1. ¿Cuáles son los principales riesgos?
- Una lectura no autorizada de la tabla puede revelar contraseñas reutilizables.
- El RFC y la información financiera pueden quedar expuestos en caso de acceso indebido, filtración o copia de datos.
- Sin validación adecuada del servidor, el cliente podría no comprobar correctamente con quién se conecta.
- Las claves guardadas en scripts pueden filtrarse por Git, copias, registros o capturas.
- Los respaldos sin cifrado pueden exponer todos los datos si se pierden o copian.

## Pregunta 2. ¿Qué mecanismo utilizarías para cada elemento?
- **Contraseña:** hash/derivación de contraseñas con sal usando un algoritmo recomendado.
- **RFC e información financiera:** cifrado cuando los datos deban recuperarse legítimamente, además de permisos mínimos y auditoría.
- **Comunicación cliente-servidor:** TLS con una autoridad certificadora confiable y validación de identidad apropiada; `verify-full` cuando la configuración lo permita.
- **Claves criptográficas:** gestor de secretos o KMS, acceso restringido, rotación y respuesta ante exposición.
- **Respaldos:** cifrado, permisos mínimos, almacenamiento separado y pruebas controladas de recuperación.
- **Nombre y correo:** limitar acceso, clasificar los datos y aplicar minimización/retención conforme a su finalidad.

## Pregunta 3. ¿Cuál es el problema más crítico y por qué?
No existe una única respuesta para todos los escenarios. Considero especialmente crítico almacenar contraseñas en texto claro, porque una sola lectura no autorizada puede divulgar credenciales que quizá se reutilicen en otros sistemas. Las claves criptográficas expuestas también son críticas porque pueden permitir descifrar conjuntos completos de datos. La prioridad final debe considerar el impacto y el alcance de cada secreto.

## Pregunta 4. ¿Tener correctamente configurados usuarios y permisos elimina estos riesgos?
No. Los permisos son necesarios, pero no protegen por sí solos frente a una filtración de respaldos, una cuenta comprometida, secretos incluidos en scripts o tráfico sin protección. La seguridad requiere capas complementarias: mínimo privilegio, hash de contraseñas, cifrado, TLS con validación adecuada, protección de respaldos, gestión de claves y revisión de repositorios.

## Conclusión
El control de acceso es solo una parte de la seguridad de la base de datos. La organización debe proteger los datos almacenados, las comunicaciones, las credenciales, los respaldos y las claves con mecanismos específicos y complementarios.
