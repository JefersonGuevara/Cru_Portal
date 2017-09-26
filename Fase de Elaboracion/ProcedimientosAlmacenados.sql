

--*************************************************

--Procedimientos almacenados version 8-8-2017

CREATE PROCEDURE Consultar_Login
    @correo varchar (100),
    @pass varchar (300)

  AS
  DECLARE @PassEncode As varchar(300)
  DECLARE @PassDecode As varchar(50)
  
  BEGIN
  
      SELECT @PassEncode = Persona.contrasena
      From Persona
      WHERE Persona.correo_directorio = @correo
      SET @PassDecode = DECRYPTBYPASSPHRASE('P4zZW0r4', @PassEncode)
      SELECT Persona.NumeroIdentificacion, Persona.id_persona
      FROM Persona
      WHERE (Persona.correo_directorio = @correo AND @PassDecode=@pass)
  
  
  END
          GO
CREATE PROCEDURE Consultar_Login_app
    @correo varchar (100),
    @pass varchar (300)

  AS
  DECLARE @PassEncode As varchar(300)
  DECLARE @PassDecode As varchar(50)
  
  BEGIN
  
      SELECT @PassEncode = Persona.contrasena
      From Persona
      WHERE Persona.correo_directorio = @correo
      SET @PassDecode = DECRYPTBYPASSPHRASE('P4zZW0r4', @PassEncode)
      SELECT estudiante.id_estudiante from estudiante
      inner join Persona on Persona.id_persona=estudiante.id_directorio_estudiante


      WHERE (Persona.correo_directorio = @correo AND @PassDecode=@pass)
  
  
  END
          GO
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


create proc consultar_estadosSolicitud
as
Begin
SELECT        id_estado_solciitud, valor_estado_solciitud
FROM            estado_solicitud
End
GO

create proc consultar_PrioridadSolicitud
as
Begin
SELECT        id_prioridad_solciitud, tiempodesolucion_horas, valor_prioridad_solciitud
FROM            prioridad_solicitud
End
Go

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


Create Proc Consultar_Tipos_Elemento
as
BEGIN
    SELECT [id_tipo_elemento]
      , [valor_tipo_elemento]
    FROM [PrototipoCRU].[dbo].[tipo_elemento]
END
 GO





--1. Procedimiento para registrar empleado con contrato
create PROCEDURE  Registrar_Empleado
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

    ---- Para contrato
    @fecha_fin datetime,
   @tipocontrato varchar(50) ,
   @salario     bigint,

   @empleadoqueregistra int
   --Tabla Espacio
    as

        declare @id_role int,  @id_enviar_directorio int  ,  @fecha_modificacion datetime, @id_nuevo_empleado int
        BEGIN
            set @fecha_modificacion = (select CURRENT_TIMESTAMP);
				--Cargo psicolog y gestor -> rol 1
				--Cargo 
                BEGIN
                    if @cargo_empleado=1 or @cargo_empleado=2
                       set @id_role=1
                END
                BEGIN
                    if @cargo_empleado=3
                        set @id_role=3
                End
                BEGIN
                    if @cargo_empleado=4
                        set @id_role=4
                END

                insert into Persona
                    (correo_directorio ,contrasena ,id_rol_Directorio ,
                       NumeroIdentificacion ,
                    Nombres , Apellidos ,

                    Estadocivil , --Tabla EstadoCivil
                    Estrato ,
                    Direccion ,
                    Telefono ,
                    Tipo_sangre , --tabla TipoSangre
                    --
                    Fechanacimiento ,
                    MunicipioNacimiento ,
                    DepartamentoNacimiento, --Tabla Departamento
                    Paisnacimiento , 
                    sesion)
                values
                    (@correo, ENCRYPTBYPASSPHRASE('P4zZW0r4', @contrasena) , @id_role,
                         @NumeroIdentificacion, @Nombres ,
                        @Apellidos , @Estadocivil ,
                        @Estrato , @Direccion , @Telefono  ,
                        @Tipo_sangre , @Fechanacimiento ,
                        @MunicipioNacimiento  , @DepartamentoNacimiento,
                        @Paisnacimiento ,0
                                                        );

                set @id_enviar_directorio = @@IDENTITY;
                insert into empleado ( empleado_directorio)
                values               ( @id_enviar_directorio);

				set @id_nuevo_empleado = @@IDENTITY;
				--insert tabla contrato
				insert into contrato (id_empleado, cargo_contrato, fecha_inicio, fecha_fin, tipo_de_contrato, salario) 
				values(@id_nuevo_empleado, @cargo_empleado, @fecha_modificacion, @fecha_fin, @tipocontrato, @salario);
				--insert tabla historico 
				insert into historico_directorio(id_directorio_, Estado_directorio_CRU, descripcion_histoico, fecha, id_empleado) 
				values ( @id_enviar_directorio, 1, 'Se ha registrado el Empleado', @fecha_modificacion,@empleadoqueregistra );

            
        END
GO
--1.1 Cargar Directorio Activo

--usuarioadministrador

EXEC	 [dbo].[Registrar_Empleado]
		@correo = N'admin_cru@gmail.com',
		@contrasena = N'123456',
		@TipoIdentificacion = 1,
		@NumeroIdentificacion = N'0000000',
		@Nombres = N'Administrador',
		@Apellidos = N'CRU',
		@Estadocivil = 1,
		@Estrato = 1,
		@Direccion = N'CRU - SEDE',
		@Telefono = N'99999999',
		@Tipo_sangre = 1,
		@Fechanacimiento = N'01-01-2000',
		@MunicipioNacimiento = N'Bogota',
		@DepartamentoNacimiento = 11,
		@Paisnacimiento = 4,
		@cargo_empleado = 4,
		@fecha_fin = N'01-01-2100',
		@tipocontrato = N'Indefinido',
		@salario = 5000000,
		@empleadoqueregistra = NULL
		
GO



EXEC	 [dbo].[Registrar_Empleado]
		@correo = N'director@gmail.com',
		@contrasena = N'123456',
		@TipoIdentificacion = 1,
		@NumeroIdentificacion = N'0000000',
		@Nombres = N'Director',
		@Apellidos = N'CRU',
		@Estadocivil = 1,
		@Estrato = 1,
		@Direccion = N'CRU - SEDE',
		@Telefono = N'99999999',
		@Tipo_sangre = 1,
		@Fechanacimiento = N'01-01-2000',
		@MunicipioNacimiento = N'Bogota',
		@DepartamentoNacimiento = 11,
		@Paisnacimiento = 4,
		@cargo_empleado = 4,
		@fecha_fin = N'01-01-2100',
		@tipocontrato = N'Indefinido',
		@salario = 5000000,
		@empleadoqueregistra = NULL
		
GO
EXEC	 [dbo].[Registrar_Empleado]
		@correo = N'mantenimiento@gmail.com',
		@contrasena = N'123456',
		@TipoIdentificacion = 1,
		@NumeroIdentificacion = N'0000000',
		@Nombres = N'Mantenimiento',
		@Apellidos = N'CRU',
		@Estadocivil = 1,
		@Estrato = 1,
		@Direccion = N'CRU - SEDE',
		@Telefono = N'99999999',
		@Tipo_sangre = 1,
		@Fechanacimiento = N'01-01-2000',
		@MunicipioNacimiento = N'Bogota',
		@DepartamentoNacimiento = 11,
		@Paisnacimiento = 4,
		@cargo_empleado = 3,
		@fecha_fin = N'01-01-2100',
		@tipocontrato = N'Indefinido',
		@salario = 5000000,
		@empleadoqueregistra = NULL
		
GO
EXEC	 [dbo].[Registrar_Empleado]
		@correo = N'psicologo@gmail.com',
		@contrasena = N'123456',
		@TipoIdentificacion = 1,
		@NumeroIdentificacion = N'0000000',
		@Nombres = N'Psicologo',
		@Apellidos = N'UNO',
		@Estadocivil = 1,
		@Estrato = 1,
		@Direccion = N'CRU - SEDE',
		@Telefono = N'99999999',
		@Tipo_sangre = 1,
		@Fechanacimiento = N'01-01-2000',
		@MunicipioNacimiento = N'Bogota',
		@DepartamentoNacimiento = 11,
		@Paisnacimiento = 4,
		@cargo_empleado = 1,
		@fecha_fin = N'01-01-2100',
		@tipocontrato = N'Indefinido',
		@salario = 5000000,
		@empleadoqueregistra = NULL
		
