-- =====================================================
-- Sistema de Gestión Médica e Inventario para Veterinaria
-- Veterinaria PetCare  |  Motor: MySQL 8+  |  Versión 2
-- Cambios: tabla cita, rol CLIENTE, usuario <-> propietario/veterinario,
--          tabla notificacion, cita_id opcional en historial_clinico
-- =====================================================

DROP DATABASE IF EXISTS veterinaria_petcare;
CREATE DATABASE veterinaria_petcare
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE veterinaria_petcare;

-- -----------------------------------------------------
-- usuario: cuentas de acceso al sistema (4 perfiles)
-- -----------------------------------------------------
CREATE TABLE usuario (
    id               BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre_usuario   VARCHAR(50)  NOT NULL UNIQUE,
    contrasena       VARCHAR(255) NOT NULL,          -- hash BCrypt
    rol              ENUM('ADMINISTRADOR','RECEPCIONISTA','VETERINARIO','CLIENTE') NOT NULL,
    estado           BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- propietario (puede o no tener cuenta: relación 0..1 con usuario)
-- -----------------------------------------------------
CREATE TABLE propietario (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    documento   VARCHAR(20)  NOT NULL UNIQUE,
    nombre      VARCHAR(100) NOT NULL,
    telefono    VARCHAR(20),
    email       VARCHAR(100),
    usuario_id  BIGINT UNIQUE,
    CONSTRAINT fk_propietario_usuario
        FOREIGN KEY (usuario_id) REFERENCES usuario(id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- veterinario (cuenta de usuario opcional)
-- -----------------------------------------------------
CREATE TABLE veterinario (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    documento   VARCHAR(20)  NOT NULL UNIQUE,
    nombre      VARCHAR(100) NOT NULL,
    telefono    VARCHAR(20),
    email       VARCHAR(100),
    usuario_id  BIGINT UNIQUE,
    CONSTRAINT fk_veterinario_usuario
        FOREIGN KEY (usuario_id) REFERENCES usuario(id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- mascota
-- -----------------------------------------------------
CREATE TABLE mascota (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre          VARCHAR(50) NOT NULL,
    especie         VARCHAR(30) NOT NULL,
    raza            VARCHAR(50),
    edad            INT CHECK (edad >= 0),
    propietario_id  BIGINT NOT NULL,
    CONSTRAINT fk_mascota_propietario
        FOREIGN KEY (propietario_id) REFERENCES propietario(id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE INDEX idx_mascota_nombre ON mascota(nombre);

-- -----------------------------------------------------
-- cita (NUEVA)
-- -----------------------------------------------------
CREATE TABLE cita (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    fecha           DATE NOT NULL,
    hora            TIME NOT NULL,
    motivo          VARCHAR(255) NOT NULL,
    estado          ENUM('PENDIENTE','APROBADA','RECHAZADA','REPROGRAMADA','CANCELADA','ATENDIDA')
                    NOT NULL DEFAULT 'PENDIENTE',
    propietario_id  BIGINT NOT NULL,
    mascota_id      BIGINT NOT NULL,
    CONSTRAINT fk_cita_propietario
        FOREIGN KEY (propietario_id) REFERENCES propietario(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_cita_mascota
        FOREIGN KEY (mascota_id) REFERENCES mascota(id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE INDEX idx_cita_fecha_hora ON cita(fecha, hora);

-- -----------------------------------------------------
-- historial_clinico (cita_id opcional: consulta originada en una cita)
-- -----------------------------------------------------
CREATE TABLE historial_clinico (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    fecha           DATE NOT NULL,
    motivo          VARCHAR(255) NOT NULL,
    diagnostico     TEXT,
    tratamiento     TEXT,
    mascota_id      BIGINT NOT NULL,
    veterinario_id  BIGINT NOT NULL,
    cita_id         BIGINT NULL,
    CONSTRAINT fk_historial_mascota
        FOREIGN KEY (mascota_id) REFERENCES mascota(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_historial_veterinario
        FOREIGN KEY (veterinario_id) REFERENCES veterinario(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_historial_cita
        FOREIGN KEY (cita_id) REFERENCES cita(id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE INDEX idx_historial_mascota_fecha ON historial_clinico(mascota_id, fecha);

-- -----------------------------------------------------
-- producto
-- -----------------------------------------------------
CREATE TABLE producto (
    id               BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre           VARCHAR(100) NOT NULL UNIQUE,
    stock_actual     INT NOT NULL DEFAULT 0 CHECK (stock_actual >= 0),
    stock_minimo     INT NOT NULL DEFAULT 5 CHECK (stock_minimo >= 0),
    precio_unitario  DECIMAL(10,2) NOT NULL CHECK (precio_unitario >= 0),
    activo           BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- detalle_atencion
-- -----------------------------------------------------
CREATE TABLE detalle_atencion (
    id                  BIGINT AUTO_INCREMENT PRIMARY KEY,
    historial_id        BIGINT NOT NULL,
    producto_id         BIGINT NOT NULL,
    cantidad_utilizada  INT NOT NULL CHECK (cantidad_utilizada > 0),
    CONSTRAINT fk_detalle_historial
        FOREIGN KEY (historial_id) REFERENCES historial_clinico(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_detalle_producto
        FOREIGN KEY (producto_id) REFERENCES producto(id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- notificacion (NUEVA): aprobación/rechazo de citas, recordatorios, stock bajo
-- -----------------------------------------------------
CREATE TABLE notificacion (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    usuario_id  BIGINT NOT NULL,
    tipo        ENUM('CITA_APROBADA','CITA_RECHAZADA','CITA_REPROGRAMADA','RECORDATORIO_CITA','STOCK_BAJO') NOT NULL,
    mensaje     VARCHAR(255) NOT NULL,
    fecha_envio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    leida       BOOLEAN NOT NULL DEFAULT FALSE,
    cita_id     BIGINT NULL,
    CONSTRAINT fk_notif_usuario
        FOREIGN KEY (usuario_id) REFERENCES usuario(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_notif_cita
        FOREIGN KEY (cita_id) REFERENCES cita(id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

-- =====================================================
-- DATOS DE EJEMPLO
-- =====================================================

-- Usuarios (hashes de ejemplo; en el sistema real se generan con BCrypt)
INSERT INTO usuario (nombre_usuario, contrasena, rol) VALUES
('admin',     '$2a$10$EJEMPLO_HASH_ADMIN_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', 'ADMINISTRADOR'),   -- id 1
('recep1',    '$2a$10$EJEMPLO_HASH_RECEP_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', 'RECEPCIONISTA'),    -- id 2
('vet_ana',   '$2a$10$EJEMPLO_HASH_VET1_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', 'VETERINARIO'),      -- id 3
('vet_mateo', '$2a$10$EJEMPLO_HASH_VET2_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', 'VETERINARIO'),      -- id 4
('maria.f',   '$2a$10$EJEMPLO_HASH_CLI1_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', 'CLIENTE'),          -- id 5
('juan.t',    '$2a$10$EJEMPLO_HASH_CLI2_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', 'CLIENTE');          -- id 6

-- Veterinarios (vinculados a sus cuentas)
INSERT INTO veterinario (documento, nombre, telefono, email, usuario_id) VALUES
('3030303030', 'Dra. Ana Pérez',  '3007778899', 'ana.perez@petcare.com',   3),
('4040404040', 'Dr. Mateo Silva', '3112223344', 'mateo.silva@petcare.com', 4);

-- Propietarios (Sofía fue registrada en recepción y aún no tiene cuenta)
INSERT INTO propietario (documento, nombre, telefono, email, usuario_id) VALUES
('1098765432', 'María Fernández', '3151234567', 'maria.fernandez@mail.com', 5),
('1087654321', 'Juan Torres',     '3169876543', 'juan.torres@mail.com',     6),
('1076543210', 'Sofía Ramírez',   '3201122334', 'sofia.ramirez@mail.com',   NULL);

-- Mascotas
INSERT INTO mascota (nombre, especie, raza, edad, propietario_id) VALUES
('Max',   'Perro', 'Labrador', 4, 1),
('Luna',  'Gato',  'Siamés',   2, 1),
('Rocky', 'Perro', 'Bulldog',  6, 2),
('Nala',  'Gato',  'Persa',    3, 3),
('Toby',  'Perro', 'Beagle',   1, 3);

-- Productos
INSERT INTO producto (nombre, stock_actual, stock_minimo, precio_unitario) VALUES
('Vacuna Antirrábica',      30, 10,  25000.00),
('Vacuna Triple Felina',    20,  8,  32000.00),
('Amoxicilina 250mg',       50, 15,   3500.00),
('Desparasitante Oral',     25, 10,  12000.00),
('Suero Fisiológico 500ml', 12,  6,   8000.00),
('Jeringa 5ml',            100, 30,   1200.00);

-- Citas
INSERT INTO cita (fecha, hora, motivo, estado, propietario_id, mascota_id) VALUES
('2026-10-05', '09:00:00', 'Vacunación anual',          'ATENDIDA',     1, 1),   -- id 1
('2026-10-12', '10:30:00', 'Vómito y decaimiento',      'ATENDIDA',     2, 3),   -- id 2
('2026-10-20', '15:00:00', 'Control y desparasitación', 'ATENDIDA',     3, 4),   -- id 3
('2026-11-12', '09:30:00', 'Vacunación felina',         'APROBADA',     1, 2),   -- id 4
('2026-11-15', '11:00:00', 'Revisión general',          'PENDIENTE',    2, 3),   -- id 5
('2026-11-18', '16:00:00', 'Control de peso',           'RECHAZADA',    3, 5);   -- id 6

-- Historial clínico (cita_id enlaza con la cita que originó la consulta)
INSERT INTO historial_clinico (fecha, motivo, diagnostico, tratamiento, mascota_id, veterinario_id, cita_id) VALUES
('2026-10-05', 'Vacunación anual',          'Paciente sano',               'Aplicación de vacuna antirrábica',   1, 1, 1),
('2026-10-12', 'Vómito y decaimiento',      'Gastroenteritis leve',        'Suero y antibiótico por 5 días',     3, 2, 2),
('2026-10-20', 'Control y desparasitación', 'Parasitosis intestinal leve', 'Desparasitante oral dosis única',    4, 1, 3),
('2026-10-28', 'Vacunación felina',         'Paciente sano',               'Aplicación de vacuna triple felina', 2, 1, NULL);  -- consulta sin cita previa

-- Detalle de atención
INSERT INTO detalle_atencion (historial_id, producto_id, cantidad_utilizada) VALUES
(1, 1, 1),
(1, 6, 1),
(2, 5, 2),
(2, 3, 10),
(3, 4, 1),
(4, 2, 1),
(4, 6, 1);

-- Descuento de stock correspondiente (en el sistema real lo hace el backend en la misma transacción)
UPDATE producto p
JOIN (SELECT producto_id, SUM(cantidad_utilizada) AS total
      FROM detalle_atencion GROUP BY producto_id) d
  ON p.id = d.producto_id
SET p.stock_actual = p.stock_actual - d.total;

-- Notificaciones
INSERT INTO notificacion (usuario_id, tipo, mensaje, cita_id) VALUES
(5, 'CITA_APROBADA',     'Tu cita del 12/11/2026 a las 09:30 fue aprobada.',                     4),
(6, 'CITA_REPROGRAMADA', 'Tu cita del 15/11/2026 está pendiente de confirmación.',               5),
(6, 'CITA_RECHAZADA',    'Tu solicitud del 18/11/2026 fue rechazada; solicita otro horario.',    6),
(5, 'RECORDATORIO_CITA', 'Recordatorio: mañana tienes cita para Luna a las 09:30.',              4);

-- =====================================================
-- VISTAS PARA REPORTES Y AGENDA
-- =====================================================

CREATE VIEW v_stock_bajo AS
SELECT id, nombre, stock_actual, stock_minimo
FROM producto
WHERE activo = TRUE AND stock_actual <= stock_minimo;

CREATE VIEW v_consumo_diario AS
SELECT h.fecha, p.nombre AS producto, SUM(d.cantidad_utilizada) AS total_consumido
FROM detalle_atencion d
JOIN historial_clinico h ON h.id = d.historial_id
JOIN producto p          ON p.id = d.producto_id
GROUP BY h.fecha, p.nombre;

CREATE VIEW v_consumo_mensual AS
SELECT DATE_FORMAT(h.fecha, '%Y-%m') AS mes, p.nombre AS producto, SUM(d.cantidad_utilizada) AS total_consumido
FROM detalle_atencion d
JOIN historial_clinico h ON h.id = d.historial_id
JOIN producto p          ON p.id = d.producto_id
GROUP BY DATE_FORMAT(h.fecha, '%Y-%m'), p.nombre;

-- Agenda de citas (para recepción)
CREATE VIEW v_agenda_citas AS
SELECT c.id, c.fecha, c.hora, c.estado, c.motivo,
       m.nombre AS mascota, p.nombre AS propietario, p.telefono
FROM cita c
JOIN mascota m     ON m.id = c.mascota_id
JOIN propietario p ON p.id = c.propietario_id
ORDER BY c.fecha, c.hora;

-- =====================================================
-- CONSULTAS DE PRUEBA
-- =====================================================
-- Buscar paciente por cédula del dueño o nombre de mascota:
-- SELECT m.nombre, m.especie, p.nombre AS propietario
-- FROM mascota m JOIN propietario p ON p.id = m.propietario_id
-- WHERE p.documento = '1098765432' OR m.nombre LIKE '%Max%';
--
-- Citas pendientes por aprobar:
-- SELECT * FROM v_agenda_citas WHERE estado = 'PENDIENTE';
--
-- Historial clínico de las mascotas de un cliente (usuario_id = 5):
-- SELECT m.nombre AS mascota, h.fecha, h.motivo, h.diagnostico, h.tratamiento
-- FROM historial_clinico h
-- JOIN mascota m     ON m.id = h.mascota_id
-- JOIN propietario p ON p.id = m.propietario_id
-- WHERE p.usuario_id = 5
-- ORDER BY h.fecha DESC;
--
-- Alertas de stock bajo:
-- SELECT * FROM v_stock_bajo;
