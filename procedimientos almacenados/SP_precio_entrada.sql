USE GrupoC;
DELIMITER $$

CREATE PROCEDURE PrecioEntradaParaCliente(
    IN p_fecha        TIMESTAMP,
    IN p_recinto      VARCHAR(100),
    IN p_nombre_grada VARCHAR(100),
    IN p_tipo_usuario VARCHAR(50)
)
BEGIN
    DECLARE v_precio         INTEGER DEFAULT NULL;
    DECLARE v_estado_evento  VARCHAR(20);

    -- Validar que el tipo de usuario es válido
    IF NOT EXISTS (
        SELECT 1 FROM Usuario WHERE Tipo = p_tipo_usuario
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El tipo de usuario indicado no es válido.';
    END IF;

    -- Validar que el evento existe y está abierto
    SELECT Estado INTO v_estado_evento
    FROM Evento
    WHERE Fecha = p_fecha AND Recinto = p_recinto;

    IF v_estado_evento IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El evento indicado no existe.';
    END IF;

    IF v_estado_evento != 'abierto' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El evento no está en estado abierto.';
    END IF;

    -- Validar que la grada pertenece al evento
    IF NOT EXISTS (
        SELECT 1 FROM Grada
        WHERE Nombre_Grada = p_nombre_grada
          AND Fecha        = p_fecha
          AND Recinto      = p_recinto
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La grada indicada no pertenece a este evento.';
    END IF;

    -- Obtener el precio
    SELECT Precio INTO v_precio
    FROM Oferta
    WHERE Fecha        = p_fecha
      AND Recinto      = p_recinto
      AND Nombre_Grada = p_nombre_grada
      AND Tipo         = p_tipo_usuario;

    IF v_precio IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No existe oferta para este tipo de usuario en esa grada.';
    END IF;

    -- Devolver resultado
    SELECT
        p_fecha                         AS Fecha_Evento,
        p_recinto                       AS Recinto,
        p_nombre_grada                  AS Grada,
        p_tipo_usuario                  AS Tipo_Usuario,
        v_precio                        AS Precio;

END$$

DELIMITER ;