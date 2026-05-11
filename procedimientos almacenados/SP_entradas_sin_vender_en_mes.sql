USE GrupoC;

DROP PROCEDURE IF EXISTS EntradasDisponiblesPorMes;

DELIMITER //

CREATE PROCEDURE EntradasDisponiblesPorMes(
    IN p_mes  INT,
    IN p_anio INT
)
BEGIN

    DECLARE v_total BIGINT DEFAULT 0;

    -- Validar mes
    IF p_mes < 1 OR p_mes > 12 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El mes debe estar entre 1 y 12.';
    END IF;

    -- Comprobar que hay eventos
    IF NOT EXISTS (
        SELECT 1
        FROM Evento
        WHERE MONTH(Fecha) = p_mes
          AND YEAR(Fecha) = p_anio
    ) THEN
        SELECT 'Error: No hay eventos para ese mes.' AS Resultado;

    ELSE

        -- Mostrar detalle por evento
        SELECT
            YEAR(ev.Fecha)  AS Anio,
            MONTH(ev.Fecha) AS Mes,
            ev.Nombre_espectaculo,
            ev.Recinto,
            COUNT(en.Localidad) AS Entradas_libres
        FROM Evento ev
        LEFT JOIN Entrada en
            ON en.Fecha = ev.Fecha
           AND en.Recinto = ev.Recinto
           AND en.Estado = 'libre'
        WHERE MONTH(ev.Fecha) = p_mes
          AND YEAR(ev.Fecha) = p_anio
        GROUP BY
            YEAR(ev.Fecha),
            MONTH(ev.Fecha),
            ev.Nombre_espectaculo,
            ev.Recinto
        ORDER BY Entradas_libres DESC;

        -- Calcular total general
        SELECT COUNT(*)
        INTO v_total
        FROM Evento ev
        INNER JOIN Entrada en
            ON en.Fecha = ev.Fecha
           AND en.Recinto = ev.Recinto
        WHERE MONTH(ev.Fecha) = p_mes
          AND YEAR(ev.Fecha) = p_anio
          AND en.Estado = 'libre';

        -- Mostrar total
        SELECT CONCAT(
            'Total de entradas pendientes de vender: ',
            v_total
        ) AS Resultado;

    END IF;

END //

DELIMITER ;