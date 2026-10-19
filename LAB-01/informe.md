# LAB-01 — Protección y privacidad de datos

**Materia:** Gestión de Seguridad y Desempeño de Bases de Datos  
**Unidad:** II — Seguridad, privacidad y control de acceso  
**Estudiante:** [Vitor Adrian Quintero Mata]  
**Fecha:** [18/10/2026]  
**Motor utilizado:** PostgreSQL 16 con pgAdmin 4

## 1. Objetivo

Aplicar técnicas de clasificación, enmascaramiento, seudonimización, anonimización, control de acceso y retención para reducir la exposición de datos personales. Se usaron únicamente registros ficticios.

## 2. Preparación

Se creó la tabla `public.clientes` con cinco registros ficticios. Para que la consulta de retención tuviera ejemplos que identificar, se cambió la fecha de alta de los registros 1 y 2 a una fecha de hace seis años. Este ajuste es solo de prueba y no elimina información.

**Evidencia:** `evidencias/01-clasificacion.pdf`

## 3. Actividad 1 — Clasificación de datos

| Campo | ¿Identifica directamente? | ¿Puede contribuir a identificar? | ¿Requiere protección? | Justificación |
|---|---|---|---|---|
| `id` | No por sí solo fuera del sistema | Sí, al relacionarlo con tablas u otros datos | Sí | Es un identificador persistente de un registro y permite vincular información. |
| `nombre` | Sí | Sí | Sí | Identifica directamente a una persona. |
| `correo` | Sí, en muchos casos | Sí | Sí | Puede asociarse directamente con la persona y sus cuentas. |
| `telefono` | Sí, en muchos casos | Sí | Sí | Puede localizar o identificar a su titular. |
| `rfc` | Sí o casi directamente | Sí | Sí | Es un identificador fiscal altamente vinculado con una persona. |
| `edad` | No | Sí | Sí, según uso y contexto | Puede ayudar a distinguir una persona cuando se combina con otros atributos. |
| `ciudad` | No | Sí | Sí, según contexto | Reduce el grupo de personas posibles al combinarse con otros campos. |
| `codigo_postal` | No | Sí, con frecuencia | Sí | Es más específico que una ciudad y puede facilitar la reidentificación. |
| `fecha_alta` | No | Sí, con otros atributos | Sí, según finalidad | Puede revelar cuándo se incorporó una persona y ayudar a distinguir registros. |

### Preguntas

**1. ¿Qué campos identifican directamente a una persona?**  
Principalmente nombre, correo, teléfono y RFC. El identificador `id` identifica el registro dentro de la base, pero no necesariamente revela por sí solo el nombre de la persona.

**2. ¿Qué campos no identifican por sí solos pero podrían contribuir a hacerlo?**  
La edad, ciudad, código postal y fecha de alta. El `id` también puede contribuir si se relaciona con una tabla que contenga la identidad.

**3. ¿Qué combinación de campos podría incrementar el riesgo de reidentificación?**  
Edad, ciudad, código postal y fecha de alta juntos pueden reducir mucho el grupo de personas posibles, aun cuando se eliminen el nombre y el RFC.

**4. ¿Todos los datos que deben protegerse son necesariamente datos personales sensibles desde el punto de vista jurídico?**  
No. Un dato personal puede requerir protección sin clasificarse jurídicamente como dato personal sensible. El nivel de protección debe considerar el tipo de dato, su uso, el contexto y el daño que causaría una exposición.

## 4. Actividad 2 — Enmascaramiento

Se creó la vista `public.v_clientes_soporte`, que muestra el nombre y el identificador del cliente, pero oculta parcialmente el correo, teléfono y RFC. Se otorgó al rol `soporte` permiso de lectura sobre la vista y se revocó el acceso directo a `public.clientes`.

### Preguntas

**1. ¿Qué información continúa existiendo en la tabla original?**  
Los valores completos del correo, teléfono y RFC permanecen en la tabla original. La vista no los modifica ni los borra.

**2. ¿Qué información puede visualizar el usuario `soporte`?**  
Puede consultar el identificador, nombre y versiones enmascaradas del correo, teléfono y RFC mediante la vista autorizada.

**3. ¿Por qué no es suficiente ocultar los datos únicamente en la aplicación?**  
Porque otro cliente o consulta podría acceder a la tabla original si tiene permisos. La base de datos debe aplicar los permisos y limitar las columnas o vistas disponibles.

**4. ¿Qué ocurriría si `soporte` tuviera acceso directo a `clientes`?**  
Podría consultar los valores originales y el enmascaramiento de la vista dejaría de ser una barrera suficiente.

**Resultado esperado:** la vista muestra los datos parcialmente ocultos; la consulta directa a `public.clientes` como `soporte` debe ser rechazada.

