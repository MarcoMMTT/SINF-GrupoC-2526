USE GrupoC;

INSERT IGNORE INTO Esta(Fecha, Recinto, Nombre_grada)
SELECT
    ev.Fecha,
    ev.Recinto,
    CONCAT('Grada ', g.n)
FROM Evento ev
JOIN numeros g
WHERE g.n <= 5;

-- =========================
-- ESTA
-- Cada evento tendrá 5 gradas
-- =========================

