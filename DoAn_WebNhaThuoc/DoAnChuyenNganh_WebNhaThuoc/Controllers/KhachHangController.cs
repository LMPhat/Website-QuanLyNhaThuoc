using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DoAnChuyenNganh_WebNhaThuoc.Models;
using PagedList;

namespace DoAnChuyenNganh_WebNhaThuoc.Controllers
{
    public class KhachHangController : Controller
    {
        //
        // GET: /KhachHang/
        QLNhaThuocDataContext dl = new QLNhaThuocDataContext();
        public ActionResult MenuLoaiSP()
        {
            List<DanhMucSP> ds = dl.DanhMucSPs.ToList();
            return PartialView(ds);
        }
        public ActionResult TongSP()
        {
            int sum = 0;
            if (Session["kh"] != null)
            {
                KhachHang us = Session["kh"] as KhachHang;
                KhachHang kh = dl.KhachHangs.FirstOrDefault(k => k.UserName == us.UserName);
                List<GioHang> ds = new List<GioHang>();
                ds = dl.GioHangs.Where(t => t.MaKH == kh.MaKH).ToList();
                foreach (GioHang g in ds)
                {
                    sum += g.SoLuong;
                }
            }
            ViewBag.sum = sum;
            return PartialView();
        }
        public ActionResult SanPham(int? page)
        {
            //int page=1
            List<SanPham> ds = dl.SanPhams.ToList();
            //page = page < 1 ? 1 : page;
            //int pagesize = 6;
            //List<SanPham> ds = dl.SanPhams.ToPagedList(page, pagesize);
            int pageNumber = (page ?? 1);
            ViewBag.URL = "SanPham";
            return View(ds.ToPagedList(pageNumber, 6));
        }
        public ActionResult HTSP_TheoLoai(string id, int? page)
        {
            List<SanPham> ds = dl.SanPhams.Where(t => t.MaDM == id).ToList();
            int pageNumber = (page ?? 1);
            ViewBag.URL = "HTSP_TheoLoai" + "/" + id;
            return View("SanPham", ds.ToPagedList(pageNumber, 6));
        }
        public ActionResult ChiTietSP(string id)
        {
            if (id == null)
                return RedirectToAction("Index", "Home");
            else
            {
                SanPham sp = dl.SanPhams.Where(t => t.MaSP == id).FirstOrDefault();
                ViewBag.masp = dl.ChiTietSanPhams.Where(t => t.MaSP == id).FirstOrDefault();
                return View(sp);
            }
        }

        public ActionResult XLTimKiem(string tensp, int? page)
        {
            //string tensp = fc["search"];
            List<SanPham> ds1 = dl.SanPhams.Where(t => t.TenSP.Contains(tensp)).ToList();
            int pageNumber = (page ?? 1);
            ViewBag.URL = "/XLTimKiem";
            ViewBag.Param = tensp;
            if (ds1.Count > 0)
            {
                return View("SanPham", ds1.ToPagedList(pageNumber, 6));
            }
            return View("SanPham", ds1.ToPagedList(pageNumber, 6));
        }

        //[HttpPost]
        //public ActionResult XLTimKiem(FormCollection fc)
        //{
        //    string tensp = fc["search"];
        //    List<SanPham> ds1 = dl.SanPhams.Where(t => t.TenSP.Contains(tensp)).ToList();
        //    if (ds1.Count > 0)
        //    {
        //        return View("SanPham", ds1);
        //    }
        //    return View("SanPham", ds1);
        //}

