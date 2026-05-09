CREATE OR REPLACE PROCEDURE crear_oferta_completa(
    p_nombre_espectaculo VARCHAR,
    p_fecha TIMESTAMP,
    p_recinto VARCHAR,
    p_nombre_grada VARCHAR,
    p_tipo_usuario VARCHAR,
    p_precio NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO usuario(tipo)
    VALUES (p_tipo_usuario)
    ON CONFLICT (tipo) DO NOTHING;

    INSERT INTO oferta(
        nombre_espectaculo,
        fecha,
        recinto,
        nombre_grada,
        tipo_usuario,
        precio
    )
    VALUES (
        p_nombre_espectaculo,
        p_fecha,
        p_recinto,
        p_nombre_grada,
        p_tipo_usuario,
        p_precio
    );
END;
$$;