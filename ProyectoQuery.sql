CREATE DATABASE TeamSmile_ShowInfantil_Database2;

USE TeamSmile_ShowInfantil_Database2;

-- Entidades

-- 1. Tabla Clientes
-- Almacena información de cada cliente que realiza una reservación.
CREATE TABLE Clientes (
    Id_cliente INT IDENTITY(1,1) PRIMARY KEY,          -- Identificador único de cada cliente.
    Nombre VARCHAR(100) NOT NULL,                      -- Nombre del cliente.
    Apellido VARCHAR(100),                             -- Apellido del cliente.
    Telefono VARCHAR(15),                              -- Teléfono de contacto del cliente.
    Correo_electronico VARCHAR(100),                   -- Correo electrónico del cliente.
	CONSTRAINT UC_Correo UNIQUE (Correo_electronico)   -- Restringe correos duplicados.
);

-- 2. Tabla Paquetes
-- Define los distintos paquetes de servicios que se pueden ofrecer para eventos.
CREATE TABLE Paquetes (
    Id_paquete INT IDENTITY(1,1) PRIMARY KEY,          -- Identificador único del paquete.
    Nombre_paquete VARCHAR(100) NOT NULL,              -- Nombre descriptivo del paquete.
    Descripcion TEXT,                                  -- Detalles del paquete.
    Disponibilidad BIT NOT NULL,                       -- Disponibilidad (1 = Disponible, 0 = No disponible).
    Costo DECIMAL(10, 2) NOT NULL                      -- Costo total del paquete.
);

-- 3. Tabla Eventos
-- Representa los eventos reservados, que pueden incluir un paquete y otros servicios.
CREATE TABLE Eventos (
    Id_evento INT IDENTITY(1,1) PRIMARY KEY,           -- Identificador único del evento.
    Fecha_inicio DATE NOT NULL,                        -- Fecha de inicio del evento.
    Hora_inicio TIME NOT NULL,                         -- Hora de inicio del evento.
    Hora_fin TIME NOT NULL,                            -- Hora de finalización del evento.
    Ubicacion VARCHAR(255),                            -- Ubicación o salón donde se realiza el evento.
    Direccion TEXT,                                    -- Dirección completa de la ubicación.
    Cantidad_de_asistentes INT,                        -- Número de asistentes al evento.
    Detalles_adicionales TEXT,                         -- Descripción adicional del evento.
    Id_paquete INT,                                    -- Relación con un paquete opcional.
    Id_cliente INT NOT NULL,                           -- Relación con el cliente que organiza el evento.
    CONSTRAINT CHK_Horario_Evento CHECK (Hora_fin > Hora_inicio), -- Asegura que la hora de fin sea posterior a la de inicio.
    CONSTRAINT FK_Eventos_Clientes FOREIGN KEY (Id_cliente) REFERENCES Clientes(Id_cliente),
    CONSTRAINT FK_Evento_Paquete FOREIGN KEY (Id_paquete) REFERENCES Paquetes(Id_paquete)
);

-- 4. Tabla Servicios
-- Almacena los servicios individuales que se pueden incluir en paquetes o eventos personalizados.
CREATE TABLE Servicios (
    Id_servicio INT IDENTITY(1,1) PRIMARY KEY,         -- Identificador único del servicio.
    Nombre_servicio VARCHAR(100) NOT NULL,             -- Nombre del servicio.
    Descripcion TEXT,                                  -- Descripción del servicio.
    Costo DECIMAL(10, 2) NOT NULL                      -- Costo unitario del servicio.
);

