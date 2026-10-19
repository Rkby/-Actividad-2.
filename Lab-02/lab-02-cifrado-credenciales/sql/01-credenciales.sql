-- LAB-02 | Actividad 1: protección de credenciales
---*****************************************

CREATE EXTENSION IF NOT EXISTS pgcrypto;

--************************************************
CREATE TABLE IF NOT EXISTS public.usuarios_insegura (
    id BIGSERIAL PRIMARY KEY,
    usuario VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL
);

INSERT INTO public.usuarios_insegura (usuario, password)
VALUES ('juan', 'Password123')
ON CONFLICT (usuario) DO NOTHING;

*----------*---------------------------------------------------
SELECT id, usuario, password
FROM public.usuarios_insegura
WHERE usuario = 'juan';

----------------------------------------------------
SELECT crypt('Password123', gen_salt('bf')) AS hash_demo_1;

SELECT crypt('Password123', gen_salt('bf')) AS hash_demo_2;

------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.usuarios_segura (
    id BIGSERIAL PRIMARY KEY,
    usuario VARCHAR(50) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL
);

INSERT INTO public.usuarios_segura (usuario, password_hash)
VALUES ('juan', crypt('Password123', gen_salt('bf')))
ON CONFLICT (usuario) DO NOTHING;

-------------------------------------------------------
SELECT id, usuario, password_hash
FROM public.usuarios_segura
WHERE usuario = 'juan';
----------------------------
SELECT
    usuario,
    password_hash = crypt('Password123', password_hash) AS contrasena_correcta,
    password_hash = crypt('OtraPassword', password_hash) AS contrasena_incorrecta
FROM public.usuarios_segura
WHERE usuario = 'juan';
