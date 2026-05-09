DELIMITER $$

CREATE PROCEDURE crear_grada_completa(
    IN p_nombre_espectaculo VARCHAR(120),
    IN p_fecha DATETIME,
    IN p_recinto VARCHAR(120),
    IN p_nombre_grada VARCHAR(80),
    IN p_huecos INT
)
BEGIN

    INSERT IGNORE INTO aforo(huecos)
    VALUES (p_huecos);

    INSERT INTO grada(
        nombre_espectaculo,
        fecha,
        recinto,
        nombre,
        huecos
    )
    VALUES (
        p_nombre_espectaculo,
        p_fecha,
        p_recinto,
        p_nombre_grada,
        p_huecos
    );

END $$

DELIMITER ;