------------------

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'soporte') THEN
        CREATE ROLE soporte NOLOGIN;
    END IF;
END
$$;

CREATE OR REPLACE VIEW public.v_clientes_soporte AS
SELECT
    id,
    nombre,
    CONCAT(
        LEFT(correo, 2),
        '*****',
        SUBSTRING(correo FROM POSITION('@' IN correo))
    ) AS correo,
    CONCAT('******', RIGHT(telefono, 4)) AS telefono,
    CONCAT('*********', RIGHT(rfc, 4)) AS rfc
FROM public.clientes;

GRANT USAGE ON SCHEMA public TO soporte;
GRANT SELECT ON public.v_clientes_soporte TO soporte;
REVOKE ALL ON public.clientes FROM soporte;

---------------------------------------------
SELECT * FROM public.v_clientes_soporte ORDER BY id;
