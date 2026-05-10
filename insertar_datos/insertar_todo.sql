USE GrupoC;
-- =========================================
-- FICHERO MAESTRO DE CARGA
-- =========================================

SOURCE numeros_aux.sql;
SOURCE insertar_usuarios.sql;
SOURCE isertar_espectaculos.sql;
SOURCE recintos_aux.sql;
SOURCE clientes.sql;
SOURCE insertar_evento.sql;
SOURCE insertar_gradas_y_aforo.sql;
SOURCE oferta.sql;
SOURCE entradas.sql;
SOURCE ventas.sql;

-- =========================================
-- FIN DE CARGA
-- =========================================

-- =======================
-- VER LO QUE SE HA CREADO
-- =======================
SELECT COUNT(*) AS espectaculos FROM Espectaculo;
SELECT COUNT(*) AS eventos FROM Evento;
SELECT COUNT(*) AS gradas FROM Grada;
SELECT COUNT(*) AS ofertas FROM Oferta;
SELECT COUNT(*) AS entradas FROM Entrada;
SELECT COUNT(*) AS ventas FROM Vendida;
SELECT COUNT(*) AS clientes FROM Cliente;