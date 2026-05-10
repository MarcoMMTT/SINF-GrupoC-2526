DELIMITER //

CREATE PROCEDURE AnadirGrada(
    IN p_fecha TIMESTAMP,
    IN p_recinto VARCHAR(100),
    IN p_nombre_grada VARCHAR(100),
    IN p_cantidad_entradas INT
)
BEGIN
    DECLARE v_seq INT;
    
    START TRANSACTION;
    
    -- 1. Verificamos que el evento existe
    IF NOT EXISTS (SELECT 1 FROM Evento WHERE Fecha = p_fecha AND Recinto = p_recinto) THEN
        ROLLBACK;
        SELECT 'Error: El evento no existe' AS Resultado;
    
    -- 2. Verificamos que la grada no existe ya en este evento
    ELSEIF EXISTS (SELECT 1 FROM Grada 
                   WHERE Nombre_Grada = p_nombre_grada 
                   AND Fecha = p_fecha 
                   AND Recinto = p_recinto) THEN
        ROLLBACK;
        SELECT 'Error: La grada ya existe en este evento' AS Resultado;
    
    -- 3. Verificamos que la cantidad de entradas es válida
    ELSEIF p_cantidad_entradas <= 0 THEN
        ROLLBACK;
        SELECT 'Error: La cantidad de entradas debe ser mayor a 0' AS Resultado;
    
    ELSE
        
        -- 4. Creamos la nueva grada
        INSERT INTO Grada (Nombre_Grada, Fecha, Recinto)
        VALUES (p_nombre_grada, p_fecha, p_recinto);
        
        -- 5. Creamos las entradas para la nueva grada (L1, L2, L3, ...)
        SET v_seq = 1;
        WHILE v_seq <= p_cantidad_entradas DO
            INSERT INTO Entrada (Fecha, Recinto, Nombre_grada, Localidad, Estado)
            VALUES (p_fecha, p_recinto, p_nombre_grada, CONCAT('L', v_seq), 'libre');
            SET v_seq = v_seq + 1;
        END WHILE;
        
        COMMIT;
        SELECT CONCAT('Grada "', p_nombre_grada, '" creada exitosamente con ', p_cantidad_entradas, ' entradas') AS Resultado;
    
    END IF;
    
END //

DELIMITER ;