**Evidencia:** `evidencias/02-enmascaramiento.pdf`

## 5. Actividad 3 — Seudonimización

Se crearon los esquemas `pii` y `analitica`. La tabla `pii.mapa_cliente` relaciona cada cliente con un token UUID aleatorio. La tabla `analitica.clientes` conserva el token y algunos atributos útiles para análisis, pero no incluye nombre, correo, teléfono ni RFC.

Los tokens se generaron con `gen_random_uuid()` mediante la extensión `pgcrypto`.

### Actividad 4 — Separación de funciones

Se creó el rol `analista` y se le concedió lectura de `analitica.clientes`. No se le concedió acceso al mapa de correspondencia ni a los datos originales. La tabla de correspondencia debe permanecer restringida a personal autorizado que realmente necesite recuperar la relación con la identidad.

### Preguntas de separación de funciones

**1. ¿Qué ocurriría si `analista` pudiera consultar también `pii.mapa_cliente`?**  
Podría relacionar los tokens con los clientes originales, reduciendo la protección que ofrece la seudonimización.

**2. ¿Qué principio de seguridad se aplica al separar ambos accesos?**  
El principio de mínimo privilegio y la separación de funciones: cada rol recibe solo los permisos necesarios para su trabajo.

**3. ¿Por qué la seudonimización no equivale a anonimización?**  
Porque existe un mapa que permite volver a asociar el token con el registro original. Si alguien accede al mapa, la identidad puede recuperarse.

**4. ¿Qué información permite volver a relacionar el token con una persona?**  
La tabla `pii.mapa_cliente`, que conecta el token UUID con `cliente_id`, y la tabla original `public.clientes`.

**Evidencia:** `evidencias/03-seudonimizacion.pdf`

## 6. Actividad 5 — Anonimización y agregación

Se generalizó la edad en rangos y el código postal en regiones. Después se combinaron ambos atributos y se añadió el filtro `HAVING COUNT(*) >= 5`, que solo muestra grupos con cinco o más registros. Como el conjunto de prueba contiene solo cinco clientes y se combinan atributos, es posible que la consulta filtrada no muestre filas; esto es esperado porque los grupos pequeños se suprimen.

### Análisis del riesgo de reidentificación

**1. ¿Qué identificadores directos fueron eliminados?**  
En el conjunto analítico se omitieron nombre, correo, teléfono y RFC. Para estadísticas agregadas tampoco se necesita mostrar el identificador de cliente.

**2. ¿Qué cuasi-identificadores permanecen?**  
Edad o rango de edad, ciudad, región derivada del código postal, código postal y fecha de alta, según la consulta utilizada.

**3. ¿Qué combinaciones de atributos podrían reducir el anonimato?**  
Un rango de edad junto con la ciudad, región postal y fecha de alta podría identificar indirectamente a una persona si el grupo es pequeño.

**4. ¿Qué sucede cuando un grupo contiene pocos registros?**  
Aumenta el riesgo de identificar a una persona por sus características. La consulta con `HAVING COUNT(*) >= 5` suprime esos grupos.

**5. ¿Qué atributos deberían generalizarse?**  
La edad puede transformarse en rangos; el código postal puede reducirse a una región más amplia; la fecha exacta puede omitirse o agruparse por periodos.

**6. ¿Qué información debería suprimirse?**  
Los identificadores directos y los resultados de grupos demasiado pequeños, así como atributos cuyo detalle no sea necesario para el objetivo estadístico.

**7. ¿Es correcto afirmar que el conjunto de datos es 100 % anónimo? ¿Por qué?**  
No. La combinación de atributos y la existencia de información externa pueden permitir la reidentificación. La generalización y la supresión reducen el riesgo, pero no garantizan anonimato absoluto.

### Reto: cambio, motivo y resultado

**Cambio realizado:** para una consulta adicional se generalizó la edad en rangos más amplios (`18-45` y `46+`) y se redujo la región al primer dígito del código postal. Se conservó el umbral mínimo de cinco registros.

**Motivo:** disminuir el detalle de los atributos y dificultar que un registro se distinga de los demás.

**Resultado esperado:** con solo cinco filas de prueba, la consulta puede seguir sin devolver grupos que alcancen el umbral de cinco. En un conjunto mayor, los grupos suficientemente grandes sí podrían aparecer.

**Riesgo que se pretende reducir:** la identificación de personas a partir de combinaciones de edad y ubicación.

**Evidencia:** `evidencias/04-anonimizacion.pdf`

## 7. Actividad 7 — Retención de datos

Se utilizó una consulta para identificar las filas cuya fecha de alta tiene más de cinco años. En el script de preparación, los registros ficticios 1 y 2 se marcaron con una antigüedad de seis años para mostrar cómo se identifican. No se ejecutó ningún `DELETE`.

