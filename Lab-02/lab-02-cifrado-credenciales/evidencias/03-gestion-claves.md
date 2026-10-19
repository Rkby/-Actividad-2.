# Evidencia 03 — Gestión de claves

## Objetivo
Identificar el riesgo de incluir una clave criptográfica dentro de consultas, scripts o archivos del repositorio.

## Comandos o procedimiento
Se revisó el ejemplo de cifrado y descifrado simétrico del archivo `sql/02-cifrado-datos.sql`. La clave del script es explícitamente ficticia y solo se usa para reproducir la práctica.

## Resultado obtenido
El ejemplo permite cifrar y descifrar el RFC ficticio, pero muestra que una clave escrita directamente en el SQL puede quedar expuesta si se comparte el archivo, el historial de Git, una captura, un registro o una copia de seguridad.

## Análisis
En sistemas reales, las claves no deben guardarse junto a los datos protegidos ni incrustarse en código. Deben gestionarse por un mecanismo específico, con acceso limitado, rotación, respaldo protegido, revocación y un procedimiento para responder a una filtración. Una clave expuesta debe considerarse comprometida.

## Conclusión
Los ejemplos del laboratorio usan datos y claves ficticios. En producción, la clave debe entregarse a la aplicación mediante un gestor de secretos o un mecanismo protegido apropiado para la arquitectura, sin incorporarla al repositorio.
