USE GrupoC;

DROP PROCEDURE IF EXISTS ClienteQueMasHaGastado_2;

DELIMITER //

CREATE PROCEDURE ClienteQueMasHaGastado_2()
BEGIN

    -- Clientes que más dinero han gastado (incluyendo empates)
            SELECT
                v2.DNI,
                SUM(o2.Precio) AS total_gastado
            FROM Vendida v2
            INNER JOIN Oferta o2
                ON v2.Recinto = o2.Recinto
               AND v2.Fecha = o2.Fecha
               AND v2.Nombre_grada = o2.Nombre_grada
               AND v2.Tipo = o2.Tipo
            GROUP BY v2.DNI ORDER BY total_gastado DESC LIMIT 3;

END //

DELIMITER ;