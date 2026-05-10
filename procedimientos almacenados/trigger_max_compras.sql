USE GrupoC;
DELIMITER //

CREATE TRIGGER check_limite_compras
BEFORE INSERT ON Vendida
FOR EACH ROW
BEGIN
    DECLARE total_compras INT;

    -- Contamos cuántas entradas tiene ya el cliente PARA EL EVENTO ESPECÍFICO
    SELECT COUNT(*) INTO total_compras
    FROM Vendida
    WHERE DNI = NEW.DNI 
      AND Fecha = NEW.Fecha 
      AND Recinto = NEW.Recinto;

    -- Si ya tiene 20 o más entradas para este evento, lanzamos un error para abortar la inserción
    IF total_compras >= 20 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: El cliente ya ha alcanzado el límite máximo de 20 entradas para este evento.';
    END IF;
END //

DELIMITER ;