USE GrupoC;

DROP PROCEDURE IF EXISTS VerHistorialVentasCliente;

DELIMITER //

CREATE PROCEDURE VerHistorialVentasCliente(
    IN p_dni VARCHAR(20)
)
BEGIN
    DECLARE v_cantidad INT DEFAULT 0;
    DECLARE v_total_gastado DECIMAL(10,2) DEFAULT 0;
    DECLARE v_entradas_abiertas INT DEFAULT 0;

    IF NOT EXISTS (SELECT 1 FROM Cliente WHERE DNI = p_dni) THEN
        SELECT 'Error: El cliente no existe' AS Resultado;

    ELSE
        SELECT COUNT(*)
        INTO v_cantidad
        FROM Vendida
        WHERE DNI = p_dni;

        SELECT COALESCE(SUM(O.Precio), 0)
        INTO v_total_gastado
        FROM Vendida V
        INNER JOIN Oferta O
            ON V.Recinto = O.Recinto
           AND V.Fecha = O.Fecha
           AND V.Nombre_grada = O.Nombre_grada
           AND V.Tipo = O.Tipo
        WHERE V.DNI = p_dni;

        SELECT COUNT(*)
        INTO v_entradas_abiertas
        FROM Vendida V
        INNER JOIN Evento E
            ON V.Recinto = E.Recinto
           AND V.Fecha = E.Fecha
        WHERE V.DNI = p_dni
          AND E.Estado = 'abierto';

        SELECT 
            E.Nombre_espectaculo,
            V.Recinto,
            V.Fecha,
            E.Estado AS Estado_Evento,
            V.Nombre_grada,
            V.Localidad,
            V.Tipo AS Tipo_Cliente,
            O.Precio
        FROM Vendida V
        INNER JOIN Evento E
            ON V.Fecha = E.Fecha
           AND V.Recinto = E.Recinto
        INNER JOIN Oferta O
            ON V.Recinto = O.Recinto 
           AND V.Fecha = O.Fecha 
           AND V.Nombre_grada = O.Nombre_grada 
           AND V.Tipo = O.Tipo
        WHERE V.DNI = p_dni
        ORDER BY V.Fecha DESC;

        SELECT 
            v_cantidad AS Total_entradas_compradas,
            v_entradas_abiertas AS Entradas_para_eventos_abiertos,
            v_total_gastado AS Total_gastado;
    END IF;
END //

DELIMITER ;