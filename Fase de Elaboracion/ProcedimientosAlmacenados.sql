

--*************************************************

--Procedimientos almacenados version 12-04-2017

--1. Consulta el corre y contraseña y me devuelve el numero de identificacion

CREATE PROCEDURE Iniciar_Sesion
    @correo varchar (100),
    @pass varchar (300)
    AS
    DECLARE @PassEncode As varchar(300)
    DECLARE @PassDecode As varchar(50)
    DECLARE @fecha as date
    DECLARE @id_directorio as int
     
    BEGIN
        set @fecha = (select CURRENT_TIMESTAMP);
        SELECT @PassEncode = DirectorioActivo.contrasena
        From DirectorioActivo
        WHERE DirectorioActivo.correo_directorio = @correo;
        SET @PassDecode = DECRYPTBYPASSPHRASE('P4zZW0r4', @PassEncode);
        SET @id_directorio = (SELECT id_directorio_ from DirectorioActivo wHERE @correo =DirectorioActivo.correo_directorio );
            
                If (DirectorioActivo.correo_directorio = @correo AND @PassDecode=@pass)
                   BEGIN
                        Select top (1) historico_directorio.Estado_directorio_CRU from historico_directorio where @id_directorio = id_directorio_ order by fecha desc


                                INSERT INTO historico_directorio (id_directorio_, Estado_directorio_CRU,descripcion_histoico , fecha  )
                                values (@id_directorio, 7, 'El usuario Inicia Sesion', @fecha);
                                SELECT DirectorioActivo.NumeroIdentificacion, DirectorioActivo.id_directorio_
                                FROM DirectorioActivo
                                WHERE (DirectorioActivo.correo_directorio = @correo)
                    end
                ELSE
                    BEGIN
                         INSERT INTO historico_directorio (id_directorio_, Estado_directorio_CRU,descripcion_histoico , fecha  )
                            values (@id_directorio, 7, 'El usuario Inicia Sesion', @fecha);
                    END
                

            
    END
GO

Create PROCEDURE RegistrarIniciodeSesion
    @NumeroIdentificacion varchar(15)
    as
    DECLARE @id_directorio as int
        BEGIN
        SET @id_directorio = (SELECT id_directorio_ from DirectorioActivo wHERE NumeroIdentificacion = @NumeroIdentificacion);
        INSERT INTO historico_directorio (id_directorio_, ) values (@id_directorio, 7, 'El usuario Inicia Sesion');
        END
go











create PROCEDURE  Insertar_Nuevo_Directorio


    --Fijo para todos
    @correo varchar(300),
    @contrasena varchar (50),
    --
    @TipoIdentificacion   int ,
    -- Tabla TipoID
    @NumeroIdentificacion varchar(15) ,
    @Nombres              varchar (100) ,
    @Apellidos            varchar (100) ,

    ---
    @Estadocivil          int,
    --Tabla EstadoCivil
    @Estrato              int ,
    @Direccion           varchar (100),
    @Telefono            varchar (20),
    @Tipo_sangre         int,
    --tabla TipoSangre
    --
    @Fechanacimiento      datetime ,
    @MunicipioNacimiento  varchar(100) ,
    @DepartamentoNacimiento int ,
    --Tabla Departamento
    @Paisnacimiento         int ,
    --Tabla Pais
    -- Para Empleado
    @cargo_empleado int ,
    -- Tabla Cargo

    ---- Para Estudiante
    @Servicio_Salud                            varchar (200) ,
    @Dispacidad_estudiante                     varchar (2) ,
    @descripcion_dispacacidad_estudainte       varchar (200),
    @Situaciondesplazamientoestudiante          varchar (2),
    @Numerohermanos                             int ,
    -- Para estudiante parte 2
    @tipodevivienda_estudiante int ,
    --Tabla  Tipovivienda
    @apoyouniversidad                        varchar (2) ,
    @descripcion_apoyo_                        varchar(100),
    @raza_estudiante                           int ,
    --Tabla Raza
    @id_espacio_estudiante                       int    ,
    @empleadoquemodifica int
--Tabla Espacio
as

