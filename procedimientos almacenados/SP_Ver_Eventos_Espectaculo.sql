USE GrupoC;

DELIMITER //

DROP PROCEDURE IF EXISTS VerEventosEspectaculo //

CREATE PROCEDURE VerEventosEspectaculo(
    IN p_nombre_espectaculo VARCHAR(50)
)
BEGIN
    DECLARE v_cantidad INT;

    IF NOT EXISTS (
        SELECT 1
        FROM Espectaculo
        WHERE Nombre_espectaculo = p_nombre_espectaculo
    ) THEN
        SELECT 'Error: El espectáculo no existe' AS Resultado;

    ELSE
        SELECT COUNT(*)
        INTO v_cantidad
        FROM Evento
        WHERE Nombre_espectaculo = p_nombre_espectaculo;

        SELECT 
            Nombre_espectaculo,
            Recinto,
            Fecha,
            Estado
        FROM Evento
        WHERE Nombre_espectaculo = p_nombre_espectaculo
        ORDER BY Fecha;

        SELECT CONCAT('Total de eventos: ', v_cantidad) AS Resultado;
    END IF;
END //

DELIMITER ;