USE GrupoC;
DROP TABLE IF EXISTS recintos_demo;

CREATE TABLE recintos_demo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    tipo_recinto VARCHAR(30) NOT NULL
);

INSERT INTO recintos_demo(nombre, tipo_recinto) VALUES
-- Estadios
('Estadio de Balaídos', 'estadio'),
('Santiago Bernabéu', 'estadio'),
('Camp Nou', 'estadio'),
('Wanda Metropolitano', 'estadio'),
('Benito Villamarín', 'estadio'),
('Ramón Sánchez-Pizjuán', 'estadio'),
('Mestalla', 'estadio'),
('San Mamés', 'estadio'),
('Reale Arena', 'estadio'),
('La Cartuja', 'estadio'),
('Riazor', 'estadio'),
('El Sadar', 'estadio'),
('Mendizorroza', 'estadio'),
('Estadio José Zorrilla', 'estadio'),
('Estadio de Gran Canaria', 'estadio'),

-- Pabellones / arenas
('WiZink Center', 'pabellon'),
('Palau Sant Jordi', 'pabellon'),
('Bilbao Arena', 'pabellon'),
('Martín Carpena', 'pabellon'),
('Roig Arena', 'pabellon'),
('Fernando Buesa Arena', 'pabellon'),
('Navarra Arena', 'pabellon'),
('Palacio Vistalegre', 'pabellon'),
('Pabellón Príncipe Felipe', 'pabellon'),
('Pavelló Olímpic de Badalona', 'pabellon'),

-- Teatros
('Teatro Real', 'teatro'),
('Teatro Lope de Vega', 'teatro'),
('Teatro Gran Vía', 'teatro'),
('Teatro Coliseum', 'teatro'),
('Teatro Arriaga', 'teatro'),
('Teatro Campoamor', 'teatro'),
('Teatro Calderón', 'teatro'),
('Teatro Cervantes', 'teatro'),
('Gran Teatro del Liceu', 'teatro'),
('Teatro Principal de Alicante', 'teatro'),

-- Auditorios
('Auditorio Nacional', 'auditorio'),
('Auditorio de Galicia', 'auditorio'),
('Auditorio Alfredo Kraus', 'auditorio'),
('Auditorio Kursaal', 'auditorio'),
('Auditorio Baluarte', 'auditorio'),
('Auditorio de Tenerife', 'auditorio'),
('Palacio Euskalduna', 'auditorio'),
('Auditorio Mar de Vigo', 'auditorio'),

-- Ferias / congresos
('IFEMA Madrid', 'feria'),
('Fira Barcelona', 'feria'),
('Palacio de Congresos de Valencia', 'feria'),
('Palacio de Congresos de Sevilla', 'feria'),
('Palacio de Ferias de Málaga', 'feria'),
('ExpoCoruña', 'feria'),
('Cidade da Cultura', 'feria');