declare @id_role int,  @id_enviar_directorio int  , @nuevoestudiante int, @fecha_modificacion datetime
BEGIN
    set @fecha_modificacion = (select CURRENT_TIMESTAMP);
    if @cargo_empleado =0
                    --Estudiante
                    BEGIN
        insert into DirectorioActivo
            (correo_directorio ,contrasena ,id_rol_Directorio ,
            Estado_directorio_CRU , TipoIdentificacion , NumeroIdentificacion ,
            Nombres ,
            Apellidos ,

            ---
            Estadocivil , --Tabla EstadoCivil
            Estrato ,
            Direccion ,
            Telefono ,
            Tipo_sangre , --tabla TipoSangre
            --
            Fechanacimiento ,
            MunicipioNacimiento ,
            DepartamentoNacimiento, --Tabla Departamento
            Paisnacimiento )
        values
            (@correo, ENCRYPTBYPASSPHRASE('P4zZW0r4', @contrasena) , 2,
                1, @TipoIdentificacion, @NumeroIdentificacion, @Nombres ,
                @Apellidos , @Estadocivil ,
                @Estrato , @Direccion , @Telefono  ,
                @Tipo_sangre , @Fechanacimiento ,
                @MunicipioNacimiento  , @DepartamentoNacimiento,
                @Paisnacimiento 
                                                                 );
        set @id_enviar_directorio = @@IDENTITY;

        insert into estudiante
            (Servicio_Salud , Dispacidad_estudiante ,
            descripcion_dispacacidad_estudainte , Situaciondesplazamientoestudiante ,
            Numerohermanos ,tipodevivienda_estudiante ,
            apoyouniversidad, descripcion_apoyo_ ,
            raza_estudiante,
            id_espacio_estudiante , id_directorio_estudiante)

        values
            (@Servicio_Salud, @Dispacidad_estudiante,
                @descripcion_dispacacidad_estudainte, @Situaciondesplazamientoestudiante,
                @Numerohermanos, @tipodevivienda_estudiante,
                @apoyouniversidad , @descripcion_apoyo_ ,
                @raza_estudiante  , @id_espacio_estudiante  , @id_enviar_directorio);
        set @nuevoestudiante = @@IDENTITY;
        insert into historicoestudiante
            (id_estudiante, fecha_historico_expediente, descripcion_historico_expediente, id_empleado_historicoestudiante)
        values
            (@nuevoestudiante, @fecha_modificacion, 'Se ha registrado el expediente', @empleadoquemodifica);
    END
                else
                    --Empleado
                    BEGIN
        BEGIN
            if @cargo_empleado=1
                            BEGIN
                set @id_role=1
            END
        END
        BEGIN
            if @cargo_empleado=2  
                            BEGIN
                set @id_role=1
            END
        END
        BEGIN
            if @cargo_empleado=3
                            BEGIN
                set @id_role=3
            END
        End
        BEGIN
            if @cargo_empleado=4
                            BEGIN
                set @id_role=4
            END
        END

        insert into DirectorioActivo
            (correo_directorio ,contrasena ,id_rol_Directorio ,
            Estado_directorio_CRU , TipoIdentificacion , NumeroIdentificacion ,
            Nombres ,
            Apellidos ,

            ---
            Estadocivil , --Tabla EstadoCivil
            Estrato ,
            Direccion ,
            Telefono ,
            Tipo_sangre , --tabla TipoSangre
            --
            Fechanacimiento ,
            MunicipioNacimiento ,
            DepartamentoNacimiento, --Tabla Departamento
            Paisnacimiento )
        values
            (@correo, ENCRYPTBYPASSPHRASE('P4zZW0r4', @contrasena) , @id_role,
                1, @TipoIdentificacion, @NumeroIdentificacion, @Nombres ,
                @Apellidos , @Estadocivil ,
                @Estrato , @Direccion , @Telefono  ,
                @Tipo_sangre , @Fechanacimiento ,
                @MunicipioNacimiento  , @DepartamentoNacimiento,
                @Paisnacimiento 
                                                 );
        set @id_enviar_directorio = @@IDENTITY;
        insert into empleado
            (cargo_empleado, empleado_directorio)
        values
            (@cargo_empleado, @id_enviar_directorio);
    END
END
            GO





--2. consultar los permisos por rol del usuarios con el correo

create procedure Consultar_Permisos_por_Usuario
    @correo varchar (100)

as


begin

    SELECT Permiso_id_, descripcion
    FROM Permiso_Rol INNER JOIN
        Permiso ON Permiso_Rol.Permiso_id_ = Permiso.Permiso_id INNER JOIN
        rol ON Permiso_Rol.Rol_id = rol.id_rol INNER JOIN
        DirectorioActivo ON rol.id_rol = DirectorioActivo.id_rol_Directorio
    where DirectorioActivo.correo_directorio= @correo;
