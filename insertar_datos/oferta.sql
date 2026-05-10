INSERT IGNORE INTO Oferta(Precio, Recinto, Fecha, Nombre_grada, Tipo)
SELECT
    CASE u.Tipo
        WHEN 'Adulto' THEN 50 + (g.Huecos % 30)
        WHEN 'Jubilado' THEN 30 + (g.Huecos % 20)
        WHEN 'Infantil' THEN 25 + (g.Huecos % 15)
        WHEN 'Parado' THEN 20 + (g.Huecos % 15)
        WHEN 'Bebé' THEN 5
    END AS Precio,
    es.Recinto,
    es.Fecha,
    es.Nombre_grada,
    u.Tipo
FROM Esta es
JOIN Aforo g
  ON g.Nombre_grada = es.Nombre_grada
CROSS JOIN Usuario u;

-- =========================
-- OFERTA / PRECIOS
-- Precio por evento, grada y tipo de usuario
-- =========================
