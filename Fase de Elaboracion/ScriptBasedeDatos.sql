
create database PrototipoCRU
        go
use PrototipoCRU
        go

create table Permiso
(
    Permiso_id Int Identity(1,1) not null primary key,
    Modulo varchar (50) not null,
    descripcion varchar(50) not null


);
go
insert into Permiso
    (Modulo, descripcion)
values
    ('Empleado', 'Puede Crear'),
    ('Empleado', 'Puede Consultar'),
    ('Empleado', 'Puede Actualizar'),
    ('Espacio', 'Puede Crear'),
    ('Espacio', 'Puede Consultar'),
    ('Espacio', 'Puede Actualizar'),
    ('Estudiante', 'Puede Crear'),
    ('Estudiante', 'Puede Consultar'),
    ('Estudiante', 'Puede Actualizar'),
    ('Solicitud', 'Puede Crear'),
    ('Solicitud', 'Puede Consultar'),
    ('Solicitud', 'Puede Actualizar'),
    ('Admision', 'Puede Crear'),
    ('Admision', 'Puede Consultar'),
    ('Admision', 'Puede Actualizar'),
    ('Citas', 'Puede Crear'),
    ('Citas', 'Puede Consultar'),
    ('Citas', 'Puede Actualizar'),
    ('Reparacion', 'Puede Crear'),
    ('Reparacion', 'Puede Consultar'),
    ('Reparacion', 'Puede Actualizar'),
    ('Inventario', 'Puede Crear'),
    ('Inventario', 'Puede Consultar'),
    ('Inventario', 'Puede Actualizar'),
    ('Elemento', 'Puede Crear'),
    ('Elemento', 'Puede Consultar'),
    ('Elemento', 'Puede Actualizar')
            go

create table tipoidentificacion
(
    id_tipoidentificacion int IDENTITY(1,1) not null,
    valor_tipoidentificacion varchar(50) not null,
    primary key (id_tipoidentificacion)
);
            go

INSERT INTO tipoidentificacion
    (valor_tipoidentificacion)
VALUES
    ('Cedula'),
    ('Tarjeta de Identidad'),
    ('Cedula Extranjeria')
            go

create table estadocivil
(
    id_estadocivil int Identity(1,1) not null,
    valor_estadocivil varchar(20) not null,
    primary key  (id_estadocivil)
);
            go
INSERT INTO estadocivil
    (valor_estadocivil)
VALUES
    ('Soltero'),
    ('Casado'),
    ('Union libre'),
    ('Divorciado'),
    ('Viudo')
            go
CREATE TABLE estado_usuario_cru
(
    Id_estado_usuario_cru int Identity(1,1),
    Descripcion_estado_usuario_cru varchar(30) NOT NULL,
    primary key (Id_estado_usuario_cru)
);
        GO

INSERT INTO estado_usuario_cru
    (Descripcion_estado_usuario_cru)
VALUES
    ('Activo'),
    ('Retirado'),
    ('Admitido'),
    ('En proceso Admision'),
    ('Expulsado'),
    ('Inactivo'),
    ('Inicio Sesion'),
    ('Cerro Sesion')
         go
--cargar todos los numero del 101 hasta el 111 y hasta el 13
create table piso
(
    id_piso int IDENTITY(1,1) not null,
    valor_piso varchar (2) not null,
    primary key (id_piso)
);

INSERT INTO piso
    (valor_piso)
VALUES
    ('1'),
    ('2'),
    ('3'),
    ('4'),
    ('5'),
    ('6'),
    ('7'),
    ('8'),
    ('9'),
    ('10'),
    ('11'),
    ('12'),
    ('13')

       
            go
create table cargo
(
    id_cargo int IDENTITY(1,1) not null,
    valor_cargo varchar(20) not null,
    primary key  (id_cargo)
);
INSERT INTO cargo
    (valor_cargo)
VALUES
    ('Psicologo'),
    ('Gestor Social'),
    ('Mantenimiento'),
    ('Director')
            go

create table tipo_expediente
(
    id_tipo_exp int IDENTITY(1,1) not null,
    valortipoexp varchar (50) not null,
    primary key  (id_tipo_exp)
);
INSERT INTO tipo_expediente
    (valortipoexp)
