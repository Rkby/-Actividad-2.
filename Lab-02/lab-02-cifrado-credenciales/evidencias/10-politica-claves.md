# Evidencia 10 — Política mínima de protección de claves

## Objetivo
Definir reglas mínimas para generar, almacenar, utilizar y retirar claves criptográficas.

## Política
1. **Generación:** crear claves mediante generadores criptográficos confiables y con longitud/algoritmo aprobados por la organización.
2. **Almacenamiento:** mantener las claves en un gestor de secretos, KMS o servicio seguro equivalente, separadas de los datos cifrados y del código.
3. **Acceso:** otorgar acceso únicamente a identidades que lo necesiten, aplicar mínimo privilegio y registrar accesos relevantes.
4. **Uso:** evitar escribir claves reales en scripts SQL, repositorios, logs, documentación, capturas o tickets.
5. **Rotación:** establecer periodos de revisión y rotar claves según la política, el riesgo y el ciclo de vida de la información.
6. **Respaldo y recuperación:** respaldar las claves de manera cifrada y restringida; probar un procedimiento de recuperación controlado.
7. **Revocación:** retirar o revocar las claves al terminar su uso, cuando cambien los permisos o al abandonar un servicio/puesto.
8. **Exposición accidental:** considerar comprometida una clave publicada, restringir el acceso, rotarla/revocarla y evaluar qué datos pudieron quedar expuestos.
9. **Eliminación:** retirar claves obsoletas mediante un procedimiento documentado que contemple las necesidades legítimas de descifrado y retención.

## Resultado y análisis
La política cubre generación, almacenamiento, acceso, rotación, respaldo, revocación, exposición accidental y eliminación. La robustez del cifrado no es suficiente si una clave queda disponible para personas no autorizadas o se pierde sin posibilidad de recuperación.

## Conclusión
La gestión de claves es parte esencial del ciclo de vida de la información protegida y debe tener responsables, controles y procedimientos verificables.