-- 5. Tabla Reservacion
-- Registra cada reservación realizada por un cliente, vinculada a un evento.
CREATE TABLE Reservacion (
    Id_reservacion INT IDENTITY(1,1) PRIMARY KEY,      -- Identificador único de la reservación.
    Id_cliente INT NOT NULL,                           -- Relación con el cliente que realiza la reservación.
    Id_evento INT NOT NULL,                            -- Relación con el evento reservado.
    Fecha_reserva DATE NOT NULL,                       -- Fecha en que se realiza la reservación.
	Pago_inicial DECIMAL(10, 2) NOT NULL,              -- Pago inicial realizado al momento de la reserva.
    Costo_total DECIMAL(10, 2) NOT NULL,               -- Costo total de la reservación.
    CONSTRAINT FK_Reservas_Clientes FOREIGN KEY (Id_cliente) REFERENCES Clientes(Id_cliente),
    CONSTRAINT FK_Reservas_Eventos FOREIGN KEY (Id_evento) REFERENCES Eventos(Id_evento)

	);

-- 9. Tabla Pagos
-- Almacena los pagos realizados para cada reservación.
CREATE TABLE Pagos (
    Id_pago INT IDENTITY(1,1) PRIMARY KEY,             -- Identificador único del pago.
    Id_reservacion INT NOT NULL,                       -- Relación con la reservación a la cual pertenece el pago.
    Monto DECIMAL(10, 2) NOT NULL,                     -- Monto del pago realizado.
    Fecha_pago DATE NOT NULL,                          -- Fecha en que se realizó el pago.
    Metodo_pago VARCHAR(50),                           -- Método de pago (ej., "Tarjeta", "Transferencia").
    Estado_pago VARCHAR(20) CHECK (Estado_pago IN ('Pendiente', 'Completado', 'Fallido', 'Reembolsado')), -- Estado del pago.
    CONSTRAINT FK_Pagos_Reservacion FOREIGN KEY (Id_reservacion) REFERENCES Reservacion(Id_reservacion)
);

-- 6. Tabla Empleados
-- Registra a los empleados que participan en los eventos.
CREATE TABLE Empleados (
    Id_empleado INT IDENTITY(1,1) PRIMARY KEY,         -- Identificador único del empleado.
    Nombre VARCHAR(100) NOT NULL,                      -- Nombre del empleado.
    Apellido VARCHAR(100) NOT NULL,                    -- Apellido del empleado.
    Telefono VARCHAR(15),                              -- Teléfono de contacto del empleado.
    Email VARCHAR(100)                                 -- Correo electrónico del empleado.
);

-- 7. Tabla Utileria
-- Almacena los elementos de utilería disponibles para los eventos.
CREATE TABLE Utileria (
    Id_utileria INT IDENTITY(1,1) PRIMARY KEY,         -- Identificador único de la utilería.
    Nombre VARCHAR(100),                               -- Nombre de la utilería (por ejemplo, "Globos").
    Cantidad INT,                                      -- Cantidad disponible de cada tipo de utilería.
	CONSTRAINT CHK_Cantidad_Positive CHECK (Cantidad >= 0) -- Restricción que asegura cantidades no negativas.
);

-- 8. Tabla Roles
-- Define los roles desempeñados por los empleados en los eventos.
CREATE TABLE Roles (
    Id_rol INT IDENTITY(1,1) PRIMARY KEY,              -- Identificador único del rol.
    Nombre_rol VARCHAR(100) NOT NULL,                  -- Nombre del rol (por ejemplo, "Decorador").
    Descripcion TEXT                                   -- Descripción del rol.
);

-- Relaciones

-- 10. Tabla intermedia Evento_Servicios para relación muchos a muchos entre Eventos y Servicios
-- Asocia servicios específicos a eventos personalizados.
CREATE TABLE Evento_Servicios (
    Id_evento INT NOT NULL,                            -- Relación con el evento.
    Id_servicio INT NOT NULL,                          -- Relación con el servicio.
    CONSTRAINT PK_Evento_Servicios PRIMARY KEY (Id_evento, Id_servicio), -- Clave primaria compuesta.
    CONSTRAINT FK_Evento_Servicios_Eventos FOREIGN KEY (Id_evento) REFERENCES Eventos(Id_evento),
    CONSTRAINT FK_Evento_Servicios_Servicios FOREIGN KEY (Id_servicio) REFERENCES Servicios(Id_servicio)
);

