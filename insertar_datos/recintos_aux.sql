USE GrupoC;
DROP TABLE IF EXISTS recintos_demo;

CREATE TABLE recintos_demo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO recintos_demo(nombre) VALUES
('RCDE Stadium'),
('Riazor'),
('Mendizorroza'),
('Nuevo Mirandilla'),
('El Sadar'),
('Anoeta'),
('Estadio José Zorrilla'),
('Power Horse Stadium'),
('Estadio de Gran Canaria'),
('Heliodoro Rodríguez López'),

('Fernando Buesa Arena'),
('Pabellón Olímpico de Badalona'),
('Palacio Vistalegre'),
('Olímpic Arena'),
('Navarra Arena'),
('Pabellón Insular Santiago Martín'),
('Pabellón Fontes do Sar'),
('Pazo dos Deportes de Lugo'),
('Pabellón Multiusos Sánchez Paraíso'),
('Arena Valencia'),

('Teatro Calderón'),
('Teatro Cervantes'),
('Gran Teatro del Liceu'),
('Teatro Principal de Alicante'),
('Teatro Campos Elíseos'),
('Teatro Olympia'),
('Teatro Gayarre'),
('Teatro Romea'),
('Teatro Victoria Eugenia'),
('Teatro Principal de Palma'),

('Auditorio Kursaal'),
('Auditorio Baluarte'),
('Auditorio de Tenerife'),
('Palacio Euskalduna'),
('Ciudad de las Artes y las Ciencias'),
('Palacio de Ferias de Málaga'),
('Centro Niemeyer'),
('Palexco'),
('Auditorio Mar de Vigo'),
('Ciudad de la Cultura'),

('Circuito de Jerez'),
('Circuito Ricardo Tormo'),
('Circuit de Barcelona-Catalunya'),
('Movistar Arena'),
('Arena Coruña'),
('Arena Zaragoza'),
('Arena Murcia'),
('Arena Sevilla'),
('Arena Málaga'),
('Arena Alicante');