**Criterio:** cinco años es el periodo didáctico indicado para esta práctica; en una organización real debe definirse según la finalidad, las necesidades operativas y las obligaciones legales o contractuales aplicables.

**¿Qué registros serían afectados?**  
Los registros que devuelve la consulta `05-retencion.sql`; en esta prueba, los registros ficticios 1 y 2.

**¿Qué aprobación debería existir antes de eliminar información?**  
Aprobación del responsable de los datos y validación de las áreas de cumplimiento o legal cuando corresponda.

**¿Qué respaldo debería existir?**  
Una copia de seguridad verificada y un procedimiento probado para restaurar la información antes de autorizar una eliminación.

**¿Qué evidencia debería conservarse?**  
La autorización, la fecha de ejecución, el criterio aplicado, los registros afectados, el responsable y el resultado de la operación.

**¿Cómo recuperar información eliminada accidentalmente?**  
Aplicando el procedimiento de recuperación validado desde un respaldo o punto de recuperación disponible, y comprobando la integridad de los datos restaurados.

**Evidencia:** `evidencias/05-retencion.pdf`

## 8. Preguntas de reflexión

**1. ¿Cuál es la diferencia entre enmascaramiento y seudonimización?**  
El enmascaramiento cambia lo que se muestra, ocultando parte del valor original. La seudonimización sustituye la identidad directa por un token que puede volver a relacionarse con el original mediante un mapa protegido.

**2. ¿Por qué la seudonimización no significa anonimización?**  
Porque el mapa de correspondencia puede permitir recuperar la identidad. Además, otros atributos pueden ayudar a reidentificar a la persona.

**3. ¿Por qué eliminar nombre y RFC no garantiza que un conjunto de datos sea anónimo?**  
Porque edad, ubicación, código postal y fechas combinadas pueden distinguir a una persona, especialmente en grupos pequeños.

**4. ¿Qué función tienen los cuasi-identificadores?**  
Son atributos que, aunque no identifiquen directamente por sí solos, pueden contribuir a identificar a una persona al combinarlos con otros datos.

**5. ¿Por qué es importante separar el mapa de seudonimización?**  
Para que quienes analizan los datos no puedan vincularlos fácilmente con las identidades reales. El mapa debe tener permisos más restrictivos.

**6. ¿Qué principio de seguridad se aplica al impedir que el analista acceda al mapa?**  
Mínimo privilegio y separación de funciones.

**7. ¿Por qué una vista puede ser preferible a entregar acceso directo a la tabla?**  
Porque permite mostrar solo las columnas necesarias y enmascarar valores sin exponer directamente la tabla original.

**8. ¿Qué diferencia existe entre proteger un dato para visualización y protegerlo contra acceso no autorizado?**  
Ocultarlo en la pantalla solo cambia la presentación. Para evitar accesos no autorizados se necesitan permisos y controles aplicados en la base de datos y en el sistema completo.

**9. ¿Por qué la retención forma parte de la protección de datos?**  
Porque guardar información más tiempo del necesario aumenta el volumen de datos expuestos ante un incidente y puede incumplir la finalidad establecida.

**10. ¿Qué riesgo existe si una organización conserva información indefinidamente?**  
Puede aumentar el impacto de una filtración, mantener información que ya no es necesaria y dificultar el cumplimiento de políticas de conservación y eliminación.

## 9. Conclusiones

Para el área de soporte utilizaría una vista con enmascaramiento y permisos limitados, ya que necesita atender consultas sin conocer todos los datos personales. Para analítica emplearía seudonimización y separaría el mapa de correspondencia para evitar que el analista identifique directamente a los clientes. Para publicar estadísticas utilizaría agregación, generalización y supresión de grupos pequeños, evaluando también los posibles cuasi-identificadores.

Ninguna técnica sustituye al control de acceso: incluso los datos enmascarados o agregados necesitan protección contra consultas y usos no autorizados. La protección efectiva requiere combinar controles técnicos, permisos mínimos, revisión del riesgo y una política de retención documentada.

## 10. Lista final de verificación

- [ ] Se ejecutaron los scripts SQL en PostgreSQL.
- [ ] Se guardaron evidencias reales de cada actividad.
- [ ] Se comprobó que `soporte` puede consultar la vista y no la tabla original.
- [ ] Se comprobó que `analista` puede consultar la tabla analítica y no el mapa ni los datos originales.
- [ ] Se documentó el resultado real de la consulta de anonimización.
- [ ] Se documentó la consulta de retención sin ejecutar `DELETE`.
- [ ] Se actualizó el nombre, fecha y evidencias de este informe.
- [ ] Se subieron los archivos al repositorio GitLab asignado.
