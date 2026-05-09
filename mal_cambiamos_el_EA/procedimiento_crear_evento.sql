DELIMITER $$

CREATE PROCEDURE crear_evento_completo(
    IN p_nombre_espectaculo VARCHAR(120),
    IN p_descripcion TEXT,
    IN p_tipo VARCHAR(50),
    IN p_fecha DATETIME,
    IN p_recinto VARCHAR(120),
    IN p_estado VARCHAR(20)
)
BEGIN

    INSERT IGNORE INTO espectaculo(nombre, descripcion, tipo)
    VALUES (
        p_nombre_espectaculo,
        p_descripcion,
        p_tipo
    );

    INSERT INTO evento(
        nombre_espectaculo,
        fecha,
        recinto,
        estado
    )
    VALUES (
        p_nombre_espectaculo,
        p_fecha,
        p_recinto,
        p_estado
    );

END $$

DELIMITER ;