END 

go




--3. Cargar Direnctorio Activo

--usuarioadministrador

EXEC    Insertar_Nuevo_Directorio    'admin@admini.com','123456', 1,'0000000','Administrador','CRU', 1, 1,
                                    'CRU - SEDE','9999999', 1,'01-01-2000','Bogota', 11,4, 4,'Jeferson CORP EPS',
                                    'No','Ninguna','No', 0,3,'No','Ninguna', 7, 0,1
                                    go
--Estudiante
EXEC    Insertar_Nuevo_Directorio 'estudiante1@cru.com','123456',1,'111111','Jeferson','Guevara',1,2,'Cra 48 - 52 69',
                                        '2589632',2,'01-01-1992','La mesa',11,4,0,'Compensar','No','Ninguna',
                                        'No',2,3,'No','Ninguno',7,3,1
                                        go


--EStudiante
EXEC Insertar_Nuevo_Directorio 'estudiante2@cru.com','123456',1,'2222222','Oscar','Guevara', 1,3,'Cll 43 No 58',
                                    '852147', 2,'02-08-1988','Oiba',21, 4,0,'Famisanar','No','Ninguna',
                                    'No', 2,3,'No','Ninguno', 7,3,1
                                    go
--Psicologo
EXEC Insertar_Nuevo_Directorio  'psicologo@cru.com','123456', 1,'333333','Aleja','Leal', 1, 1,'Calle 47 - 58 ',
                                     '33333333', 5,'01-05-1994','Bogota',11, 4, 1,'Ninguno','No','Ninguna','Ninguna',
                                     0,2,'No','Ninguno',7, 0,1
 go
--Director
EXEC    Insertar_Nuevo_Directorio 'director@cru.com','123456', 1,'4444444','Jose','Primo', 2, 2,'Cra 85  -  47',
                                        '444444444', 2,'01-01-2000','Bogota',11,4, 4,'Colsubsidio','as',
                                        'as','as',0, 5,'as','as',1,1,1
                        --Mantenimiento
 go
exec   Insertar_Nuevo_Directorio 'mantenimiento@correo.com','123456',1,'5555555','Juan','Gomez', 1, 2,'Cr 74 No 96',
                                        '5555555', 4,'05-09-2000','Mesitas ',11, 4, 3,'asd','as','asd','as', 1,
                                         1,'as','as', 1, 1,1


GO

--4. Consultar todos los empleados -- Vista solo para admisnistradores

create proc Consultar_Todos_Empleados
as
SELECT DirectorioActivo.id_directorio_, DirectorioActivo.Nombres, DirectorioActivo.Apellidos, DirectorioActivo.NumeroIdentificacion, cargo.valor_cargo, estado_usuario_cru.Descripcion_estado_usuario_cru,
    DirectorioActivo.Direccion, DirectorioActivo.Telefono, DirectorioActivo.correo_directorio
FROM empleado INNER JOIN
    DirectorioActivo ON empleado.empleado_directorio = DirectorioActivo.id_directorio_ INNER JOIN
    cargo ON empleado.cargo_empleado = cargo.id_cargo INNER JOIN
    estado_usuario_cru ON DirectorioActivo.Estado_directorio_CRU = estado_usuario_cru.Id_estado_usuario_cru INNER JOIN
    estadocivil ON DirectorioActivo.Estadocivil = estadocivil.id_estadocivil INNER JOIN
    tipodesangre ON DirectorioActivo.Tipo_sangre = tipodesangre.id_tipo_sangre INNER JOIN
    departamento ON DirectorioActivo.DepartamentoNacimiento = departamento.id_departamento
where DirectorioActivo.id_directorio_  <>1
                         
       GO







-- consultar tipos de combobox
create proc Consultar_Tipos_de_Identificacion

as
SELECT id_tipoidentificacion, valor_tipoidentificacion
FROM tipoidentificacion
    go

create proc Consultar_Cargos
as
SELECT id_cargo, valor_cargo
FROM cargo
    go

create proc Consultar_Estados_Civiles
as
SELECT id_estadocivil, valor_estadocivil
FROM estadocivil
    go

create proc Consultar_Estados_Usuario
as
SELECT Id_estado_usuario_cru, Descripcion_estado_usuario_cru
FROM estado_usuario_cru
    go


