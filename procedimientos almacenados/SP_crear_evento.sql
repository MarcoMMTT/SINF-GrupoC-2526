Use GrupoC;
DELIMITER //

CREATE PROCEDURE CrearEvento(
    IN p_nombre_espectaculo VARCHAR(50),
    IN p_recinto VARCHAR(100),
    IN p_fecha TIMESTAMP,
    IN p_gradas_json JSON,
    IN p_ofertas_json JSON
)
BEGIN
    DECLARE v_contador INT DEFAULT 0;
    DECLARE v_total_gradas INT;
    DECLARE v_total_ofertas INT;
    DECLARE v_nombre_grada VARCHAR(100);
    DECLARE v_cantidad_entradas INT;
    DECLARE v_tipo VARCHAR(50);
    DECLARE v_precio INT;
    DECLARE v_seq INT;
    
    START TRANSACTION;
    
    -- 1. Verificamos que el espectáculo existe
    IF NOT EXISTS (SELECT 1 FROM Espectaculo WHERE Nombre_espectaculo = p_nombre_espectaculo) THEN
        ROLLBACK;
        SELECT 'Error: El espectáculo no existe' AS Resultado;
    
    -- 2. Verificamos que no exista ya un evento con esa fecha y recinto
    ELSEIF EXISTS (SELECT 1 FROM Evento WHERE Fecha = p_fecha AND Recinto = p_recinto) THEN
        ROLLBACK;
        SELECT 'Error: Ya existe un evento en ese recinto y fecha' AS Resultado;
    
    ELSE
        
        -- 3. Creamos el evento en estado 'abierto'
        INSERT INTO Evento (Nombre_espectaculo, Recinto, Fecha, Estado)
        VALUES (p_nombre_espectaculo, p_recinto, p_fecha, 'abierto');
        
        -- 4. Creamos las gradas y sus entradas para el evento
        SET v_total_gradas = JSON_LENGTH(p_gradas_json);
        SET v_contador = 0;
        
        WHILE v_contador < v_total_gradas DO
            SET v_nombre_grada = JSON_EXTRACT(p_gradas_json, CONCAT('$[', v_contador, '].nombre'));
            SET v_cantidad_entradas = JSON_EXTRACT(p_gradas_json, CONCAT('$[', v_contador, '].cantidad'));
            
            -- Removemos las comillas del nombre si las tiene
            SET v_nombre_grada = TRIM('"' FROM v_nombre_grada);
            
            INSERT INTO Grada (Nombre_Grada, Fecha, Recinto)
            VALUES (v_nombre_grada, p_fecha, p_recinto);
            
            -- Creamos las entradas para esta grada (L1, L2, L3, ...)
            SET v_seq = 1;
            WHILE v_seq <= v_cantidad_entradas DO
                INSERT INTO Entrada (Fecha, Recinto, Nombre_grada, Localidad, Estado)
                VALUES (p_fecha, p_recinto, v_nombre_grada, CONCAT('L', v_seq), 'libre');
                SET v_seq = v_seq + 1;
            END WHILE;
            
            SET v_contador = v_contador + 1;
        END WHILE;
        
        -- 5. Insertamos las ofertas para cada tipo de usuario
        SET v_total_ofertas = JSON_LENGTH(p_ofertas_json);
        SET v_contador = 0;
        
        WHILE v_contador < v_total_ofertas DO
            SET v_tipo = JSON_EXTRACT(p_ofertas_json, CONCAT('$[', v_contador, '].tipo'));
            SET v_precio = JSON_EXTRACT(p_ofertas_json, CONCAT('$[', v_contador, '].precio'));
            SET v_nombre_grada = JSON_EXTRACT(p_ofertas_json, CONCAT('$[', v_contador, '].grada'));
            
            -- Removemos las comillas si las tiene
            SET v_tipo = TRIM('"' FROM v_tipo);
            SET v_nombre_grada = TRIM('"' FROM v_nombre_grada);
            
            -- Verificamos que el tipo de usuario existe
            IF NOT EXISTS (SELECT 1 FROM Usuario WHERE Tipo = v_tipo) THEN
                ROLLBACK;
                SELECT CONCAT('Error: El tipo de usuario ', v_tipo, ' no existe') AS Resultado;
            END IF;
            
            -- Verificamos que la grada existe
            IF NOT EXISTS (SELECT 1 FROM Grada WHERE Nombre_Grada = v_nombre_grada AND Fecha = p_fecha AND Recinto = p_recinto) THEN
                ROLLBACK;
                SELECT CONCAT('Error: La grada ', v_nombre_grada, ' no existe en este evento') AS Resultado;
            END IF;
            
            INSERT INTO Oferta (Precio, Recinto, Fecha, Nombre_grada, Tipo)
            VALUES (v_precio, p_recinto, p_fecha, v_nombre_grada, v_tipo);
            
            SET v_contador = v_contador + 1;
        END WHILE;
        
        COMMIT;
        SELECT 'Evento creado exitosamente con gradas, ofertas y entradas' AS Resultado;
    
    END IF;
    
END //

DELIMITER ;
