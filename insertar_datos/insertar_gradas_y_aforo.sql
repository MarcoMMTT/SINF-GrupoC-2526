USE GrupoC;

INSERT IGNORE INTO Grada(Nombre_Grada, Fecha, Recinto)
SELECT
    CASE
        WHEN r.tipo_recinto = 'estadio' THEN
            CASE g.n
                WHEN 1 THEN 'Tribuna Principal'
                WHEN 2 THEN 'Preferencia'
                WHEN 3 THEN 'Fondo Norte'
                WHEN 4 THEN 'Fondo Sur'
                WHEN 5 THEN 'Lateral Este'
                WHEN 6 THEN 'Lateral Oeste'
                WHEN 7 THEN 'Palco VIP'
                WHEN 8 THEN 'Grada Animación'
            END

        WHEN r.tipo_recinto = 'pabellon' THEN
            CASE g.n
                WHEN 1 THEN 'Pista'
                WHEN 2 THEN 'Grada Baja'
                WHEN 3 THEN 'Grada Alta'
                WHEN 4 THEN 'Fondo Norte'
                WHEN 5 THEN 'Fondo Sur'
                WHEN 6 THEN 'Zona VIP'
            END

        WHEN r.tipo_recinto = 'teatro' THEN
            CASE g.n
                WHEN 1 THEN 'Patio de Butacas'
                WHEN 2 THEN 'Platea'
                WHEN 3 THEN 'Anfiteatro'
                WHEN 4 THEN 'Palcos'
                WHEN 5 THEN 'Gallinero'
            END

        WHEN r.tipo_recinto = 'auditorio' THEN
            CASE g.n
                WHEN 1 THEN 'Platea Central'
                WHEN 2 THEN 'Platea Lateral'
                WHEN 3 THEN 'Anfiteatro'
                WHEN 4 THEN 'Palcos'
                WHEN 5 THEN 'Zona Coral'
            END

        WHEN r.tipo_recinto = 'feria' THEN
            CASE g.n
                WHEN 1 THEN 'Zona General'
                WHEN 2 THEN 'Zona Premium'
                WHEN 3 THEN 'Zona Expositores'
                WHEN 4 THEN 'Sala Conferencias'
                WHEN 5 THEN 'Zona VIP'
            END

        WHEN r.tipo_recinto = 'cine' THEN
            CASE g.n
                WHEN 1 THEN 'Fila A'
                WHEN 2 THEN 'Fila B'
                WHEN 3 THEN 'Fila C'
                WHEN 4 THEN 'Fila D'
                WHEN 5 THEN 'Fila E'
                WHEN 6 THEN 'Fila F'
                WHEN 7 THEN 'Fila G'
                WHEN 8 THEN 'Fila H'
                WHEN 9 THEN 'Fila I'
                WHEN 10 THEN 'Fila J'
            END
    END AS Nombre_Grada,
    e.Fecha,
    e.Recinto
FROM Evento e
JOIN recintos_demo r
  ON r.nombre = e.Recinto
JOIN numeros g
WHERE
       (r.tipo_recinto = 'estadio'   AND g.n <= 8)
    OR (r.tipo_recinto = 'pabellon'  AND g.n <= 6)
    OR (r.tipo_recinto = 'teatro'    AND g.n <= 5)
    OR (r.tipo_recinto = 'auditorio' AND g.n <= 5)
    OR (r.tipo_recinto = 'feria'     AND g.n <= 5)
    OR (r.tipo_recinto = 'cine'      AND g.n <= 10);