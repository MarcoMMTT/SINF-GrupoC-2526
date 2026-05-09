--
-- Script creado una vez se hizo el modelo relacional del proyecto
--

DROP DATABASE IF EXISTS GrupoC;
CREATE DATABASE GrupoC;
USE GrupoC;

-- Creación de tablas fuertes (sin dependencias)
DROP TABLE IF EXISTS Vendida CASCADE;
DROP TABLE IF EXISTS Oferta CASCADE;
DROP TABLE IF EXISTS Entrada CASCADE;
DROP TABLE IF EXISTS Aforo CASCADE;
DROP TABLE IF EXISTS Grada CASCADE;
DROP TABLE IF EXISTS Evento CASCADE;
DROP TABLE IF EXISTS Espectaculo CASCADE;
DROP TABLE IF EXISTS Usuario CASCADE;
DROP TABLE IF EXISTS Cliente CASCADE;
DROP TABLE IF EXISTS Aforo CASCADE;

CREATE TABLE Espectaculo ( -- OK
    Nombre_espectaculo VARCHAR(50) PRIMARY KEY,
    Descripcion TEXT,
    Tipo VARCHAR(50)
);

CREATE TABLE Usuario ( -- OK
    Tipo VARCHAR(50) PRIMARY KEY,
    CHECK (Tipo IN ('Jubilado', 'Adulto', 'Infantil', 'Parado', 'Bebé'))
);

CREATE TABLE Cliente ( -- OK
    DNI VARCHAR(20) PRIMARY KEY,
    numero_cuenta VARCHAR(50)
);

CREATE TABLE Grada ( -- OK
    Nombre_Grada VARCHAR(100) PRIMARY KEY
);

-- Creación de tablas con dependencias (Claves Foráneas)
CREATE TABLE Aforo (-- OK
    Huecos INT PRIMARY KEY, 
    Nombre_grada VARCHAR(100) NOT NULL,

    FOREIGN KEY (Nombre_grada) REFERENCES Grada(Nombre_Grada),
    CHECK (Huecos > 0)
);

CREATE TABLE Evento ( -- OK
    Nombre_espectaculo VARCHAR(50) NOT NULL,
    Recinto VARCHAR(50) NOT NULL,
    Fecha TIMESTAMP NOT NULL, 
    Estado VARCHAR(20) NOT NULL,

    PRIMARY KEY (Recinto, Fecha),
    FOREIGN KEY (Nombre_espectaculo) REFERENCES Espectaculo(Nombre_espectaculo),
    CHECK (Estado IN ('finalizado', 'abierto', 'cerrado'))
);

CREATE TABLE Oferta (
    Precio INTEGER NOT NULL,
    Recinto VARCHAR(100) NOT NULL,
    Fecha TIMESTAMP NOT NULL, 
    Nombre_grada VARCHAR(100) NOT NULL,
    Tipo  VARCHAR(50) NOT NULL,

    PRIMARY KEY (Recinto, Fecha, Nombre_Grada, Tipo),
    FOREIGN KEY (Recinto, Fecha) REFERENCES Evento(Recinto, Fecha),
    FOREIGN KEY (Nombre_grada) REFERENCES Grada(Nombre_Grada),
    FOREIGN KEY (Tipo) REFERENCES Usuario(Tipo),
    CHECK (Precio > 0)
);

CREATE TABLE Entrada ( -- OK
    Fecha TIMESTAMP NOT NULL,
    Recinto VARCHAR(50) NOT NULL,
    Nombre_grada VARCHAR(100) NOT NULL,
    Localidad VARCHAR(100) NOT NULL,
    Estado VARCHAR(50),
    
    PRIMARY KEY (Fecha, Recinto, Nombre_grada, Localidad),
    FOREIGN KEY (Recinto, Fecha) REFERENCES Evento(Recinto, Fecha),
    FOREIGN KEY (Nombre_grada) REFERENCES Grada(Nombre_Grada),
    CHECK (Estado IN ('libre', 'reservado', 'deteriorado')) -- deteriorado: ya pasó el evento.
);

CREATE TABLE Vendida (
    Nombre_grada VARCHAR(100) NOT NULL,
    Tipo VARCHAR(50) NOT NULL,
    Fecha TIMESTAMP NOT NULL,
    Recinto VARCHAR(50) NOT NULL,
    Nombre_espectaculo VARCHAR(50) NOT NULL,
    DNI VARCHAR(20) NOT NULL,
    Localidad VARCHAR(100) NOT NULL,

    PRIMARY KEY (Nombre_Grada, Tipo, Fecha, Recinto, Nombre_espectaculo, DNI, Localidad),
    FOREIGN KEY (Recinto, Fecha) REFERENCES Evento(Recinto, Fecha),
    FOREIGN KEY (Nombre_grada) REFERENCES Grada(Nombre_Grada),
    FOREIGN KEY (Nombre_espectaculo) REFERENCES Espectaculo(Nombre_espectaculo),
    FOREIGN KEY (Tipo) REFERENCES Usuario(Tipo),
    FOREIGN KEY (DNI) REFERENCES Cliente(DNI),
    FOREIGN KEY (Fecha, Recinto, Nombre_grada, Localidad) REFERENCES Entrada(Fecha, Recinto, Nombre_grada, Localidad)
);
 

CREATE TABLE Esta (
    Fecha TIMESTAMP NOT NULL,
    Recinto VARCHAR(50) NOT NULL,
    Nombre_grada VARCHAR(100) NOT NULL,

    PRIMARY KEY (Nombre_grada,Recinto, Fecha),
    FOREIGN KEY (Recinto, Fecha) REFERENCES Evento(Recinto, Fecha),
    FOREIGN KEY (Nombre_grada) REFERENCES Grada(Nombre_Grada)
);