GO
EXEC	 [dbo].[Registrar_Empleado]
		@correo = N'psicologo2@gmail.com',
		@contrasena = N'123456',
		@TipoIdentificacion = 1,
		@NumeroIdentificacion = N'0000000',
		@Nombres = N'Psicologo ',
		@Apellidos = N'DOS',
		@Estadocivil = 1,
		@Estrato = 1,
		@Direccion = N'CRU - SEDE',
		@Telefono = N'99999999',
		@Tipo_sangre = 1,
		@Fechanacimiento = N'01-01-2000',
		@MunicipioNacimiento = N'Bogota',
		@DepartamentoNacimiento = 11,
		@Paisnacimiento = 4,
		@cargo_empleado = 1,
		@fecha_fin = N'01-01-2100',
		@tipocontrato = N'Indefinido',
		@salario = 5000000,
		@empleadoqueregistra = NULL
		
GO
-- 1.3 Verificar si la persona existe?

Create proc [dbo].[Insertar_Nuevo_Espacio]
            @descripcion varchar(100),
            @capacidad int,
            @tipoespacio int,
            @piso int,
            @id_empleadoquecrea int
        as

        declare @id_espacionuevo int, @fecha_modificacion DATE, @espacionuevo int
        Begin
            insert into espacio
                (descripcion_espacio, capacidad, cupo,id_tipo_espacio_,id_piso_espacio)
            values
                (@descripcion, @capacidad, @capacidad, @tipoespacio, @piso )
            set @espacionuevo = @@IDENTITY;
            set @fecha_modificacion = (select CURRENT_TIMESTAMP);
            insert into historico_espacio (fecha_historico_espacio,descripcion, estado_espacio_o, id_espacio_historico, id_empleado_historico) values
                                           (@fecha_modificacion,'Se ha creado el espacio', 1, @espacionuevo, @id_empleadoquecrea );
        End

		Go

EXEC	 [dbo].[Insertar_Nuevo_Espacio]
		@descripcion = N'Admision',
		@capacidad = 300,
		@tipoespacio = 1,
		@piso = 1,
		@id_empleadoquecrea = 1
        GO
EXEC	 [dbo].[Insertar_Nuevo_Espacio]
		@descripcion = N'Bodega',
		@capacidad = 1000,
		@tipoespacio = 3,
		@piso = 1,
		@id_empleadoquecrea = 1
        GO
EXEC	 [dbo].[Insertar_Nuevo_Espacio]
		@descripcion = N'201',
		@capacidad = 3,
		@tipoespacio = 1,
		@piso = 2,
		@id_empleadoquecrea = 1
        GO
 EXEC	 [dbo].[Insertar_Nuevo_Espacio]
		@descripcion = N'301',
		@capacidad = 3,
		@tipoespacio = 1,
		@piso = 3,
		@id_empleadoquecrea = 1
        GO
EXEC	 [dbo].[Insertar_Nuevo_Espacio]
		@descripcion = N'401',
		@capacidad = 2,
		@tipoespacio = 1,
		@piso = 4,
		@id_empleadoquecrea = 1
        GO        

create procedure Verificar_Persona
    @id_persona varchar(15)
    as
    SELECT        Nombres, Apellidos
    FROM            Persona where Persona.NumeroIdentificacion = @id_persona;
    --si es null el resultado no existe puede, ejecutar registro
    --si no es null, no se puede registrar
go

--2. Procedimeinto para registrar estudiante en la admision

--2. Procedimeinto para registrar estudiante en la admision
create PROCEDURE  Registrar_Admision
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
    @Fechanacimiento      datetime ,
    @MunicipioNacimiento  varchar(100) ,
    @DepartamentoNacimiento int ,
    --Tabla Departamento
    @Paisnacimiento         int ,
    --Tabla Pais
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
        	@Universidad varchar(100),
		@Facultad varchar(100),
		@Programa  varchar(100),
		@PuntajeBasicoMatricula varchar(20),
		@Promedio varchar(4),
		@FechadeIngreso datetime,
		@Semestre_ingreso int,
		@porcentajedeavance varchar(2)
  as

    declare @id_role int,  
		@id_enviar_directorio int,
		@nuevoestudiante int,
		@fecha_modificacion datetime
    BEGIN
    set @fecha_modificacion = (select CURRENT_TIMESTAMP);
                    --Estudiante
						insert into Persona
						(correo_directorio,contrasena ,id_rol_Directorio ,
						  NumeroIdentificacion ,
						Nombres ,
						Apellidos ,

						Estadocivil , --Tabla EstadoCivil
						Estrato ,
						Direccion ,
						Telefono ,
						Tipo_sangre , --tabla TipoSangre
						--
						Fechanacimiento ,
						MunicipioNacimiento ,
						DepartamentoNacimiento, --Tabla Departamento
						Paisnacimiento, sesion )
					values
						(@correo, ENCRYPTBYPASSPHRASE('P4zZW0r4', @contrasena) , 2,
							 @NumeroIdentificacion, @Nombres ,
							@Apellidos , @Estadocivil ,
							@Estrato , @Direccion , @Telefono  ,
							@Tipo_sangre , @Fechanacimiento ,
							@MunicipioNacimiento  , @DepartamentoNacimiento,
							@Paisnacimiento , 2);

					set @id_enviar_directorio = @@IDENTITY;
                    insert into HistoricoTipoIdentificacion (id_personatipo, id_tipoidentifica)values(@id_enviar_directorio,@TipoIdentificacion );
					insert into estudiante
						(Servicio_Salud , Dispacidad_estudiante ,
						descripcion_dispacacidad_estudainte , Situaciondesplazamientoestudiante ,
						Numerohermanos ,tipodevivienda_estudiante ,
						apoyouniversidad, descripcion_apoyo_ ,
						raza_estudiante,
						 id_directorio_estudiante)

					values
						(@Servicio_Salud, @Dispacidad_estudiante,
							@descripcion_dispacacidad_estudainte, @Situaciondesplazamientoestudiante,
							@Numerohermanos, @tipodevivienda_estudiante,
							@apoyouniversidad , @descripcion_apoyo_ ,
							@raza_estudiante    , @id_enviar_directorio);


					set @nuevoestudiante = @@IDENTITY;
					insert into historico_directorio(id_directorio_, Estado_directorio_CRU, descripcion_histoico, fecha, id_empleado) 
					values ( @id_enviar_directorio, 4, 'Se ha registrado la admision', @fecha_modificacion, 1);
					--Insert historico estudiante
					insert into historicoestudiante
						(id_estudiante, fecha_historico_expediente, descripcion_historico_expediente, id_empleado_historicoestudiante)
					values
						(@nuevoestudiante, @fecha_modificacion, 'Se registro un Estudiante', 1);
					update espacio set cupo = (select espacio.cupo)-1 where espacio.id_espacio=1;
					insert into historico_espacio (estado_espacio_o,descripcion, fecha_historico_espacio,id_empleado_historico,id_espacio_historico,id_estudiante_espacio)
					values(1,'Se ha agregado un cupo en Admisiones', @fecha_modificacion, 1,1,@nuevoestudiante );
					
					insert into datosuniversidad (Año_ingreso_Universidad_,Facultad_estudiante,id_estudiante_datosuniversidad,Porcentaje_Avance,Programa_estudiante,Promedio_Academico_estudiante,Puntaje_Basico_Matricula,semestre_ingreso_universidad,Universidad_estudiante)
					values(@FechadeIngreso, @Facultad, @nuevoestudiante, @porcentajedeavance, @Programa, @Promedio, @PuntajeBasicoMatricula, @Semestre_ingreso, @Universidad);
					

					
					
         
    END
