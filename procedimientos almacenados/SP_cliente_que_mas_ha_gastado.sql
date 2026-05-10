USE GrupoC;

DROP PROCEDURE IF EXISTS ClienteQueMasHaGastado;

DELIMITER //

CREATE PROCEDURE ClienteQueMasHaGastado()
BEGIN

    -- Clientes que más dinero han gastado (incluyendo empates)

    SELECT
        c.DNI,
        c.numero_cuenta,
        COUNT(*) AS Entradas_compradas,
        SUM(o.Precio) AS Total_gastado
    FROM Cliente c
    INNER JOIN Vendida v
        ON c.DNI = v.DNI
    INNER JOIN Oferta o
        ON v.Recinto = o.Recinto
       AND v.Fecha = o.Fecha
       AND v.Nombre_grada = o.Nombre_grada
       AND v.Tipo = o.Tipo
    GROUP BY c.DNI, c.numero_cuenta
    HAVING SUM(o.Precio) = (

        SELECT MAX(total_gastado)
        FROM (
            SELECT
                SUM(o2.Precio) AS total_gastado
            FROM Vendida v2
            INNER JOIN Oferta o2
                ON v2.Recinto = o2.Recinto
               AND v2.Fecha = o2.Fecha
               AND v2.Nombre_grada = o2.Nombre_grada
               AND v2.Tipo = o2.Tipo
            GROUP BY v2.DNI
        ) AS Totales
    );

END //

DELIMITER ;