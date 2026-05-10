USE GrupoC;


INSERT IGNORE INTO Grada(Nombre_Grada, Fecha, Recinto)
SELECT
    CONCAT('Grada ', g.n),
    e.Fecha,
    e.Recinto
FROM Evento e
JOIN numeros g
WHERE g.n <= 5;
-- =========================
-- GRADA
-- =========================