-- 11. Tabla intermedia Paquete_Servicios para relación muchos a muchos entre Paquetes y Servicios
-- Asocia servicios específicos a paquetes de eventos.
CREATE TABLE Paquete_Servicios (
    Id_paquete_servicios INT IDENTITY(1,1) PRIMARY KEY, -- Identificador único de la relación paquete-servicio.
    Id_paquete INT NOT NULL,                            -- Relación con el paquete.
    Id_servicio INT NOT NULL,                           -- Relación con el servicio.
    CONSTRAINT FK_Paquete_Servicios_Paquetes FOREIGN KEY (Id_paquete) REFERENCES Paquetes(Id_paquete),
    CONSTRAINT FK_Paquete_Servicios_Servicios FOREIGN KEY (Id_servicio) REFERENCES Servicios(Id_servicio)
);

-- 12. Tabla Servicio_Utileria para relación entre Servicios y Utileria
-- Asocia los elementos de utilería con los servicios que los requieren.
CREATE TABLE Servicio_Utileria (
    Id_servicio_utileria INT IDENTITY(1,1) PRIMARY KEY, -- Identificador único de la relación servicio-utilería.
    Id_servicio INT NOT NULL,                           -- Relación con el servicio.
    Id_utileria INT NOT NULL,                           -- Relación con la utilería.
    CONSTRAINT FK_Servicio_Utileria_Servicio FOREIGN KEY (Id_servicio) REFERENCES Servicios(Id_servicio),
    CONSTRAINT FK_Servicio_Utileria_Utileria FOREIGN KEY (Id_utileria) REFERENCES Utileria(Id_utileria)
);

-- 13. Tabla intermedia Rol_Empleado_Evento para relación muchos a muchos entre Empleados y Eventos
-- Asocia empleados con sus roles específicos en cada evento.
CREATE TABLE Rol_Empleado_Evento (
    Id_rol_empleado_evento INT IDENTITY(1,1) PRIMARY KEY, -- Identificador único de la relación rol-empleado-evento.
    Id_evento INT NOT NULL,                               -- Relación con el evento.
    Id_empleado INT NOT NULL,                             -- Relación con el empleado.
    Id_rol INT NOT NULL,                                  -- Relación con el rol del empleado en el evento.
    CONSTRAINT FK_Rol_Empleado_Evento_Eventos FOREIGN KEY (Id_evento) REFERENCES Eventos(Id_evento),
    CONSTRAINT FK_Rol_Empleado_Evento_Empleados FOREIGN KEY (Id_empleado) REFERENCES Empleados(Id_empleado),
    CONSTRAINT FK_Rol_Empleado_Evento_Roles FOREIGN KEY (Id_rol) REFERENCES Roles(Id_rol)
);