VALUES
    ('Psicologico'),
    ('Social')
            go
create table rol
(
    id_rol int IDENTITY(1,1) not null,
    descripcion_rol varchar (50) not null,
    primary key  (id_rol)
);
        go
INSERT INTO rol
    (descripcion_rol)
VALUES
    ('Empleado'),
    ('Estudiante'),
    ('Mantenimiento'),
    ('Administrador')
            go




create table Permiso_Rol
(
    Rol_id int not null,
    Permiso_id_ int not null,
    primary key (Rol_id, Permiso_id_),

    CONSTRAINT  fk_rol_Permiso
                FOREIGN KEY ( Rol_id )
                REFERENCES    rol  ( id_rol),
    CONSTRAINT  fk_Permiso_Rol
                FOREIGN KEY (  Permiso_id_ )
                REFERENCES    Permiso  ( Permiso_id)

);
        go
insert into Permiso_Rol
    (Rol_id,Permiso_id_)
values
    (1, 1),
    (1, 3),
    (1, 4),
    (1, 6),
    (1, 7)

            go






create table estado_solicitud
(
    id_estado_solciitud int IDENTITY(1,1) not null,
    valor_estado_solciitud varchar (50) not null,
    primary key (id_estado_solciitud)
);
INSERT INTO estado_solicitud
    (valor_estado_solciitud)
VALUES
    ('Recibido'),
    ('Atendiendo'),
    ('Suspendido'),
    ('Solucionado'),
    ('Cancelado'),
    ('Proceso de aprobacion'),
    ('vencido')
            go


create table prioridad_solicitud
(
    id_prioridad_solciitud int IDENTITY(1,1) not null,
    valor_prioridad_solciitud varchar (50) not null,
    tiempodesolucion_horas int not null,
    primary key (id_prioridad_solciitud)
);
        go
INSERT INTO prioridad_solicitud
    (valor_prioridad_solciitud, tiempodesolucion_horas)
VALUES
    ('Alta', 24),
    ('Media', 48),
    ('Baja', 72),
    ('Urgente', 8)
            go


--
create table tipo_espacio
(
    id_tipo_espacio int IDENTITY(1,1) not null,
    valor_tipo_espacio varchar (20) not null,
    primary key (id_tipo_espacio)
);
        go
INSERT INTO tipo_espacio
    (valor_tipo_espacio)
VALUES
    ('Residencial'),
    ('Recreativo'),
    ('Almacenamiento')
            go


create table tipo_elemento
(
    id_tipo_elemento int IDENTITY(1,1) not null,
    valor_tipo_elemento varchar (30) not null,
    primary key (id_tipo_elemento)
);
        go
INSERT INTO tipo_elemento
    (valor_tipo_elemento)
VALUES
    ('Uso Residencial'),
    ('Uso Recreativo'),
    ('Tecnologico')
            go



Create Table departamento
(
    id_departamento int IDENTITY(1,1) not null,
    descripcion_departamento varchar (100) not null,
    primary key (id_departamento)
);

go
INSERT INTO departamento
    (descripcion_departamento)
VALUES
    ('ANTIOQUIA'),
    ('ATLANTICO'),
    ('BOGOTA'),
    ('BOLIVAR'),
    ('BOYACA'),
    ('CALDAS'),
    ('CAQUETA'),
    ('CAUCA'),
    ('CESAR'),
    ('CORDOBA'),
    ('CUNDINAMARCA'),
    ('CHOCO'),
    ('HUILA'),
    ('GUAVIARE'),
    ('MAGDALENA'),
    ('META'),
    ('NARIÑO'),
    ('N. DE SANTANDER'),
    ('QUINDIO'),
    ('RISARALDA'),
    ('SANTANDER'),
    ('SUCRE'),
    ('TOLIMA'),
    ('VALLE DEL CAUCA'),
    ('ARAUCA'),
    ('CASANARE'),
    ('PUTUMAYO'),
    ('SAN ANDRES'),
    ('AMAZONAS'),
    ('GUAINIA'),
    ('LA GUAJIRA'),
    ('VAUPES'),
    ('VICHADA')
