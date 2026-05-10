USE GrupoC;

INSERT IGNORE INTO Entrada(Fecha, Recinto, Nombre_grada, Localidad, Estado)
SELECT
    es.Fecha,
    es.Recinto,
    es.Nombre_grada,
    CONCAT('L', LPAD(n.n, 4, '0')),
    CASE
        WHEN n.n % 97 = 0 THEN 'deteriorado'
        ELSE 'libre'
    END
FROM Esta es
JOIN numeros n
WHERE n.n <= 100;

-- =========================
-- ENTRADAS
-- 100 localidades por grada de cada evento
-- =========================
