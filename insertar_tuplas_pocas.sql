-- Primero eliminamos el procedimiento si ya existe para evitar errores de creación
DROP PROCEDURE IF EXISTS ejemplo_tuplas;

DELIMITER //

CREATE PROCEDURE ejemplo_tuplas()
BEGIN
    -- 1. Tablas Maestras (Sin dependencias)
    INSERT INTO Espectaculo (Nombre_espectaculo, Descripcion, Tipo) VALUES 
    ('Rock Fest 2024', 'Festival de rock con bandas locales', 'Concierto'),
    ('Hamlet', 'Obra clásica de Shakespeare', 'Teatro');

    INSERT INTO Usuario (Tipo) VALUES 
    ('Jubilado'), ('Adulto'), ('Infantil'), ('Parado'), ('Bebé');

    INSERT INTO Cliente (DNI, numero_cuenta) VALUES 
    ('12345678A', 'ES12345678901234567890'),
    ('87654321B', 'ES09876543210987654321');

    INSERT INTO Grada (Nombre_Grada) VALUES 
    ('Pista Principal'), 
    ('Palco VIP'), 
    ('Anfiteatro');

    -- 2. Tablas con Dependencias Simples
    INSERT INTO Aforo (Huecos, Nombre_grada) VALUES 
    (500, 'Pista Principal'),
    (50, 'Palco VIP'),
    (200, 'Anfiteatro');

    INSERT INTO Evento (Nombre_espectaculo, Recinto, Fecha, Estado) VALUES 
    ('Rock Fest 2024', 'Estadio Balaídos', '2024-07-15 21:00:00', 'abierto'),
    ('Hamlet', 'Teatro García Barbón', '2024-08-20 19:30:00', 'abierto');

    -- 3. Tablas de Relación
    INSERT INTO Esta (Fecha, Recinto, Nombre_grada) VALUES 
    ('2024-07-15 21:00:00', 'Estadio Balaídos', 'Pista Principal'),
    ('2024-07-15 21:00:00', 'Estadio Balaídos', 'Palco VIP'),
    ('2024-08-20 19:30:00', 'Teatro García Barbón', 'Anfiteatro');

    INSERT INTO Oferta (Precio, Recinto, Fecha, Nombre_grada, Tipo) VALUES 
    (50, 'Estadio Balaídos', '2024-07-15 21:00:00', 'Pista Principal', 'Adulto'),
    (40, 'Estadio Balaídos', '2024-07-15 21:00:00', 'Pista Principal', 'Jubilado'),
    (150, 'Estadio Balaídos', '2024-07-15 21:00:00', 'Palco VIP', 'Adulto'),
    (30, 'Teatro García Barbón', '2024-08-20 19:30:00', 'Anfiteatro', 'Adulto');

    -- 4. Creación de Entradas
    INSERT INTO Entrada (Fecha, Recinto, Nombre_grada, Localidad, Estado) VALUES 
    ('2024-07-15 21:00:00', 'Estadio Balaídos', 'Pista Principal', 'A-01', 'reservado'),
    ('2024-07-15 21:00:00', 'Estadio Balaídos', 'Pista Principal', 'A-02', 'libre'),
    ('2024-07-15 21:00:00', 'Estadio Balaídos', 'Palco VIP', 'VIP-01', 'reservado'),
    ('2024-08-20 19:30:00', 'Teatro García Barbón', 'Anfiteatro', 'Fila1-05', 'libre');

    -- 5. Registro de Ventas
    INSERT INTO Vendida (Nombre_grada, Tipo, Fecha, Recinto, Nombre_espectaculo, DNI, Localidad) VALUES 
    ('Pista Principal', 'Adulto', '2024-07-15 21:00:00', 'Estadio Balaídos', 'Rock Fest 2024', '12345678A', 'A-01'),
    ('Palco VIP', 'Adulto', '2024-07-15 21:00:00', 'Estadio Balaídos', 'Rock Fest 2024', '87654321B', 'VIP-01');

END //

DELIMITER ;