go
create table pais
(
    id_pais int IDENTITY(1,1) not null,
    descripcionPais varchar(100) not null,
    primary key (id_pais)
);
        go
INSERT INTO pais
    (descripcionPais)
VALUES
    ('ARGENTINA'),
    ('BOLIVIA'),
    ('BRASIL'),
    ('COLOMBIA'),
    ('CHILE'),
    ('ECUADOR'),
    ('GUYANA'),
    ('PARAGUAY'),
    ('PERU'),
    ('SURINAM'),
    ('URUGUAY'),
    ('VENEZUELA'),
    ('GUAYANA FRANCESA'),
    ('ISLAS MALVINAS')


create table raza
(
    id_raza int IDENTITY (1,1) not null,
    descripcion_raza varchar (14) not null,
    primary key (id_raza)
);
        go
INSERT INTO raza
    (descripcion_raza)
VALUES
    ('Afrocolombiano'),
    ('Raizal'),
    ('Indigena'),
    ('Mulato'),
    ('Rom'),
    ('Negro'),
    ('Ninguno')
        go


create table tipodesangre
(
    id_tipo_sangre int IDENTITY(1,1) not null,
    descripcion_tipo_sangre varchar(11) not null,
    primary key(id_tipo_sangre)
);
        go
INSERT INTO tipodesangre
    (descripcion_tipo_sangre)
VALUES
    ('O -'),
    ('O +'),
    ('A -'),
    ('A +'),
    ('B -'),
    ('B +'),
    ('AB -'),
    ('AB +')                                                        
        go

create table tipodevivienda
(
    id_tipodevivienda int IDENTITY(1,1) not null,
    descripcion_tipovivienda varchar(9) not null,
    primary key (id_tipodevivienda)
);
INSERT INTO tipodevivienda
    (descripcion_tipovivienda)
VALUES
    ('Arrendada'),
    ('Familiar'),
    ('Propia')
        go
-----------------
create table estado_espacio
(
    id_estado_espacio int IDENTITY (1,1) not null primary key,
    valor_estado_espacio varchar (10) not null,
);
        go
insert into estado_espacio
    (valor_estado_espacio)
values
    ('Disponible'),
    ('Ocupado')
        go

create table espacio
(
    id_espacio int IDENTITY(1,1) not null,
    descripcion_espacio varchar (100) not null,
    capacidad int ,
    cupo int ,
    id_tipo_espacio_ int not null,
    id_piso_espacio int not null,

    primary key (id_espacio),
    CONSTRAINT  fk_espacio_piso
                        FOREIGN KEY (  id_piso_espacio )
                        REFERENCES    piso ( id_piso),
    CONSTRAINT  fk_tipo_espacio
                        FOREIGN KEY (  id_tipo_espacio_ )
                        REFERENCES    tipo_espacio ( id_tipo_espacio)


);
        go







create table Persona
(
    id_persona int Identity(1,1)not null,
    correo_directorio varchar(300) not null,
    contrasena varchar(50) not null,
    id_rol_Directorio int not null,
    -- Rol
    
    --

    -- Tabla TipoID
    NumeroIdentificacion varchar(15) not null,
    Nombres varchar (100) not null,
    Apellidos varchar (100) not null,
    ---
    Estadocivil int not null,
    --Tabla EstadoCivil
    Estrato int not null,
    Direccion varchar (100) not null,
    Telefono varchar (20) not null,
    Tipo_sangre int not null,
    --tabla TipoSangre
    --
    Fechanacimiento datetime not null,
    MunicipioNacimiento varchar(100) not null,
    DepartamentoNacimiento int not null,
    --Tabla Departamento
    Paisnacimiento int not null,
    sesion int not null,
    --Tabla Pais
    primary key( id_persona),
    CONSTRAINT  fk_directorio_Rol
                FOREIGN KEY ( id_rol_Directorio )
                REFERENCES    rol ( id_rol),



    CONSTRAINT  fk_estadocivil_Directorio
                    FOREIGN KEY (  Estadocivil )
                    REFERENCES    estadocivil  ( id_estadocivil),

    CONSTRAINT  fk_tiposangre_Directorio
                    FOREIGN KEY (  Tipo_sangre)
                    REFERENCES    tipodesangre  (  id_tipo_sangre ),
    CONSTRAINT  fk_pais_Directorio
                    FOREIGN KEY (  Paisnacimiento)
                    REFERENCES    Pais  (  id_pais ),

    CONSTRAINT  fk_departamento_Directorio
                    FOREIGN KEY (  departamentoNacimiento)
                    REFERENCES    departamento  (  id_departamento )



);
go



