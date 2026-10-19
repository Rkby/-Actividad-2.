# LAB-02 — Cifrado, credenciales y comunicaciones seguras

**Motor:** PostgreSQL 16 · **Base:** utiliza la del LAB-01 · **Datos:** exclusivamente ficticios.

## 1. Introducción
Esta práctica aborda la protección de credenciales, el cifrado de información sensible, la protección de comunicaciones cliente-servidor y la gestión segura de claves. Una base de datos no queda protegida únicamente por configurar usuarios y permisos: también es necesario proteger los datos almacenados, el tráfico, los respaldos y los secretos.

## 2. Protección de credenciales
Almacenar contraseñas en texto claro permite que alguien con permisos de lectura obtenga directamente la credencial. El hash con sal proporciona una representación que permite verificar la contraseña sin recuperarla directamente. En el script se usa `pgcrypto` con `crypt()` y `gen_salt('bf')` como demostración.

**Resultados que deben comprobarse:** los hashes de dos llamadas con sal generada por separado son distintos; la verificación de `Password123` debe devolver `true`; una contraseña incorrecta debe devolver `false`.

## 3. Protección de datos sensibles
Se cifra un RFC ficticio con `pgp_sym_encrypt()` y se recupera con `pgp_sym_decrypt()`. El valor cifrado se almacena como `BYTEA`. A diferencia del hash de contraseña, el cifrado es reversible cuando se dispone de la clave correcta. La clave que aparece en el ejemplo es ficticia, exclusiva para el laboratorio y no debe reutilizarse en ningún sistema real.

## 4. TLS
TLS protege los datos mientras se transmiten entre cliente y servidor y contribuye a la confidencialidad, integridad y, cuando se validan correctamente los certificados, autenticación del servidor. Se incluye un script para revisar `SHOW ssl`, el protocolo mínimo configurado y la conexión actual mediante `pg_stat_ssl`.

**Completar antes de entregar:** registrar en `evidencias/04-tls.md` los valores reales devueltos por tu instancia: `ssl`, `version`, `cipher`, puerto y `listen_addresses`. No asumir que TLS está activo sin comprobar la sesión. `sslmode=require` solicita TLS, mientras que `verify-full` también comprueba la CA y la coincidencia del nombre del servidor con el certificado.

## 5. Gestión de claves
Una clave incluida en SQL puede filtrarse por el repositorio, su historial, capturas, registros o copias de seguridad. En un entorno productivo debe almacenarse en un gestor de secretos/KMS o mecanismo seguro equivalente, con acceso limitado, rotación, respaldo protegido y procedimiento de revocación. Un repositorio privado no es un almacén de secretos.

## 6. Resultados
- Se prepara una demostración de la diferencia entre contraseña en texto claro y hash protegido.
- Se prepara una demostración de cifrado y descifrado simétrico para un RFC ficticio.
- Se incluyen consultas para verificar el estado TLS real de PostgreSQL.
- Se documenta una política mínima de gestión de claves y un análisis de riesgos.

**Pendiente de ejecución local:** anotar los resultados reales de PostgreSQL y verificar que todas las consultas funcionan en el entorno utilizado. No presentar estos scripts como pruebas ejecutadas hasta obtener y revisar sus resultados.

## 7. Problemas encontrados
Completar con cualquier incidencia real durante la instalación, ejecución de scripts o verificación TLS. Si no hubo incidencias, escribir: “No se presentaron problemas técnicos durante la ejecución” únicamente después de completar las pruebas.

## 8. Conclusiones
Hash y cifrado son mecanismos distintos: la contraseña se protege mediante derivación/hash y un dato que necesita recuperarse puede cifrarse. TLS protege el tránsito, mientras que el cifrado de columnas y respaldos protege información almacenada. Estas medidas no sustituyen permisos mínimos, auditoría ni una correcta gestión de claves.

## Preguntas de reflexión

