using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(Portal_CRU.Startup))]
namespace Portal_CRU
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
