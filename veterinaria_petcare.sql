
DROP DATABASE IF EXISTS veterinaria_petcare;
CREATE DATABASE veterinaria_petcare
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE veterinaria_petcare;

CREATE TABLE usuario (
    id             BIGINT AUTO_INCREMENT PRIMARY KEY,
    documento      VARCHAR(20)  NOT NULL UNIQUE,
    nombre         VARCHAR(100) NOT NULL,
    telefono       VARCHAR(20),
    email          VARCHAR(100) NOT NULL UNIQUE,
    username       VARCHAR(50)  NOT NULL UNIQUE,
    password_hash  VARCHAR(255) NOT NULL,
    rol            ENUM('ADMINISTRADOR','RECEPCIONISTA','VETERINARIO') NOT NULL,
    activo         BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE=InnoDB;

CREATE TABLE propietario (
    id         BIGINT AUTO_INCREMENT PRIMARY KEY,
    documento  VARCHAR(20)  NOT NULL UNIQUE,
    nombre     VARCHAR(100) NOT NULL,
    telefono   VARCHAR(20),
    email      VARCHAR(100)
) ENGINE=InnoDB;


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

CREATE TABLE historial_clinico (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    fecha           DATE NOT NULL,
    motivo          VARCHAR(255) NOT NULL,
    diagnostico     TEXT,
    tratamiento     TEXT,
    mascota_id      BIGINT NOT NULL,
    veterinario_id  BIGINT NOT NULL,
    CONSTRAINT fk_historial_mascota
        FOREIGN KEY (mascota_id) REFERENCES mascota(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_historial_veterinario
        FOREIGN KEY (veterinario_id) REFERENCES usuario(id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE INDEX idx_historial_mascota_fecha ON historial_clinico(mascota_id, fecha);

CREATE TABLE producto (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre          VARCHAR(100) NOT NULL UNIQUE,
    stock_actual    INT NOT NULL DEFAULT 0 CHECK (stock_actual >= 0),
    stock_minimo    INT NOT NULL DEFAULT 5 CHECK (stock_minimo >= 0),
    precio_unitario DECIMAL(10,2) NOT NULL CHECK (precio_unitario >= 0),
    activo          BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE=InnoDB;


CREATE TABLE detalle_atencion (
    id                 BIGINT AUTO_INCREMENT PRIMARY KEY,
    historial_id       BIGINT NOT NULL,
    producto_id        BIGINT NOT NULL,
    cantidad_utilizada INT NOT NULL CHECK (cantidad_utilizada > 0),
    CONSTRAINT fk_detalle_historial
        FOREIGN KEY (historial_id) REFERENCES historial_clinico(id)
        ON UPDATE CASCADE ON DELETE CASCADE, 
    CONSTRAINT fk_detalle_producto
        FOREIGN KEY (producto_id) REFERENCES producto(id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;


INSERT INTO usuario (documento, nombre, telefono, email, username, password_hash, rol) VALUES
('1010101010', 'Laura Gómez',    '3001112233', 'laura.gomez@petcare.com',   'admin',    '$2a$10$EJEMPLO_HASH_ADMIN_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', 'ADMINISTRADOR'),
('2020202020', 'Carlos Ruiz',    '3004445566', 'carlos.ruiz@petcare.com',   'recep1',   '$2a$10$EJEMPLO_HASH_RECEP_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', 'RECEPCIONISTA'),
('3030303030', 'Dra. Ana Pérez', '3007778899', 'ana.perez@petcare.com',     'vet_ana',  '$2a$10$EJEMPLO_HASH_VET1_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', 'VETERINARIO'),
('4040404040', 'Dr. Mateo Silva','3112223344', 'mateo.silva@petcare.com',   'vet_mateo','$2a$10$EJEMPLO_HASH_VET2_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', 'VETERINARIO');

INSERT INTO propietario (documento, nombre, telefono, email) VALUES
('1098765432', 'María Fernández', '3151234567', 'maria.fernandez@mail.com'),
('1087654321', 'Juan Torres',     '3169876543', 'juan.torres@mail.com'),
('1076543210', 'Sofía Ramírez',   '3201122334', 'sofia.ramirez@mail.com');

INSERT INTO mascota (nombre, especie, raza, edad, propietario_id) VALUES
('Max',   'Perro', 'Labrador',  4, 1),
('Luna',  'Gato',  'Siamés',    2, 1),
('Rocky', 'Perro', 'Bulldog',   6, 2),
('Nala',  'Gato',  'Persa',     3, 3),
('Toby',  'Perro', 'Beagle',    1, 3);

INSERT INTO producto (nombre, stock_actual, stock_minimo, precio_unitario) VALUES
('Vacuna Antirrábica',       30, 10,  25000.00),
('Vacuna Triple Felina',     20,  8,  32000.00),
('Amoxicilina 250mg',        50, 15,   3500.00),
('Desparasitante Oral',      25, 10,  12000.00),
('Suero Fisiológico 500ml',  12,  6,   8000.00),
('Jeringa 5ml',             100, 30,   1200.00);

INSERT INTO historial_clinico (fecha, motivo, diagnostico, tratamiento, mascota_id, veterinario_id) VALUES
('2026-10-05', 'Vacunación anual',          'Paciente sano',                    'Aplicación de vacuna antirrábica',        1, 3),
('2026-10-12', 'Vómito y decaimiento',      'Gastroenteritis leve',             'Suero y antibiótico por 5 días',          3, 4),
('2026-10-20', 'Control y desparasitación', 'Parasitosis intestinal leve',      'Desparasitante oral dosis única',         4, 3),
('2026-10-28', 'Vacunación felina',         'Paciente sano',                    'Aplicación de vacuna triple felina',      2, 3);

INSERT INTO detalle_atencion (historial_id, producto_id, cantidad_utilizada) VALUES
(1, 1, 1),   -- Vacuna antirrábica a Max
(1, 6, 1),   -- Jeringa
(2, 5, 2),   -- Suero a Rocky
(2, 3, 10),  -- Amoxicilina
(3, 4, 1),   -- Desparasitante a Nala
(4, 2, 1),   -- Vacuna triple felina a Luna
(4, 6, 1);   -- Jeringa

UPDATE producto p
JOIN (SELECT producto_id, SUM(cantidad_utilizada) AS total
      FROM detalle_atencion GROUP BY producto_id) d
  ON p.id = d.producto_id
SET p.stock_actual = p.stock_actual - d.total;


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