create proc Consultar_Tipo_Espacios
as
Begin
    SELECT id_tipo_espacio, valor_tipo_espacio
    FROM tipo_espacio
END
GO

create proc Consultar_Pisos
as
Begin
    SELECT id_piso, valor_piso
    FROM piso
END
GO


create proc Consultar_Estados_Espacios
as
Begin
    SELECT id_estado_espacio, valor_estado_espacio
    FROM estado_espacio
END

GO

Create proc Consultar_Pais
as
SELECT id_pais, descripcionPais
FROM pais

GO

Create proc Consultar_Departamento
as
SELECT id_departamento, descripcion_departamento
FROM departamento

GO

Create proc Consultar_RH
as
SELECT id_tipo_sangre, descripcion_tipo_sangre
FROM tipodesangre

GO



Create Proc Consultar_Tipos_Elemento
as
BEGIN
    SELECT [id_tipo_elemento]
      , [valor_tipo_elemento]
    FROM [PrototipoCRU].[dbo].[tipo_elemento]
END
 GO


--Procedimientos para gestion de espacios

create proc Consultar_Espacios
as
BEGIN

    SELECT espacio.id_espacio, espacio.descripcion_espacio, espacio.capacidad, tipo_espacio.valor_tipo_espacio, piso.valor_piso, estado_espacio.valor_estado_espacio, espacio.cupo
    FROM espacio INNER JOIN
        estado_espacio ON espacio.estado_espacio_o = estado_espacio.id_estado_espacio INNER JOIN
        piso ON espacio.id_piso_espacio = piso.id_piso INNER JOIN
        tipo_espacio ON espacio.id_tipo_espacio_ = tipo_espacio.id_tipo_espacio
END
GO


create proc Insertar_Nuevo_Espacio
    @descripcion varchar(100),
    @capacidad int,
    @tipoespacio int,
    @piso int
as
Begin
    insert into espacio
        (descripcion_espacio, capacidad, cupo,id_tipo_espacio_,id_piso_espacio, estado_espacio_o)
    values
        (@descripcion, @capacidad, @capacidad, @tipoespacio, @piso, 1 )

End
go





create proc Actualizar_Espacio
    @id int,
    @capacidad int,
    @tipoespacio int

as

declare @cupo int, @capacidad_anterior int
set @capacidad_anterior = (select espacio.capacidad
from espacio
where espacio.id_espacio = @id);
Begin
    if (@capacidad=@capacidad_anterior)
    BEGIN
        update espacio set id_tipo_espacio_ = @tipoespacio where espacio.id_espacio = @id
    ;
    END
    if (@capacidad>@capacidad_anterior)
    BEGIN
        set @cupo = @capacidad - @capacidad_anterior;
        if (@cupo= 0)
            begin
            update espacio set id_tipo_espacio_ = @tipoespacio, espacio.cupo = @cupo, espacio.capacidad=@capacidad, espacio.estado_espacio_o = 2 where espacio.id_espacio = @id
        ;
        END
        update espacio set id_tipo_espacio_ = @tipoespacio, espacio.cupo = @cupo, espacio.capacidad=@capacidad where espacio.id_espacio = @id
    ;
    END
    if (@capacidad<@capacidad_anterior)
    BEGIN
        set @cupo =  @capacidad_anterior - @capacidad
        ;
        if (@cupo= 0)
            begin
            update espacio set id_tipo_espacio_ = @tipoespacio, espacio.cupo = @cupo, espacio.capacidad=@capacidad, espacio.estado_espacio_o = 2 where espacio.id_espacio = @id
        ;
        END
        update espacio set id_tipo_espacio_ = @tipoespacio, espacio.cupo = @cupo, espacio.capacidad=@capacidad  where espacio.id_espacio = @id
    ;


    END
END
go



create proc Consultar_Un_Espacio
    @id int
as

SELECT espacio.id_espacio, espacio.descripcion_espacio, espacio.capacidad, tipo_espacio.valor_tipo_espacio, piso.valor_piso, estado_espacio.valor_estado_espacio, espacio.cupo
FROM espacio INNER JOIN
    estado_espacio ON espacio.estado_espacio_o = estado_espacio.id_estado_espacio INNER JOIN
    piso ON espacio.id_piso_espacio = piso.id_piso INNER JOIN
    tipo_espacio ON espacio.id_tipo_espacio_ = tipo_espacio.id_tipo_espacio
