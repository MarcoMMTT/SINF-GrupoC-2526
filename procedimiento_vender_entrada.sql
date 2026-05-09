DELIMITER $$

CREATE PROCEDURE vender_entrada_completa(
    IN p_dni_cliente VARCHAR(20),
    IN p_numero_cuenta VARCHAR(30),
    IN p_nombre_espectaculo VARCHAR(120),
    IN p_fecha DATETIME,
    IN p_recinto VARCHAR(120),
    IN p_nombre_grada VARCHAR(80),
    IN p_localidad VARCHAR(30),
    IN p_tipo_usuario VARCHAR(20)
)
BEGIN
    DECLARE v_estado VARCHAR(20);

    INSERT IGNORE INTO cliente(dni, numero_cuenta)
    VALUES (p_dni_cliente, p_numero_cuenta);

    SELECT estado
    INTO v_estado
    FROM entrada
    WHERE nombre_espectaculo = p_nombre_espectaculo
      AND fecha = p_fecha
      AND recinto = p_recinto
      AND nombre_grada = p_nombre_grada
      AND localidad = p_localidad;

    IF v_estado IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La entrada no existe';
    END IF;

    IF v_estado <> 'libre' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La entrada no está libre';
    END IF;

    INSERT IGNORE INTO oferta_entrada(
        nombre_espectaculo,
        fecha,
        recinto,
        nombre_grada,
        localidad,
        tipo_usuario
    )
    VALUES (
        p_nombre_espectaculo,
        p_fecha,
        p_recinto,
        p_nombre_grada,
        p_localidad,
        p_tipo_usuario
    );

    INSERT INTO vendida(
        dni_cliente,
        nombre_espectaculo,
        fecha,
        recinto,
        nombre_grada,
        localidad,
        tipo_usuario
    )
    VALUES (
        p_dni_cliente,
        p_nombre_espectaculo,
        p_fecha,
        p_recinto,
        p_nombre_grada,
        p_localidad,
        p_tipo_usuario
    );

    UPDATE entrada
    SET estado = 'vendida'
    WHERE nombre_espectaculo = p_nombre_espectaculo
      AND fecha = p_fecha
      AND recinto = p_recinto
      AND nombre_grada = p_nombre_grada
      AND localidad = p_localidad;
END $$

DELIMITER ;