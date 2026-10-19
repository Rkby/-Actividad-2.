

-- PRUEBA A
SET ROLE soporte;
SELECT * FROM public.v_clientes_soporte ORDER BY id;
RESET ROLE;

-- PRUEBA B
SET ROLE soporte;
SELECT * FROM public.clientes;


-- PRUEBA C
SET ROLE analista;
SELECT * FROM analitica.clientes;
RESET ROLE;

-- PRUEBA D
SET ROLE analista;
SELECT * FROM pii.mapa_cliente;


-- PRUEBA E
SET ROLE analista;
SELECT * FROM public.clientes;
