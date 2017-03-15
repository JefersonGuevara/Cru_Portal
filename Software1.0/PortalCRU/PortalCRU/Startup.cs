using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(PortalCRU.Startup))]
namespace PortalCRU
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