where espacio.id_espacio=@id;


go


create proc Consultar_Un_Empleado
    @identificacion int

as
BEGIN
    SELECT DirectorioActivo.Nombres, DirectorioActivo.Apellidos, DirectorioActivo.NumeroIdentificacion, DirectorioActivo.Estrato, DirectorioActivo.Direccion, DirectorioActivo.Telefono, DirectorioActivo.Fechanacimiento,
        DirectorioActivo.MunicipioNacimiento, departamento.descripcion_departamento, estadocivil.valor_estadocivil, tipoidentificacion.valor_tipoidentificacion, tipodesangre.descripcion_tipo_sangre,
        estado_usuario_cru.Descripcion_estado_usuario_cru, cargo.valor_cargo, DirectorioActivo.correo_directorio, DirectorioActivo.id_directorio_
    FROM DirectorioActivo INNER JOIN
        empleado ON DirectorioActivo.id_directorio_ = empleado.empleado_directorio INNER JOIN
        cargo ON empleado.cargo_empleado = cargo.id_cargo INNER JOIN
        departamento ON DirectorioActivo.DepartamentoNacimiento = departamento.id_departamento INNER JOIN
        estado_usuario_cru ON DirectorioActivo.Estado_directorio_CRU = estado_usuario_cru.Id_estado_usuario_cru INNER JOIN
        estadocivil ON DirectorioActivo.Estadocivil = estadocivil.id_estadocivil INNER JOIN
        tipodesangre ON DirectorioActivo.Tipo_sangre = tipodesangre.id_tipo_sangre INNER JOIN
        tipoidentificacion ON DirectorioActivo.TipoIdentificacion = tipoidentificacion.id_tipoidentificacion
    where DirectorioActivo.id_directorio_ = @identificacion
END
       GO




create proc Actualizar_Empleado
    @correo varchar (300),

    @valor_estado_cru int,
    @valor_estadoci int,
    @estrato int,
    @direccion varchar (100),
    @telefono_empl varchar (10),
    @valor_carg int,
    @id_directorio int
as
begin
    UPDATE [dbo].[DirectorioActivo]   SET [correo_directorio] = @correo,
                                              
                                              [Estado_directorio_CRU] = @valor_estado_cru,
                                              [Estadocivil] = @valor_estadoci,
                                              [Estrato] = @estrato,
                                              [Direccion] = @direccion,
                                              [Telefono] = @telefono_empl
                                              wHERE DirectorioActivo.id_directorio_ = @id_directorio;

    UPDATE [dbo].[empleado]  SET [cargo_empleado] =  @valor_carg where empleado.empleado_directorio = @id_directorio


end
        GO


create proc Actualizar_Contrasena_Usuario
    @id_directorio int,
    @pass varchar (50)
as
update DirectorioActivo set   [contrasena] = (ENCRYPTBYPASSPHRASE('P4zZW0r4', @pass)) 
        where DirectorioActivo.id_directorio_ = @id_directorio;


go







--************************************************************

create PROCEDURE  Insertar_Admision


    --Fijo para todos
    @correo varchar(300),
    @contrasena varchar (50),
    --
    @TipoIdentificacion   int ,
    -- Tabla TipoID
    @NumeroIdentificacion varchar(15) ,
    @Nombres              varchar (100) ,
    @Apellidos            varchar (100) ,

    ---
    @Estadocivil          int,
    --Tabla EstadoCivil
    @Estrato              int ,
    @Direccion           varchar (100),
    @Telefono            varchar (20),
    @Tipo_sangre         int,
    --tabla TipoSangre
    --
    @Fechanacimiento      datetime ,
    @MunicipioNacimiento  varchar(100) ,
    @DepartamentoNacimiento int ,
    --Tabla Departamento
    @Paisnacimiento         int ,
    --Tabla Pais


    ---- Para Estudiante    5
    @Servicio_Salud                            varchar (200) ,
    @Dispacidad_estudiante                     varchar (2) ,
    @descripcion_dispacacidad_estudainte       varchar (200),
    @Situaciondesplazamientoestudiante          varchar (2),
    @Numerohermanos                             int ,
    -- Para estudiante parte 2   4
    @tipodevivienda_estudiante int ,
    --Tabla  Tipovivienda
    @apoyouniversidad                        varchar (2) ,
    @descripcion_apoyo_                        varchar(100),
    @raza_estudiante                           int ,
    --Tabla Raza

    ---DatosUniversidad 8
    @Universidad                         varchar (200),
    @Facultad                            varchar(200),
    @Programa                            varchar (200),
    @PuntajeBasicoMatricula              varchar (20),
    @Promedio                            varchar (20),
    @FechadeIngreso                      datetime,
    @Semestre_ingreso                    int,
    @porcentajedeavance                  varchar(2),
    ----Acudiente 9
    @dependencia_economica              varchar(2),
    @Nombre_acudiente                   varchar(100),
    @apellidosa_acudiente               varchar(100),
    @ocupacion_acueidnete               varchar(100),
    @Direccion_Acudiente                varchar (200),
    @departamento_acudiente             int,
    --DEPARTAMENTO
    @telefono_acuediente                varchar(20),
    @parentezco_acudiente               varchar(100),
    @correo_acudiente                   varchar(100)

