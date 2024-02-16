using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace DoAnChuyenNganh_WebNhaThuoc.Models
{
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method)]
    public class CustomAuthorizeFilter : FilterAttribute, IAuthorizationFilter
    {
        QLNhaThuocDataContext dl = new QLNhaThuocDataContext();
        public void OnAuthorization(AuthorizationContext filterContext)
        {
            var user = filterContext.HttpContext.User;
            var userName = user.Identity.Name;
            string[] arr = userName.Split(',');

            if (arr.Length == 2)
            {
                string ten = arr[0];
                string phanQuyen = arr[1];

                // Kiểm tra tên người dùng có phải là admin hay không
                if (bool.Parse(phanQuyen) != false)
                {
                    filterContext.Result = new HttpUnauthorizedResult(); // Hoặc chuyển hướng đến trang Unauthorized
                }
                else
                {
                    if (ten != "admin")
                    {
                        filterContext.Result = new HttpUnauthorizedResult(); // Hoặc chuyển hướng đến trang Unauthorized
                    }
                }
            }
            else
            {
                filterContext.Result = new HttpUnauthorizedResult(); // Hoặc chuyển hướng đến trang Unauthorized
            }
        }
    }

    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method)]
    public class CustomAuthorizationFilter : FilterAttribute, IAuthorizationFilter
    {
        QLNhaThuocDataContext dl = new QLNhaThuocDataContext();
        public void OnAuthorization(AuthorizationContext filterContext)
        {
            var user = filterContext.HttpContext.User;
            var userName = user.Identity.Name;
            string[] arr = userName.Split(',');

            if (arr.Length == 2)
            {
                string ten = arr[0];
                string phanQuyen = arr[1];

                // Kiểm tra tên người dùng có phải là admin hay không
                if (bool.Parse(phanQuyen) != false)
                {
                    filterContext.Result = new HttpUnauthorizedResult(); // Hoặc chuyển hướng đến trang Unauthorized
                }

            }
            else
            {
                filterContext.Result = new HttpUnauthorizedResult(); // Hoặc chuyển hướng đến trang Unauthorized
            }
        }
    }
}