GO
EXEC	[dbo].[Registrar_Admision]
		@correo = N'estudiante1@cru.com',
		@contrasena = N'123456',
		@TipoIdentificacion = 2,
		@NumeroIdentificacion = N'101257896',
		@Nombres = N'Myrian',
		@Apellidos = N'Sanchez',
		@Estadocivil = 1,
		@Estrato = 1,
		@Direccion = N'Cra 49',
		@Telefono = N'7412589',
		@Tipo_sangre = 1,
		@Fechanacimiento = N'01-01-2000',
		@MunicipioNacimiento = N'Bogota',
		@DepartamentoNacimiento = 11,
		@Paisnacimiento = 4,
		@Servicio_Salud = N'Famisanar',
		@Dispacidad_estudiante = N'No',
		@descripcion_dispacacidad_estudainte = N'No Aplica',
		@Situaciondesplazamientoestudiante = N'No',
		@Numerohermanos = 2,
		@tipodevivienda_estudiante = 1,
		@apoyouniversidad = N'No',
		@descripcion_apoyo_ = N'No Aplica',
		@raza_estudiante = 7,
		@Universidad = N'U Nacional',
		@Facultad = N'Sistemas',
		@Programa = N'Ingenieria de Sistema',
		@PuntajeBasicoMatricula = N'450',
		@Promedio = N'4.03',
		@FechadeIngreso = N'2015-09-02 00:00:00.000',
		@Semestre_ingreso = 2,
		@porcentajedeavance = N'25'



EXEC	[dbo].[Registrar_Admision]
		@correo = N'estudiante2@cru.com',
		@contrasena = N'123456',
		@TipoIdentificacion = 2,
		@NumeroIdentificacion = N'101257895',
		@Nombres = N'Oscar',
		@Apellidos = N'Sanchez',
		@Estadocivil = 1,
		@Estrato = 1,
		@Direccion = N'Cra 49',
		@Telefono = N'7412589',
		@Tipo_sangre = 1,
		@Fechanacimiento = N'01-01-2000',
		@MunicipioNacimiento = N'Bogota',
		@DepartamentoNacimiento = 11,
		@Paisnacimiento = 4,
		@Servicio_Salud = N'Famisanar',
		@Dispacidad_estudiante = N'No',
		@descripcion_dispacacidad_estudainte = N'No Aplica',
		@Situaciondesplazamientoestudiante = N'No',
		@Numerohermanos = 2,
		@tipodevivienda_estudiante = 1,
		@apoyouniversidad = N'No',
		@descripcion_apoyo_ = N'No Aplica',
		@raza_estudiante = 7,
		@Universidad = N'U Nacional',
		@Facultad = N'Sistemas',
		@Programa = N'Ingenieria de Sistema',
		@PuntajeBasicoMatricula = N'450',
		@Promedio = N'4.03',
		@FechadeIngreso = N'2015-09-02 00:00:00.000',
		@Semestre_ingreso = 2,
		@porcentajedeavance = N'25'

EXEC	 [dbo].[Registrar_Admision]
		@correo = N'estudiante3@cru.com',
		@contrasena = N'123456',
		@TipoIdentificacion = 2,
		@NumeroIdentificacion = N'101257856',
		@Nombres = N'Angie',
		@Apellidos = N'Sanchez',
		@Estadocivil = 1,
		@Estrato = 1,
		@Direccion = N'Cra 49',
		@Telefono = N'7412589',
		@Tipo_sangre = 1,
		@Fechanacimiento = N'01-01-2000',
		@MunicipioNacimiento = N'Bogota',
		@DepartamentoNacimiento = 11,
		@Paisnacimiento = 4,
		@Servicio_Salud = N'Famisanar',
		@Dispacidad_estudiante = N'No',
		@descripcion_dispacacidad_estudainte = N'No Aplica',
		@Situaciondesplazamientoestudiante = N'No',
		@Numerohermanos = 2,
		@tipodevivienda_estudiante = 1,
		@apoyouniversidad = N'No',
		@descripcion_apoyo_ = N'No Aplica',
		@raza_estudiante = 7,
		@Universidad = N'U Nacional',
		@Facultad = N'Sistemas',
		@Programa = N'Ingenieria de Sistema',
		@PuntajeBasicoMatricula = N'450',
		@Promedio = N'4.03',
		@FechadeIngreso = N'2015-09-02 00:00:00.000',
		@Semestre_ingreso = 2,
		@porcentajedeavance = N'25'

EXEC	 [dbo].[Registrar_Admision]
		@correo = N'estudiante4@cru.com',
		@contrasena = N'123456',
		@TipoIdentificacion = 2,
		@NumeroIdentificacion = N'101257896',
		@Nombres = N'Jeferson',
		@Apellidos = N'Sanchez',
		@Estadocivil = 1,
		@Estrato = 1,
		@Direccion = N'Cra 49',
		@Telefono = N'7412589',
		@Tipo_sangre = 1,
		@Fechanacimiento = N'01-01-2000',
		@MunicipioNacimiento = N'Bogota',
		@DepartamentoNacimiento = 11,
		@Paisnacimiento = 4,
		@Servicio_Salud = N'Famisanar',
		@Dispacidad_estudiante = N'No',
		@descripcion_dispacacidad_estudainte = N'No Aplica',
		@Situaciondesplazamientoestudiante = N'No',
		@Numerohermanos = 2,
		@tipodevivienda_estudiante = 1,
		@apoyouniversidad = N'No',
		@descripcion_apoyo_ = N'No Aplica',
		@raza_estudiante = 7,
		@Universidad = N'U Nacional',
		@Facultad = N'Sistemas',
		@Programa = N'Ingenieria de Sistema',
		@PuntajeBasicoMatricula = N'450',
		@Promedio = N'4.03',
		@FechadeIngreso = N'2015-09-02 00:00:00.000',
		@Semestre_ingreso = 2,
		@porcentajedeavance = N'25'

EXEC	 [dbo].[Registrar_Admision]
		@correo = N'estudiante5@cru.com',
		@contrasena = N'123456',
		@TipoIdentificacion = 2,
		@NumeroIdentificacion = N'101257874',
		@Nombres = N'Jose',
		@Apellidos = N'Sanchez',
		@Estadocivil = 1,
		@Estrato = 1,
		@Direccion = N'Cra 49',
		@Telefono = N'7412589',
		@Tipo_sangre = 1,
		@Fechanacimiento = N'01-01-2000',
		@MunicipioNacimiento = N'Bogota',
		@DepartamentoNacimiento = 11,
		@Paisnacimiento = 4,
		@Servicio_Salud = N'Famisanar',
		@Dispacidad_estudiante = N'No',
		@descripcion_dispacacidad_estudainte = N'No Aplica',
		@Situaciondesplazamientoestudiante = N'No',
		@Numerohermanos = 2,
		@tipodevivienda_estudiante = 1,
		@apoyouniversidad = N'No',
		@descripcion_apoyo_ = N'No Aplica',
		@raza_estudiante = 7,
		@Universidad = N'U Nacional',
		@Facultad = N'Sistemas',
		@Programa = N'Ingenieria de Sistema',
		@PuntajeBasicoMatricula = N'450',
		@Promedio = N'4.03',
		@FechadeIngreso = N'2015-09-02 00:00:00.000',
		@Semestre_ingreso = 2,
		@porcentajedeavance = N'25'

GO






--3. Procedimeinto para agregar Acudiente

Create PROCEDURE Registrar_Acudiente
	@id_estudiante int,

	@dependecia_econ varchar (2),
	@nombre_acudient varchar (100), 
    @apellidos_acudi varchar (100) ,
    @ocupacion_acudi varchar (100) ,
    @direccion_acudi varchar(200) ,
    @departamento_ac int ,
    @telefono_acudie varchar (20) ,
    @parentezo_acudi varchar (100) ,
    @correo_acudient varchar (100) 
    


 as
    declare @id_nuevoacudiente int 
	    insert into acudiente(
						dependencia_econo_ ,
						nombre_acudiente ,
						apellidos_acudiente ,
						ocupacion_acudiente ,
						direccion_acudiente ,
						departamento_acudiente ,
						telefono_acudiente ,
						parentezo_acudiente ,
						correo_acudiente )
						
						 values(
							@dependecia_econ,
							@nombre_acudient, 
							@apellidos_acudi ,
							@ocupacion_acudi ,
							@direccion_acudi,
							@departamento_ac ,
							@telefono_acudie ,
							@parentezo_acudi ,
							@correo_acudient 
						 );
		set @id_nuevoacudiente = @@IDENTITY;
		insert into acudiente_estudainte (id_estudiante, id_acudiente) 
						values   		(@id_estudiante, @id_nuevoacudiente);
go