        [HttpPost]
        public ActionResult ChonMua(GioHang g)
        {
            if (Session["kh"] == null)
            {
                return RedirectToAction("Login", "TaiKhoan");
            }
            KhachHang us = Session["kh"] as KhachHang;
            KhachHang kh = dl.KhachHangs.FirstOrDefault(k => k.UserName == us.UserName);
            GioHang i = dl.GioHangs.FirstOrDefault(t => t.MaSP == g.MaSP && t.MaKH == kh.MaKH);
            string slValue = Request.Form["sl"];
            if (int.Parse(slValue) > 0)
            {
                if (i == null)
                {
                    i = new GioHang();
                    i.MaSP = g.MaSP;
                    i.MaKH = kh.MaKH;
                    i.SoLuong = int.Parse(slValue);

                    dl.GioHangs.InsertOnSubmit(i);
                    dl.SubmitChanges();
                    return RedirectToAction("SanPham");
                }
                else
                {
                    if (i.SoLuong + int.Parse(slValue) <= i.SanPham.SoLuong)
                    {
                        i.SoLuong += int.Parse(slValue);

                        UpdateModel(i);
                        dl.SubmitChanges();
                        return RedirectToAction("SanPham");
                    }
                    else
                    {
                        ViewBag.Er = "Số lượng trong giỏ hàng không được vượt số lượng trong kho";
                        SanPham sp = dl.SanPhams.Where(t => t.MaSP == g.MaSP).FirstOrDefault();
                        ViewBag.masp = dl.ChiTietSanPhams.Where(t => t.MaSP == g.MaSP).FirstOrDefault();
                        return View("ChiTietSP", sp);

                    }
                }
            }
            else
            {
                ViewBag.Er = "Số lượng không nhỏ hơn 1";
                SanPham sp = dl.SanPhams.Where(t => t.MaSP == g.MaSP).FirstOrDefault();
                ViewBag.masp = dl.ChiTietSanPhams.Where(t => t.MaSP == g.MaSP).FirstOrDefault();
                return View("ChiTietSP", sp);
            }
        }

        public ActionResult Cart()
        {
            if (Session["kh"] != null)
            {
                KhachHang us = Session["kh"] as KhachHang;
                KhachHang kh = dl.KhachHangs.FirstOrDefault(k => k.UserName == us.UserName);
                List<GioHang> ds = new List<GioHang>();
                ds = dl.GioHangs.Where(t => t.MaKH == kh.MaKH).ToList();
                ViewBag.kh = kh;
                return View(ds);
            }
            else
            {
                return RedirectToAction("Login", "TaiKhoan");
            }
        }