create table HistoricoTipoIdentificacion(
    id int IDENTITY(1,1) not null,
    id_personatipo int not null,
    id_tipoidentifica int not null,

    primary key (id),
    CONSTRAINT  fk_tipodocumentoDirectorio
                    FOREIGN KEY (  id_tipoidentifica )
                    REFERENCES    tipoidentificacion  (  id_tipoidentificacion ),
    CONSTRAINT  fk_hisotiropersonatipoiden
                    FOREIGN KEY (  id_personatipo )
                    REFERENCES    Persona  (  id_persona )
    



);
go



--('Activo'),('Retirado'),('Admitido'), ('En proceso Admision'), ('Expulsado'), ('Inactivo')
-- INSERT INTO cargo (valor_cargo) VALUES ('Psicologo'),('Gestor Social'), ('Mantenimiento'),('Director')

--3:56 Pm

create table empleado
(
    id_empleado int IDENTITY(1,1) not null,

    empleado_directorio int not null,
    --Tabla Directorio
    primary key (id_empleado),
    CONSTRAINT  fk_Empleado_directorio
                        FOREIGN KEY (empleado_directorio )
                        REFERENCES    Persona (  id_persona )
);
        go



create table contrato
(
    id_contrato int IDENTITY(1,1) NOT null,
    id_empleado int not null,
    cargo_contrato int not null,
    -- Tabla Cargo
    fecha_inicio date not null,
    fecha_fin date not null,
    tipo_de_contrato varchar(50) not null,
    salario bigint,
    PRIMARY key (id_contrato),
    CONSTRAINT  fk_cargo_contrato
                        FOREIGN KEY (cargo_contrato )
                        REFERENCES    cargo (  id_cargo ),
    CONSTRAINT  fk_empelado_contrato
                        FOREIGN KEY (id_empleado )
                        REFERENCES    empleado ( id_empleado )
);
        
        GO

create table historico_directorio(
    id_historico_directorio int IDENTITY(1,1) not null,
    id_directorio_ int not null,
    Estado_directorio_CRU int not null,
    descripcion_histoico varchar (200)not null,
    fecha date not null,
    id_empleado int,
    -- Estado
    primary KEY (id_historico_directorio),
      CONSTRAINT  fk_directorio_historico
                FOREIGN KEY ( id_directorio_ )
                REFERENCES   Persona  ( id_persona),
    CONSTRAINT  fk_directorio_estado
                FOREIGN KEY ( Estado_directorio_CRU )
                REFERENCES    estado_usuario_cru ( Id_estado_usuario_cru),
CONSTRAINT  fk_historico_mod_empleado
                FOREIGN KEY ( id_empleado )
                REFERENCES    empleado ( id_empleado)

);







create table estudiante
(
    id_estudiante int IDENTITY(1,1) not null,

    Servicio_Salud varchar (200) not null,
    Dispacidad_estudiante varchar (2) not  null,
    descripcion_dispacacidad_estudainte varchar (200),
    Situaciondesplazamientoestudiante varchar (2) not null,
    Numerohermanos int not null,

    tipodevivienda_estudiante int not null,
    --Tabla  Tipovivienda
    apoyouniversidad varchar (2) not null,
    descripcion_apoyo_ varchar(100),
    raza_estudiante int not null,
    --Tabla Raza
    
    --Tabla Espacio
    id_directorio_estudiante int not null,
    --Tabla    
    primary key (id_estudiante),

    CONSTRAINT  fk_estudiante_directorio
                        FOREIGN KEY (id_directorio_estudiante )
                        REFERENCES    Persona (  id_persona ),

    CONSTRAINT  fk_tipovivienda_estudiante
                    FOREIGN KEY (  tipodevivienda_estudiante )
                    REFERENCES    tipodevivienda  ( id_tipodevivienda  ),


    CONSTRAINT  fk_raza_estudiante
                    FOREIGN KEY (  raza_estudiante )
                    REFERENCES    raza  ( id_raza)

    
);
        go