EXEC  [dbo].[Registrar_Acudiente]
		@id_estudiante = 1,
		@dependecia_econ = N'No',
		@nombre_acudient = N'Carlos',
		@apellidos_acudi = N'Gutierrez',
		@ocupacion_acudi = N'Guarda',
		@direccion_acudi = N'Cra 48 Barrio Sucre',
		@departamento_ac = 4,
		@telefono_acudie = N'8523698',
		@parentezo_acudi = N'Tio',
		@correo_acudient = N'carlos@corre.com'


EXEC  [dbo].[Registrar_Acudiente]
		@id_estudiante = 2,
		@dependecia_econ = N'No',
		@nombre_acudient = N'Carlos',
		@apellidos_acudi = N'Gutierrez',
		@ocupacion_acudi = N'Guarda',
		@direccion_acudi = N'Cra 48 Barrio Sucre',
		@departamento_ac = 4,
		@telefono_acudie = N'8523698',
		@parentezo_acudi = N'Tio',
		@correo_acudient = N'carlos@corre.com'

EXEC  [dbo].[Registrar_Acudiente]
		@id_estudiante = 3,
		@dependecia_econ = N'No',
		@nombre_acudient = N'Carlos',
		@apellidos_acudi = N'Gutierrez',
		@ocupacion_acudi = N'Guarda',
		@direccion_acudi = N'Cra 48 Barrio Sucre',
		@departamento_ac = 4,
		@telefono_acudie = N'8523698',
		@parentezo_acudi = N'Tio',
		@correo_acudient = N'carlos@corre.com'

EXEC  [dbo].[Registrar_Acudiente]
		@id_estudiante = 4,
		@dependecia_econ = N'No',
		@nombre_acudient = N'Carlos',
		@apellidos_acudi = N'Gutierrez',
		@ocupacion_acudi = N'Guarda',
		@direccion_acudi = N'Cra 48 Barrio Sucre',
		@departamento_ac = 4,
		@telefono_acudie = N'8523698',
		@parentezo_acudi = N'Tio',
		@correo_acudient = N'carlos@corre.com'

EXEC  [dbo].[Registrar_Acudiente]
		@id_estudiante = 5,
		@dependecia_econ = N'No',
		@nombre_acudient = N'Carlos',
		@apellidos_acudi = N'Gutierrez',
		@ocupacion_acudi = N'Guarda',
		@direccion_acudi = N'Cra 48 Barrio Sucre',
		@departamento_ac = 4,
		@telefono_acudie = N'8523698',
		@parentezo_acudi = N'Tio',
		@correo_acudient = N'carlos@corre.com'


Go




--4. 



Create proc [dbo].[Consultar_Espacios]
as
BEGIN

    SELECT        espacio.id_espacio, espacio.descripcion_espacio, espacio.cupo,tipo_espacio.valor_tipo_espacio, piso.valor_piso, estado_espacio.valor_estado_espacio, historico_espacio.fecha_historico_espacio
FROM            historico_espacio  INNER JOIN

						(select historico_espacio.id_espacio_historico , max(historico_espacio.fecha_historico_espacio ) as fecha from  historico_espacio group by historico_espacio.id_espacio_historico ) as T1 on
						T1.id_espacio_historico=historico_espacio.id_espacio_historico and 
						T1.fecha = historico_espacio.fecha_historico_espacio
						 INNER JOIN
                         estado_espacio ON historico_espacio.estado_espacio_o = estado_espacio.id_estado_espacio INNER JOIN
                         espacio ON historico_espacio.id_espacio_historico = espacio.id_espacio INNER JOIN
                         tipo_espacio ON espacio.id_tipo_espacio_ = tipo_espacio.id_tipo_espacio inner join
						 piso on espacio.id_piso_espacio = piso.id_piso
						where espacio.id_espacio <>1 and espacio.id_espacio<>2
END

Go


create proc [dbo].[Consultar_Si_ExisteEspacio]
@descripcion varchar (100)
as
BEGIN

    SELECT         espacio.descripcion_espacio
FROM           espacio where espacio.descripcion_espacio= @descripcion
END
Go

CREATE proc [dbo].[Consultar_Espacio_Id]
@id_espacio int
as
BEGIN

     SELECT        espacio.id_espacio, espacio.descripcion_espacio,espacio.capacidad , espacio.cupo,tipo_espacio.valor_tipo_espacio, piso.valor_piso, estado_espacio.valor_estado_espacio, historico_espacio.fecha_historico_espacio
FROM            historico_espacio  INNER JOIN

						(select historico_espacio.id_espacio_historico , max(historico_espacio.fecha_historico_espacio ) as fecha from  historico_espacio group by historico_espacio.id_espacio_historico ) as T1 on
						T1.id_espacio_historico=historico_espacio.id_espacio_historico and 
						T1.fecha = historico_espacio.fecha_historico_espacio
						 INNER JOIN
                         estado_espacio ON historico_espacio.estado_espacio_o = estado_espacio.id_estado_espacio INNER JOIN
                         espacio ON historico_espacio.id_espacio_historico = espacio.id_espacio INNER JOIN
                         tipo_espacio ON espacio.id_tipo_espacio_ = tipo_espacio.id_tipo_espacio inner join
						 piso on espacio.id_piso_espacio = piso.id_piso
						where espacio.id_espacio =@id_espacio
END
Go

CREATE proc [dbo].[Actualizar_Espacio]
    @id int,
    @capacidad int,
    @tipoespacio int,
    @empleado_modifica int
    

as

declare @cupo int, @capacidad_anterior int, @fecha_modificacion date ,@estado_espacio int
set @capacidad_anterior = (select espacio.capacidad
from espacio
where espacio.id_espacio = @id);
set @estado_espacio = (SELECT         estado_espacio.id_estado_espacio 
                        FROM            historico_espacio  INNER JOIN
						(select historico_espacio.id_espacio_historico , max(historico_espacio.fecha_historico_espacio ) as fecha from  historico_espacio group by historico_espacio.id_espacio_historico ) as T1 on
						T1.id_espacio_historico=historico_espacio.id_espacio_historico and 
						T1.fecha = historico_espacio.fecha_historico_espacio
						 INNER JOIN
                         estado_espacio ON historico_espacio.estado_espacio_o = estado_espacio.id_estado_espacio INNER JOIN
                         espacio ON historico_espacio.id_espacio_historico = espacio.id_espacio 
                         
						where espacio.id_espacio =@id);

Begin
    if (@capacidad=@capacidad_anterior)
    BEGIN
        update espacio set id_tipo_espacio_ = @tipoespacio where espacio.id_espacio = @id  ;
        set @fecha_modificacion = (select CURRENT_TIMESTAMP);
        insert into historico_espacio (fecha_historico_espacio, estado_espacio_o, id_espacio_historico, id_empleado_historico) values
                                           (@fecha_modificacion,@estado_espacio, @id, @empleado_modifica );

    END
    if (@capacidad>@capacidad_anterior)
    BEGIN
        set @cupo = @capacidad - @capacidad_anterior;
        if (@cupo= 0)
            begin
            update espacio set id_tipo_espacio_ = @tipoespacio, espacio.cupo = @cupo, espacio.capacidad=@capacidad
            where espacio.id_espacio = @id;


              set @fecha_modificacion = (select CURRENT_TIMESTAMP);
              insert into historico_espacio (fecha_historico_espacio, estado_espacio_o, id_espacio_historico, id_empleado_historico) values
                                           (@fecha_modificacion,2, @id, @empleado_modifica );

        END
        update espacio set id_tipo_espacio_ = @tipoespacio, espacio.cupo = @cupo, espacio.capacidad=@capacidad 
        where espacio.id_espacio = @id    ;
    END
    if (@capacidad<@capacidad_anterior)
    BEGIN
        set @cupo =  @capacidad_anterior - @capacidad        ;
        if (@cupo= 0)
            begin
            update espacio set id_tipo_espacio_ = @tipoespacio, espacio.cupo = @cupo, espacio.capacidad=@capacidad
              where espacio.id_espacio = @id        ;
            
              set @fecha_modificacion = (select CURRENT_TIMESTAMP);
              insert into historico_espacio (fecha_historico_espacio, estado_espacio_o, id_espacio_historico, id_empleado_historico) values
                                           (@fecha_modificacion,2, @id, @empleado_modifica );

        END
        update espacio set id_tipo_espacio_ = @tipoespacio, espacio.cupo = @cupo,
         espacio.capacidad=@capacidad  where espacio.id_espacio = @id
    ;

    END
