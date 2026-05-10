USE GrupoC;
DELIMITER //

CREATE PROCEDURE RealizarCompra(
    IN p_DNI VARCHAR(20),
    IN p_Fecha TIMESTAMP,
    IN p_Recinto VARCHAR(100),
    IN p_Nombre_grada VARCHAR(100),
    IN p_Localidad VARCHAR(100),
    IN p_Tipo_Usuario VARCHAR(50)
)
BEGIN
    -- Declaración de variables para validación
    DECLARE v_evento_estado VARCHAR(20);
    DECLARE v_entrada_estado VARCHAR(50);
    DECLARE v_oferta_existe INT DEFAULT 0;
    DECLARE v_cliente_existe INT DEFAULT 0;
    
    -- Manejador de errores: Si algo falla, se deshace la transacción
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL; -- Vuelve a lanzar el error para que la aplicación lo detecte
    END;

    -- 1. Validar que el cliente existe
    SELECT COUNT(*) INTO v_cliente_existe 
    FROM Cliente 
    WHERE DNI = p_DNI;
    
    IF v_cliente_existe = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El cliente no existe en el sistema.';
    END IF;

    -- 2. Validar que el evento existe y está abierto
    SELECT Estado INTO v_evento_estado
    FROM Evento
    WHERE Fecha = p_Fecha AND Recinto = p_Recinto;

    IF v_evento_estado IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El evento no existe.';
    ELSEIF v_evento_estado != 'abierto' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El evento no está abierto para compras.';
    END IF;

    -- 3. Validar que la localidad existe y está libre
    SELECT Estado INTO v_entrada_estado
    FROM Entrada
    WHERE Fecha = p_Fecha AND Recinto = p_Recinto AND Nombre_grada = p_Nombre_grada AND Localidad = p_Localidad;

    IF v_entrada_estado IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: La entrada/localidad indicada no existe.';
    ELSEIF v_entrada_estado != 'libre' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: La localidad ya no está libre (reservada o deteriorada).';
    END IF;

    -- 4. Validar que existe una oferta (precio configurado) para ese tipo de usuario en esa grada
    SELECT COUNT(*) INTO v_oferta_existe
    FROM Oferta
    WHERE Fecha = p_Fecha AND Recinto = p_Recinto AND Nombre_grada = p_Nombre_grada AND Tipo = p_Tipo_Usuario;

    IF v_oferta_existe = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No hay una oferta de precio definida para este tipo de usuario en esta grada.';
    END IF;
    
    -- 5. Ejecutar la compra dentro de una transacción segura
    START TRANSACTION;

        -- Marcar la entrada como 'reservada' (vendida)
        UPDATE Entrada
        SET Estado = 'reservado'
        WHERE Fecha = p_Fecha AND Recinto = p_Recinto AND Nombre_grada = p_Nombre_grada AND Localidad = p_Localidad;

        -- Registrar el ticket en la tabla Vendida
        INSERT INTO Vendida (Nombre_grada, Tipo, Fecha, Recinto, DNI, Localidad)
        VALUES (p_Nombre_grada, p_Tipo_Usuario, p_Fecha, p_Recinto, p_DNI, p_Localidad);

    -- Confirmar los cambios
    COMMIT;

END //

DELIMITER ;