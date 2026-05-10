DELIMITER $$

CREATE PROCEDURE EntradasDisponiblesPorEvento(
    IN p_fecha    TIMESTAMP,
    IN p_recinto  VARCHAR(100)
)

BEGIN
    -- Validar que el evento existe
    IF NOT EXISTS (
        SELECT 1 FROM Evento 
        WHERE Fecha = p_fecha AND Recinto = p_recinto
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El evento indicado no existe.';
    END IF;

    -- Validar que el evento está abierto
    IF NOT EXISTS (
        SELECT 1 FROM Evento 
        WHERE Fecha = p_fecha AND Recinto = p_recinto AND Estado = 'abierto'
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El evento no está en estado abierto.';
    END IF;

    SELECT 
        ev.Nombre_espectaculo,
        ev.Recinto,
        ev.Fecha,
        en.Nombre_grada,
        en.Localidad,
        en.Estado        AS Estado_Entrada,
        o.Tipo           AS Tipo_Usuario,
        o.Precio
    FROM Entrada en
    JOIN Evento  ev ON  en.Fecha   = ev.Fecha
                    AND en.Recinto = ev.Recinto
    LEFT JOIN Oferta o ON  o.Fecha        = en.Fecha
                       AND o.Recinto      = en.Recinto
                       AND o.Nombre_Grada = en.Nombre_grada
    WHERE en.Fecha   = p_fecha
      AND en.Recinto = p_recinto
      AND en.Estado  = 'libre'
    ORDER BY en.Nombre_grada, en.Localidad, o.Tipo;
END$$

DELIMITER ;