END

Go

insert into solicitud (id_prioridad_solciitud__, fecha_solicitud, descripcion_solicitud,id_estudiante_solicitud, id_empleado_solicitud ) values 
(1,'2017-09-18 12:27:58.610', 'Certificacion de cupo asignado',1,2	),
(2,'2017-09-18 12:27:58.610', 'Certificacion Actualizacion de Datos',2,2	),
(3,'2017-09-18 12:27:58.610', 'Cancelacion de Cupo',3,2),
(4,'2017-09-18 12:27:58.610', 'Actualizacion de Acudiente',3,2	),
(3,'2017-09-18 12:27:58.610', 'Cambio de Apartamento',4,2	),
(2,'2017-09-18 12:27:58.610', 'Asignacion de cama nueva',2,2	)
Go


insert into historico_solicitud (id_caso_anotacion, descripcion_anotacion, fecha_modificacion, id_empleado_historico, id_estado_solicitud_)
values(1, 'Se ha registrado la peticion', '2017-09-18 12:27:58.610',1,1 ),
(2, 'Se ha registrado la peticion', '2017-09-18 12:27:58.610',1,1 ),
(3, 'Se ha registrado la peticion', '2017-09-18 12:27:58.610',1,1 ),
(4, 'Se ha registrado la peticion', '2017-09-18 12:27:58.610',1,1 ),
(5, 'Se ha registrado la peticion', '2017-09-18 12:27:58.610',1,1 ),
(6, 'Se ha registrado la peticion', '2017-09-18 12:27:58.610',1,1 )
GO

Create procedure Consultar_Solcitudes_Estudiante

@correoestudiante varchar(300)
as
declare @id_estudiante int
Begin
	set @id_estudiante =  (SELECT        estudiante.id_estudiante
							FROM            estudiante INNER JOIN
                         Persona ON estudiante.id_directorio_estudiante = Persona.id_persona where Persona.correo_directorio =@correoestudiante);
		
	SELECT        solicitud.id_solicitud, solicitud.descripcion_solicitud,solicitud.fecha_solicitud as fechacreacion,
				 historico_solicitud.fecha_modificacion , prioridad_solicitud.valor_prioridad_solciitud, estado_solicitud.valor_estado_solciitud,
				 Persona.Nombres as Encargado, Persona.Apellidos
FROM            historico_solicitud  INNER JOIN

						(select historico_solicitud.id_caso_anotacion , max(historico_solicitud.fecha_modificacion ) as fecha from  historico_solicitud group by historico_solicitud.id_caso_anotacion ) as T1 on
						T1.id_caso_anotacion=historico_solicitud.id_caso_anotacion and 
						T1.fecha = historico_solicitud.fecha_modificacion
						 INNER JOIN
                         estado_solicitud ON historico_solicitud.id_estado_solicitud_ = estado_solicitud.id_estado_solciitud INNER JOIN
						 solicitud on historico_solicitud.id_caso_anotacion = solicitud.id_solicitud inner join
                         prioridad_solicitud ON solicitud.id_prioridad_solciitud__ = prioridad_solicitud.id_prioridad_solciitud INNER JOIN
                         empleado ON empleado.id_empleado = solicitud.id_empleado_solicitud  inner join
						 Persona on empleado.empleado_directorio= Persona.id_persona where solicitud.id_estudiante_solicitud =@id_estudiante

						 

end

Go


Create procedure Consultar_Solcitudes_Estudiante_ID

@id int
as

Begin
	
		
	SELECT        solicitud.id_solicitud, solicitud.descripcion_solicitud,solicitud.fecha_solicitud as fechacreacion,
				 historico_solicitud.fecha_modificacion , prioridad_solicitud.valor_prioridad_solciitud, estado_solicitud.valor_estado_solciitud,
				 Persona.Nombres as Encargado, Persona.Apellidos
FROM            historico_solicitud  INNER JOIN

						(select historico_solicitud.id_caso_anotacion , max(historico_solicitud.fecha_modificacion ) as fecha from  historico_solicitud group by historico_solicitud.id_caso_anotacion ) as T1 on
						T1.id_caso_anotacion=historico_solicitud.id_caso_anotacion and 
						T1.fecha = historico_solicitud.fecha_modificacion
						 INNER JOIN
                         estado_solicitud ON historico_solicitud.id_estado_solicitud_ = estado_solicitud.id_estado_solciitud INNER JOIN
						 solicitud on historico_solicitud.id_caso_anotacion = solicitud.id_solicitud inner join
                         prioridad_solicitud ON solicitud.id_prioridad_solciitud__ = prioridad_solicitud.id_prioridad_solciitud INNER JOIN
                         empleado ON empleado.id_empleado = solicitud.id_empleado_solicitud  inner join
						 Persona on empleado.empleado_directorio= Persona.id_persona where solicitud.id_estudiante_solicitud =@id;

						 

end

Go


create proc Registrar_Solicitud
@prioridad int, 
@descripcion varchar(200),
@correoestudiante varchar(100)


as
declare @fecharegistro date, @id_estudiante  int, @nuevasolicitud int
BEgin
set @fecharegistro = (select CURRENT_TIMESTAMP);
set @id_estudiante =  (SELECT        estudiante.id_estudiante
							FROM            estudiante INNER JOIN
                         Persona ON estudiante.id_directorio_estudiante = Persona.id_persona where Persona.correo_directorio =@correoestudiante);

insert into solicitud (id_prioridad_solciitud__, fecha_solicitud, descripcion_solicitud,id_estudiante_solicitud, id_empleado_solicitud ) values
(@prioridad, @fecharegistro, @descripcion,@id_estudiante, 1 );
set @nuevasolicitud =@@IDENTITY;
insert into historico_solicitud (id_caso_anotacion, descripcion_anotacion, fecha_modificacion, id_empleado_historico, id_estado_solicitud_) values
(@nuevasolicitud, 'Se ha registrado la solicitud', @fecharegistro, 1, 1);
End
Go



create proc consultar_solicutud_detalle
@idsolicitud int
as
BEGIN

	SELECT        solicitud.id_solicitud,
                    solicitud.descripcion_solicitud,
                    solicitud.fecha_solicitud as fechacreacion,
				 historico_solicitud.fecha_modificacion ,
                 prioridad_solicitud.valor_prioridad_solciitud,
                  estado_solicitud.valor_estado_solciitud,

				 Persona.Nombres as Encargado, Persona.Apellidos
FROM            historico_solicitud  INNER JOIN

						(select historico_solicitud.id_caso_anotacion , max(historico_solicitud.fecha_modificacion ) as fecha from  historico_solicitud group by historico_solicitud.id_caso_anotacion ) as T1 on
						T1.id_caso_anotacion=historico_solicitud.id_caso_anotacion and 
						T1.fecha = historico_solicitud.fecha_modificacion
						 INNER JOIN
                         estado_solicitud ON historico_solicitud.id_estado_solicitud_ = estado_solicitud.id_estado_solciitud INNER JOIN
						 solicitud on historico_solicitud.id_caso_anotacion = solicitud.id_solicitud inner join
                         prioridad_solicitud ON solicitud.id_prioridad_solciitud__ = prioridad_solicitud.id_prioridad_solciitud INNER JOIN
                         empleado ON empleado.id_empleado = solicitud.id_empleado_solicitud  inner join
						 Persona on empleado.empleado_directorio= Persona.id_persona where solicitud.id_solicitud=@idsolicitud

					
END
Go



create proc Escalar_solicitud
@correoempleado varchar(100),
@id_solicitud int,
@id_empleadonuevo int


as
declare @fecharegistro date, @idempleadoquecambia int, @estadosolicitud int 

