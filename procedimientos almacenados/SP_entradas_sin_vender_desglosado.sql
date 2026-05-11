USE GrupoC;

DROP PROCEDURE IF EXISTS EntradasDisponiblesGeneral;

DELIMITER //

CREATE PROCEDURE EntradasDisponiblesGeneral()
BEGIN

    DECLARE v_total BIGINT DEFAULT 0;

    -- Mostrar entradas libres por evento
    SELECT
        ev.Nombre_espectaculo,
        ev.Recinto,
        ev.Fecha,
        ev.Estado,
        COUNT(en.Localidad) AS Entradas_libres
    FROM Evento ev
    LEFT JOIN Entrada en
        ON en.Fecha = ev.Fecha
       AND en.Recinto = ev.Recinto
       AND en.Estado = 'libre'
    GROUP BY
        ev.Nombre_espectaculo,
        ev.Recinto,
        ev.Fecha,
        ev.Estado
    ORDER BY Entradas_libres DESC;

    -- Calcular total general
    SELECT COUNT(*)
    INTO v_total
    FROM Entrada
    WHERE Estado = 'libre';

    -- Mostrar total
    SELECT CONCAT(
        'Total de entradas pendientes de vender: ',
        v_total
    ) AS Resultado;

END //

DELIMITER ;