1. **¿Por qué una contraseña no debe almacenarse como texto claro?** Porque cualquiera que lea la tabla puede obtenerla directamente; una filtración divulgaría credenciales utilizables.
2. **¿Por qué un hash no es equivalente a un cifrado?** El hash/derivación está diseñado para verificar sin recuperar directamente el original; el cifrado es reversible con la clave adecuada.
3. **¿Por qué cifrar una columna no sustituye el control de acceso?** Porque siguen siendo necesarios permisos, restricciones y auditoría; además, usuarios o servicios autorizados a descifrar pueden acceder al dato.
4. **¿Por qué TLS no sustituye la autorización de PostgreSQL?** TLS protege la conexión; no decide qué tablas puede consultar cada usuario.
5. **¿Qué ocurre si se pierde una clave utilizada para cifrar información?** Se puede perder el acceso a los datos cifrados si no existe una copia segura recuperable.
6. **¿Qué ocurre si una clave se publica accidentalmente en GitLab?** Debe considerarse comprometida, restringirse el acceso, revocarse o rotarse y evaluarse la información que pudo quedar expuesta. Borrar el archivo no necesariamente elimina la clave del historial.
7. **¿Por qué un repositorio privado no es un almacén de secretos?** Porque miembros, integraciones, copias o el historial pueden exponerlos; el acceso privado no hace seguro guardar secretos en código.
8. **¿Qué diferencia hay entre proteger información almacenada y protegerla durante su transmisión?** El cifrado en reposo protege archivos/datos almacenados; TLS protege la comunicación entre cliente y servidor.
9. **¿Por qué la gestión de claves es tan importante como el algoritmo?** Porque una clave expuesta puede anular la protección y una clave perdida puede volver irrecuperables los datos.
10. **¿Qué medida adicional usarías para respaldos?** Cifrar los respaldos, limitar quién accede, almacenarlos de forma separada y probar periódicamente su recuperación.

## Estructura
- `sql/01-credenciales.sql`
- `sql/02-cifrado-datos.sql`
- `sql/03-verificacion-tls.sql`
- `evidencias/01-credenciales.md`
- `evidencias/02-cifrado-datos.md`
- `evidencias/03-gestion-claves.md`
- `evidencias/04-tls.md`
- `evidencias/07-comparacion.md`
- `evidencias/08-analisis-escenario.md`
- `evidencias/10-politica-claves.md`

## Orden rápido de ejecución
1. Abrir la base del LAB-01 en pgAdmin.
2. Ejecutar `01-credenciales.sql` por bloques y verificar cada resultado importante.
3. Ejecutar `02-cifrado-datos.sql` por bloques; comprobar el valor cifrado y el descifrado.
4. Ejecutar cada consulta de `03-verificacion-tls.sql` por separado y completar `evidencias/04-tls.md`.
5. Revisar los archivos, insertar capturas solo cuando aporten evidencia y confirmar que no hay secretos reales.

> En pgAdmin, si ejecutas varios `SELECT` a la vez, el panel puede mostrar solamente el resultado de la última consulta. Selecciona y ejecuta cada bloque de consulta por separado para tomar evidencias claras.

## Git: ejemplo de commits
Desde la raíz del repositorio personal, después de revisar los archivos:

```bash
git add unidad-02/lab-02-cifrado-credenciales/sql/01-credenciales.sql
git commit -m "feat: implementa proteccion de credenciales"
git add unidad-02/lab-02-cifrado-credenciales/sql/02-cifrado-datos.sql
git commit -m "feat: implementa cifrado de datos sensibles"
git add unidad-02/lab-02-cifrado-credenciales/sql/03-verificacion-tls.sql unidad-02/lab-02-cifrado-credenciales/evidencias
git commit -m "docs: documenta cifrado y verificacion TLS"
```

Los comandos de Git asumen que la carpeta está en esa ruta relativa y que el repositorio ya fue clonado y configurado.
