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
    END AS Estado
FROM Grada g
JOIN numeros n
WHERE
       (g.Nombre_Grada LIKE 'Fila %'       AND n.n <= 10)
    OR (g.Nombre_Grada LIKE '%VIP%'        AND n.n <= 200)
    OR (g.Nombre_Grada LIKE '%Palco%'      AND n.n <= 300)
    OR (g.Nombre_Grada LIKE '%Gallinero%'  AND n.n <= 400)
    OR (g.Nombre_Grada LIKE '%Pista%'      AND n.n <= 1200)
    OR (g.Nombre_Grada LIKE '%General%'    AND n.n <= 1500)
    OR (g.Nombre_Grada LIKE '%Fondo%'      AND n.n <= 1200)
    OR (g.Nombre_Grada LIKE '%Lateral%'    AND n.n <= 1000)
    OR (g.Nombre_Grada LIKE '%Tribuna%'    AND n.n <= 900)
    OR (g.Nombre_Grada LIKE '%Preferencia%' AND n.n <= 900)
    OR (g.Nombre_Grada LIKE '%Grada Alta%' AND n.n <= 800)
    OR (g.Nombre_Grada LIKE '%Grada Baja%' AND n.n <= 900)
    OR (g.Nombre_Grada LIKE '%Platea%'     AND n.n <= 500)
    OR (g.Nombre_Grada LIKE '%Anfiteatro%' AND n.n <= 450)
    OR (g.Nombre_Grada NOT LIKE 'Fila %'
        AND g.Nombre_Grada NOT LIKE '%VIP%'
        AND g.Nombre_Grada NOT LIKE '%Palco%'
        AND g.Nombre_Grada NOT LIKE '%Gallinero%'
        AND g.Nombre_Grada NOT LIKE '%Pista%'
        AND g.Nombre_Grada NOT LIKE '%General%'
        AND g.Nombre_Grada NOT LIKE '%Fondo%'
        AND g.Nombre_Grada NOT LIKE '%Lateral%'
        AND g.Nombre_Grada NOT LIKE '%Tribuna%'
        AND g.Nombre_Grada NOT LIKE '%Preferencia%'
        AND g.Nombre_Grada NOT LIKE '%Grada Alta%'
        AND g.Nombre_Grada NOT LIKE '%Grada Baja%'
        AND g.Nombre_Grada NOT LIKE '%Platea%'
        AND g.Nombre_Grada NOT LIKE '%Anfiteatro%'
        AND n.n <= 300);