as

declare    @nuevoestudiante int, @fecha_modificacion datetime, @iddirectorio int
BEGIN
    set @fecha_modificacion = (select CURRENT_TIMESTAMP);

    --Estudiante

    insert into DirectorioActivo
        (correo_directorio ,contrasena ,id_rol_Directorio ,
        Estado_directorio_CRU , TipoIdentificacion , NumeroIdentificacion ,
        Nombres ,
        Apellidos ,

        ---
        Estadocivil , --Tabla EstadoCivil
        Estrato ,
        Direccion ,
        Telefono ,
        Tipo_sangre , --tabla TipoSangre
        --
        Fechanacimiento ,
        MunicipioNacimiento ,
        DepartamentoNacimiento, --Tabla Departamento
        Paisnacimiento )
    values
        (@correo, ENCRYPTBYPASSPHRASE('P4zZW0r4', @contrasena) , 2,
            4, @TipoIdentificacion, @NumeroIdentificacion, @Nombres ,
            @Apellidos , @Estadocivil ,
            @Estrato , @Direccion , @Telefono  ,
            @Tipo_sangre , @Fechanacimiento ,
            @MunicipioNacimiento  , @DepartamentoNacimiento,
            @Paisnacimiento 
                                                                 );
    set @iddirectorio = @@IDENTITY;
    --Registra el estudiante
    insert into estudiante
        (Servicio_Salud , Dispacidad_estudiante ,
        descripcion_dispacacidad_estudainte , Situaciondesplazamientoestudiante ,
        Numerohermanos ,tipodevivienda_estudiante ,
        apoyouniversidad, descripcion_apoyo_ ,
        raza_estudiante,
        id_espacio_estudiante , id_directorio_estudiante)

    values
        (@Servicio_Salud, @Dispacidad_estudiante,
            @descripcion_dispacacidad_estudainte, @Situaciondesplazamientoestudiante,
            @Numerohermanos, @tipodevivienda_estudiante,
            @apoyouniversidad , @descripcion_apoyo_ ,
            @raza_estudiante  , 7  , @iddirectorio);
    set @nuevoestudiante = @@IDENTITY;
    --registra historico del expediente
    insert into historicoestudiante
        (id_estudiante, fecha_historico_expediente, descripcion_historico_expediente, id_empleado_historicoestudiante)
    values
        (@nuevoestudiante, @fecha_modificacion, 'Se ha registrado la admision', @iddirectorio);
    --registra la universidad de estudiante
    insert into datosuniversidad
        (Universidad_estudiante, Facultad_estudiante,
        Programa_estudiante, Puntaje_Basico_Matricula, Promedio_Academico_estudiante,
        Año_ingreso_Universidad_, semestre_ingreso_universidad, Porcentaje_Avance, id_estudiante_datosuniversidad)
    values(
            @Universidad, @Facultad, @Programa, @PuntajeBasicoMatricula, @Promedio
                                                                    , @FechadeIngreso, @Semestre_ingreso, @porcentajedeavance, @nuevoestudiante);
    --registra acudiente del estudiante
    insert into acudiente_estudiante
        (dependencia_econo_, nombre_acudiente, apellidos_acudiente,
        ocupacion_acudiente, direccion_acudiente, departamento_acudiente,
        telefono_acudiente, parentezo_acudiente, correo_acudiente, id_estudiante_acu)
    values
        (@dependencia_economica, @Nombre_acudiente, @apellidosa_acudiente,
            @ocupacion_acueidnete, @Direccion_Acudiente, @departamento_acudiente,
            @telefono_acuediente, @parentezco_acudiente, @correo_acudiente, @nuevoestudiante);