-- Inserciones de prueba

	-- Insertar clientes
	INSERT INTO Clientes (Nombre, Apellido, Telefono, Correo_electronico)
	VALUES 
	('Juan', 'Perez', '1234567890', 'juan.perez@example.com'),
	('Maria', 'Lopez', '0987654321', 'maria.lopez@example.com'),
	('Carlos', 'Ramirez', '1122334455', 'carlos.ramirez@example.com'),
	('Ana', 'Gonzalez', '2233445566', 'ana.gonzalez@example.com');

	-- Añadir servicios
	INSERT INTO Servicios (Nombre_servicio, Descripcion, Costo)
	VALUES 
	('Decoración', 'Decoración temática para eventos', 200.00),
	('Personajes', 'Personas disfrazadas de personajes para eventos infantiles', 300.00),
	('Equipo de Sonido', 'Provisión de sonido y DJ', 400.00),
	('Fotografía', 'Fotógrafo profesional para eventos', 500.00),
	('Actividades', 'Juegos de mesa y dinámicas', 200.00);

	-- Registrar empleados
	INSERT INTO Empleados (Nombre, Apellido, Telefono, Email)
	VALUES 
	('Carlos', 'López', '123456789', 'carlos.lopez@example.com'),
	('Ana', 'García', '987654321', 'ana.garcia@example.com'),
	('Luis', 'Martínez', '456789123', 'luis.martinez@example.com'),
	('Sofia', 'Fernández', '321654987', 'sofia.fernandez@example.com');

	-- Añadir roles
	INSERT INTO Roles (Nombre_rol, Descripcion)
	VALUES 
	('Decorador', 'Encargado de la decoración del evento'),
	('Persona disfrazada', 'Persona encargada de usar los disfraces de personas'),
	('Fotógrafo', 'Encargado de capturar fotos del evento'),
	('Técnico de Sonido', 'Encargado del equipo de sonido y música');

	-- Registrar utilería disponible
	INSERT INTO Utileria (Nombre, Cantidad)
	VALUES 
	('Globos', 100),
	('Banderines', 50),
	('Mesas', 20),
	('Sillas', 100),
	('Equipo de Sonido', 10),
	('Trajes', 10),
	('Cámara profesional',5),
	('Jenga', 7);

	-- Asignar utilería a cada servicio
	INSERT INTO Servicio_Utileria (Id_servicio, Id_utileria)
	VALUES 
	(1, 1), (1, 2), (1, 3), (1, 4), -- Decoración: Globos, Banderines, Mesas, Sillas
	(2, 6),                          -- Personajes: Trajes
	(3, 5),                          -- Sonido: Equipo de Sonido
	(4, 7),                          -- Fotografía: Cámara profesional
	(5, 8);                          -- Actividades: Jenga

	-- Insertar paquetes
	INSERT INTO Paquetes (Nombre_paquete, Descripcion, Disponibilidad, Costo)
	VALUES 
	('Cumpleaños Básico', 'Incluye decoración, actividades y sonido', 1, 900.00),
	('Fiesta Infantil', 'Incluye la decoración, actividades, sonido y personajes', 1, 1000.00);

	-- Asociar servicios con paquetes
	INSERT INTO Paquete_Servicios (Id_paquete, Id_servicio)
	VALUES 
	(1, 1), (1, 3), (1, 5),        -- Cumpleaños Básico: Decoración, Sonido, Actividades
	(2, 1), (2, 3), (2, 5), (2, 2); -- Fiesta Infantil: Decoración, Sonido, Actividades, Personajes

	-- Insertar eventos
	-- Evento 1: Cumpleaños Infantil personalizado (sin paquete, servicios especificados)
	INSERT INTO Eventos (Fecha_inicio, Hora_inicio, Hora_fin, Ubicacion, Direccion, Cantidad_de_asistentes, Detalles_adicionales, Id_paquete, Id_cliente)
	VALUES 
	('2024-12-01', '14:00', '18:00', 'Salón Fiesta', 'Calle Falsa 123', 20, 'Cumpleaños infantil con tema de superhéroes', NULL, 1);

	-- Evento 2: Boda personalizada sin paquete, servicios específicos
	INSERT INTO Eventos (Fecha_inicio, Hora_inicio, Hora_fin, Ubicacion, Direccion, Cantidad_de_asistentes, Detalles_adicionales, Id_paquete, Id_cliente)
	VALUES 
	('2024-12-15', '18:00', '23:00', 'Jardines del Lago', 'Calle Real 456', 10, 'Boda con temática vintage', NULL, 2);

	-- Evento 3: Conferencia Corporativa personalizada sin paquete
	INSERT INTO Eventos (Fecha_inicio, Hora_inicio, Hora_fin, Ubicacion, Direccion, Cantidad_de_asistentes, Detalles_adicionales, Id_paquete, Id_cliente)
	VALUES 
	('2024-11-20', '09:00', '17:00', 'Centro de Convenciones', 'Avenida Empresa 789', 12, 'Conferencia anual de la empresa', NULL, 3);

	-- Evento 4: Fiesta Infantil personalizada sin paquete
	INSERT INTO Eventos (Fecha_inicio, Hora_inicio, Hora_fin, Ubicacion, Direccion, Cantidad_de_asistentes, Detalles_adicionales, Id_paquete, Id_cliente)
	VALUES 
	('2025-01-10', '15:00', '19:00', 'Parque Central', 'Zona Verde 321', 15, 'Fiesta infantil con actividades de animación', NULL, 4);

	-- Evento 5: Boda con Paquete "Fiesta Infantil"
	INSERT INTO Eventos (Fecha_inicio, Hora_inicio, Hora_fin, Ubicacion, Direccion, Cantidad_de_asistentes, Detalles_adicionales, Id_paquete, Id_cliente)
	VALUES 
	('2025-06-20', '18:00', '23:00', 'Jardines del Lago', 'Calle Real 456', 30, 'Celebración de boda en exteriores con temática vintage', 2, 1);

	-- Calcular costo y pago inicial de cada evento personalizado

	--Servicios contratados por evento

	-- Evento 1: Cumpleaños Infantil personalizado (sin paquete)
	INSERT INTO Evento_Servicios (Id_evento, Id_servicio)
	VALUES 
	(1, 1), -- Decoración
	(1, 2), -- Personajes
	(1, 5); -- Actividades

	-- Evento 2: Boda personalizada (sin paquete)
	INSERT INTO Evento_Servicios (Id_evento, Id_servicio)
	VALUES 
	(2, 1), -- Decoración
	(2, 4); -- Fotografía

	-- Evento 3: Conferencia Corporativa (sin paquete)
	INSERT INTO Evento_Servicios (Id_evento, Id_servicio)
	VALUES 
	(3, 3), -- Equipo de Sonido
	(3, 4); -- Fotografía

	-- Evento 4: Fiesta Infantil personalizada (sin paquete)
	INSERT INTO Evento_Servicios (Id_evento, Id_servicio)
	VALUES 
	(4, 1), -- Decoración
	(4, 2), -- Personajes
	(4, 5); -- Actividades





	-- Evento 1: Costo basado en servicios seleccionados
	DECLARE @Costo_Evento1 DECIMAL(10, 2) = (SELECT SUM(Costo) FROM Servicios WHERE Id_servicio IN (1, 2, 5));
	INSERT INTO Reservacion (Id_cliente, Id_evento, Fecha_reserva, Costo_total, Pago_inicial)
	VALUES (1, 1, '2024-10-15', @Costo_Evento1, @Costo_Evento1 * 0.5);

	-- Evento 2: Costo basado en servicios seleccionados
	DECLARE @Costo_Evento2 DECIMAL(10, 2) = (SELECT SUM(Costo) FROM Servicios WHERE Id_servicio IN (1, 4));
	INSERT INTO Reservacion (Id_cliente, Id_evento, Fecha_reserva, Costo_total, Pago_inicial)
	VALUES (2, 2, '2024-11-10', @Costo_Evento2, @Costo_Evento2 * 0.5);

	-- Evento 3: Costo basado en servicios seleccionados
	DECLARE @Costo_Evento3 DECIMAL(10, 2) = (SELECT SUM(Costo) FROM Servicios WHERE Id_servicio IN (3, 4));
	INSERT INTO Reservacion (Id_cliente, Id_evento, Fecha_reserva, Costo_total, Pago_inicial)
	VALUES (3, 3, '2024-10-01', @Costo_Evento3, @Costo_Evento3 * 0.5);

	-- Evento 4: Costo basado en servicios seleccionados
	DECLARE @Costo_Evento4 DECIMAL(10, 2) = (SELECT SUM(Costo) FROM Servicios WHERE Id_servicio IN (1, 2, 5));
	INSERT INTO Reservacion (Id_cliente, Id_evento, Fecha_reserva, Costo_total, Pago_inicial)
	VALUES (4, 4, '2024-12-01', @Costo_Evento4, @Costo_Evento4 * 0.5);

	-- Evento 5: Costo del paquete "Fiesta Infantil"
	DECLARE @Costo_Evento5 DECIMAL(10, 2);

	SET @Costo_Evento5 = (SELECT SUM(Costo) 
						  FROM Paquetes 
						  WHERE Id_paquete = 2);-- Costo ya definido en la tabla Paquetes
	INSERT INTO Reservacion (Id_cliente, Id_evento, Fecha_reserva, Costo_total, Pago_inicial)
	VALUES (1, 5, '2025-05-01', @Costo_Evento5, @Costo_Evento5 * 0.5);



	-- Roles de los empleados por evento


	-- Evento 1 (Cumpleaños Infantil personalizado)
	INSERT INTO Rol_Empleado_Evento (Id_evento, Id_empleado, Id_rol)
	VALUES 
	(1, 1, 1), -- Carlos como "Decorador"
	(1, 2, 2); -- Ana como "Persona disfrazada"

	-- Evento 2 (Boda sin paquete)
	INSERT INTO Rol_Empleado_Evento (Id_evento, Id_empleado, Id_rol)
	VALUES 
	(2, 3, 4), -- Luis como "Técnico de Sonido"
	(2, 4, 3); -- Sofia como "Fotógrafo"

	-- Evento 3 (Conferencia Corporativa sin paquete)
	INSERT INTO Rol_Empleado_Evento (Id_evento, Id_empleado, Id_rol)
	VALUES 
	(3, 1, 4), -- Carlos como "Técnico de Sonido"
	(3, 3, 3); -- Luis como "Fotógrafo"

	-- Evento 4 (Fiesta Infantil personalizada)
	INSERT INTO Rol_Empleado_Evento (Id_evento, Id_empleado, Id_rol)
	VALUES 
	(4, 2, 2), -- Ana como "Persona disfrazada"
	(4, 1, 1); -- Carlos como "Decorador"


	-- Insertar pagos iniciales en la tabla Pagos
	INSERT INTO Pagos (Id_reservacion, Monto, Fecha_pago, Metodo_pago, Estado_pago)
	VALUES 
	(1, @Costo_Evento1 * 0.5, '2024-10-15', 'Tarjeta', 'Completado'),
	(2, @Costo_Evento2 * 0.5, '2024-10-15', 'Tarjeta', 'Completado'),
	(3, @Costo_Evento3 * 0.5, '2024-10-15', 'Tarjeta', 'Completado'),
	(4, @Costo_Evento4 * 0.5, '2024-10-15', 'Tarjeta', 'Completado'),
	(5, @Costo_Evento5 * 0.5, '2024-10-15', 'Tarjeta', 'Completado');


