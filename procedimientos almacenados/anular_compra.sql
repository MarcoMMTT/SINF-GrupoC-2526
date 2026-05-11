USE GrupoC;

DROP PROCEDURE IF EXISTS CancelarCompra;

DELIMITER //

CREATE PROCEDURE CancelarCompra(
    IN p_dni VARCHAR(20),
    IN p_fecha TIMESTAMP,
    IN p_recinto VARCHAR(100),
    IN p_nombre_grada VARCHAR(100),
    IN p_localidad VARCHAR(100)
)
BEGIN
    -- Iniciamos una transacción para asegurar integridad total
    START TRANSACTION;

    -- 1. Verificamos si la compra existe para ESE cliente
    IF EXISTS (
        SELECT 1
        FROM Vendida
        WHERE Fecha = p_fecha
          AND Recinto = p_recinto
          AND Nombre_grada = p_nombre_grada
          AND Localidad = p_localidad
          AND DNI = p_dni
    ) THEN

        -- 2. Eliminamos la venta
        DELETE FROM Vendida
        WHERE Fecha = p_fecha
          AND Recinto = p_recinto
          AND Nombre_grada = p_nombre_grada
          AND Localidad = p_localidad
          AND DNI = p_dni;

        -- 3. Liberamos el asiento
        UPDATE Entrada
        SET Estado = 'libre'
        WHERE Fecha = p_fecha
          AND Recinto = p_recinto
          AND Nombre_grada = p_nombre_grada
          AND Localidad = p_localidad;

        COMMIT;

        SELECT 'Compra cancelada exitosamente' AS Resultado;

    ELSE

        ROLLBACK;

        SELECT 'Error: La compra no existe o no pertenece a este cliente'
        AS Resultado;

    END IF;

END //

DELIMITER ;