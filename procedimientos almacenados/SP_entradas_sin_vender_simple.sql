USE GrupoC;
DROP PROCEDURE IF EXISTS EntradasSinVenderSimple;

-- Cambiamos el delimitador temporalmente para que MySQL no corte el bloque en los punto y coma internos
DELIMITER //

CREATE PROCEDURE EntradasSinVenderSimple()
BEGIN
    SELECT COUNT(*) AS Entradas_Sin_Vender
    FROM Entrada
    WHERE Estado = 'libre';
END //

-- Restauramos el delimitador por defecto
DELIMITER ;