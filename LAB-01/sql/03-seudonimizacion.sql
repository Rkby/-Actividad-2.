----------------------------------------

CREATE SCHEMA IF NOT EXISTS pii;
CREATE SCHEMA IF NOT EXISTS analitica;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS pii.mapa_cliente (
    token UUID PRIMARY KEY,
    cliente_id BIGINT UNIQUE REFERENCES public.clientes(id)
);

----------------------------------------------------------
INSERT INTO pii.mapa_cliente (token, cliente_id)
SELECT gen_random_uuid(), c.id
FROM public.clientes AS c
WHERE NOT EXISTS (
    SELECT 1 FROM pii.mapa_cliente AS m WHERE m.cliente_id = c.id
);
----------------------------------------------------------------
CREATE TABLE analitica.clientes AS
SELECT
    m.token AS cliente_token,
    c.edad,
    c.ciudad,
    c.codigo_postal,
    c.fecha_alta
FROM pii.mapa_cliente AS m
JOIN public.clientes AS c ON c.id = m.cliente_id;

-----------------------------------------------------------------
SELECT * FROM pii.mapa_cliente ORDER BY cliente_id;
SELECT * FROM analitica.clientes ORDER BY cliente_token;