        public ActionResult Xoa_Cart(string id)
        {
            if (Session["kh"] == null)
            {
                Session["kh"] = new KhachHang();
            }
            KhachHang us = Session["kh"] as KhachHang;
            KhachHang kh = dl.KhachHangs.FirstOrDefault(k => k.UserName == us.UserName);
            GioHang i = dl.GioHangs.FirstOrDefault(t => t.MaSP == id && t.MaKH == kh.MaKH);
            if (i != null)
            {
                dl.GioHangs.DeleteOnSubmit(i);
                dl.SubmitChanges();
            }
            return RedirectToAction("Cart");
        }
        [HttpPost]
        public ActionResult UpdateQuantity(string itemId, int newQuantity)
        {
            GioHang ds = new GioHang();
            // Thực hiện cập nhật số lượng trong danh sách ds hoặc cơ sở dữ liệu ở đây
            if (Session["kh"] != null)
            {
                KhachHang us = Session["kh"] as KhachHang;
                KhachHang kh = dl.KhachHangs.FirstOrDefault(k => k.UserName == us.UserName);
                ds = dl.GioHangs.Where(t => t.MaKH == kh.MaKH && t.MaSP == itemId).FirstOrDefault();
                if (ds != null)
                {
                    if (newQuantity > ds.SanPham.SoLuong)
                    { }
                    if (newQuantity > 0)
                    {
                        ds.SoLuong = newQuantity;
                        dl.SubmitChanges();
                    }
                    else
                    {
                        dl.GioHangs.DeleteOnSubmit(ds);
                        dl.SubmitChanges();
                    }
                }

            }
            return Json(new { success = true, message = "Cập nhật số lượng thành công" });
        }
        [HttpPost]
        public ActionResult DatHang(int tt, float sum)
        {
            List<GioHang> ds = new List<GioHang>();
            if (Session["kh"] != null)
            {
                KhachHang us = Session["kh"] as KhachHang;
                KhachHang kh = dl.KhachHangs.FirstOrDefault(k => k.UserName == us.UserName);
                ds = dl.GioHangs.Where(t => t.MaKH == kh.MaKH).ToList();
                HoaDon hd = new HoaDon();
                int dem = dl.HoaDons.Count();
                hd.SoHD = "HD00" + (dem + 1).ToString();
                HoaDon n = dl.HoaDons.FirstOrDefault(f => f.SoHD == hd.SoHD);
                while (n != null)
                {
                    dem++;
                    hd.SoHD = "HD00" + (dem + 1).ToString();
                    n = dl.HoaDons.FirstOrDefault(f => f.SoHD == hd.SoHD);
                }
                hd.MaKH = kh.MaKH;
                hd.NgayLap = DateTime.Now;
                hd.TongTien = (int)sum;
                hd.NgayGiao = null;
                hd.MaNV = null;
                hd.PTThanhToan = false;
                hd.DiaChi = kh.DiaChi;
                //Thanh toán khi nhận hàng
                if (tt == 0)
                {
                    hd.TrangThai = false;
                    dl.HoaDons.InsertOnSubmit(hd);
                    dl.SubmitChanges();
                    foreach (GioHang g in ds)
                    {
                        ChiTietHD ct = new ChiTietHD();
                        ct.SoHD = hd.SoHD;
                        ct.MaSP = g.MaSP;
                        ct.SoLuongBan = g.SoLuong;
                        ct.GiaBan = g.SanPham.GiaBan;
                        ct.ThanhTien = (int?)g.SoLuong * (int?)g.SanPham.GiaBan;
                        dl.ChiTietHDs.InsertOnSubmit(ct);
                        dl.SubmitChanges();
                        g.SanPham.SoLuong -= g.SoLuong;
                        dl.GioHangs.DeleteOnSubmit(g);
                        dl.SubmitChanges();
                    }
                    return RedirectToAction("DatHangThanhCong");
                }
                //Thanh toán online   

            }
            return RedirectToAction("DatHangThanhCong");
        }
        public ActionResult DatHangThanhCong()
        {
            return View();
        }
        public ActionResult HoSo()
        {
            if (Session["kh"] != null)
            {
                KhachHang us = Session["kh"] as KhachHang;
                KhachHang kh = dl.KhachHangs.FirstOrDefault(k => k.UserName == us.UserName);
                ViewBag.kh = kh;
                return View();
            }
            else
            {
                return RedirectToAction("Login", "TaiKhoan");
            }
        }
        public ActionResult SuaKH(KhachHang t, FormCollection fc)
        {
            KhachHang l = dl.KhachHangs.FirstOrDefault(s => s.MaKH != fc["id"] && s.SDT == fc["phone"]);
            if (l == null)
            {
                KhachHang ft = dl.KhachHangs.FirstOrDefault(s => s.MaKH == fc["id"]);
                ft.TenKH = fc["name"];
                ft.DiaChi = fc["address"];
                ft.SDT = fc["phone"];
                ft.Email = fc["email"];
                dl.SubmitChanges();

                return RedirectToAction("Cart");
            }
            else
            {
                // Thông báo cho người dùng
                ViewBag.ErrorMessage = "Sửa thông tin không thành công!";

                return View("HoSo"); // Trả về View với thông báo lỗi
            }
        }
        public ActionResult KiemTraPass()
        {
            KhachHang kh = (KhachHang)Session["kh"];
            KhachHang k = dl.KhachHangs.FirstOrDefault(f => f.UserName == kh.UserName);
            ViewBag.kh = k;
            return View();
        }
        [HttpPost]
        public ActionResult KiemTraPass(FormCollection fc)
        {
            string user = fc["username"];
            string pass = fc["password"];
            KhachHang kh = (KhachHang)Session["kh"];
            if (user == kh.UserName && pass == kh.TaiKhoan.Password)
            {
                KhachHang k = dl.KhachHangs.FirstOrDefault(f => f.UserName == kh.UserName);
                return View("DoiPass", k);
            }
            else
            {
                TempData["LoginMessage"] = "Invalid password !";

                KhachHang k = dl.KhachHangs.FirstOrDefault(f => f.UserName == kh.UserName);
                return RedirectToAction("KiemTraPass", k); // Trả về View với thông báo lỗi
            }
        }
        public ActionResult DoiPass()
        {
            KhachHang kh = (KhachHang)Session["kh"];
            KhachHang k = dl.KhachHangs.FirstOrDefault(f => f.UserName == kh.UserName);
            return View(k);
        }
        [HttpPost]
        public ActionResult DoiPass(FormCollection fc)
        {
            KhachHang kh = (KhachHang)Session["kh"];
            string user = fc["username"];
            if (fc["password"] == fc["confirmpassword"])
            {
                TaiKhoan a = dl.TaiKhoans.FirstOrDefault(f => f.UserName == user);
                if (a != null)
                {
                    a.UserName = user;
                    a.Password = fc["password"];
                    dl.SubmitChanges();

                    TempData["LoginMessage"] = "Đổi mật khẩu thành công";
                    KhachHang k = dl.KhachHangs.FirstOrDefault(f => f.UserName == kh.UserName);
                    ViewBag.kh = k;
                    return View("HoSo"); // Trả về View với thông báo lỗi
                }
                else
                {
                    // Thông báo cho người dùng
                    ViewBag.ErrorMessage = "Mật khẩu thay đổi thất bại!";

                    KhachHang k = dl.KhachHangs.FirstOrDefault(f => f.UserName == kh.UserName);
                    ViewBag.kh = k;
                    return View("HoSo"); // Trả về View với thông báo lỗi
                }
            }
            else
            {
                TempData["LoginMessage"] = "Mật khẩu không chính xác!";

                KhachHang k = dl.KhachHangs.FirstOrDefault(f => f.UserName == kh.UserName);
                return View("DoiPass", k); // Trả về View với thông báo lỗi
            }
        }
        public ActionResult VnpayReturn()
        {
            if (Request.QueryString.Count > 0)
            {
                string vnp_HashSecret = "CWHYNXKKLQTCCTQXEKOIDOOFEOVWNSJN"; //Chuoi bi mat

                var vnpayData = Request.QueryString;
                VnPayLibrary vnpay = new VnPayLibrary();

                foreach (string s in vnpayData)
                {
                    //get all querystring data
                    if (!string.IsNullOrEmpty(s) && s.StartsWith("vnp_"))
                    {
                        vnpay.AddResponseData(s, vnpayData[s]);
                    }
                }
                string orderCode = Convert.ToString(vnpay.GetResponseData("vnp_TxnRef"));
                long vnpayTranId = Convert.ToInt64(vnpay.GetResponseData("vnp_TransactionNo"));
                string vnp_ResponseCode = vnpay.GetResponseData("vnp_ResponseCode");
                string vnp_TransactionStatus = vnpay.GetResponseData("vnp_TransactionStatus");
                String vnp_SecureHash = Request.QueryString["vnp_SecureHash"];
                String TerminalID = Request.QueryString["vnp_TmnCode"];
                long vnp_Amount = Convert.ToInt64(vnpay.GetResponseData("vnp_Amount")) / 100;
                String bankCode = Request.QueryString["vnp_BankCode"];

                bool checkSignature = vnpay.ValidateSignature(vnp_SecureHash, vnp_HashSecret);
                if (checkSignature)
                {
                    if (vnp_ResponseCode == "00" && vnp_TransactionStatus == "00")
                    {
                        ThanhToanOnline onl = new ThanhToanOnline();
                        onl.SoHD = thanhToanOnline();
                        onl.MaGD = vnpayTranId.ToString();
                        onl.NganHang = bankCode;
                        addOnl(onl);

                        //Thanh toan thanh cong
                        ViewBag.InnerText = "Giao dịch được thực hiện thành công. Cảm ơn quý khách đã sử dụng dịch vụ.";
                        //displayVnpayTranNo.InnerText = "Mã giao dịch tại VNPAY:" + vnpayTranId.ToString();
                        ViewBag.ThanhToanThanhCong = "Số tiền thanh toán: " + vnp_Amount.ToString() + " VND";
                        //displayBankCode.InnerText = "Ngân hàng thanh toán:" + bankCode;

                    }
                    else
                    {
                        //Thanh toan khong thanh cong. Ma loi: vnp_ResponseCode
                        ViewBag.InnerText = "Có lỗi xảy ra trong quá trình xử lý thanh toán.";
                    }
                }
            }
            return View();
        }
        private void addOnl(ThanhToanOnline onl)
        {
            dl.ThanhToanOnlines.InsertOnSubmit(onl);
            dl.SubmitChanges();
        }
        private int tinhTongTien()
        {
            float sum = 0;
            if (Session["kh"] != null)
            {
                List<GioHang> ds = new List<GioHang>();
                KhachHang us = Session["kh"] as KhachHang;
                KhachHang kh = dl.KhachHangs.FirstOrDefault(k => k.UserName == us.UserName);
                ds = dl.GioHangs.Where(t => t.MaKH == kh.MaKH).ToList();
                foreach (GioHang g in ds)
                {
                    sum += g.SoLuong * g.SanPham.GiaBan;
                }
            }
            return (int)sum;
        }
        private string thanhToanOnline()
        {
            HoaDon hd = new HoaDon();
            List<GioHang> ds = new List<GioHang>();
            if (Session["kh"] != null)
            {
                KhachHang us = Session["kh"] as KhachHang;
                KhachHang kh = dl.KhachHangs.FirstOrDefault(k => k.UserName == us.UserName);
                ds = dl.GioHangs.Where(t => t.MaKH == kh.MaKH).ToList();
                int dem = dl.HoaDons.Count();
                hd.SoHD = "HD00" + (dem + 1).ToString();
                HoaDon n = dl.HoaDons.FirstOrDefault(f => f.SoHD == hd.SoHD);
                while (n != null)
                {
                    dem++;
                    hd.SoHD = "HD00" + (dem + 1).ToString();
                    n = dl.HoaDons.FirstOrDefault(f => f.SoHD == hd.SoHD);
                }
                hd.MaKH = kh.MaKH;
                hd.NgayLap = DateTime.Now;
                hd.TongTien = tinhTongTien();
                hd.NgayGiao = null;
                hd.MaNV = null;
                hd.PTThanhToan = true;
                hd.DiaChi = kh.DiaChi;
                hd.TrangThai = false;
                dl.HoaDons.InsertOnSubmit(hd);
                dl.SubmitChanges();
                foreach (GioHang g in ds)
                {
                    ChiTietHD ct = new ChiTietHD();
                    ct.SoHD = hd.SoHD;
                    ct.MaSP = g.MaSP;
                    ct.SoLuongBan = g.SoLuong;
                    ct.GiaBan = g.SanPham.GiaBan;
                    ct.ThanhTien = (int?)g.SoLuong * (int?)g.SanPham.GiaBan;
                    dl.ChiTietHDs.InsertOnSubmit(ct);
                    dl.SubmitChanges();
                    g.SanPham.SoLuong -= g.SoLuong;
                    dl.GioHangs.DeleteOnSubmit(g);
                    dl.SubmitChanges();
                }
            }
            return hd.SoHD;
        }
    }
}