DELIMITER $$

CREATE PROCEDURE crear_grada_con_entradas(
    IN p_nombre_espectaculo VARCHAR(120),
    IN p_fecha DATETIME,
    IN p_recinto VARCHAR(120),
    IN p_nombre_grada VARCHAR(80),
    IN p_huecos INT
)
BEGIN
    DECLARE i INT DEFAULT 1;

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

    WHILE i <= p_huecos DO
        INSERT INTO entrada(
            nombre_espectaculo,
            fecha,
            recinto,
            nombre_grada,
            localidad,
            estado
        )
        VALUES (
            p_nombre_espectaculo,
            p_fecha,
            p_recinto,
            p_nombre_grada,
            CONCAT('E', i),
            'libre'
        );

        SET i = i + 1;
    END WHILE;
END $$

DELIMITER ;