create table historicoestudiante
(
    id_historico_expediente int IDENTITY(1,1) not null,
    id_estudiante int not null,
    fecha_historico_expediente datetime not null,
    descripcion_historico_expediente varchar (500) not null,
    id_empleado_historicoestudiante int,
    primary key (id_historico_expediente),

    CONSTRAINT  fk_estudiante_historico
                FOREIGN KEY (id_estudiante )
                REFERENCES    estudiante ( id_estudiante ),
    CONSTRAINT  fk_empleado_historicoestudiante
                FOREIGN KEY (id_empleado_historicoestudiante )
                REFERENCES    empleado( id_empleado )

);
        go
-- Estos



--**********************************************************
--
--                            VALUES  (1,1,'1012333333','Jefer.','Leal',1,'Cra 45 No 52 - 25','2225552','jefers@gmail.com',4,'01-01-1992','Bogota',11,4,'Compensar','No','Ninguna','No',0,3,1,'No','Ninguno',7,1,'123456',2 ),
--                                  (1,1,'1012666666','Oscar.','Leal',1,'Cll 45 No 52 - 25','2225552','oscars@gmail.com',2,'02-09-1992','Mesa',23,4,'Famisanar','No','Ninguna','No',2,3,3,'No','Ninguno',7,1,'123456',2)
--go



CREATE TABLE historico_espacio
(
    id_historico_espacio int IDENTITY(1,1) not null,
    fecha_historico_espacio date not null,
    estado_espacio_o int not null,
    descripcion varchar (100) not null,
    id_espacio_historico int not null,
    id_empleado_historico int,
    id_estudiante_espacio int, 
    PRIMARY KEY (id_historico_espacio),
    CONSTRAINT  fk_estado_espacio
                        FOREIGN KEY (  estado_espacio_o )
                        REFERENCES   estado_espacio ( id_estado_espacio),
    CONSTRAINT  fk_empleado_historico
                        FOREIGN KEY (  id_empleado_historico )
                        REFERENCES   empleado ( id_empleado),

    CONSTRAINT  fk_historico_espacio
                        FOREIGN KEY (  id_espacio_historico )
                        REFERENCES   espacio ( id_espacio),

    CONSTRAINT  fk_estudiante_espacio
                        FOREIGN KEY ( id_estudiante_espacio )
                        REFERENCES   estudiante ( id_estudiante)


);
        GO


create table datosuniversidad
(
    id_datosuniversidad int IDENTITY (1,1) not null primary key,
    Universidad_estudiante varchar (200) not null,
    Facultad_estudiante varchar (200) not null,
    Programa_estudiante varchar (200) not null,
    Puntaje_Basico_Matricula varchar (20) not null,-- 0  a 50
    Promedio_Academico_estudiante varchar (20),
    Año_ingreso_Universidad_ datetime not null,
    semestre_ingreso_universidad int not null,
    Porcentaje_Avance varchar (2),
    id_estudiante_datosuniversidad int not null ,

    CONSTRAINT  fk_datosuniversidad_estudiante
                FOREIGN KEY ( id_estudiante_datosuniversidad )
                REFERENCES    estudiante ( id_estudiante)

);
        go


create table acudiente
(
    id_acudiente int IDENTITY(1,1) not null,
    dependencia_econo_ varchar (2) not null,
    nombre_acudiente varchar (100) not null,
    apellidos_acudiente varchar (100) not null,
    ocupacion_acudiente varchar (100) not null,
    direccion_acudiente varchar(200) not null,
    departamento_acudiente int not null,
    telefono_acudiente varchar (20) not null,
    parentezo_acudiente varchar (100) not null,
    correo_acudiente varchar (100) not null,
    
    primary key (id_acudiente),
    CONSTRAINT  fk_acudiente_departamento
                FOREIGN KEY (  departamento_acudiente )
                REFERENCES    departamento ( id_departamento)
   
);
        go

