using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DoAnChuyenNganh_WebNhaThuoc.Models;
using System.Web.Security;

namespace DoAnChuyenNganh_WebNhaThuoc.Controllers
{
    public class TaiKhoanController : Controller
    {
        //
        // GET: /TaiKhoan/
        QLNhaThuocDataContext dl = new QLNhaThuocDataContext();
        public ActionResult KhoiTao()
        {
            KhachHang kh = (KhachHang)Session["kh"];
            if (kh != null)
                ViewBag.chao = "Hello, " + kh.TenKH;
            return PartialView();
        }
        public ActionResult KhoiTao_AD()
        {
            NhanVien ad = (NhanVien)Session["ad"];
            if (ad != null)
                ViewBag.chao = "Hello, " + ad.TenNV;
            return PartialView();
        }

        public ActionResult KhoiTao_NV()
        {
            NhanVien ad = (NhanVien)Session["nv"];
            if (ad != null)
                ViewBag.chao = "Hello, " + ad.TenNV;
            return PartialView();
        }

        public ActionResult Login()
        {
            return View();
        }
        [HttpPost]
        public ActionResult Login(FormCollection fc)
        {

            TaiKhoan tk = dl.TaiKhoans.FirstOrDefault(t => (t.UserName == fc["username"] && t.Password == fc["password"]));
            if (tk != null)
            {
                string str = tk.UserName + "," + tk.PhanQuyen.ToString();
                // Set thông tin người dùng cho HttpContext.User
                FormsAuthentication.SetAuthCookie(str, false);

                if (tk.PhanQuyen == false)
                {
                    NhanVien nv = dl.NhanViens.FirstOrDefault(t => (t.UserName == fc["username"]));
                    if (nv != null)
                    {
                        if(nv.TrangThai)
                        {
                            Session["nv"] = nv;
                            return RedirectToAction("PhieuNhap", "QuanLy");
                        }
                        else
                        {
                            // Thông báo cho người dùng
                            TempData["LoginMessage"] = "Tài khoản của bạn không tồn tại!";

                            return View("Login"); // Trả về View với thông báo lỗi
                        }
                    }
                    else
                    {
                        Session["ad"] = tk;
                        return RedirectToAction("SanPham", "QuanLy");
                    }
                }
                else
                {
                    KhachHang kh = dl.KhachHangs.FirstOrDefault(t => (t.UserName == fc["username"]));
                    if (kh.TrangThai)
                    {
                        Session["kh"] = kh;
                        return RedirectToAction("SanPham", "KhachHang");
                    }
                    else
                    {
                        // Thông báo cho người dùng
                        TempData["LoginMessage"] = "Tài khoản của bạn không tồn tại!";

                        return View("Login"); // Trả về View với thông báo lỗi
                    }
                }
            }
            else
            {
                // Thông báo cho người dùng
                TempData["LoginMessage"] = "Tài khoản của bạn không tồn tại!";

                return View("Login"); // Trả về View với thông báo lỗi
            }
            
            
        }

        public ActionResult Register()
        {
            ViewBag.dl = dl;
            return View();
        }
        [HttpPost]
        public ActionResult Register(KhachHang d, TaiKhoan a, FormCollection fc)
        {
            KhachHang kh = dl.KhachHangs.Where(t => t.UserName == d.UserName).FirstOrDefault();
            TaiKhoan tk = dl.TaiKhoans.Where(t => t.UserName == d.UserName.Trim()).FirstOrDefault();
            NhanVien ktr_sdt = dl.NhanViens.FirstOrDefault(s => s.SDT == fc["phone"].Trim());
            NhanVien ktr_email = dl.NhanViens.FirstOrDefault(s => s.Email == fc["email"].Trim());

            if (d.UserName.Trim() == "" || fc["phone"].Trim() == "" || fc["email"].Trim() == "")
            {
                TempData["Loi_Rong"] = "Loi_Rong";
                return RedirectToAction("Register");
            }

            if (kh != null || tk != null)
            {
                TempData["LoginMessage"] = "Loi_1";
                return RedirectToAction("Register"); // Trả về View với thông báo lỗi
            }
            if (ktr_sdt != null && ktr_email != null)
            {
                if (ktr_sdt != null)
                    TempData["SuaLoi_SDT"] = "SuaLoi_SDT";
                if (ktr_email != null)
                    TempData["SuaLoi_Email"] = "SuaLoi_Email";

                return RedirectToAction("Register");
            }
            else
            {
                if (fc["password"] == fc["confirmPassword"])
                {
                    a.UserName = fc["username"];
                    a.Password = fc["password"];
                    a.PhanQuyen = true;
                    dl.TaiKhoans.InsertOnSubmit(a);
                    dl.SubmitChanges();

                    int t = dl.KhachHangs.Count();
                    d.MaKH = "KH00" + (t + 1).ToString();
                    KhachHang n = dl.KhachHangs.FirstOrDefault(f => f.MaKH == d.MaKH);
                    while (n != null)
                    {
                        t++;
                        d.MaKH = "KH00" + (t + 1).ToString();
                        n = dl.KhachHangs.FirstOrDefault(f => f.MaKH == d.MaKH);
                    }

                    d.TenKH = fc["name"];
                    d.SDT = fc["phone"];
                    d.DiaChi = fc["address"];
                    d.TrangThai = true;
                    d.Email = fc["email"];

                    d.UserName = fc["username"];
                    dl.KhachHangs.InsertOnSubmit(d);
                    dl.SubmitChanges();

                    //TempData["LoginMessage"] = "Them_TC";
                    return View("Login");
                }
                else
                {
                    TempData["LoginMessage"] = "Mật khẩu xác nhận không trùng khớp !";
                    return View("Register"); // Trả về View với thông báo lỗi
                }
            }
            
        }

        public ActionResult LogOut()
        {
            Session.Clear();
            Session.RemoveAll();
            FormsAuthentication.SignOut();
            return RedirectToAction("Login", "TaiKhoan");
        }

        public ActionResult Error()
        {
            return View();
        }
	}
}