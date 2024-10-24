CREATE DATABASE Proyecto;

Use Proyecto;

-- 1. Tabla Clientes
CREATE TABLE Clientes (
    id_cliente INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(15),
    email VARCHAR(100)
);

-- 2. Tabla Eventos
CREATE TABLE Eventos (
    id_evento INT IDENTITY(1,1) PRIMARY KEY,
    fecha_inicio DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    ubicacion VARCHAR(255),
    descripcion TEXT,
    id_cliente INT NOT NULL,
    CONSTRAINT FK_Eventos_Clientes FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

-- 3. Tabla Paquetes
CREATE TABLE Paquetes (
    id_paquete INT IDENTITY(1,1) PRIMARY KEY,
    nombre_paquete VARCHAR(100) NOT NULL,
    descripcion TEXT,
    disponibilidad BIT NOT NULL, 
    costo DECIMAL(10, 2) NOT NULL
);

-- 4. Tabla Servicios
CREATE TABLE Servicios (
    id_servicio INT IDENTITY(1,1) PRIMARY KEY,
    nombre_servicio VARCHAR(100) NOT NULL,
    descripcion TEXT,
    costo DECIMAL(10, 2) NOT NULL
);

-- 5. Tabla Reservas
CREATE TABLE Reservas (
    id_reserva INT IDENTITY(1,1) PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_evento INT NOT NULL,
    fecha_reserva DATE NOT NULL,
    pago_inicial DECIMAL(10, 2) NOT NULL,
    CONSTRAINT FK_Reservas_Clientes FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    CONSTRAINT FK_Reservas_Eventos FOREIGN KEY (id_evento) REFERENCES Eventos(id_evento)
);

-- 6. Tabla intermedia Evento_Servicios para relación muchos a muchos entre Eventos y Servicios
CREATE TABLE Evento_Servicios (
    id_evento INT NOT NULL,
    id_servicio INT NOT NULL,
    CONSTRAINT PK_Evento_Servicios PRIMARY KEY (id_evento, id_servicio),
    CONSTRAINT FK_Evento_Servicios_Eventos FOREIGN KEY (id_evento) REFERENCES Eventos(id_evento),
    CONSTRAINT FK_Evento_Servicios_Servicios FOREIGN KEY (id_servicio) REFERENCES Servicios(id_servicio)
);

-- 7. Tabla intermedia Paquete_Servicios para relación muchos a muchos entre Paquetes y Servicios
CREATE TABLE Paquete_Servicios (
	id_Paquete_Servicios INT PRIMARY KEY IDENTITY(1,1),
    id_paquete INT NOT NULL,
    id_servicio INT NOT NULL,
    CONSTRAINT FK_Paquete_Servicios_Paquetes FOREIGN KEY (id_paquete) REFERENCES Paquetes(id_paquete),
    CONSTRAINT FK_Paquete_Servicios_Servicios FOREIGN KEY (id_servicio) REFERENCES Servicios(id_servicio)
);

-- 8. Tabla Empleados
CREATE TABLE Empleados (
    id_empleado INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    telefono VARCHAR(15),
    email VARCHAR(100)
);

-- 9. Tabla intermedia Rol_Empleado_Evento para relación muchos a muchos entre Empleados y Eventos
CREATE TABLE Rol_Empleado_Evento (
	id_Rol_Empleado_Evento INT IDENTITY(1,1) PRIMARY KEY,
    id_evento INT NOT NULL,
    id_empleado INT NOT NULL,
    rol VARCHAR(100) NOT NULL,   
    CONSTRAINT FK_Rol_Empleado_Evento_Eventos FOREIGN KEY (id_evento) REFERENCES Eventos(id_evento),
    CONSTRAINT FK_Rol_Empleado_Evento_Empleados FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
);
