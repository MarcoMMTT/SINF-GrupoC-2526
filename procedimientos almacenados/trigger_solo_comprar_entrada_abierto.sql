DELIMITER //

CREATE TRIGGER check_evento_abierto
BEFORE INSERT ON Vendida
FOR EACH ROW
BEGIN
    DECLARE estado_evento VARCHAR(20);

    -- Obtenemos el estado del evento asociado a la venta
    SELECT Estado INTO estado_evento
    FROM Evento
    WHERE Fecha = NEW.Fecha 
      AND Recinto = NEW.Recinto;

    -- Si el evento no está en estado 'abierto', lanzamos un error
    IF estado_evento != 'abierto' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Solo se pueden comprar entradas cuando el evento está en estado abierto.';
    END IF;
END //

DELIMITER ;
