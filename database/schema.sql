-- Sistema de Gestión de Vehículos para Empresa Minera
-- Script base de implementación en MySQL (documento 04, sección 21)
-- Tablas: rol, usuario, vehiculo, conductor, asignacion, alquiler, mantenimiento,
--         documento_vehiculo, historial_vehiculo

CREATE DATABASE IF NOT EXISTS gestion_vehiculos
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE gestion_vehiculos;

CREATE TABLE rol (
    id_rol       INT AUTO_INCREMENT PRIMARY KEY,
    nombre       VARCHAR(50) NOT NULL UNIQUE,
    descripcion  VARCHAR(200)
);

CREATE TABLE usuario (
    id_usuario       INT AUTO_INCREMENT PRIMARY KEY,
    id_rol           INT NOT NULL,
    nombre_usuario   VARCHAR(80) NOT NULL UNIQUE,
    contrasena_hash  VARCHAR(255) NOT NULL,
    estado           VARCHAR(20) NOT NULL,
    fecha_creacion   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_usuario_rol FOREIGN KEY (id_rol) REFERENCES rol(id_rol)
);

CREATE TABLE vehiculo (
    id_vehiculo     INT AUTO_INCREMENT PRIMARY KEY,
    codigo          VARCHAR(20) NOT NULL UNIQUE,
    placa           VARCHAR(10) NOT NULL UNIQUE,
    marca           VARCHAR(50) NOT NULL,
    modelo          VARCHAR(50) NOT NULL,
    anio            SMALLINT NOT NULL,
    tipo            VARCHAR(40) NOT NULL,
    color           VARCHAR(30),
    kilometraje     DECIMAL(10,2) NOT NULL DEFAULT 0,
    estado          VARCHAR(30) NOT NULL,
    fecha_registro  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    observaciones   TEXT
);

CREATE TABLE conductor (
    id_conductor       INT AUTO_INCREMENT PRIMARY KEY,
    dni                VARCHAR(12) NOT NULL UNIQUE,
    nombres            VARCHAR(80) NOT NULL,
    apellidos          VARCHAR(100) NOT NULL,
    licencia           VARCHAR(30) NOT NULL UNIQUE,
    categoria          VARCHAR(20) NOT NULL,
    telefono           VARCHAR(20),
    estado             VARCHAR(30) NOT NULL,
    fecha_vencimiento  DATE NOT NULL,
    observaciones      TEXT
);

CREATE TABLE asignacion (
    id_asignacion     INT AUTO_INCREMENT PRIMARY KEY,
    id_vehiculo       INT NOT NULL,
    id_conductor      INT NOT NULL,
    fecha_asignacion  DATETIME NOT NULL,
    encargado         VARCHAR(120),
    estado            VARCHAR(30) NOT NULL,
    FOREIGN KEY (id_vehiculo)  REFERENCES vehiculo(id_vehiculo),
    FOREIGN KEY (id_conductor) REFERENCES conductor(id_conductor)
);

CREATE TABLE alquiler (
    id_alquiler    INT AUTO_INCREMENT PRIMARY KEY,
    id_vehiculo    INT NOT NULL,
    id_conductor   INT NOT NULL,
    fecha_inicio   DATETIME NOT NULL,
    fecha_fin      DATETIME,
    destino        VARCHAR(150) NOT NULL,
    motivo         VARCHAR(200),
    estado         VARCHAR(30) NOT NULL,
    observaciones  TEXT,
    FOREIGN KEY (id_vehiculo)  REFERENCES vehiculo(id_vehiculo),
    FOREIGN KEY (id_conductor) REFERENCES conductor(id_conductor)
);

CREATE TABLE mantenimiento (
    id_mantenimiento       INT AUTO_INCREMENT PRIMARY KEY,
    id_vehiculo            INT NOT NULL,
    tipo                   VARCHAR(30) NOT NULL,
    fecha                  DATETIME NOT NULL,
    kilometraje            DECIMAL(10,2),
    descripcion            TEXT NOT NULL,
    proximo_mantenimiento  DATE,
    estado                 VARCHAR(30) NOT NULL,
    observaciones          TEXT,
    FOREIGN KEY (id_vehiculo) REFERENCES vehiculo(id_vehiculo)
);

CREATE TABLE documento_vehiculo (
    id_documento       INT AUTO_INCREMENT PRIMARY KEY,
    id_vehiculo        INT NOT NULL,
    tipo               VARCHAR(50) NOT NULL,
    numero             VARCHAR(50),
    fecha_emision      DATE,
    fecha_vencimiento  DATE,
    archivo            VARCHAR(255),
    estado             VARCHAR(30) NOT NULL,
    FOREIGN KEY (id_vehiculo) REFERENCES vehiculo(id_vehiculo)
);

CREATE TABLE historial_vehiculo (
    id_historial  INT AUTO_INCREMENT PRIMARY KEY,
    id_vehiculo   INT NOT NULL,
    tipo_evento   VARCHAR(50) NOT NULL,
    fecha         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    descripcion   TEXT NOT NULL,
    id_usuario    INT,
    FOREIGN KEY (id_vehiculo) REFERENCES vehiculo(id_vehiculo),
    FOREIGN KEY (id_usuario)  REFERENCES usuario(id_usuario)
);

CREATE INDEX idx_vehiculo_estado          ON vehiculo(estado);
CREATE INDEX idx_alquiler_vehiculo_fecha  ON alquiler(id_vehiculo, fecha_inicio);
CREATE INDEX idx_alquiler_conductor_fecha ON alquiler(id_conductor, fecha_inicio);
CREATE INDEX idx_mantenimiento_veh_fecha  ON mantenimiento(id_vehiculo, fecha);
CREATE INDEX idx_documento_vencimiento    ON documento_vehiculo(fecha_vencimiento);
CREATE INDEX idx_historial_vehiculo_fecha ON historial_vehiculo(id_vehiculo, fecha);
