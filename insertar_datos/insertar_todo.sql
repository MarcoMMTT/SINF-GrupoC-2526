USE GrupoC;

SELECT '========== INICIO DE CARGA ==========' AS Estado;

SELECT 'Cargando numeros_aux.sql...' AS Estado;
SOURCE numeros_aux.sql;
SELECT 'OK numeros_aux.sql' AS Estado;

SELECT 'Cargando insertar_usuarios.sql...' AS Estado;
SOURCE insertar_usuarios.sql;
SELECT 'OK insertar_usuarios.sql' AS Estado;

SELECT 'Cargando isertar_espectaculos.sql...' AS Estado;
SOURCE isertar_espectaculos.sql;
SELECT 'OK isertar_espectaculos.sql' AS Estado;

SELECT 'Cargando recintos_aux.sql...' AS Estado;
SOURCE recintos_aux.sql;
SELECT 'OK recintos_aux.sql' AS Estado;

SELECT 'Cargando clientes.sql...' AS Estado;
SOURCE clientes.sql;
SELECT 'OK clientes.sql' AS Estado;

SELECT 'Cargando insertar_evento.sql...' AS Estado;
SOURCE insertar_evento.sql;
SELECT 'OK insertar_evento.sql' AS Estado;

SELECT 'Cargando insertar_gradas_y_aforo.sql...' AS Estado;
SOURCE insertar_gradas_y_aforo.sql;
SELECT 'OK insertar_gradas_y_aforo.sql' AS Estado;

SELECT 'Cargando oferta.sql...' AS Estado;
SOURCE oferta.sql;
SELECT 'OK oferta.sql' AS Estado;

SELECT 'Cargando entradas.sql...' AS Estado;
SOURCE entradas.sql;
SELECT 'OK entradas.sql' AS Estado;

SELECT 'Cargando ventas.sql...' AS Estado;
SOURCE ventas.sql;
SELECT 'OK ventas.sql' AS Estado;

SELECT '========== FIN DE CARGA ==========' AS Estado;

SELECT COUNT(*) AS espectaculos FROM Espectaculo;
SELECT COUNT(*) AS eventos FROM Evento;
SELECT COUNT(*) AS gradas FROM Grada;
SELECT COUNT(*) AS ofertas FROM Oferta;
SELECT COUNT(*) AS entradas FROM Entrada;
SELECT COUNT(*) AS ventas FROM Vendida;
SELECT COUNT(*) AS clientes FROM Cliente;