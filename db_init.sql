-- Crear base de datos
CREATE DATABASE IF NOT EXISTS sos_empresa
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE sos_empresa;

-- 1) Clientes
CREATE TABLE IF NOT EXISTS clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(120),
    direccion VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2) Técnicos
CREATE TABLE IF NOT EXISTS tecnicos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(120),
    activo TINYINT(1) DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 3) Equipos
CREATE TABLE IF NOT EXISTS equipos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    tipo_equipo VARCHAR(100) NOT NULL,      -- CCTV, alarma, etc.
    marca VARCHAR(100),
    modelo VARCHAR(100),
    numero_serie VARCHAR(100),
    fecha_instalacion DATE,
    garantia_hasta DATE,                    -- para "Equipos en garantía"
    estado ENUM('operativo','en_revision','baja') DEFAULT 'operativo',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_equipos_cliente
        FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

-- 4) Tickets
CREATE TABLE IF NOT EXISTS tickets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    folio VARCHAR(30) UNIQUE,
    cliente_id INT NOT NULL,
    equipo_id INT,
    tecnico_id INT,
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT,
    prioridad ENUM('baja','media','alta','critica') DEFAULT 'media',
    estado ENUM('abierto','en_proceso','en_espera','cerrado') DEFAULT 'abierto',
    canal_origen ENUM('telefono','whatsapp','correo','web') DEFAULT 'telefono',
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_cierre DATETIME NULL,
    CONSTRAINT fk_tickets_cliente
        FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    CONSTRAINT fk_tickets_equipo
        FOREIGN KEY (equipo_id) REFERENCES equipos(id),
    CONSTRAINT fk_tickets_tecnico
        FOREIGN KEY (tecnico_id) REFERENCES tecnicos(id)
);

-- 5) Visitas (para "Visitas de hoy")
CREATE TABLE IF NOT EXISTS visitas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ticket_id INT NOT NULL,
    tecnico_id INT NOT NULL,
    fecha_visita DATETIME NOT NULL,
    tipo_visita ENUM('diagnostico','mantenimiento','instalacion','garantia') DEFAULT 'diagnostico',
    notas TEXT,
    CONSTRAINT fk_visitas_ticket
        FOREIGN KEY (ticket_id) REFERENCES tickets(id),
    CONSTRAINT fk_visitas_tecnico
        FOREIGN KEY (tecnico_id) REFERENCES tecnicos(id)
);

-- 6) Evidencias (para "Cargar evidencia")
CREATE TABLE IF NOT EXISTS evidencias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ticket_id INT NOT NULL,
    visita_id INT NULL,
    ruta_archivo VARCHAR(255) NOT NULL,
    tipo ENUM('imagen','video','documento') DEFAULT 'imagen',
    descripcion VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_evidencias_ticket
        FOREIGN KEY (ticket_id) REFERENCES tickets(id),
    CONSTRAINT fk_evidencias_visita
        FOREIGN KEY (visita_id) REFERENCES visitas(id)
);

-- 7) Inventario
CREATE TABLE IF NOT EXISTS inventario_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    categoria VARCHAR(100),
    codigo VARCHAR(50),
    stock_actual INT DEFAULT 0,
    stock_minimo INT DEFAULT 0,
    ubicacion VARCHAR(100),
    activo TINYINT(1) DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 8) Usuarios (login)
CREATE TABLE IF NOT EXISTS usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,           -- nombre completo
    username VARCHAR(50) NOT NULL UNIQUE,   -- para iniciar sesión
    email VARCHAR(120) UNIQUE,
    password_hash VARCHAR(255) NOT NULL,    -- contraseña encriptada
    rol ENUM('admin','coordinador','tecnico','cliente') DEFAULT 'tecnico',
    activo TINYINT(1) DEFAULT 1,
    tecnico_id INT NULL,                    -- opcional: vincular con técnico
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_usuarios_tecnico
        FOREIGN KEY (tecnico_id) REFERENCES tecnicos(id)
);
