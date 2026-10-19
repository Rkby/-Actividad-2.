-- LAB-01 | Actividad 5: Generalización, agregación y supresión

-- 1) Generalizar edad por rangos.
SELECT
    CASE
        WHEN edad BETWEEN 18 AND 30 THEN '18-30'
        WHEN edad BETWEEN 31 AND 45 THEN '31-45'
        ELSE '46+'
    END AS rango_edad,
    COUNT(*) AS total
FROM public.clientes
GROUP BY 1
ORDER BY 1;

-- 2) Generalizar región usando los dos primeros dígitos del código postal.
SELECT LEFT(codigo_postal, 2) AS region, COUNT(*) AS total
FROM public.clientes
GROUP BY 1
ORDER BY 1;

-- 3) Combinar atributos: edad generalizada y región.
SELECT
    CASE
        WHEN edad BETWEEN 18 AND 30 THEN '18-30'
        WHEN edad BETWEEN 31 AND 45 THEN '31-45'
        ELSE '46+'
    END AS rango_edad,
    LEFT(codigo_postal, 2) AS region,
    COUNT(*) AS total
FROM public.clientes
GROUP BY 1, 2
ORDER BY 1, 2;

-- 4) Suprimir grupos con menos de cinco registros. Con cinco filas de ejemplo
-- y atributos combinados, es posible que no se muestre ningún grupo.
SELECT
    CASE
        WHEN edad BETWEEN 18 AND 30 THEN '18-30'
        WHEN edad BETWEEN 31 AND 45 THEN '31-45'
        ELSE '46+'
    END AS rango_edad,
    LEFT(codigo_postal, 2) AS region,
    COUNT(*) AS total
FROM public.clientes
GROUP BY 1, 2
HAVING COUNT(*) >= 5
ORDER BY 1, 2;

-- Reto: generalizar aún más. Se agrupan edades en tramos más amplios y se usa
-- solo el primer dígito del código postal. Se mantiene el umbral de cinco.
SELECT
    CASE WHEN edad < 46 THEN '18-45' ELSE '46+' END AS rango_edad,
    LEFT(codigo_postal, 1) AS region_amplia,
    COUNT(*) AS total
FROM public.clientes
GROUP BY 1, 2
HAVING COUNT(*) >= 5
ORDER BY 1, 2;
