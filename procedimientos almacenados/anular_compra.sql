DELIMITER //

CREATE PROCEDURE CancelarCompra(
    IN p_fecha TIMESTAMP,
    IN p_recinto VARCHAR(100),
    IN p_nombre_grada VARCHAR(100),
    IN p_localidad VARCHAR(100)
)
BEGIN
    -- Iniciamos una transacción para asegurar integridad total
    START TRANSACTION;

    -- 1. Verificamos si la venta existe
    IF EXISTS (SELECT 1 FROM Vendida 
               WHERE Fecha = p_fecha 
                 AND Recinto = p_recinto 
                 AND Nombre_grada = p_nombre_grada
                 AND Localidad = p_localidad
               ) THEN

        -- 2. Eliminamos la relación en Vendida
        DELETE FROM Vendida 
        WHERE Fecha = p_fecha 
          AND Recinto = p_recinto 
          AND Nombre_grada = p_nombre_grada
          AND Localidad = p_localidad;

        -- 3. Liberamos el asiento en la tabla Entrada pasándolo a estado 'libre'
        UPDATE Entrada 
        SET Estado = 'libre'
        WHERE Fecha = p_fecha 
          AND Recinto = p_recinto 
          AND Nombre_grada = p_nombre_grada
          AND Localidad = p_localidad;

        COMMIT; -- Confirmamos los cambios
        SELECT 'Compra cancelada exitosamente' AS Resultado;

    ELSE
        ROLLBACK; -- Si no existe, revertimos
        SELECT 'Error: La compra no existe' AS Resultado;
    END IF;

END //

DELIMITER ;