BEGIN
set @fecharegistro = (select CURRENT_TIMESTAMP);
	set @idempleadoquecambia =  (SELECT        empleado.id_empleado
							FROM            empleado INNER JOIN
                         Persona ON empleado.empleado_directorio = Persona.id_persona where Persona.correo_directorio =@correoempleado);
	set @estadosolicitud = (SELECT         estado_solicitud.id_estado_solciitud
				 
FROM            historico_solicitud  INNER JOIN

						(select historico_solicitud.id_caso_anotacion , max(historico_solicitud.fecha_modificacion ) as fecha from  historico_solicitud group by historico_solicitud.id_caso_anotacion ) as T1 on
						T1.id_caso_anotacion=historico_solicitud.id_caso_anotacion and 
						T1.fecha = historico_solicitud.fecha_modificacion
						 INNER JOIN
                         estado_solicitud ON historico_solicitud.id_estado_solicitud_ = estado_solicitud.id_estado_solciitud INNER JOIN
						 solicitud on historico_solicitud.id_caso_anotacion = solicitud.id_solicitud 
                         where solicitud.id_solicitud=@id_solicitud
								
								);
	update solicitud set id_empleado_solicitud = @id_empleadonuevo where @id_solicitud=solicitud.id_solicitud
	insert into historico_solicitud (id_caso_anotacion, descripcion_anotacion, fecha_modificacion, id_empleado_historico, id_estado_solicitud_) values
(@id_solicitud, 'Se ha cambiado el responsable de la solicitud', @fecharegistro, @idempleadoquecambia, @estadosolicitud);

END
GO


create proc CambiarEstadoSolicitud
@correoempleoadocambia varchar(100),
@id_solicitud int,
@estadonuevo int


as
declare @fecharegistro date, @idempleadoquecambia int
BEGIN
	set @fecharegistro = (select CURRENT_TIMESTAMP);
	set @idempleadoquecambia =  (SELECT        empleado.id_empleado
							FROM            empleado INNER JOIN
                         Persona ON empleado.empleado_directorio = Persona.id_persona where Persona.correo_directorio =@correoempleoadocambia);
	insert into historico_solicitud (id_caso_anotacion, descripcion_anotacion, fecha_modificacion, id_empleado_historico, id_estado_solicitud_) values
(@id_solicitud, 'Se ha cambiado el estado de la solicitud', @fecharegistro, @idempleadoquecambia, @estadonuevo);

END
GO


create proc Solucionar_Solicitud
@correoempleoadocambia varchar(100),
@id_solicitud int,
@solucion varchar (100)


as
declare @fecharegistro date, @idempleadoquecambia int
BEGIN
	set @fecharegistro = (select CURRENT_TIMESTAMP);
	set @idempleadoquecambia =  (SELECT        empleado.id_empleado
							FROM            empleado INNER JOIN
                         Persona ON empleado.empleado_directorio = Persona.id_persona where Persona.correo_directorio =@correoempleoadocambia);
	insert into solucion (descripcion_solucion, id_empleado_solucion, fecha_solucion, id_solicitud_solucion)values
	(@solucion, @idempleadoquecambia, @fecharegistro, @id_solicitud);
	insert into historico_solicitud (id_caso_anotacion, descripcion_anotacion, fecha_modificacion, id_empleado_historico, id_estado_solicitud_) values
(@id_solicitud, 'Se ha agregado una solucion  a la solicitud', @fecharegistro, @idempleadoquecambia, 4);

END
GO



create proc VerHistorico_Solicitud
@idsolicitud int
as
BEGIN
	SELECT        historico_solicitud.id_caso_anotacion, 
                  historico_solicitud.descripcion_anotacion,
                  historico_solicitud.fecha_modificacion, 
                  estado_solicitud.valor_estado_solciitud, 
                  Persona.Nombres, 
                  Persona.Apellidos
FROM            solicitud INNER JOIN
                         historico_solicitud ON solicitud.id_solicitud = historico_solicitud.id_caso_anotacion INNER JOIN
                         estado_solicitud ON historico_solicitud.id_estado_solicitud_ = estado_solicitud.id_estado_solciitud INNER JOIN
                         empleado ON solicitud.id_empleado_solicitud = empleado.id_empleado AND historico_solicitud.id_empleado_historico = empleado.id_empleado INNER JOIN
                         Persona ON empleado.empleado_directorio = Persona.id_persona where historico_solicitud.id_caso_anotacion = @idsolicitud

END
GO




Create procedure Consultar_Solcitudes_Empleado

@correoempleado varchar(300)
as
declare @id_empleado int
Begin
	set @id_empleado =  (SELECT        empleado.id_empleado
							FROM            empleado INNER JOIN
                         Persona ON empleado.empleado_directorio = Persona.id_persona where Persona.correo_directorio =@correoempleado);	
	SELECT        solicitud.id_solicitud, solicitud.descripcion_solicitud,solicitud.fecha_solicitud as fechacreacion,
				 historico_solicitud.fecha_modificacion , prioridad_solicitud.valor_prioridad_solciitud, estado_solicitud.valor_estado_solciitud,
				 Persona.Nombres as Estudiante, Persona.Apellidos
FROM            historico_solicitud  INNER JOIN

						(select historico_solicitud.id_caso_anotacion , max(historico_solicitud.fecha_modificacion ) as fecha from  historico_solicitud group by historico_solicitud.id_caso_anotacion ) as T1 on
						T1.id_caso_anotacion=historico_solicitud.id_caso_anotacion and 
						T1.fecha = historico_solicitud.fecha_modificacion
						 INNER JOIN
                         estado_solicitud ON historico_solicitud.id_estado_solicitud_ = estado_solicitud.id_estado_solciitud INNER JOIN
						 solicitud on historico_solicitud.id_caso_anotacion = solicitud.id_solicitud inner join
                         prioridad_solicitud ON solicitud.id_prioridad_solciitud__ = prioridad_solicitud.id_prioridad_solciitud INNER JOIN
                         estudiante ON estudiante.id_estudiante = solicitud.id_estudiante_solicitud  inner join
						 Persona on estudiante.id_directorio_estudiante		= Persona.id_persona where solicitud.id_empleado_solicitud =@id_empleado

						 

end

Go

create proc empleadosdisponiblesparaescalar
as
BEGIN
SELECT        empleado.id_empleado, Persona.Nombres, Persona.Apellidos
FROM            Persona INNER JOIN
                         empleado ON Persona.id_persona = empleado.empleado_directorio where Persona.id_rol_Directorio=1
END


GO


create proc Consultar_Todos_Empleados
as
BEGIN
SELECT        cargo.valor_cargo, Persona.id_persona, Persona.Nombres, Persona.Apellidos, Persona.NumeroIdentificacion, Persona.Direccion, Persona.Telefono, Persona.Estadocivil
FROM            empleado INNER JOIN
						contrato on empleado.id_empleado = contrato.id_empleado inner join
                         cargo ON contrato.cargo_contrato = cargo.id_cargo INNER JOIN
                       
                         Persona ON empleado.empleado_directorio = Persona.id_persona 
                        
where Persona.id_persona  <>1
           END              
       GO


insert into cita (fecha_cita,id_empleado_cita,id_paciente)values 
				('2017-09-25 15:00:00.000', 5, 1),
				('2017-09-25 10:00:00.000', 4, 2),
				('2017-09-25 18:00:00.000', 5, 2),
				('2017-09-25 14:00:00.000', 4, 1),
				('2017-09-25 16:00:00.000', 5, 1),
                ('2017-09-26 15:00:00.000', 5, 2),
				('2017-09-26 18:00:00.000', 4, 2),
				('2017-09-26 13:00:00.000', 5, 1),
				('2017-09-27 14:00:00.000', 4, 1),
				('2017-09-29 16:00:00.000', 5, 1)
				GO
insert into HistoricoCita (id_cita_, descripcion_anotacion, fecha_modificacion, id_empleado_historico, id_estadocita)
							values(1, 'Se ha agendado la cita', '2017-09-22 15:00:00.000', 1, 1 ),
								(2, 'Se ha agendado la cita', '2017-09-22 15:00:00.000', 1, 1 ),
								(3, 'Se ha agendado la cita', '2017-09-22 15:00:00.000', 1, 1 ),
								(4, 'Se ha agendado la cita', '2017-09-22 15:00:00.000', 1, 1 ),
								(5, 'Se ha agendado la cita', '2017-09-22 15:00:00.000', 1, 1 ),
                                (4, 'Se ha cancelado la cita', '2017-09-23 15:00:00.000', 1, 4 ),
                                (6, 'Se ha agendado la cita', '2017-09-22 18:00:00.000', 1, 1 ),
								(7, 'Se ha agendado la cita', '2017-09-22 16:00:00.000', 1, 1 ),
								(8, 'Se ha agendado la cita', '2017-09-22 17:00:00.000', 1, 1 ),
								(9, 'Se ha agendado la cita', '2017-09-22 15:00:00.000', 1, 1 ),
								(10, 'Se ha agendado la cita', '2017-09-22 15:00:00.000', 1, 1 )
                               

							go


