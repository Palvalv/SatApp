-- Crear un script MySQL con el esquema y datos de una BBDD para un centro sanitario de
-- medicina de cabecera. 
DROP DATABASE IF EXISTS satapp;
CREATE DATABASE IF NOT EXISTS satapp;
USE satapp;


CREATE TABLE IF NOT EXISTS Pacientes (
    PacienteID INT(10) AUTO_INCREMENT NOT NULL PRIMARY KEY,
    Apellidos VARCHAR(40) NOT NULL,
    Nombre VARCHAR(40) NOT NULL,
    Fecha_Nacimiento DATETIME NOT NULL,
    Direccion TEXT(255) NOT NULL,
    Telefono INT(9) NOT NULL,
    Email VARCHAR(40) NOT NULL,
    Doctor_Responsable INT(10) NOT NULL,
    Administrativo VARCHAR(40) NOT NULL
    ) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS Doctores (
    DoctorID INT(10) AUTO_INCREMENT NOT NULL PRIMARY KEY,
    Nombre_Doctor VARCHAR(40) NOT NULL,
    Especialidad INT(11) NOT NULL,
    Telefono INT(9) NOT NULL
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS Especialidades_Medicas (
    EspecialidadID INT(10) AUTO_INCREMENT NOT NULL PRIMARY KEY,
    Nombre_Especialidad VARCHAR(40) NOT NULL
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS Citas (
    ConsultaID INT(10) AUTO_INCREMENT NOT NULL PRIMARY KEY,
    PacienteID INT(10) NOT NULL,
    DoctorID INT(10) NOT NULL,
    Motivo TEXT(255) NOT NULL,
    Tratamiento TEXT(255) NOT NULL,
    Fecha_Consulta DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP 
		ON UPDATE CURRENT_TIMESTAMP,
	Asistencia BOOLEAN NOT NULL,
    FOREIGN KEY (PacienteID) 
        REFERENCES  Pacientes(PacienteID)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,
    FOREIGN KEY (DoctorID) 
        REFERENCES  Doctores(DoctorID)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS Usuarios_De_Sistemas (
    Usuario VARCHAR(40) NOT NULL PRIMARY KEY,
    Apellidos VARCHAR(40) NOT NULL,
    Nombre VARCHAR(40) NOT NULL,
    Telefono INT(9) NOT NULL,
    Cargo VARCHAR(40) NOT NULL,
    Contraseña VARCHAR(40) NOT NULL
) ENGINE = INNODB;

 ALTER TABLE Pacientes ADD FOREIGN KEY (Doctor_Responsable)
 REFERENCES Doctores(DoctorID);
 
 ALTER TABLE Pacientes ADD FOREIGN KEY (Administrativo)
 REFERENCES Usuarios_De_Sistemas(Usuario);
 
 ALTER TABLE Doctores ADD FOREIGN KEY (Especialidad)
 REFERENCES Especialidades_Medicas(EspecialidadID);
 
 INSERT INTO Usuarios_De_Sistemas VALUES
 ("gmartinez", "Martinez Ruiz", "Gonzalo", 651231232, "Administracion", "cont1"),
 ("irosales", "Rosales Guerrero", "Ines", 622259884, "Recepcion", "cont2"),
 ("promero", "Romero Aguilar", "Pedro", 654984541, "Recepcion", "cont3"),
 ("ipomelo", "Pomelo Ruiz", "Isaias", 698456345, "Administratcion", "cont4"),
 ("jgonzalez", "Gonzalez Lopetegui", "Jose", 684315846,"Limpieza", "cont5");
 
 INSERT INTO Especialidades_Medicas (Nombre_Especialidad) VALUES
 ("Pediatria"),
 ("Traumatologia"),
 ("Cardiologia"),
 ("Oncologia"),
 ("Neurologia"),
 ("Urologia");
 
 INSERT INTO Doctores (Nombre_Doctor, Especialidad, Telefono) VALUES
 ("Jesus Gonzalo", 1, 620259564),
 ("Isabel Ortuña", 3, 784658301),
 ("Rodrigo Fuertes", 4, 600512955),
 ("Andrea Esteban", 6, 688235017);
 
 INSERT INTO Pacientes (Apellidos, Nombre, Fecha_Nacimiento, Direccion, Telefono, Email, Doctor_Responsable, Administrativo) VALUES 
 ("Casado Asuero", "Juan", "2022-02-18 13:20:23", "Calle Torneo, n7, 1ºD, 41002", "665239400", "casado.asuero@gmail.com", 2, "irosales"),
 ("Alvarez Alvarez", "Pablo", "2022-02-18 13:20:23", "Calle Torneo, n7, 1ºD, 41002", "665239400", "alvarezx2@gmail.com", 1, "irosales"),
 ("Charlo Millan", "Ignacio", "2022-02-18 13:20:23", "Calle Torneo, n7, 1ºD, 41002", "665239400", "charlo.millan@gmail.com", 4, "promero"),
 ("Gonzalez Figueroa", "Miguel", "2022-02-18 13:20:23", "Calle Torneo, n7, 1ºD, 41002", "665239400", "gonzalezfigueroa@gmail.com", 4, "irosales");
 
 INSERT INTO Citas (PacienteID, DoctorID, Motivo, Tratamiento, Asistencia) VALUES
 (1, 2, "Extrasistoles", "2mg Atorbastatina cada 8 horas", TRUE),
 (2, 1, "Fimosis", "Tratamiento pre-operartorio", FALSE),
 (3, 4, "Infeccion de orina", "Beber mucha agua y una pastillita", TRUE);
 
 -- Saber que doctor ha atendido a cada paciente
 SELECT Nombre, Apellidos, Nombre_Doctor 
 FROM Pacientes JOIN Doctores ON Pacientes.Doctor_Responsable=Doctores.DoctorID;
 
 -- Saber el nombre y apellido, la fecha y la asistencia del paciente que ha ido al hospital por Extrasistoles asi como
 -- el nombre del medico que le ha atendido
 SELECT Nombre, Apellidos, Nombre_Doctor, Motivo, Tratamiento, Fecha_Consulta, Asistencia 
 FROM Citas, Pacientes, Doctores WHERE Motivo = "Extrasistoles" AND Pacientes.PacienteID = Citas.PacienteID AND Pacientes.Doctor_Responsable = Doctores.DoctorID;
 
 -- Recuperar el numero de pacientes que ha atendido cada doctor
 SELECT Nombre_Doctor, COUNT(*) AS NumPacientesAtendidos FROM Pacientes, Doctores
 WHERE Pacientes.Doctor_Responsable = Doctores.DoctorID GROUP BY Doctor_Responsable;
