using Portalfinal.Asistente.Login;
using Portalfinal.Asistente.Solicitudes;
using Portalfinal.Asistente.TipoIdentificacion;
using Portalfinal.Models;
using Portalfinal.Models.Solicitud;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Portalfinal.Controllers
{
    public class ServicioSolicitudesController : ApiController
    {
        // GET: api/ServicioSolicitudes
        Asistente_Tipos AsisTipos = new Asistente_Tipos();
        Asis_Solicitudes AsisSoli = new Asis_Solicitudes();
        //yy aqui quiero que entre el id o el correo desde la app
        public List<SolicitudApp> Get(string correo)
        {
            List<SolicitudApp> app = new List<SolicitudApp>();
            //tuve que hacer dos clases por que solicitudes model me trae muchos campos que no necesito en la app
            List<SolicitudModel> Solitudetes = new List<SolicitudModel>();
            Solitudetes = AsisSoli.ConsultarSolicuutdesPorEstudiante(correo);

            foreach (SolicitudModel a in Solitudetes)
            {
                SolicitudApp V = new SolicitudApp()
                {
                    Id = a.Id_solicitud,
                    Estado = a.EstadoSolicitud.Descripcion,
                    Descripcion = a.Descripcion,
                    FechaCreacion = a.Fecha,
                    Priodidad = a.PrioridadSolicitud.Descripcion,


                    Empleado = a.Empleado.Nombres + " " + a.Empleado.Apellidos
                };
                app.Add(V);



            }



            return app;
        }

       

        // POST: api/ServicioSolicitudes
        public int Get(string correo, string password)
        {
            bool respuesta = false;
            Asistente_Login asisLogin = new Asistente_Login();
            LoginModel login = new LoginModel(correo, password);
            //aqui voy a cambiarlo para que me de el id de este usuario
            respuesta = asisLogin.ConsultarDatos(login);
            if (respuesta)
            {

                return 2;
            }



            return 1;
        }

        // PUT: api/ServicioSolicitudes/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE: api/ServicioSolicitudes/5
        public void Delete(int id)
        {
        }
    }
}
