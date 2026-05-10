USE GrupoC;
DELIMITER //

CREATE PROCEDURE SP_Registrar_Cliente(
    IN p_DNI VARCHAR(20),
    IN p_numero_cuenta VARCHAR(50)
)
BEGIN
    -- Comprobamos si el cliente ya existe para evitar errores no controlados
    IF EXISTS (SELECT 1 FROM Cliente WHERE DNI = p_DNI) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El cliente ya existe.';
    ELSE
        INSERT INTO Cliente (DNI, numero_cuenta) 
        VALUES (p_DNI, p_numero_cuenta);
    END IF;
END //

DELIMITER ;