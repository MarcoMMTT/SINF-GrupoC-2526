USE GrupoC;
DELIMITER //

CREATE PROCEDURE VerDineroGanado()
BEGIN
    DECLARE v_total_dinero DECIMAL(10, 2);
    
    -- 1. Calculamos el dinero total ganado por todas las ventas
    SELECT SUM(O.Precio) INTO v_total_dinero
    FROM Vendida V
    INNER JOIN Oferta O ON V.Recinto = O.Recinto 
                        AND V.Fecha = O.Fecha 
                        AND V.Nombre_grada = O.Nombre_grada 
                        AND V.Tipo = O.Tipo;
    

    

    -- 2. Mostramos desglose por espectáculo
    SELECT 
        E.Nombre_espectaculo,
        V.Recinto,
        V.Fecha,
        SUM(O.Precio) AS Dinero_Ganado,
        COUNT(*) AS Entradas_Vendidas
    FROM Vendida V
    INNER JOIN Evento E ON V.Fecha = E.Fecha AND V.Recinto = E.Recinto
    INNER JOIN Oferta O ON V.Recinto = O.Recinto 
                        AND V.Fecha = O.Fecha 
                        AND V.Nombre_grada = O.Nombre_grada 
                        AND V.Tipo = O.Tipo
    GROUP BY E.Nombre_espectaculo, V.Recinto, V.Fecha
    ORDER BY Dinero_Ganado DESC;
    
    -- 3. Mostramos desglose por tipo de cliente
    SELECT 
        V.Tipo,
        SUM(O.Precio) AS Dinero_Ganado,
        COUNT(*) AS Entradas_Vendidas
    FROM Vendida V
    INNER JOIN Oferta O ON V.Recinto = O.Recinto 
                        AND V.Fecha = O.Fecha 
                        AND V.Nombre_grada = O.Nombre_grada 
                        AND V.Tipo = O.Tipo
    GROUP BY V.Tipo
    ORDER BY Dinero_Ganado DESC;


        -- 4. Mostramos el total general
    SELECT CONCAT('Dinero total ganado: ', COALESCE(v_total_dinero, 0), '€') AS Total_General;
    
END //

DELIMITER ;
