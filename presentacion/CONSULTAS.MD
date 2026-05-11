# CONSULTAS PARA HACER EN CLASE
## Experiencia de Usuario:

# ENTRADAS DISPONIBLES PARA UN EVENTO DETERMINADO 
CALL EntradasDisponiblesPorEvento('2026-01-16 20:00:00', 'Camp Nou');

# VER EVENTOS DE UN DETERMINADO ESPECTÁCULO
CALL VerEventosEspectaculo('Concierto David Bisbal');

# VER PRECIO DE ENTRADAS PARA UN EVENTO DADO
CALL PrecioEntradaParaCliente('2026-01-01 16:00:00', 'Cine Yelmo Travesía', 'Fila A', 'Adulto');

CALL PrecioEntradaParaCliente('2026-01-01 16:00:00', 'Cine Yelmo Travesía', 'Fila A', 'Infantil');

# VER HISTORIAL DE VENTAS CLIENTE
CALL VerHistorialVentasCliente('DNI00001000');


# REALIZAR VENTA
CALL Venta('DNI00000001', 'Auditorio Alfredo Kraus', '2026-01-03 11:00:00', 'Anfiteatro', 'L0005','Adulto');
# Comprobaciones:
SELECT * FROM Entrada WHERE Fecha = '2026-01-03 11:00:00' AND Recinto = 'Auditorio Alfredo Kraus' AND Nombre_grada = 'Anfiteatro' AND Localidad = 'L0005';
SELECT * FROM Vendida WHERE Fecha = '2026-01-03 11:00:00' AND Recinto = 'Auditorio Alfredo Kraus' AND Nombre_grada = 'Anfiteatro' AND Localidad = 'L0005';

# REALIZAR ANULACIÓN
CALL CancelarCompra('DNI00000001','2026-01-03 11:00:00','Auditorio Alfredo Kraus', 'Anfiteatro', 'L0005');

COMPROBACION DE NO CANCELAR LA COMPRA DE OTRO (Cambiar el DNI)


## Experiencia de Administrador:

# VER DINERO GANADO
Call VerDineroGanado();

# CLIENTE QUE MÁS HA GASTADO
CALL ClienteQueMasHaGastado()

# VER ENTRADAS DISPONIBLES
CALL EntradasDisponiblesPorMes(4, 2026);
CALL EntradasDisponiblesPorDia('2026-03-04');
CALL EntradasSinVenderSimple();
CALL EntradasDisponiblesGeneral();

# CREAR EVENTO


Comprobaciones Previas:

SI ES UN ESPECTÁCULO NUEVO, ANTES DE NADA:
INSERT IGNORE INTO Espectaculo(Nombre_espectaculo, Descripcion, Tipo)
VALUES ('Celta Levante', 'Partido de liga', 'deportivo');

SELECT * FROM Evento WHERE Recinto = 'Estadio Balaídos' AND Fecha = '2026-05-12 19:00:00';

CALL CrearEvento(     'Celta Levante',      'Estadio Balaídos',      '2026-05-12 19:00:00',     '[
        {"nombre": "Pista Principal", "cantidad": 100},
        {"nombre": "Palco VIP", "cantidad": 50},
        {"nombre": "Anfiteatro", "cantidad": 200}
    ]',     '[
        {"grada": "Pista Principal", "tipo": "Adulto", "precio": 50},
        {"grada": "Pista Principal", "tipo": "Jubilado", "precio": 40},
        {"grada": "Palco VIP", "tipo": "Adulto", "precio": 150},
        {"grada": "Anfiteatro", "tipo": "Infantil", "precio": 25}
    ]' );


# Añadir Grada 
CALL AnadirGrada(     '2026-05-12 19:00:00',     'Estadio Balaídos',
'MARCADOR SKY CLUB',     25,     '[
        {"tipo": "Adulto", "precio": 150},
        {"tipo": "Jubilado", "precio": 120},
        {"tipo": "Infantil", "precio": 100}
    ]' );

COMPROBACIONES:
SELECT * FROM Grada WHERE Fecha = '2026-05-12 19:00:00' AND Recinto = 'Estadio Balaídos' AND Nombre_Grada = 'MARCADOR SKY CLUB';

SELECT COUNT(*) AS entradas_creadas FROM Entrada WHERE Fecha = '2026-05-12 19:00:00' AND Recinto = 'Estadio Balaídos' AND Nombre_grada = 'MARCADOR SKY CLUB';

SELECT * FROM Oferta WHERE Fecha = '2026-05-12 19:00:00' AND Recinto = 'Estadio Balaídos' AND Nombre_grada = 'MARCADOR SKY CLUB';