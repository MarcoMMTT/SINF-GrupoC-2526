-- Creación de tablas fuertes (sin dependencias)
CREATE TABLE Espectaculo (
    Nombre_espectaculo VARCHAR(150) PRIMARY KEY,
    Descripcion TEXT,
    tipo VARCHAR(50)
);

CREATE TABLE Usuario (
    Tipo VARCHAR(50) PRIMARY KEY -- ⚠️ ATENCIÓN: Revisar este diseño
);

CREATE TABLE Cliente (
    DNI VARCHAR(20) PRIMARY KEY,
    numero_cuenta VARCHAR(50)
);

CREATE TABLE Grada (
    Nombre_Grada VARCHAR(100) PRIMARY KEY
);

CREATE TABLE Recinto (
    Nombre_Recinto VARCHAR(100) PRIMARY KEY
);

-- Creación de tablas con dependencias (Claves Foráneas)
CREATE TABLE Aforo (
    Huecos INT PRIMARY KEY, -- ⚠️ ATENCIÓN: Revisar este diseño
    Nombre_grada VARCHAR(100),
    FOREIGN KEY (Nombre_grada) REFERENCES Grada(Nombre_Grada)
);

CREATE TABLE Oferta (
    Nombre_Espectaculo VARCHAR(150),
    Recinto VARCHAR(100),
    PRIMARY KEY (Nombre_Espectaculo, Recinto),
    FOREIGN KEY (Nombre_Espectaculo) REFERENCES Espectaculo(Nombre_espectaculo),
    FOREIGN KEY (Recinto) REFERENCES Recinto(Nombre_Recinto)
);

CREATE TABLE Entrada (
    Fecha DATE,
    Recinto VARCHAR(100),
    Nombre_grada VARCHAR(100),
    Localidad VARCHAR(100),
    Estado VARCHAR(50),
    PRIMARY KEY (Fecha, Recinto, Nombre_grada, Localidad),
    FOREIGN KEY (Recinto) REFERENCES Recinto(Nombre_Recinto),
    FOREIGN KEY (Nombre_grada) REFERENCES Grada(Nombre_Grada)
);