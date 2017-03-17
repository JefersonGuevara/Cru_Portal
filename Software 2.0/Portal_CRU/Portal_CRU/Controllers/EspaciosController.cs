using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using Portal_CRU.Models;

namespace Portal_CRU.Controllers
{
    public class EspaciosController : Controller
    {
        private ApplicationDbContext db = new ApplicationDbContext();

        // GET: Espacios
        public ActionResult Index()
        {
            return View(db.Espacios.ToList());
        }

        // GET: Espacios/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Espacios espacios = db.Espacios.Find(id);
            if (espacios == null)
            {
                return HttpNotFound();
            }
            return View(espacios);
        }

        // GET: Espacios/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Espacios/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "Id,Descripcion,Tipodeespacio,Ubicacion,IdEstudiante")] Espacios espacios)
        {
            if (ModelState.IsValid)
            {
                db.Espacios.Add(espacios);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(espacios);
        }

        // GET: Espacios/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Espacios espacios = db.Espacios.Find(id);
            if (espacios == null)
            {
                return HttpNotFound();
            }
            return View(espacios);
        }

        // POST: Espacios/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "Id,Descripcion,Tipodeespacio,Ubicacion,IdEstudiante")] Espacios espacios)
        {
            if (ModelState.IsValid)
            {
                db.Entry(espacios).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(espacios);
        }

        // GET: Espacios/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Espacios espacios = db.Espacios.Find(id);
            if (espacios == null)
            {
                return HttpNotFound();
            }
            return View(espacios);
        }

        // POST: Espacios/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            Espacios espacios = db.Espacios.Find(id);
            db.Espacios.Remove(espacios);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
