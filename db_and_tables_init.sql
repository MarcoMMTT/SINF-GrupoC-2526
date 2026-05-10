DROP DATABASE IF EXISTS GrupoC;
CREATE DATABASE GrupoC;
USE GrupoC;
--
-- Script creado una vez se hizo el modelo relacional del proyecto
--

-- Una vez ejecutado la primera vez comentar lo de drop database y create database

-- Creación de tablas fuertes (sin dependencias)
DROP TABLE IF EXISTS Vendida;
DROP TABLE IF EXISTS Oferta;
DROP TABLE IF EXISTS Entrada;
DROP TABLE IF EXISTS Grada;
DROP TABLE IF EXISTS Evento;
DROP TABLE IF EXISTS Espectaculo;
DROP TABLE IF EXISTS Usuario;
DROP TABLE IF EXISTS Cliente;

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
    numero_cuenta VARCHAR(50) UNIQUE
);



CREATE TABLE Evento ( -- OK
    Nombre_espectaculo VARCHAR(50) NOT NULL,
    Recinto VARCHAR(100) NOT NULL,
    Fecha TIMESTAMP NOT NULL, 
    Estado VARCHAR(20) NOT NULL,

    PRIMARY KEY (Fecha, Recinto),
    FOREIGN KEY (Nombre_espectaculo) REFERENCES Espectaculo(Nombre_espectaculo)
        ON UPDATE CASCADE 
        ON DELETE CASCADE,
    CHECK (Estado IN ('finalizado', 'abierto', 'cerrado'))
);

CREATE TABLE Grada ( -- OK
    Nombre_Grada VARCHAR(100),
    Fecha TIMESTAMP NOT NULL,
    Recinto VARCHAR(100) NOT NULL,
    PRIMARY KEY(Nombre_Grada, Fecha, Recinto),
    FOREIGN KEY (Fecha, Recinto)
        REFERENCES Evento(Fecha, Recinto)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
CREATE TABLE Oferta (
    Precio INTEGER NOT NULL,
    Recinto VARCHAR(100) NOT NULL,
    Fecha TIMESTAMP NOT NULL, 
    Nombre_grada VARCHAR(100) NOT NULL,
    Tipo  VARCHAR(50) NOT NULL,

    PRIMARY KEY (Recinto, Fecha, Nombre_Grada, Tipo),
    FOREIGN KEY (Fecha, Recinto) REFERENCES Evento(Fecha, Recinto)
        ON UPDATE CASCADE 
        ON DELETE CASCADE,
    FOREIGN KEY (Nombre_grada, Fecha, Recinto) REFERENCES Grada(Nombre_Grada, Fecha, Recinto)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (Tipo) REFERENCES Usuario(Tipo)
        ON UPDATE CASCADE 
        ON DELETE RESTRICT,
    CHECK (Precio > 0)
);

CREATE TABLE Entrada ( 
    Fecha TIMESTAMP NOT NULL,
    Recinto VARCHAR(100) NOT NULL,
    Nombre_grada VARCHAR(100) NOT NULL,
    Localidad VARCHAR(100) NOT NULL,
    Estado VARCHAR(50),
    
    PRIMARY KEY (Fecha, Recinto, Nombre_grada, Localidad),
    FOREIGN KEY (Fecha, Recinto) REFERENCES Evento(Fecha, Recinto)
        ON UPDATE CASCADE 
        ON DELETE CASCADE,
    FOREIGN KEY (Nombre_grada, Fecha, Recinto) REFERENCES Grada(Nombre_Grada, Fecha, Recinto)
        ON UPDATE CASCADE 
        ON DELETE CASCADE,
    CHECK (Estado IN ('libre', 'deteriorado')) -- deteriorado: ya pasó el evento.
);

CREATE TABLE Vendida (
    Nombre_grada VARCHAR(100) NOT NULL,
    Tipo VARCHAR(50) NOT NULL,
    Fecha TIMESTAMP NOT NULL,
    Recinto VARCHAR(100) NOT NULL,
    DNI VARCHAR(20) NOT NULL,
    Localidad VARCHAR(100) NOT NULL,

    PRIMARY KEY (Nombre_Grada, Tipo, Fecha, Recinto, DNI, Localidad),
    FOREIGN KEY (Fecha, Recinto) REFERENCES Evento(Fecha, Recinto)
        ON UPDATE CASCADE,
    FOREIGN KEY (Nombre_grada, Fecha, Recinto) REFERENCES Grada(Nombre_Grada, Fecha, Recinto)
        ON UPDATE CASCADE,
    FOREIGN KEY (Tipo) REFERENCES Usuario(Tipo)
        ON UPDATE CASCADE 
        ON DELETE RESTRICT,
    FOREIGN KEY (DNI) REFERENCES Cliente(DNI)
        ON UPDATE CASCADE 
        ON DELETE RESTRICT,
    FOREIGN KEY (Fecha, Recinto, Nombre_grada, Localidad) REFERENCES Entrada(Fecha, Recinto, Nombre_grada, Localidad)
        ON UPDATE CASCADE 
        ON DELETE RESTRICT,
    UNIQUE (Fecha, Recinto, Nombre_grada, Localidad)
);
 