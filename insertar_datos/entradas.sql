USE GrupoC;

INSERT IGNORE INTO Entrada(Fecha, Recinto, Nombre_grada, Localidad, Estado)
SELECT
    g.Fecha,
    g.Recinto,
    g.Nombre_Grada,
    CONCAT('L', LPAD(n.n, 4, '0')),
    CASE
        WHEN n.n % 97 = 0 THEN 'deteriorado'
        ELSE 'libre'
    END
FROM Grada g
JOIN numeros n
WHERE n.n <= 100;

-- =========================
-- ENTRADAS
-- 100 localidades por grada de cada evento
-- =========================
