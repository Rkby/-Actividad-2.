-- LAB-01 | Actividad 4: Separación de funciones

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'analista') THEN
        CREATE ROLE analista NOLOGIN;
    END IF;
END
$$;

GRANT USAGE ON SCHEMA analitica TO analista;
GRANT SELECT ON analitica.clientes TO analista;

-- Defensa explícita: el analista no debe consultar las tablas de identificación.
REVOKE ALL ON SCHEMA pii FROM analista;
REVOKE ALL ON TABLE pii.mapa_cliente FROM analista;
REVOKE ALL ON TABLE public.clientes FROM analista;

-- Ver los permisos otorgados (la evidencia de acceso denegado se obtiene con 06-pruebas-permisos.sql).
SELECT grantee, table_schema, table_name, privilege_type
FROM information_schema.role_table_grants
WHERE grantee IN ('soporte', 'analista')
ORDER BY grantee, table_schema, table_name, privilege_type;
