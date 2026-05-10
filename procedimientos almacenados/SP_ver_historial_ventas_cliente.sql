DELIMITER //

CREATE PROCEDURE VerHistorialVentasCliente(
    IN p_dni VARCHAR(20)
)
BEGIN
    DECLARE v_cantidad INT;
    
    -- 1. Verificamos que el cliente existe
    IF NOT EXISTS (SELECT 1 FROM Cliente WHERE DNI = p_dni) THEN
        SELECT 'Error: El cliente no existe' AS Resultado;
    
    ELSE
        -- 2. Contamos cuántas ventas ha realizado
        SELECT COUNT(*) INTO v_cantidad
        FROM Vendida
        WHERE DNI = p_dni;
        
        
        -- 3. Mostramos todas las ventas del cliente con detalles
        SELECT 
            E.Nombre_espectaculo,
            V.Recinto,
            V.Fecha,
            V.Nombre_grada,
            V.Localidad,
            V.Tipo AS Tipo_Cliente,
            O.Precio
        FROM Vendida V
        INNER JOIN Evento E ON V.Fecha = E.Fecha AND V.Recinto = E.Recinto
        INNER JOIN Oferta O ON V.Recinto = O.Recinto 
                            AND V.Fecha = O.Fecha 
                            AND V.Nombre_grada = O.Nombre_grada 
                            AND V.Tipo = O.Tipo
        WHERE V.DNI = p_dni
        ORDER BY V.Fecha DESC;

        -- 4. Mostramos el total de ventas
        SELECT CONCAT('Total de entradas compradas: ', v_cantidad) AS Resultado;
    
    END IF;
    
END //

DELIMITER ;
