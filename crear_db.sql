-- Esquema relacional derivado del modelo E-A de taquilla virtual
-- PostgreSQL

DROP TABLE IF EXISTS vendida CASCADE;
DROP TABLE IF EXISTS oferta_entrada CASCADE;
DROP TABLE IF EXISTS oferta CASCADE;
DROP TABLE IF EXISTS entrada CASCADE;
DROP TABLE IF EXISTS aforo CASCADE;
DROP TABLE IF EXISTS grada CASCADE;
DROP TABLE IF EXISTS evento CASCADE;
DROP TABLE IF EXISTS espectaculo CASCADE;
DROP TABLE IF EXISTS usuario CASCADE;
DROP TABLE IF EXISTS cliente CASCADE;

CREATE TABLE espectaculo (
    nombre VARCHAR(120) PRIMARY KEY,
    descripcion TEXT,
    tipo VARCHAR(30) NOT NULL,
    CHECK (tipo IN ('deportivo', 'musical', 'teatral', 'cultural', 'otro'))
);

CREATE TABLE evento (
    nombre_espectaculo VARCHAR(120) NOT NULL,
    fecha TIMESTAMP NOT NULL,
    recinto VARCHAR(120) NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'abierto',
    PRIMARY KEY (nombre_espectaculo, fecha, recinto),
    FOREIGN KEY (nombre_espectaculo)
        REFERENCES espectaculo(nombre)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CHECK (estado IN ('abierto', 'cerrado', 'finalizado'))
);

CREATE TABLE aforo (
    huecos INTEGER PRIMARY KEY,
    CHECK (huecos >= 0)
);

CREATE TABLE grada (
    nombre_espectaculo VARCHAR(120) NOT NULL,
    fecha TIMESTAMP NOT NULL,
    recinto VARCHAR(120) NOT NULL,
    nombre VARCHAR(80) NOT NULL,
    huecos INTEGER NOT NULL,

    PRIMARY KEY (nombre_espectaculo, fecha, recinto, nombre),

    FOREIGN KEY (nombre_espectaculo, fecha, recinto)
        REFERENCES evento(nombre_espectaculo, fecha, recinto)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    FOREIGN KEY (huecos)
        REFERENCES aforo(huecos)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE entrada (
    nombre_espectaculo VARCHAR(120) NOT NULL,
    fecha TIMESTAMP NOT NULL,
    recinto VARCHAR(120) NOT NULL,
    nombre_grada VARCHAR(80) NOT NULL,
    localidad VARCHAR(30) NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'libre',
    PRIMARY KEY (nombre_espectaculo, fecha, recinto, nombre_grada, localidad),
    FOREIGN KEY (nombre_espectaculo, fecha, recinto, nombre_grada)
        REFERENCES grada(nombre_espectaculo, fecha, recinto, nombre)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CHECK (estado IN ('libre', 'reservada', 'vendida', 'deteriorada'))
);

CREATE TABLE usuario (
    tipo VARCHAR(20) PRIMARY KEY,
    CHECK (tipo IN ('Adulto', 'Niño', 'Jubilado', 'Parado', 'Bebé'))
);

-- Relación Oferta entre Grada y Usuario, con atributo precio.
CREATE TABLE oferta (
    nombre_espectaculo VARCHAR(120) NOT NULL,
    fecha TIMESTAMP NOT NULL,
    recinto VARCHAR(120) NOT NULL,
    nombre_grada VARCHAR(80) NOT NULL,
    tipo_usuario VARCHAR(20) NOT NULL,
    precio NUMERIC(8,2) NOT NULL,
    PRIMARY KEY (nombre_espectaculo, fecha, recinto, nombre_grada, tipo_usuario),
    FOREIGN KEY (nombre_espectaculo, fecha, recinto, nombre_grada)
        REFERENCES grada(nombre_espectaculo, fecha, recinto, nombre)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (tipo_usuario)
        REFERENCES usuario(tipo)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CHECK (precio > 0)
);

-- Agregación Oferta + Entrada. Permite vender una entrada usando una oferta compatible.
CREATE TABLE oferta_entrada (
    nombre_espectaculo VARCHAR(120) NOT NULL,
    fecha TIMESTAMP NOT NULL,
    recinto VARCHAR(120) NOT NULL,
    nombre_grada VARCHAR(80) NOT NULL,
    localidad VARCHAR(30) NOT NULL,
    tipo_usuario VARCHAR(20) NOT NULL,
    PRIMARY KEY (nombre_espectaculo, fecha, recinto, nombre_grada, localidad, tipo_usuario),
    FOREIGN KEY (nombre_espectaculo, fecha, recinto, nombre_grada, tipo_usuario)
        REFERENCES oferta(nombre_espectaculo, fecha, recinto, nombre_grada, tipo_usuario)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (nombre_espectaculo, fecha, recinto, nombre_grada, localidad)
        REFERENCES entrada(nombre_espectaculo, fecha, recinto, nombre_grada, localidad)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE cliente (
    dni VARCHAR(15) PRIMARY KEY,
    numero_cuenta VARCHAR(34) NOT NULL UNIQUE
);

-- Relación Vendida entre Cliente y la agregación OfertaEntrada.
CREATE TABLE vendida (
    dni_cliente VARCHAR(15) NOT NULL,
    nombre_espectaculo VARCHAR(120) NOT NULL,
    fecha TIMESTAMP NOT NULL,
    recinto VARCHAR(120) NOT NULL,
    nombre_grada VARCHAR(80) NOT NULL,
    localidad VARCHAR(30) NOT NULL,
    tipo_usuario VARCHAR(20) NOT NULL,
    fecha_venta TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (nombre_espectaculo, fecha, recinto, nombre_grada, localidad),
    FOREIGN KEY (dni_cliente)
        REFERENCES cliente(dni)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (nombre_espectaculo, fecha, recinto, nombre_grada, localidad, tipo_usuario)
        REFERENCES oferta_entrada(nombre_espectaculo, fecha, recinto, nombre_grada, localidad, tipo_usuario)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);
