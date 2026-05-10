USE GrupoC;

INSERT IGNORE INTO Oferta(Precio, Recinto, Fecha, Nombre_grada, Tipo)
SELECT
    GREATEST(
        CASE
            WHEN g.Nombre_Grada LIKE '%VIP%' THEN 120
            WHEN g.Nombre_Grada LIKE '%Palco%' THEN 100
            WHEN g.Nombre_Grada LIKE '%Tribuna%' THEN 85
            WHEN g.Nombre_Grada LIKE '%Preferencia%' THEN 75
            WHEN g.Nombre_Grada LIKE '%Pista%' THEN 70
            WHEN g.Nombre_Grada LIKE '%Platea%' THEN 65
            WHEN g.Nombre_Grada LIKE '%Lateral%' THEN 55
            WHEN g.Nombre_Grada LIKE '%Fondo%' THEN 45
            WHEN g.Nombre_Grada LIKE '%Anfiteatro%' THEN 40
            WHEN g.Nombre_Grada LIKE '%Gallinero%' THEN 25
            WHEN g.Nombre_Grada LIKE '%General%' THEN 30
            ELSE 35
        END
        +
        CASE u.Tipo
            WHEN 'Adulto' THEN 0
            WHEN 'Jubilado' THEN -15
            WHEN 'Infantil' THEN -20
            WHEN 'Parado' THEN -25
            WHEN 'Bebé' THEN -30
        END
        +
        (DAY(g.Fecha) % 10),
        5
    ) AS Precio,
    g.Recinto,
    g.Fecha,
    g.Nombre_Grada,
    u.Tipo
FROM Grada g
CROSS JOIN Usuario u;