CREATE DATABASE IF NOT EXISTS clindesk;
USE clindesk;

CREATE TABLE usuario (
  id_usuario INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  apellidos VARCHAR(150) NOT NULL,
  email VARCHAR(120) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  rol ENUM('ADMINISTRADOR', 'DOCTOR', 'AUXILIAR', 'RECEPCION') NOT NULL,
  telefono VARCHAR(20),
  activo BOOLEAN DEFAULT TRUE,
  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE paciente (
  id_paciente INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  apellidos VARCHAR(150) NOT NULL,
  dni VARCHAR(12) UNIQUE,
  fecha_nacimiento DATE,
  telefono VARCHAR(20),
  email VARCHAR(120),
  direccion VARCHAR(255),
  observaciones TEXT,
  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE cita (
  id_cita INT AUTO_INCREMENT PRIMARY KEY,
  id_paciente INT NOT NULL,
  id_profesional INT NOT NULL,
  fecha DATE NOT NULL,
  hora TIME NOT NULL,
  motivo VARCHAR(150) NOT NULL,
  estado ENUM('PENDIENTE', 'CONFIRMADA', 'CANCELADA', 'ATENDIDA') DEFAULT 'PENDIENTE',
  notas TEXT,
  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_cita_paciente FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
  CONSTRAINT fk_cita_profesional FOREIGN KEY (id_profesional) REFERENCES usuario(id_usuario)
);

CREATE TABLE historial_clinico (
  id_historial INT AUTO_INCREMENT PRIMARY KEY,
  id_paciente INT NOT NULL,
  id_profesional INT NOT NULL,
  fecha_registro DATETIME NOT NULL,
  diagnostico TEXT,
  tratamiento TEXT,
  observaciones TEXT,
  CONSTRAINT fk_historial_paciente FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
  CONSTRAINT fk_historial_profesional FOREIGN KEY (id_profesional) REFERENCES usuario(id_usuario)
);

CREATE TABLE factura (
  id_factura INT AUTO_INCREMENT PRIMARY KEY,
  id_paciente INT NOT NULL,
  id_cita INT,
  fecha_emision DATE NOT NULL,
  concepto VARCHAR(200) NOT NULL,
  base_imponible DECIMAL(10,2) NOT NULL,
  iva DECIMAL(10,2) NOT NULL,
  total DECIMAL(10,2) NOT NULL,
  estado_pago ENUM('PENDIENTE', 'PAGADA', 'ANULADA') DEFAULT 'PENDIENTE',
  CONSTRAINT fk_factura_paciente FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
  CONSTRAINT fk_factura_cita FOREIGN KEY (id_cita) REFERENCES cita(id_cita)
);

CREATE TABLE documento (
  id_documento INT AUTO_INCREMENT PRIMARY KEY,
  id_paciente INT NOT NULL,
  id_usuario_subida INT NOT NULL,
  nombre_archivo VARCHAR(180) NOT NULL,
  tipo_documento VARCHAR(100) NOT NULL,
  ruta_archivo VARCHAR(255) NOT NULL,
  fecha_subida TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_documento_paciente FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
  CONSTRAINT fk_documento_usuario FOREIGN KEY (id_usuario_subida) REFERENCES usuario(id_usuario)
);