create proc consultarCitasAgendadasAPP
@id_estudiante int
as
BEGIN
select cita.id_cita,
cita.fecha_cita, Persona.Nombres , Persona.Apellidos , estado_cita.valor_estado_cita from HistoricoCita
		inner join (select HistoricoCita.id_cita_ as id, max (HistoricoCita.fecha_modificacion)as fecha from HistoricoCita group by HistoricoCita.id_cita_ )as
		 t1 on t1.id= HistoricoCita.id_cita_ and t1.fecha= HistoricoCita.fecha_modificacion 
		inner join estado_cita on estado_cita.id_estado_cita = HistoricoCita.id_estadocita
		inner join cita on cita.id_cita= HistoricoCita.id_cita_
		inner join empleado on empleado.id_empleado = cita.id_empleado_cita
		inner join Persona on Persona.id_persona = empleado.empleado_directorio
		where cita.id_paciente=@id_estudiante order by fecha_cita desc
END
GO

create proc consultarCitasAgendadasEstudianteWeb
@correo varchar(100)
as
declare @id_estudiante int
BEGIN
set @id_estudiante =(select estudiante.id_estudiante from estudiante
						inner join Persona on Persona.id_persona = estudiante.id_directorio_estudiante
						where  Persona.correo_directorio =@correo);

select cita.id_cita,
    cita.fecha_cita, Persona.Nombres , Persona.Apellidos , estado_cita.valor_estado_cita from HistoricoCita
		inner join (select HistoricoCita.id_cita_ as id, max (HistoricoCita.fecha_modificacion)as fecha from HistoricoCita group by HistoricoCita.id_cita_ )as
		 t1 on t1.id= HistoricoCita.id_cita_ and t1.fecha= HistoricoCita.fecha_modificacion 
		inner join estado_cita on estado_cita.id_estado_cita = HistoricoCita.id_estadocita
		inner join cita on cita.id_cita= HistoricoCita.id_cita_
		inner join empleado on empleado.id_empleado = cita.id_empleado_cita
		inner join Persona on Persona.id_persona = empleado.empleado_directorio
		where cita.id_paciente=@id_estudiante order by fecha_cita desc
END
GO

create proc VerDetalleCitasEstudianteWeb
@correo varchar(100),
@id_cita int
as
declare @id_estudiante int
BEGIN
set @id_estudiante =(select estudiante.id_estudiante from estudiante
						inner join Persona on Persona.id_persona = estudiante.id_directorio_estudiante
						where  Persona.correo_directorio =@correo);

select cita.id_cita,cita.fecha_cita, Persona.Nombres , Persona.Apellidos , estado_cita.valor_estado_cita from HistoricoCita
		inner join (select HistoricoCita.id_cita_ as id, max (HistoricoCita.fecha_modificacion)as fecha from HistoricoCita group by HistoricoCita.id_cita_ )as
		 t1 on t1.id= HistoricoCita.id_cita_ and t1.fecha= HistoricoCita.fecha_modificacion 
		inner join estado_cita on estado_cita.id_estado_cita = HistoricoCita.id_estadocita
		inner join cita on cita.id_cita= HistoricoCita.id_cita_
		inner join empleado on empleado.id_empleado = cita.id_empleado_cita
		inner join Persona on Persona.id_persona = empleado.empleado_directorio
		where cita.id_paciente=@id_estudiante and cita.id_cita=@id_cita
END
GO


create proc CancelarCitaEstudiante
@id_cita int
as
declare @fecha datetime
BEGIN
set @fecha = (Select CURRENT_TIMESTAMP);
	insert into HistoricoCita 
	( descripcion_anotacion, id_estadocita, fecha_modificacion, id_cita_) values
	('El estudiante ha cancelado la cita ',4, @fecha, @id_cita );  
END
GO


create proc AgendarCitaestudiante
@fechaCita datetime,
@empleado int,
@correoestudiante varchar(100)
as
declare @idestudiante int, @idnuevacita int, @fechamodi datetime
BEGIN
set @fechamodi = (select CURRENT_TIMESTAMP);
set @idestudiante = (select estudiante.id_estudiante from estudiante
					inner join Persona on Persona.id_persona = estudiante.id_directorio_estudiante
					where Persona.correo_directorio =@correoestudiante);
insert into cita (fecha_cita, id_empleado_cita, id_paciente)
			values (@fechaCita, @empleado, @idestudiante);
set @idnuevacita = @@IDENTITY;
insert into HistoricoCita (descripcion_anotacion, fecha_modificacion, id_cita_, id_estadocita)
values('Se ha agendado la cita', @fechamodi, @idnuevacita, 1);

END
GO


create proc consultarCitasEmpleado
@correoempleado varchar(300)
as
declare @id_empleado int
Begin
	set @id_empleado =  (SELECT        empleado.id_empleado
							FROM            empleado INNER JOIN
                         Persona ON empleado.empleado_directorio = Persona.id_persona where Persona.correo_directorio =@correoempleado);	

select cita.id_cita,cita.fecha_cita, Persona.Nombres , Persona.Apellidos , estado_cita.valor_estado_cita from HistoricoCita
		inner join (select HistoricoCita.id_cita_ as id, max (HistoricoCita.fecha_modificacion)as fecha from HistoricoCita group by HistoricoCita.id_cita_ )as
		 t1 on t1.id= HistoricoCita.id_cita_ and t1.fecha= HistoricoCita.fecha_modificacion 
		inner join estado_cita on estado_cita.id_estado_cita = HistoricoCita.id_estadocita
		inner join cita on cita.id_cita= HistoricoCita.id_cita_
		inner join estudiante on estudiante.id_estudiante = cita.id_paciente
		inner join Persona on Persona.id_persona = estudiante.id_directorio_estudiante
		where cita.id_empleado_cita=@id_empleado order by fecha_cita desc
END
GO



create proc VerDetalleCitaEmpleado
@correoempleado varchar(300), 
@id_cita int
as
declare @id_empleado int
Begin
	set @id_empleado =  (SELECT        empleado.id_empleado
							FROM            empleado INNER JOIN
                         Persona ON empleado.empleado_directorio = Persona.id_persona where Persona.correo_directorio =@correoempleado);	

select cita.id_cita,cita.fecha_cita, Persona.Nombres , Persona.Apellidos , estado_cita.valor_estado_cita from HistoricoCita
		inner join (select HistoricoCita.id_cita_ as id, max (HistoricoCita.fecha_modificacion)as fecha from HistoricoCita group by HistoricoCita.id_cita_ )as
		 t1 on t1.id= HistoricoCita.id_cita_ and t1.fecha= HistoricoCita.fecha_modificacion 
		inner join estado_cita on estado_cita.id_estado_cita = HistoricoCita.id_estadocita
		inner join cita on cita.id_cita= HistoricoCita.id_cita_
		inner join estudiante on estudiante.id_estudiante = cita.id_paciente
		inner join Persona on Persona.id_persona = estudiante.id_directorio_estudiante
		where cita.id_empleado_cita=@id_empleado and cita.id_cita = @id_cita
END
GO


create proc RegistrarExpedienteCita
@descripcion_expediente varchar(500),
@cita int,
@correoempleoado varchar(100)
as
declare @fecha datetime, @id_expnuevo int, @id_empleado int
BEGIN
set @fecha = (select CURRENT_TIMESTAMP);
set @id_empleado =(select empleado.id_empleado from empleado INNER JOin
					Persona on Persona.id_persona = empleado.empleado_directorio
					where Persona.correo_directorio = @correoempleoado);
insert into expediente 
			(descripcion_Expediente,fecha_expediente, id_tipo_exp )values
			(@descripcion_expediente, @fecha, 1);
set @id_expnuevo = @@IDENTITY;
update cita set id_expediente_cita  = @id_expnuevo  where cita.id_cita = @cita;
insert into HistoricoCita (descripcion_anotacion, fecha_modificacion,id_cita_, id_empleado_historico, id_estadocita)values
			('Se ha atendido la cita ', @fecha,@cita, @id_empleado, 2 );
