USE GrupoC;

INSERT IGNORE INTO Cliente(DNI, numero_cuenta)
SELECT
    CONCAT('DNI', LPAD(n, 8, '0')),
    CONCAT('ES', LPAD(n, 22, '0'))
FROM numeros
WHERE n <= 5000;

-- =========================
-- CLIENTES
-- =========================
