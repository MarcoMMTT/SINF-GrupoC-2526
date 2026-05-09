DELIMITER //

CREATE TRIGGER check_limite_compras
BEFORE INSERT ON Vendida
FOR EACH ROW
BEGIN
    DECLARE total_compras INT;

    -- Contamos cuántas entradas tiene ya el cliente
    SELECT COUNT(*) INTO total_compras
    FROM Vendida
    WHERE DNI = NEW.DNI;

    -- Si ya tiene 20 o más, lanzamos un error para abortar la inserción
    IF total_compras >= 20 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: El cliente ya ha alcanzado el límite máximo de 20 entradas compradas.';
    END IF;
END //

DELIMITER ;