END
GO


create proc VerDetalleExpedienteCita
@id_cita int
as
BEGIN

select expediente.descripcion_Expediente, expediente.fecha_expediente  from expediente
		INNER JOIN cita on cita.id_expediente_cita = expediente.id_expediente
		where cita.id_cita = @id_cita
END
GO

create proc CancelarCitaEmpleado
@id_cita int,
@correoempleado varchar(100)
as
declare @fecha datetime, @id_empleoad int
BEGIN
set @fecha = (Select CURRENT_TIMESTAMP);
set @id_empleoad = (Select empleado.id_empleado from empleado 
					Inner join Persona on Persona.id_persona = empleado.empleado_directorio
					where Persona.correo_directorio = @correoempleado);
					
	insert into HistoricoCita 
	( descripcion_anotacion, id_estadocita, fecha_modificacion, id_cita_, id_empleado_historico) values
	('El empleado ha cancelado la cita ',4, @fecha, @id_cita, @id_empleoad );  
END
GO

create proc Validarcita
@id_empleado int

as
Begin

select cita.fecha_cita, Persona.correo_directorio , estado_cita.valor_estado_cita from HistoricoCita
		inner join (select HistoricoCita.id_cita_ as id, max (HistoricoCita.fecha_modificacion)as fecha from HistoricoCita group by HistoricoCita.id_cita_ )as
		 t1 on t1.id= HistoricoCita.id_cita_ and t1.fecha= HistoricoCita.fecha_modificacion 
		inner join estado_cita on estado_cita.id_estado_cita = HistoricoCita.id_estadocita
		inner join cita on cita.id_cita= HistoricoCita.id_cita_
		inner join estudiante on estudiante.id_estudiante = cita.id_paciente
		inner join Persona on Persona.id_persona = estudiante.id_directorio_estudiante
		where cita.id_empleado_cita=@id_empleado order by fecha_cita desc
END
GO

--Proceso Admision

create proc EstudiantesAdmision
as
BEGIN

SELECT        estudiante.id_estudiante , Persona.Nombres, Persona.Apellidos, estado_usuario_cru.Descripcion_estado_usuario_cru 
FROM            historico_directorio  INNER JOIN

						(select historico_directorio.id_directorio_ as id, max(historico_directorio.fecha ) as fecha from  historico_directorio group by historico_directorio.id_directorio_ ) as T1 on
						T1.id=historico_directorio.id_directorio_ and 
						T1.fecha = historico_directorio.fecha
						 INNER JOIN Persona on Persona.id_persona = historico_directorio.id_directorio_
						 INNER JOIN estudiante on Persona.id_persona = estudiante.id_directorio_estudiante
						 INNER join  estado_usuario_cru on estado_usuario_cru.Id_estado_usuario_cru = historico_directorio.Estado_directorio_CRU
						 where historico_directorio.Estado_directorio_CRU =4
                        
						
END
GO
create proc AgregarAnotacionEstudiante
@id_estudiante int,
@anotacion varchar (200),
@correoquemodifica varchar (100)
as
declare @id_directorio int, @estado int , @fechamod datetime, @id_empleoad int

BEGIN

set @id_empleoad =  (SELECT        empleado.id_empleado
							FROM            empleado INNER JOIN
                         Persona ON empleado.empleado_directorio = Persona.id_persona where Persona.correo_directorio =@correoquemodifica);

set @id_directorio = (select Persona.id_persona from Persona
  INNER JOIN estudiante on estudiante.id_directorio_estudiante = Persona.id_persona 
  where estudiante.id_estudiante = @id_estudiante );
 
	set @fechamod = (select CURRENT_TIMESTAMP);
	insert into historicoestudiante (descripcion_historico_expediente, fecha_historico_expediente, id_empleado_historicoestudiante, id_estudiante) values
		(@anotacion, @fechamod, @id_empleoad, @id_estudiante);


END
GO
EXEC	[AgregarAnotacionEstudiante]
		@id_estudiante = 1,
		@anotacion = N'Se realiza validacion de la informacion, la direccion no concuerda',
		@correoquemodifica = N'psicologo@gmail.com'
GO
EXEC	[AgregarAnotacionEstudiante]
		@id_estudiante = 4,
		@anotacion = N'Se realiza validacion de la informacion, malas referencias del convivencia',
		@correoquemodifica = N'director@gmail.com'
GO
EXEC	[AgregarAnotacionEstudiante]
		@id_estudiante = 3,
		@anotacion = N'Se realiza validacion de la informacion, todo correcto',
		@correoquemodifica = N'psicologo2@gmail.com'
GO

EXEC	[AgregarAnotacionEstudiante]
		@id_estudiante = 3,
		@anotacion = N'Se realiza validacion de la informacion, todo correcto',
		@correoquemodifica = N'director@gmail.com'
GO

EXEC	[AgregarAnotacionEstudiante]
		@id_estudiante = 3,
		@anotacion = N'Se realiza entrevista, resultado positivo',
		@correoquemodifica = N'psicologo2@gmail.com'
GO


EXEC	[AgregarAnotacionEstudiante]
		@id_estudiante = 2,
		@anotacion = N'Se realiza validacion de la informacion, todo correcto',
		@correoquemodifica = N'director@gmail.com'
GO



EXEC	[AgregarAnotacionEstudiante]
		@id_estudiante = 3,
		@anotacion = N'Pendiente por asignar espacio',
		@correoquemodifica = N'psicologo2@gmail.com'
GO



EXEC	[AgregarAnotacionEstudiante]
		@id_estudiante = 5,
		@anotacion = N'Se realiza validacion de la informacion, todo correcto',
		@correoquemodifica = N'director@gmail.com'
GO


EXEC	[AgregarAnotacionEstudiante]
		@id_estudiante = 5,
		@anotacion = N'Se realiza entrevista , el estudiante no controla emociones fuertes',
		@correoquemodifica = N'psicologo2@gmail.com'
GO




create proc verhistoricoestudiante
@id_estudiante int 
as
BEGIN
	
	select historicoestudiante.fecha_historico_expediente, historicoestudiante.descripcion_historico_expediente, Persona.Nombres, Persona.Apellidos from historicoestudiante
			inner join empleado on empleado.id_empleado = historicoestudiante.id_empleado_historicoestudiante
			INNER JOIN persona on empleado.empleado_directorio = Persona.id_persona
			where historicoestudiante.id_estudiante =@id_estudiante;
END
GO






create proc Consultar_Espacios_Disponibles
as
SELECT espacio.id_espacio, espacio.descripcion_espacio
FROM historico_espacio
				inner join (select historico_espacio.id_espacio_historico, max(historico_espacio.fecha_historico_espacio) as fe from historico_espacio group by historico_espacio.id_espacio_historico ) as 
				t1    on t1.id_espacio_historico =historico_espacio.id_espacio_historico and t1.fe = historico_espacio.fecha_historico_espacio
				inner join  estado_espacio on estado_espacio.id_estado_espacio = historico_espacio.estado_espacio_o
				inner join espacio on espacio.id_espacio = historico_espacio.id_espacio_historico
				where historico_espacio.estado_espacio_o =1 and historico_espacio.id_espacio_historico <> 1 and historico_espacio.id_espacio_historico <> 2  

go






























































create proc Actualizar_Espacio_A_Estudiante
    @id_Estudiante int,
    @correo varchar(100) ,
    @espacionuevo int, 
	@id_espacioanterior int 

as
declare @fecha datetime, @cupo_anterior int, @cuponuevo int
   


BEGIN
    set @fecha = (select CURRENT_TIMESTAMP);
    
    set @cupo_anterior=( select espacio.cupo from espacio where espacio.id_espacio= @id_espacioanterior);

	update espacio set  espacio.cupo= @cupo_anterior+1 where espacio.id_espacio =@id_espacioanterior;
	
	set @cuponuevo = (select espacio.cupo from espacio where espacio.id_espacio = @id_espacioanterior);

    if(@cuponuevo=0)


    --Actualizo el espacio al estudiante
	insert into historico_espacio (descripcion,estado_espacio_o, fecha_historico_espacio, id_estudiante_espacio, id_empleado_historico,id_espacio_historico)values();
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









































































--1



















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










