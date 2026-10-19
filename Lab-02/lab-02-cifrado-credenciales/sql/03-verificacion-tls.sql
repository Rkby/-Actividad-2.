-- LAB-02 

--***********************
SHOW ssl;

---------------*************
SHOW ssl_min_protocol_version;

--*******
SHOW port;

-- **********
SHOW listen_addresses;

-- **********
SELECT inet_client_addr() AS direccion_cliente,
       inet_client_port() AS puerto_cliente;

-----*******
SELECT ssl, version, cipher
FROM pg_stat_ssl
WHERE pid = pg_backend_pid();

------*****