create table acudiente_estudainte(
    id_acudiente_estudainte int IDENTITY(1,1) not null,
    id_estudiante int not null,
    id_acudiente int not null,
    primary key (id_acudiente_estudainte),
  CONSTRAINT  fk_estudiante_acudiente
                FOREIGN KEY (  id_acudiente )
                REFERENCES    acudiente  ( id_acudiente),

  
 CONSTRAINT  fk_acudiente_estudiante
                FOREIGN KEY (  id_estudiante )
                REFERENCES    estudiante  ( id_estudiante)


);
Go
create table archivo_estudiante
(

    id_archivo int not null,
    id_estudiante_archi int not null,
    descripcion_archivo varchar (100) not null,
    direccion_archivo varchar (500) not null,
    primary key (id_archivo),
    CONSTRAINT  fk_archivo_estudiante
                FOREIGN KEY (  id_estudiante_archi )
                REFERENCES    estudiante  (  id_estudiante ),

);

go





create table elemento
(
    id_elemento int IDENTITY(1,1) not null,
    id_tipo_elemento_ int not null,
    descripcion varchar(50) not null,
    marca varchar(50) ,
    Modelo varchar (50),
    primary key (id_elemento),
    CONSTRAINT  fk_tipo_elemento
                FOREIGN KEY (  id_tipo_elemento_ )
                REFERENCES    tipo_elemento  ( id_tipo_elemento)
);

        go


        go
create table inventario_espacio
(
    id_inventario_esp int IDENTITY(1,1) not null,
    id_elemento_inventario_espacio int not null,
    cantidad_inventario_elemento_espacio int not null,
    fecha_inventario_espacio datetime not null,
    id_espacio_inventario__ int not null,
    primary key (id_inventario_esp),
    CONSTRAINT  fk_elemento_inventario
                FOREIGN KEY (  id_elemento_inventario_espacio )
                REFERENCES    elemento  ( id_elemento),
    CONSTRAINT  fk_espacio_inventario
                FOREIGN KEY (  id_espacio_inventario__)
                REFERENCES    espacio  ( id_espacio)

);
        go


create table historio_de_inventario
(
    id_inventario_historico int Identity(1,1) primary key,
    id_empleado_historico_inventario int not null,--
    descripcion_historico_inventario varchar (200) not null,
    fecha_historico_inventario datetime not null,
    inventario_id_ int not null,--


    CONSTRAINT  fk_historico_empleado
                FOREIGN KEY (   id_empleado_historico_inventario   )
                REFERENCES    empleado (id_empleado),

    CONSTRAINT  fk_historico_inventario
                FOREIGN KEY ( inventario_id_)
                REFERENCES    inventario_espacio (id_inventario_esp)



);

go


create table solicitud
(

    id_solicitud int IDENTITY(1,1) not null,
    
    id_prioridad_solciitud__ int not null,
    fecha_solicitud date not null,
    descripcion_solicitud varchar (200) not null,
    id_estudiante_solicitud int not null,
    id_empleado_solicitud int not null,
    primary key (id_solicitud),

    CONSTRAINT  fk_prioridad_solicitud
                        FOREIGN KEY ( id_prioridad_solciitud__ )    
                        REFERENCES    prioridad_solicitud (id_prioridad_solciitud ),
    CONSTRAINT  fk_empleado_solicitud
                        FOREIGN KEY (  id_empleado_solicitud)
                        REFERENCES    empleado ( id_empleado),
    CONSTRAINT  fk_estudiante_solcitud
                        FOREIGN KEY ( id_estudiante_solicitud )
                        REFERENCES    estudiante (id_estudiante )
);
        go

create table reparacion_espacio
(
    id_reparacion int IDENTITY(1,1) not null,
    fecha_reparacion_espacio datetime not null,
    descripcion_reparacion varchar (500) not null,
    id_solicitud_reparacion int not null,

    espacio_reparacion int not null,
    archivo_Reparacion varchar(500),
    antes varchar(100),
    despues varchar (100), 
    costo bigint not null,
    

    primary key (id_reparacion),

    CONSTRAINT  fk_espacio_reparacion
                FOREIGN KEY (  espacio_reparacion)
                REFERENCES    espacio ( id_espacio),
CONSTRAINT  fk_solicitud_reparacion
                FOREIGN KEY ( id_solicitud_reparacion)
                REFERENCES    solicitud( id_solicitud)

    

);
        go