END
go


Create proc Consultar_Tipos_Vivienda
as
SELECT id_tipodevivienda, descripcion_tipovivienda
FROM tipodevivienda
go

Create proc Consultar_Raza
as
SELECT id_raza, descripcion_raza
FROM raza
go


--Actualiza Admision de un estudiante de acuerdo a un empleado que modifica
create proc Actualizar_Estado_Admision
    @id_Estudiante int,
    @estodo_nuevo int,
    @empleado_modifica int
as
declare @fecha datetime, @estado_anterior varchar(30), @id_directorio_estudiante int, @estado_nuevo varchar (30)
BEGIN
    set @id_directorio_estudiante = (select estudiante.id_directorio_estudiante
    from estudiante
    where id_estudiante =@id_Estudiante);
    set @fecha = (select CURRENT_TIMESTAMP);
    --Valor_estado_Anterior
    set @estado_nuevo = (SELECT estado_usuario_cru.Descripcion_estado_usuario_cru
    FROM estado_usuario_cru
    where estado_usuario_cru.Id_estado_usuario_cru =@estodo_nuevo)
    ;
    set @estado_anterior = (SELECT estado_usuario_cru.Descripcion_estado_usuario_cru
    FROM DirectorioActivo INNER JOIN estado_usuario_cru ON DirectorioActivo.Estado_directorio_CRU = estado_usuario_cru.Id_estado_usuario_cru
    where id_directorio_ =@id_directorio_estudiante)
    ;
    update DirectorioActivo set Estado_directorio_CRU=@estodo_nuevo where DirectorioActivo.id_directorio_ = @id_Estudiante;
    insert into historicoestudiante
        (descripcion_historico_expediente,
        fecha_historico_expediente,
        id_estudiante, id_empleado_historicoestudiante)
    values

        ('El estado a cambiado de '+@estado_anterior +' a '+ @estado_nuevo, @fecha,
            @id_Estudiante, @empleado_modifica);

end

go


create proc Actualizar_Espacio_A_Estudiante
    @id_Estudiante int,
    @id_empleado_modifica int ,
    @espacionuevo int

as
declare @fecha datetime, @espacio_anterior varchar(100), @espacio_nuevo varchar (100), @cupo_ int,
    @id_anterior int


BEGIN
    set @fecha = (select CURRENT_TIMESTAMP);
    set @id_anterior = (SELECT espacio.id_espacio
    FROM espacio INNER JOIN
        estudiante ON espacio.id_espacio = estudiante.id_espacio_estudiante
    where estudiante.id_estudiante=@id_Estudiante);
    set @espacio_anterior = (SELECT espacio.descripcion_espacio
    FROM espacio INNER JOIN
        estudiante ON espacio.id_espacio = estudiante.id_espacio_estudiante
    where estudiante.id_estudiante=@id_Estudiante);
    set @espacio_nuevo = ( SELECT descripcion_espacio
    FROM espacio
    where espacio.id_espacio =@espacionuevo);
    --Actualizo el espacio al estudiante
    update estudiante set id_espacio_estudiante =@espacionuevo where id_estudiante= @id_Estudiante;
    --Inserto Historico del cambio
    insert into historicoestudiante
        (descripcion_historico_expediente,
        fecha_historico_expediente,
        id_estudiante, id_empleado_historicoestudiante)
    values
        ('El espacio ha cambiado de ' + @espacio_anterior +' a '+ @espacio_nuevo,
            @fecha, @id_Estudiante, @id_empleado_modifica);
    ---Actualizacion del cupo del espacio anterior 
    set @cupo_ = (select espacio.cupo
    from espacio
    where espacio.id_espacio = @id_anterior);
    set @cupo_ = @cupo_ + 1;


    update espacio set cupo =@cupo_, estado_espacio_o= 1 where id_espacio = @id_anterior;
    set @cupo_=0;

    -----Actualizacion del cupo del espacio nuevo
    set @cupo_ = (select espacio.cupo
    from espacio
    where espacio.id_espacio = @espacio_nuevo);
    set @cupo_=@cupo_ -1;
    begin
        if (@cupo_=0)
    begin
            update espacio set cupo =@cupo_, estado_espacio_o= 2 where id_espacio = @espacio_nuevo;
        end
        if (@cupo_>0)
    begin
            update espacio set cupo =@cupo_, estado_espacio_o= 1 where id_espacio = @espacio_nuevo;
        end
    ENd

