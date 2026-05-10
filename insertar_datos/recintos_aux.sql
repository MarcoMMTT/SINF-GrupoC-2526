USE GrupoC;
DROP TABLE IF EXISTS recintos_demo;

CREATE TABLE recintos_demo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO recintos_demo(nombre) VALUES
('Estadio de Balaídos'),
('Santiago Bernabéu'),
('Camp Nou'),
('Wanda Metropolitano'),
('Benito Villamarín'),
('San Mamés'),
('La Cartuja'),
('WiZink Center'),
('Palau Sant Jordi'),
('Bilbao Arena'),
('Martín Carpena'),
('Teatro Real'),
('Teatro Lope de Vega'),
('Teatro Gran Vía'),
('Auditorio Nacional'),
('Auditorio de Galicia'),
('IFEMA Madrid'),
('Fira Barcelona'),
('Kursaal San Sebastián'),
('Roig Arena');


-- =========================
-- RECINTOS AUXILIARES
-- =========================
-- Hay que añadir más 