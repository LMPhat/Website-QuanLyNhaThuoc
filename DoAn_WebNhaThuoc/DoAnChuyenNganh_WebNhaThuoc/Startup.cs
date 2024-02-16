using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(DoAnChuyenNganh_WebNhaThuoc.Startup))]
namespace DoAnChuyenNganh_WebNhaThuoc
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
