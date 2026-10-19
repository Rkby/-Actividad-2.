-- LAB-02 | Actividad 2

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS public.clientes_protegidos (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    rfc_cifrado BYTEA NOT NULL
);

--************************************************************************
INSERT INTO public.clientes_protegidos (nombre, rfc_cifrado)
SELECT 'Ana López', pgp_sym_encrypt('LOPA900101ABC', 'LAB-ONLY-KEY-NOT-FOR-PRODUCTION')
WHERE NOT EXISTS (
    SELECT 1 FROM public.clientes_protegidos WHERE nombre = 'Ana López'
);

----***********************************************************************
SELECT id, nombre, encode(rfc_cifrado, 'hex') AS rfc_cifrado_hex
FROM public.clientes_protegidos
ORDER BY id;

----*********************************
SELECT
    id,
    nombre,
    pgp_sym_decrypt(
        rfc_cifrado,
        'LAB-ONLY-KEY-NOT-FOR-PRODUCTION'
    ) AS rfc_descifrado
FROM public.clientes_protegidos
ORDER BY id;

---*****************
