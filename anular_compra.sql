DELIMITER //

CREATE PROCEDURE CancelarCompra(
    IN p_dni VARCHAR(20),
    IN p_fecha DATE,
    IN p_recinto VARCHAR(100),
    IN p_localidad VARCHAR(50)
)
BEGIN
    -- Iniciamos una transacción para asegurar integridad total
    START TRANSACTION;

    -- 1. Verificamos si la venta existe y no está ya anulada
    IF EXISTS (SELECT 1 FROM Vendida 
               WHERE DNI = p_dni AND Fecha = p_fecha 
               AND Recinto = p_recinto AND Localidad = p_localidad 
               AND estado_venta != 'Anulada') THEN

        -- 2. Marcamos la venta como Anulada
        UPDATE Vendida 
        SET estado_venta = 'Anulada'
        WHERE DNI = p_dni AND Fecha = p_fecha 
          AND Recinto = p_recinto AND Localidad = p_localidad;

        -- 3. Liberamos el asiento en la tabla Entrada
        UPDATE Entrada 
        SET Estado = 'Disponible'
        WHERE Fecha = p_fecha AND Recinto = p_recinto 
          AND Localidad = p_localidad;

        COMMIT; -- Confirmamos los cambios
        SELECT 'Anulación realizada con éxito' AS Resultado;

    ELSE
        ROLLBACK; -- Si algo falla o no existe, revertimos
        SELECT 'Error: La venta no existe o ya ha sido anulada' AS Resultado;
    END IF;

END //

DELIMITER ;