create table historico_solicitud
(
    id_historico_solicitud int IDENTITY(1,1) not null,
    id_caso_anotacion int not null,
    descripcion_anotacion varchar (200) not null,
    fecha_modificacion datetime not null,
    id_empleado_historico int,
    id_estado_solicitud_ int,
    primary key (id_historico_solicitud),
    CONSTRAINT  fk_solcitud_historio
                FOREIGN KEY (  id_caso_anotacion)
                REFERENCES    solicitud ( id_solicitud),

    CONSTRAINT  fk_estado_solicitud
                FOREIGN KEY ( id_estado_solicitud_ )
                REFERENCES    estado_solicitud ( id_estado_solciitud),

    CONSTRAINT  fk_empleado_historio
                FOREIGN KEY (  id_empleado_historico)
                REFERENCES    empleado ( id_empleado)

);
go

create table solucion
(
    id_solucion int IDENTITY(1,1) not null,
    descripcion_solucion varchar(100) not null,
    id_empleado_solucion int,
    fecha_solucion datetime,
    primary  key (id_solucion),
    id_solicitud_solucion int ,
    
    CONSTRAINT  fk_solucion_solicitud
                FOREIGN KEY (  id_solicitud_solucion)
                REFERENCES    solicitud ( id_solicitud),
    CONSTRAINT  fk_empleado_solucion
                FOREIGN KEY (  id_empleado_solucion)
                REFERENCES    empleado ( id_empleado),
  
    
);
go


create table estado_cita
(
    id_estado_cita int IDENTITY(1,1) not null,
    valor_estado_cita varchar (50) not null,
    primary key (id_estado_cita)
);
        go
INSERT INTO estado_cita
    (valor_estado_cita)
VALUES
    ('Agendada'),
    ('Atendida'),
    ('No asistio'),
    ('Cancelada');
            go

create table expediente
(
    id_expediente int IDENTITY(1,1) not null,
    id_tipo_exp int not null,


    fecha_expediente datetime not null,
    descripcion_Expediente varchar(500) not null,


    primary key (id_expediente),

    CONSTRAINT  fk_tipo_exo
                FOREIGN KEY (  id_tipo_exp )
                REFERENCES    tipo_expediente  ( id_tipo_exp)
);
     go

create table cita
(
    id_cita int IDENTITY(1,1)not null,


    
    id_expediente_cita int null,
    fecha_cita datetime not null,
    id_empleado_cita int,
    id_paciente int ,
    primary key (id_cita),
  CONSTRAINT  fk_cita_estudiante
                FOREIGN KEY (  id_paciente)
                REFERENCES    estudiante ( id_estudiante),


    CONSTRAINT  fk_cita_expediente
                FOREIGN KEY (  id_expediente_cita)
                REFERENCES    expediente ( id_expediente),

 CONSTRAINT  fk_empleado_cita
                FOREIGN KEY (  id_empleado_cita)
                REFERENCES    empleado ( id_empleado)

);

    go


CREATE TABLE HistoricoCita(
    id_HistoricoCita  int IDENTITY(1,1)not null,



    id_cita_ int not null,
    descripcion_anotacion varchar (200) not null,
    fecha_modificacion datetime not null,
    id_empleado_historico int,
    id_estadocita int,

    primary key (id_HistoricoCita),
    CONSTRAINT  fk_cita_historio
                FOREIGN KEY (  id_cita_)
                REFERENCES    cita ( id_cita),

    CONSTRAINT  fk_estado_cita
                FOREIGN KEY ( id_estadocita )
                REFERENCES    estado_cita ( id_estado_cita),

    CONSTRAINT  fk_cita_historio_empleado
                FOREIGN KEY (  id_empleado_historico)
                REFERENCES    empleado ( id_empleado)


); 
go