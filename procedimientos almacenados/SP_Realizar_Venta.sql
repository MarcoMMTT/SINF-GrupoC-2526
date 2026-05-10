DELIMITER //

CREATE PROCEDURE Venta(
    IN p_dni VARCHAR(20),
    IN p_recinto VARCHAR(100),
    IN p_fecha TIMESTAMP,
    IN p_nombre_grada VARCHAR(100),
    IN p_localidad VARCHAR(100),
    IN p_tipo VARCHAR(50)
)
BEGIN
    DECLARE v_nombre_espectaculo VARCHAR(50);
    DECLARE v_huecos_actuales INT;
    DECLARE v_huecos_nuevos INT;
    
    -- Iniciamos una transacción para asegurar integridad
    START TRANSACTION;
    
    -- 1. Verificamos que el cliente existe
    IF NOT EXISTS (SELECT 1 FROM Cliente WHERE DNI = p_dni) THEN
        ROLLBACK;
        SELECT 'Error: El cliente no existe' AS Resultado;
    
    -- 2. Verificamos que el evento existe y obtenemos el nombre del espectáculo
    ELSEIF NOT EXISTS (SELECT 1 FROM Evento 
                       WHERE Recinto = p_recinto AND Fecha = p_fecha) THEN
        ROLLBACK;
        SELECT 'Error: El evento no existe' AS Resultado;
    
    -- 3. Verificamos que la entrada existe y está libre
    ELSEIF NOT EXISTS (SELECT 1 FROM Entrada 
                       WHERE Fecha = p_fecha 
                       AND Recinto = p_recinto 
                       AND Nombre_grada = p_nombre_grada 
                       AND Localidad = p_localidad
                       AND Estado = 'libre') THEN
        ROLLBACK;
        SELECT 'Error: La entrada no existe, no está disponible o ya ha sido vendida' AS Resultado;
    
    -- 4. Verificamos que existe oferta para ese tipo de cliente
    ELSEIF NOT EXISTS (SELECT 1 FROM Oferta 
                       WHERE Recinto = p_recinto 
                       AND Fecha = p_fecha 
                       AND Nombre_grada = p_nombre_grada 
                       AND Tipo = p_tipo) THEN
        ROLLBACK;
        SELECT 'Error: No existe oferta para este tipo de cliente en esta grada' AS Resultado;
    
    -- 5. Verificamos que hay huecos disponibles en la grada
    ELSEIF NOT EXISTS (SELECT 1 FROM Aforo 
                       WHERE Nombre_grada = p_nombre_grada 
                       AND Huecos > 0) THEN
        ROLLBACK;
        SELECT 'Error: No hay huecos disponibles en esta grada' AS Resultado;
    
    ELSE
        -- 6. Obtenemos los huecos actuales
        SELECT Nombre_espectaculo INTO v_nombre_espectaculo
        FROM Evento 
        WHERE Recinto = p_recinto AND Fecha = p_fecha;
        
        SELECT Huecos INTO v_huecos_actuales
        FROM Aforo
        WHERE Nombre_grada = p_nombre_grada;
        
        -- 7. Insertamos la tupla en Vendida
        INSERT INTO Vendida (Nombre_grada, Tipo, Fecha, Recinto, Nombre_espectaculo, DNI, Localidad)
        VALUES (p_nombre_grada, p_tipo, p_fecha, p_recinto, v_nombre_espectaculo, p_dni, p_localidad);
        
        -- 8. Actualizamos el estado de la Entrada a 'reservado'
        UPDATE Entrada
        SET Estado = 'reservado'
        WHERE Fecha = p_fecha 
          AND Recinto = p_recinto 
          AND Nombre_grada = p_nombre_grada 
          AND Localidad = p_localidad;
        
        -- 9. Actualizamos el Aforo (restamos 1 hueco)
        -- Como Huecos es la PK, necesitamos DELETE e INSERT
        DELETE FROM Aforo
        WHERE Nombre_grada = p_nombre_grada;
        
        SET v_huecos_nuevos = v_huecos_actuales - 1;
        
        INSERT INTO Aforo (Huecos, Nombre_grada)
        VALUES (v_huecos_nuevos, p_nombre_grada);
        
        COMMIT;
        SELECT 'Compra realizada exitosamente' AS Resultado;
    
    END IF;
    
END //

DELIMITER ;