SELECT * FROM Reservacion WHERE Id_reservacion=1;
select * FROM Pagos WHERE Id_reservacion=1;

INSERT INTO Pagos (Id_reservacion, Monto, Fecha_pago, Metodo_pago, Estado_pago)
	VALUES 
	(1, 100, '2024-10-15', 'Tarjeta', 'Completado');


-- Cuanto falta por pagar de la reservación 1
SELECT S.Costo_total - SUM(P.Monto) AS Costo_Neto
FROM Reservacion S
JOIN Pagos P ON S.Id_reservacion = P.Id_reservacion
WHERE S.Id_reservacion = 1
GROUP BY S.Costo_total;

-- Ver cuanto falta por pagar de todas las reservaciones
SELECT S.Id_reservacion, S.Costo_total - SUM(P.Monto) AS Costo_Neto
FROM Reservacion S
LEFT JOIN Pagos P ON S.Id_reservacion = P.Id_reservacion
GROUP BY S.Id_reservacion, S.Costo_total;

-- Mostrar todos los eventos contratados por cada evento
SELECT ES.Id_evento, S.Nombre_servicio 
FROM Evento_Servicios ES JOIN  Servicios S ON S.Id_servicio = ES.Id_servicio
ORDER BY ES.Id_evento;

-- Mostrar el total de los pagos que si fueron exitosos.
SELECT SUM(Monto) AS Total_ganancias FROM Pagos WHERE Estado_pago='Completado'
