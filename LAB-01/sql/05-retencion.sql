-- LAB-01 | Actividad 7: Identificar registros con más de cinco años
-- Consulta solo de lectura. NO ejecutar DELETE en la tabla principal.
SELECT id, nombre, fecha_alta
FROM public.clientes
WHERE fecha_alta < CURRENT_DATE - INTERVAL '5 years'
ORDER BY fecha_alta;
