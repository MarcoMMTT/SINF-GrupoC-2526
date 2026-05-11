USE GrupoC;

DROP PROCEDURE IF EXISTS EntradasDisponiblesPorDia;

DELIMITER //

CREATE PROCEDURE EntradasDisponiblesPorDia(
    IN p_dia DATE
)
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM Evento
        WHERE DATE(Fecha) = p_dia
    ) THEN
        SELECT 'Error: No hay eventos en ese día' AS Resultado;

    ELSE
        SELECT
            ev.Nombre_espectaculo,
            ev.Recinto,
            ev.Fecha,
            ev.Estado AS Estado_Evento,
            COUNT(en.Localidad) AS Entradas_libres
        FROM Evento ev
        LEFT JOIN Entrada en
            ON en.Fecha = ev.Fecha
           AND en.Recinto = ev.Recinto
           AND en.Estado = 'libre'
        WHERE DATE(ev.Fecha) = p_dia
        GROUP BY
            ev.Nombre_espectaculo,
            ev.Recinto,
            ev.Fecha,
            ev.Estado
        ORDER BY ev.Fecha, ev.Recinto;
    END IF;
END //

DELIMITER ;