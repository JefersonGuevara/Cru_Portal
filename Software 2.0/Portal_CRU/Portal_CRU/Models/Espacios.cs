using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
namespace Portal_CRU.Models
{
    public class Espacios
    {

        [Display(Name="No")]
        [Required]
        public int Id { get; set; }
        [Required]
        public string Descripcion { get; set; }
        [Required]
        [Display(Name = "Tipo")]

        public string Tipodeespacio { get; set; }
        [Required]
        public string Ubicacion { get; set; }
        [Required]
        [Display(Name = "Responsable ")]
        public string IdEstudiante { get; set; }
       
    }
}