END 
gO


create proc Consultar_Espacios_Disponibles
as
SELECT espacio.id_espacio, espacio.descripcion_espacio
FROM espacio INNER JOIN
    estado_espacio ON espacio.estado_espacio_o = estado_espacio.id_estado_espacio
where espacio.estado_espacio_o =1
go


Create proc Consultar_Estudiantes_Admision

as
BEGIN
    SELECT DirectorioActivo.Nombres, DirectorioActivo.Apellidos, DirectorioActivo.id_directorio_, estado_usuario_cru.Descripcion_estado_usuario_cru, espacio.descripcion_espacio
    FROM DirectorioActivo INNER JOIN
        estudiante ON DirectorioActivo.id_directorio_ = estudiante.id_directorio_estudiante INNER JOIN
        espacio ON estudiante.id_espacio_estudiante = espacio.id_espacio INNER JOIN
        estado_usuario_cru ON DirectorioActivo.Estado_directorio_CRU = estado_usuario_cru.Id_estado_usuario_cru
    where espacio.id_espacio = 1
END
go







------------------------------------
create proc Insertar_Nuevo_Elemento
    @id_tipo_Elemento int,
    @descripcion_ele varchar(50),
    @marca  varchar(50),
    @Modelo varchar(50),
    @cantidad int,
    @id_directorio int
as
declare @fecha datetime, @id_elemento int, @inventario int, @empleado int
BEGIN
    set @fecha = (select CURRENT_TIMESTAMP);
    set @empleado =(SELECT empleado.id_empleado
    FROM empleado INNER JOIN
        DirectorioActivo ON empleado.empleado_directorio = DirectorioActivo.id_directorio_
    where DirectorioActivo.id_directorio_ =@id_directorio);

    insert into elemento
        (id_tipo_elemento_,descripcion, marca, Modelo)
    values
        (@id_tipo_Elemento, @descripcion_ele, @marca, @Modelo);
    set @id_elemento =@@IDENTITY;

    insert into inventario_espacio
        (id_elemento_inventario_espacio,cantidad_inventario_elemento_espacio, fecha_inventario_espacio, id_espacio_inventario__)
    values(@id_elemento, @cantidad, @fecha, 2)
    ;

    set @inventario = @@IDENTITY;
    insert into historio_de_inventario
        (id_empleado_historico_inventario, descripcion_historico_inventario,fecha_historico_inventario, inventario_id_)
    values(@empleado, 'Se ha registrado el elemento '+ @descripcion_ele  +' con cantidad inicial '+ Cast(@cantidad as varchar) +' Unidades ', @fecha, @inventario);


END
GO


EXEC    [dbo].[Insertar_Nuevo_Elemento] 1, 'Cama Sencilla', 'Madeflex', 'Sencilla',20, 5
go

EXEC    [dbo].[Insertar_Nuevo_Elemento] 1, 'Colchones', 'Spring', 'SemiOrtopedica',20, 5
go

EXEC    [dbo].[Insertar_Nuevo_Elemento] 1, 'Cobija', 'ECUADOR', ' Termica',20, 5
go

EXEC    [dbo].[Insertar_Nuevo_Elemento] 1, 'Estufa Electrica', 'HACEB', 'Dos Puestos',10, 5
go

EXEC    [dbo].[Insertar_Nuevo_Elemento] 1, 'Escritorio', 'Madeflex', 'Estudiantil',15, 5
go

EXEC    [dbo].[Insertar_Nuevo_Elemento] 1, 'Silla Plastica', 'Remix', 'Estabdar',15, 5
go



create proc Consultar_Inventario_de_Espacio
    @id_espacio  int
as
BEGIN
    SELECT elemento.descripcion, inventario_espacio.cantidad_inventario_elemento_espacio, inventario_espacio.fecha_inventario_espacio, elemento.id_elemento, espacio.id_espacio
    FROM espacio INNER JOIN
        inventario_espacio ON espacio.id_espacio = inventario_espacio.id_espacio_inventario__ INNER JOIN
        elemento ON inventario_espacio.id_elemento_inventario_espacio = elemento.id_elemento
    WHERE        (espacio.id_espacio = @id_espacio)
END

go










