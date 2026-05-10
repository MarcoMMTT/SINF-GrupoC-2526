USE GrupoC;
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
    -- Iniciamos una transacción para asegurar integridad
    START TRANSACTION;
    
    -- 1. Verificamos que el cliente existe
    IF NOT EXISTS (SELECT 1 FROM Cliente WHERE DNI = p_dni) THEN
        ROLLBACK;
        SELECT 'Error: El cliente no existe' AS Resultado;
    
    -- 2. Verificamos que el evento existe
    ELSEIF NOT EXISTS (SELECT 1 FROM Evento 
                       WHERE Recinto = p_recinto AND Fecha = p_fecha) THEN
        ROLLBACK;
        SELECT 'Error: El evento no existe' AS Resultado;
    
    -- 3. Verificamos que la grada existe en este evento
    ELSEIF NOT EXISTS (SELECT 1 FROM Grada 
                       WHERE Nombre_Grada = p_nombre_grada 
                       AND Fecha = p_fecha 
                       AND Recinto = p_recinto) THEN
        ROLLBACK;
        SELECT 'Error: La grada no existe en este evento' AS Resultado;
    
    -- 4. Verificamos que la entrada existe y está libre
    ELSEIF NOT EXISTS (SELECT 1 FROM Entrada 
                       WHERE Fecha = p_fecha 
                       AND Recinto = p_recinto 
                       AND Nombre_grada = p_nombre_grada 
                       AND Localidad = p_localidad
                       AND Estado = 'libre') THEN
        ROLLBACK;
        SELECT 'Error: La entrada no existe, no está disponible o ya ha sido vendida' AS Resultado;
    
    -- 5. Verificamos que existe oferta para ese tipo de cliente
    ELSEIF NOT EXISTS (SELECT 1 FROM Oferta 
                       WHERE Recinto = p_recinto 
                       AND Fecha = p_fecha 
                       AND Nombre_grada = p_nombre_grada 
                       AND Tipo = p_tipo) THEN
        ROLLBACK;
        SELECT 'Error: No existe oferta para este tipo de cliente en esta grada' AS Resultado;

    
    ELSE
        
        -- 6. Insertamos la tupla en Vendida
        INSERT INTO Vendida (Nombre_grada, Tipo, Fecha, Recinto, DNI, Localidad)
        VALUES (p_nombre_grada, p_tipo, p_fecha, p_recinto, p_dni, p_localidad);
        
        -- 7. Actualizamos el estado de la Entrada a 'reservado'
        UPDATE Entrada
        SET Estado = 'reservado'
        WHERE Fecha = p_fecha 
          AND Recinto = p_recinto 
          AND Nombre_grada = p_nombre_grada 
          AND Localidad = p_localidad;
        
        
        COMMIT;
        SELECT 'Compra realizada exitosamente' AS Resultado;
    
    END IF;
    
END //

DELIMITER ;
