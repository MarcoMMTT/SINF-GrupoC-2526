USE GrupoC;

INSERT IGNORE INTO Grada(Nombre_Grada)
SELECT CONCAT('Grada ', n)
FROM numeros
WHERE n <= 20;

INSERT IGNORE INTO Aforo(Huecos, Nombre_grada)
SELECT 
    1000 + n,
    CONCAT('Grada ', n)
FROM numeros
WHERE n <= 20;
-- =========================
-- GRADAS Y AFORO
-- OJO: como Huecos es PK, cada aforo debe ser distinto
-- =========================

