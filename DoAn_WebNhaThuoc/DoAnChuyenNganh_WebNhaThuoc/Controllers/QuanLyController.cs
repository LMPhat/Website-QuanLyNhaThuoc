using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DoAnChuyenNganh_WebNhaThuoc.Models;

namespace DoAnChuyenNganh_WebNhaThuoc.Controllers
{
    [CustomAuthorizationFilter]
    public class QuanLyController : Controller
    {
        //
        // GET: /QuanLy/
        QLNhaThuocDataContext dl = new QLNhaThuocDataContext();
        public ActionResult MenuLoaiSP()
        {
            List<DanhMucSP> ds = dl.DanhMucSPs.ToList();
            return PartialView(ds);
        }
        [CustomAuthorizeFilter]
        public ActionResult DanhMuc()
        {
            List<DanhMucSP> ds = dl.DanhMucSPs.ToList();
            return View(ds);
        }
        [HttpPost]
        public ActionResult ThemDM(FormCollection fc)
        {
            List<DanhMucSP> dsl = dl.DanhMucSPs.ToList();
            string tenDM = fc["tenDM"].Trim().ToString();
            if (tenDM == "")
            {
                // Thông báo cho người dùng
                ViewBag.ErrorMessage = "Tên danh mục có ít nhất 1 ký tự.";

                return View("DanhMuc", dsl); // Trả về View với thông báo lỗi
            }
            DanhMucSP dm = new DanhMucSP();
            dm = dsl.FirstOrDefault(f => f.TenDM.ToLower() == tenDM.ToLower());
            if (dm == null)
            {
                dm = new DanhMucSP();
                int t = dl.DanhMucSPs.Count();
                dm.MaDM = "TL00" + (t + 1).ToString();
                DanhMucSP n = dl.DanhMucSPs.FirstOrDefault(f => f.MaDM == dm.MaDM);
                while (n != null)
                {
                    t++;
                    dm.MaDM = "TL00" + (t + 1).ToString();
                    n = dl.DanhMucSPs.FirstOrDefault(f => f.MaDM == dm.MaDM);
                }
                dm.TenDM = tenDM;

                dl.DanhMucSPs.InsertOnSubmit(dm);
                dl.SubmitChanges();
                return RedirectToAction("DanhMuc", dm);
            }
            else
            {
                // Thông báo cho người dùng
                ViewBag.ErrorMessage = "Tên danh mục đã tồn tại.";

                return View("DanhMuc", dsl); // Trả về View với thông báo lỗi
            }
        }

        [HttpPost]
        public ActionResult SuaDM(DanhMucSP t)
        {
            List<DanhMucSP> dsl = dl.DanhMucSPs.ToList();
            if (t.TenDM.Trim() == "")
            {
                // Thông báo cho người dùng
                ViewBag.ErrorMessage = "Tên danh mục có ít nhất 1 ký tự.";

                return View("DanhMuc", dsl); // Trả về View với thông báo lỗi
            }
            DanhMucSP l = dl.DanhMucSPs.FirstOrDefault(s => s.MaDM != t.MaDM && s.TenDM.ToLower() == t.TenDM.ToLower().Trim());
            if (l == null)
            {
                DanhMucSP ft = dl.DanhMucSPs.FirstOrDefault(s => s.MaDM == t.MaDM);

                ft.TenDM = t.TenDM;

                UpdateModel(ft);
                dl.SubmitChanges();

                return RedirectToAction("DanhMuc");
            }
            else
            {
                // Thông báo cho người dùng
                ViewBag.ErrorMessage = "Tên danh mục vừa sửa đã tồn tại.";

                return View("DanhMuc", dsl); // Trả về View với thông báo lỗi
            }
        }

        [HttpPost]
        public ActionResult XoaDM(DanhMucSP n)
        {
            List<DanhMucSP> dsl = dl.DanhMucSPs.ToList();
            DanhMucSP ft = dl.DanhMucSPs.FirstOrDefault(t => t.MaDM == n.MaDM);
            SanPham sp = dl.SanPhams.FirstOrDefault(t => t.MaDM == ft.MaDM);
            if (sp == null)
            {
                dl.DanhMucSPs.DeleteOnSubmit(ft);
                dl.SubmitChanges();

                return RedirectToAction("DanhMuc");
            }
            else
            {
                // Thông báo cho người dùng
                ViewBag.ErrorMessage = "Xóa danh mục không thành công.";

                return View("DanhMuc", dsl); // Trả về View với thông báo lỗi
            }
        }

        [CustomAuthorizeFilter]
        public ActionResult SanPham()
        {
            List<SanPham> ds = dl.SanPhams.OrderByDescending(sp => sp.MaSP).ToList();
            ViewBag.maloai = dl.DanhMucSPs.ToList();
            return View(ds);
        }
        [CustomAuthorizeFilter]
        [HttpPost]
        public ActionResult ThemSanPham(SanPham d, ChiTietSanPham ct, HttpPostedFileBase fileUpload, FormCollection fc)
        {
            List<SanPham> dssp = dl.SanPhams.OrderByDescending(sp => sp.MaSP).ToList();
            SanPham l = dl.SanPhams.FirstOrDefault(s => s.TenSP.ToLower() == d.TenSP.ToLower() && s.MaDM == d.MaDM);
            if (d.TenSP.Trim() == "" || d.NuocSX.Trim() == "" || ct.CongDung.Trim() == "" || ct.ThanhPhan.Trim() == "" || ct.LuuY.Trim() == "")
            {
                // Thông báo cho người dùng
                ViewBag.ErrorMessage = "Thông tin ít nhất có 1 ký tự";
                ViewBag.maloai = dl.DanhMucSPs.ToList();

                return View("SanPham", dssp); // Trả về View với thông báo lỗi
            }
            if (l == null)
            {
                int t = dl.SanPhams.Count();
                d.MaSP = "SP00" + (dl.SanPhams.Count() + 1).ToString();
                SanPham n = dl.SanPhams.FirstOrDefault(f => f.MaSP == d.MaSP);
                while (n != null)
                {
                    t++;
                    d.MaSP = "SP00" + (t + 1).ToString();
                    n = dl.SanPhams.FirstOrDefault(f => f.MaSP == d.MaSP);
                }
                fileUpload.SaveAs(Server.MapPath("/HinhAnh/" + fileUpload.FileName));
                d.HinhAnh = fileUpload.FileName;
                d.TrangThai = true;
                d.SoLuong = 0;

                dl.SanPhams.InsertOnSubmit(d);//thêm vào bảng Sản phẩm
                dl.SubmitChanges();

                ct.MaSP = d.MaSP;

                dl.ChiTietSanPhams.InsertOnSubmit(ct);//thêm vào bảng Sản phẩm
                dl.SubmitChanges();

                ViewBag.maloai = dl.DanhMucSPs.ToList();
                return RedirectToAction("SanPham", d);
            }
            else
            {
                // Thông báo cho người dùng
                ViewBag.ErrorMessage = "Sản phẩm thêm mới đã tồn tại.";
                ViewBag.maloai = dl.DanhMucSPs.ToList();

                return View("SanPham", dssp); // Trả về View với thông báo lỗi
            }
        }

        [HttpPost]
        public ActionResult SuaSP(SanPham t, ChiTietSanPham ct)
        {
            List<SanPham> dsl = dl.SanPhams.OrderByDescending(sp => sp.MaSP).ToList();

            if (t.TenSP.Trim() == "" || t.NuocSX.Trim() == "" || ct.CongDung.Trim() == "" || ct.ThanhPhan.Trim() == "" || ct.LuuY.Trim() == "")
            {
                // Thông báo cho người dùng
                ViewBag.ErrorMessage = "Thông tin ít nhất có 1 ký tự";
                ViewBag.maloai = dl.DanhMucSPs.ToList();

                return View("SanPham", dsl); // Trả về View với thông báo lỗi
            }
            SanPham l = dl.SanPhams.FirstOrDefault(s => s.MaSP != t.MaSP && s.TenSP.ToLower() == t.TenSP.ToLower().Trim() && s.MaDM == t.MaDM);
            if (l == null)
            {
                SanPham ft = dl.SanPhams.FirstOrDefault(s => s.MaSP == t.MaSP);
                ChiTietSanPham ft_ct = dl.ChiTietSanPhams.FirstOrDefault(s => s.MaSP == t.MaSP);
                if (ft != null && ft_ct != null)
                {
                    ft.TenSP = t.TenSP;
                    ft.MaDM = t.MaDM;
                    ft.TrangThai = t.TrangThai;

                    ft_ct.ThanhPhan = ct.ThanhPhan;
                    ft_ct.CongDung = ct.CongDung;
                    ft_ct.LuuY = ct.LuuY;

                    //UpdateModel(ft);
                    dl.SubmitChanges();
                }
                ViewBag.maloai = dl.DanhMucSPs.ToList();
                return RedirectToAction("SanPham", dsl);
            }
            else
            {
                // Thông báo cho người dùng
                ViewBag.ErrorMessage = "Thông tin sửa đã tồn tại.";
                ViewBag.maloai = dl.DanhMucSPs.ToList();

                return View("SanPham", dsl); // Trả về View với thông báo lỗi
            }
        }

        [HttpPost]
        public ActionResult XoaSP(FormCollection coll)
        {
            string id = coll["MaSP"].Trim();
            //Tìm 1 thể loại trong sql
            List<SanPham> dsl = dl.SanPhams.OrderByDescending(sp => sp.MaSP).ToList();
            SanPham ft = dl.SanPhams.FirstOrDefault(t => t.MaSP == id); //tìm được thể loại cũ
            ChiTietSanPham kt = dl.ChiTietSanPhams.FirstOrDefault(t => t.MaSP == id);
            ViewBag.maloai = dl.DanhMucSPs.ToList();

            List<GioHang> lst_GH = dl.GioHangs.Where(f => f.MaSP == id).ToList();

            if (ft != null && kt != null)
            {
                foreach (GioHang item in lst_GH)
                {
                    dl.GioHangs.DeleteOnSubmit(item);
                    dl.SubmitChanges();
                }

                dl.ChiTietSanPhams.DeleteOnSubmit(kt);
                dl.SubmitChanges();

                dl.SanPhams.DeleteOnSubmit(ft);
                dl.SubmitChanges(); //được thêm vào sql

                TempData["LoginMessage"] = "1";
                return RedirectToAction("SanPham", dsl);
            }
            else
            {
                // Thông báo cho người dùng
                ViewBag.ErrorMessage = "Xóa sản phẩm không thành công !";
                return View("SanPham", dsl); // Trả về View với thông báo lỗi
            }
        }
        public ActionResult ChiTietSP(string id)
        {
            if (id == null)
                return RedirectToAction("SanPham");
            else
            {
                SanPham sp = dl.SanPhams.Where(t => t.MaSP == id).FirstOrDefault();
                ViewBag.masp = dl.ChiTietSanPhams.Where(t => t.MaSP == id).FirstOrDefault();
                return View(sp);
            }
        }

        [CustomAuthorizeFilter]
        public ActionResult NhanVien()
        {
            List<NhanVien> ds = dl.NhanViens.ToList();
            return View(ds);
        }

        [HttpPost]
        public ActionResult ThemNV(NhanVien d, TaiKhoan a, FormCollection fc)
        {
            List<NhanVien> ds = dl.NhanViens.ToList();
            NhanVien nv = dl.NhanViens.Where(t => t.UserName == fc["tenDN"].Trim()).FirstOrDefault();
            TaiKhoan tk = dl.TaiKhoans.Where(t => t.UserName == fc["tenDN"].Trim()).FirstOrDefault();
            NhanVien ktr_sdt = dl.NhanViens.FirstOrDefault(s => s.SDT == fc["sdt"].Trim());
            NhanVien ktr_email = dl.NhanViens.FirstOrDefault(s => s.Email == fc["email"].Trim());

            if (fc["tenDN"].Trim() == "" || fc["tenNV"].Trim() == "")
            {
                // Thông báo cho người dùng
                ViewBag.ErrorMessage = "Thông tin ít nhất có 1 ký tự";

                return View("NhanVien", ds); // Trả về View với thông báo lỗi
            }

            if (nv != null || tk != null)
            {
                TempData["LoginMessage"] = "Loi_1";
                return RedirectToAction("NhanVien"); // Trả về View với thông báo lỗi
            }
            if (ktr_sdt == null && ktr_email == null)
            {
                a.UserName = fc["tenDN"].Trim();
                a.Password = fc["password"];
                a.PhanQuyen = false;
                dl.TaiKhoans.InsertOnSubmit(a);
                dl.SubmitChanges();

                int t = dl.KhachHangs.Count();
                d.MaNV = "NV00" + (t + 1).ToString();
                NhanVien n = dl.NhanViens.FirstOrDefault(f => f.MaNV == d.MaNV);
                while (n != null)
                {
                    t++;
                    d.MaNV = "NV00" + (t + 1).ToString();
                    n = dl.NhanViens.FirstOrDefault(f => f.MaNV == d.MaNV);
                }

                d.TenNV = fc["tenNV"];
                d.SDT = fc["sdt"];
                d.TrangThai = true;
                d.Email = fc["email"];

                d.UserName = fc["tenDN"];
                dl.NhanViens.InsertOnSubmit(d);
                dl.SubmitChanges();

                TempData["LoginMessage"] = "Them_TC";
                return RedirectToAction("NhanVien");
            }
            else
            {
                if (ktr_sdt != null)
                    TempData["SuaLoi_SDT"] = "SuaLoi_SDT";
                if (ktr_email != null)
                    TempData["SuaLoi_Email"] = "SuaLoi_Email";

                return RedirectToAction("NhanVien"); // Trả về View với thông báo lỗi
            }
        }

        [HttpPost]
        public ActionResult SuaNV(NhanVien t)
        {
            List<NhanVien> dsl = dl.NhanViens.ToList();
            NhanVien ktr_sdt = dl.NhanViens.FirstOrDefault(s => s.MaNV != t.MaNV && s.SDT == t.SDT.Trim());
            NhanVien ktr_email = dl.NhanViens.FirstOrDefault(s => s.MaNV != t.MaNV && s.Email == t.Email.Trim());
            if (t.TenNV.Trim() == "" || t.SDT.Trim() == "" || t.Email.Trim() == "")
            {
                // Thông báo cho người dùng
                ViewBag.ErrorMessage = "Tên nhân viên ít nhất có 1 ký tự";

                return View("NhanVien", dsl); // Trả về View với thông báo lỗi
            }
            if (ktr_sdt == null && ktr_email == null)
            {
                NhanVien ft = dl.NhanViens.FirstOrDefault(s => s.MaNV == t.MaNV);

                ft.TenNV = t.TenNV;
                ft.SDT = t.SDT;
                ft.Email = t.Email;

                UpdateModel(ft);
                dl.SubmitChanges();

                TempData["LoginMessage"] = "Sua_TC";
                return RedirectToAction("NhanVien");
            }
            else
            {
                if(ktr_sdt != null)
                    TempData["SuaLoi_SDT"] = "SuaLoi_SDT";
                if (ktr_email != null)
                    TempData["SuaLoi_Email"] = "SuaLoi_Email";

                return RedirectToAction("NhanVien");
            }
        }

        [HttpPost]
        public ActionResult XoaNV(FormCollection coll)
        {
            string id = coll["MaNV"].Trim();
            string us = coll["UserName"].Trim();
            List<NhanVien> dsl = dl.NhanViens.ToList();
            NhanVien ft = dl.NhanViens.FirstOrDefault(t => t.UserName == us);
            TaiKhoan kt = dl.TaiKhoans.FirstOrDefault(t => t.UserName == us);
            HoaDon hd = dl.HoaDons.FirstOrDefault(t => t.MaNV == id);
            PhieuNhap pn = dl.PhieuNhaps.FirstOrDefault(t => t.MaNV == id);

            if (ft != null && kt != null && hd == null && pn == null)
            {
                dl.NhanViens.DeleteOnSubmit(ft);
                dl.SubmitChanges(); //được thêm vào sql

                dl.TaiKhoans.DeleteOnSubmit(kt);
                dl.SubmitChanges();

                TempData["LoginMessage"] = "Xoa_TC";
                return RedirectToAction("NhanVien");
            }
            else
            {
                // Thông báo cho người dùng
                ViewBag.ErrorMessage = "Xóa nhân viên không thành công.";

                return RedirectToAction("NhanVien"); // Trả về View với thông báo lỗi
            }
        }

        [CustomAuthorizeFilter]
        public ActionResult KhachHang()
        {
            List<KhachHang> ds = dl.KhachHangs.ToList();
            return View(ds);
        }

        [HttpPost]
        public ActionResult SuaKH(KhachHang t)
        {
            List<KhachHang> dsl = dl.KhachHangs.ToList();
            KhachHang l = dl.KhachHangs.FirstOrDefault(s => s.MaKH != t.MaKH && (s.SDT == t.SDT || s.Email == t.Email));
            if (l == null)
            {
                KhachHang ft = dl.KhachHangs.FirstOrDefault(s => s.MaKH == t.MaKH);
                if (ft != null)
                {
                    ft.TrangThai = t.TrangThai;

                    //UpdateModel(ft);
                    dl.SubmitChanges();
                }
                TempData["LoginMessage"] = "1";
                return RedirectToAction("KhachHang", dsl);
            }
            else
            {
                // Thông báo cho người dùng
                ViewBag.ErrorMessage = "Thông tin sửa đã tồn tại.";

                return View("KhachHang", dsl); // Trả về View với thông báo lỗi
            }
        }

        [HttpPost]
        public ActionResult XoaKH(FormCollection coll)
        {
            string id = coll["MaKH"].Trim();
            string us = coll["UserName"].Trim();
            //Tìm 1 thể loại trong sql
            List<KhachHang> dsl = dl.KhachHangs.OrderByDescending(sp => sp.MaKH).ToList();
            KhachHang ft = dl.KhachHangs.FirstOrDefault(t => t.MaKH == id); //tìm được thể loại cũ
            TaiKhoan kt = dl.TaiKhoans.FirstOrDefault(t => t.UserName == us);
            HoaDon hd = dl.HoaDons.FirstOrDefault(t => t.MaKH == id);

            if (ft != null && kt != null && hd == null)
            {
                dl.KhachHangs.DeleteOnSubmit(ft);
                dl.SubmitChanges(); //được thêm vào sql

                dl.TaiKhoans.DeleteOnSubmit(kt);
                dl.SubmitChanges();

                TempData["LoginMessage"] = "2";
                return RedirectToAction("KhachHang", dsl);
            }
            else
            {
                // Thông báo cho người dùng
                ViewBag.ErrorMessage = "Xóa khách hàng không thành công !";
                return View("KhachHang", dsl); // Trả về View với thông báo lỗi
            }
        }

        public ActionResult HoaDon()
        {
            List<HoaDon> ds = dl.HoaDons.ToList();
            return View(ds);
        }

        public ActionResult CapNhatTrangThai_HD(string id)
        {
            List<HoaDon> dsl = dl.HoaDons.ToList();
            HoaDon l = dl.HoaDons.FirstOrDefault(s => s.SoHD == id);
            if (l != null)
            {
                l.TrangThai = true;
                l.NgayGiao = DateTime.Now;

                UpdateModel(l);
                dl.SubmitChanges();

                TempData["LoginMessage"] = "1";
                return RedirectToAction("HoaDon");
            }
            else
            {
                // Thông báo cho người dùng
                TempData["LoginMessage"] = "2";

                return View("HoaDon", dsl); // Trả về View với thông báo lỗi
            }
        }

        public ActionResult ChiTietHD(string id)
        {
            List<ChiTietHD> dsl = dl.ChiTietHDs.Where(f => f.SoHD == id).ToList();
            HoaDon hd = dl.HoaDons.Where(f => f.SoHD == id).FirstOrDefault();
            ViewBag.soHD = hd;
            KhachHang kh = dl.KhachHangs.FirstOrDefault(k => k.MaKH == hd.MaKH);
            ViewBag.kh = kh;
            ThanhToanOnline onl = dl.ThanhToanOnlines.Where(o => o.SoHD == id).FirstOrDefault();
            ViewBag.onl = onl;
            return View(dsl);
        }

        public ActionResult PhieuNhap()
        {
            List<PhieuNhap> dsl = dl.PhieuNhaps.ToList();
            ViewBag.mapn = dl.ChiTietPNs.ToList();
            return View(dsl);
        }

        public ActionResult ChiTietPN(string id)
        {
            List<ChiTietPN> dsl = dl.ChiTietPNs.Where(f => f.MaPN == id).ToList();
            PhieuNhap pn = dl.PhieuNhaps.Where(f => f.MaPN == id).FirstOrDefault();
            ViewBag.mapn = pn;
            NhaCungCap ncc = dl.NhaCungCaps.FirstOrDefault(k => k.MaNCC == pn.MaNCC);
            ViewBag.ncc = ncc;
            return View(dsl);
        }

        public ActionResult ThemPN()
        {
            // Kiểm tra xem Session["SelectedProducts"] đã được khởi tạo chưa
            if (Session["SelectedProducts"] == null)
            {
                // Nếu chưa được khởi tạo, bạn có thể tạo một danh sách trống
                Session["SelectedProducts"] = new List<CTPN>();
            }

            ViewBag.mancc = dl.NhaCungCaps.ToList();
            ViewBag.masp = dl.SanPhams.OrderBy(s => s.SoLuong).ToList();

            return View();
        }

        [HttpPost]
        public ActionResult AddProduct(ChiTietPN c, FormCollection fc)
        {
            string MASP = fc["MaSP"].Trim();
            string SLNHAP = fc["SoLuongNhap"];
            string DGNHAP = fc["GiaNhap"];

            // Lấy sản phẩm từ CSDL dựa trên id hoặc theo cách bạn lấy sản phẩm
            SanPham product = dl.SanPhams.FirstOrDefault(t => t.MaSP.Trim() == MASP.Trim());
            if (float.Parse(DGNHAP) < product.GiaBan)
            {
                CTPN item = new CTPN(product.MaSP.Trim(), product.TenSP.Trim(), product.DanhMucSP.TenDM, int.Parse(DGNHAP), int.Parse(SLNHAP));

                // Kiểm tra xem Session["SelectedProducts"] đã tồn tại và khởi tạo nó nếu cần
                List<CTPN> selectedProducts = Session["SelectedProducts"] as List<CTPN>;

                bool exists = false;
                foreach (CTPN i in selectedProducts)
                {
                    if (MASP == i.masp)
                    {
                        i.giaNhap = item.giaNhap; // Cộng dồn giá nhập
                        i.soluong += item.soluong; // Cộng dồn số lượng
                        exists = true;
                        break;
                    }
                }

                if (!exists)
                {
                    selectedProducts.Add(item); // Thêm mới vào danh sách
                }

                Session["SelectedProducts"] = selectedProducts;

                return RedirectToAction("ThemPN"); // Chuyển hướng trở lại trang danh sách sản phẩm
            }
            else
            {
                // Thông báo cho người dùng
                ViewBag.ErrorMessage = "Giá nhập phải bé hơn giá bán.";
                ViewBag.mancc = dl.NhaCungCaps.ToList();
                ViewBag.masp = dl.SanPhams.OrderBy(s => s.SoLuong).ToList();

                return View("ThemPN"); // Trả về View với thông báo lỗi
            }
        }

        [HttpPost]
        public ActionResult UpdateProduct(ChiTietPN c, FormCollection fc)
        {
            string MASP = fc["MaSP"].Trim();
            string SLNHAP = fc["SoLuongNhap"];
            string DGNHAP = fc["GiaNhap"];

            // Lấy sản phẩm từ CSDL dựa trên id hoặc theo cách bạn lấy sản phẩm
            SanPham product = dl.SanPhams.FirstOrDefault(t => t.MaSP.Trim() == MASP.Trim());
            if (int.Parse(DGNHAP) < product.GiaBan)
            {
                CTPN item = new CTPN(product.MaSP, product.TenSP, product.DanhMucSP.TenDM, int.Parse(DGNHAP), int.Parse(SLNHAP));

                // Kiểm tra xem Session["SelectedProducts"] đã tồn tại và khởi tạo nó nếu cần
                List<CTPN> selectedProducts = Session["SelectedProducts"] as List<CTPN>;
                CTPN pn = selectedProducts.Where(f => f.masp == MASP).FirstOrDefault();
                pn.giaNhap = item.giaNhap; // Cộng dồn giá nhập
                pn.soluong += item.soluong; // Cộng dồn số lượng

                Session["SelectedProducts"] = selectedProducts;

                return RedirectToAction("ThemPN"); // Chuyển hướng trở lại trang danh sách sản phẩm
            }
            else
            {
                // Thông báo cho người dùng
                ViewBag.ErrorMessage = "Giá nhập phải bé hơn giá bán.";

                return RedirectToAction("ThemPN"); // Trả về View với thông báo lỗi
            }
        }

        [HttpGet]
        public ActionResult DeleteProduct(string id)
        {
            List<CTPN> selectedProducts = Session["SelectedProducts"] as List<CTPN>;

            // Tìm và xóa sản phẩm dựa trên id (MASP)
            CTPN productToDelete = selectedProducts.FirstOrDefault(p => p.masp.Trim() == id.Trim());
            if (productToDelete != null)
            {
                selectedProducts.Remove(productToDelete);
                Session["SelectedProducts"] = selectedProducts;

                return RedirectToAction("ThemPN");
            }
            else
            {
                // Thông báo cho người dùng
                TempData["LoginMessage"] = "Xoa";

                return RedirectToAction("ThemPN"); // Trả về View với thông báo lỗi
            }
        }

        [HttpGet]
        public ActionResult ThemPhieuNhap_CT(string mancc)
        {
            try
            {
                PhieuNhap pn = new PhieuNhap();
                NhaCungCap ncc = dl.NhaCungCaps.FirstOrDefault(n => n.MaNCC == mancc);
                List<CTPN> selectedProducts = Session["SelectedProducts"] as List<CTPN>;
                TaiKhoan tk = Session["ad"] as TaiKhoan;
                NhanVien nv = dl.NhanViens.Where(f => f.UserName == tk.UserName).FirstOrDefault();

                int t = dl.PhieuNhaps.Count();
                pn.MaPN = "PN00" + (t + 1).ToString();
                PhieuNhap pn_1 = dl.PhieuNhaps.FirstOrDefault(f => f.MaPN == pn.MaPN);
                while (pn_1 != null)
                {
                    t++;
                    pn.MaPN = "PN00" + (t + 1).ToString();
                    pn_1 = dl.PhieuNhaps.FirstOrDefault(f => f.MaPN == pn.MaPN);
                }
                //Thêm phiếu nhập
                pn.NgayLap = DateTime.Now;
                if (nv != null)
                    pn.MaNV = nv.MaNV;
                else
                    pn.MaNV = null;
                pn.MaNCC = ncc.MaNCC;
                pn.TongTien = selectedProducts.Sum(f => f.soluong * f.giaNhap);
                dl.PhieuNhaps.InsertOnSubmit(pn);
                dl.SubmitChanges();

                //Thêm chi tiết phiếu nhập
                foreach (CTPN item in selectedProducts)
                {
                    ChiTietPN ct = new ChiTietPN();
                    ct.MaPN = pn.MaPN;
                    ct.MaSP = item.masp;
                    ct.SoLuongNhap = item.soluong;
                    ct.GiaNhap = item.giaNhap;
                    ct.ThanhTien = item.thanhTien;

                    dl.ChiTietPNs.InsertOnSubmit(ct);
                    dl.SubmitChanges();

                    //chỉnh sửa số lượng của sản phẩm
                    SanPham sp = dl.SanPhams.FirstOrDefault(f => f.MaSP == item.masp);
                    sp.SoLuong += item.soluong;

                    dl.SubmitChanges();
                }
                // Thông báo cho người dùng
                TempData["LoginMessage"] = "ThemPN_D";

                return RedirectToAction("PhieuNhap", pn);
            }
            catch
            {
                // Thông báo cho người dùng
                TempData["LoginMessage"] = "ThemPN_S";

                return RedirectToAction("PhieuNhap");
            }
        }

        public ActionResult ThongKe()
        {
            return PartialView();
        }

        [HttpPost]
        public ActionResult ThongKe(int? selectedYear)
        {
            int?[] salesByMonth = new int?[12];

            for (int month = 1; month <= 12; month++)
            {
                try
                {
                    // Truy vấn tổng tiền từ các hóa đơn của từng tháng trong năm
                    int totalSales = dl.HoaDons
                        .Where(hd => hd.NgayLap != null && hd.NgayLap.Year == selectedYear && hd.NgayLap.Month == month)
                        .Sum(hd => hd.TongTien.GetValueOrDefault(0));

                    salesByMonth[month - 1] = totalSales;
                }
                catch (Exception ex)
                {
                    // Xử lý ngoại lệ ở đây
                    salesByMonth[month - 1] = 0; // Hoặc gián một giá trị khác nếu cần
                }
            }

            ViewBag.DoanhSoTheoThang = string.Join(",", salesByMonth);

            return View(); // Trả về view ThongKe
        }

        [HttpPost]
        public ActionResult ThongKe_KhoangTG(DateTime? startDate, DateTime? endDate)
        {
            // Kiểm tra xem có dữ liệu ngày bắt đầu và kết thúc không
            if (startDate == null || endDate == null)
            {
                // Xử lý lỗi hoặc trả về trang với thông báo lỗi
                return RedirectToAction("ThongKe");
            }

            // Thực hiện truy vấn dữ liệu từ startDate đến endDate
            try
            {
                // Truy vấn tổng tiền từ các hóa đơn trong khoảng thời gian
                var salesData = dl.HoaDons
                    .Where(hd => hd.NgayLap != null && hd.NgayLap.Date >= startDate && hd.NgayLap.Date <= endDate)
                    .GroupBy(hd => hd.NgayLap.Date)  // Nhóm theo ngày
                    .OrderBy(group => group.Key)
                    .Select(group => new
                    {
                        Date = group.Key,
                        TotalSales = group.Sum(hd => hd.TongTien.GetValueOrDefault(0))
                    })
                    .ToList();

                // Chuyển dữ liệu thành JSON để hiển thị trong view
                ViewBag.DoanhSoTheoNgay = Newtonsoft.Json.JsonConvert.SerializeObject(salesData);
            }
            catch (Exception ex)
            {
                // Xử lý ngoại lệ ở đây
                // Có thể in ra log hoặc hiển thị thông báo lỗi
                ViewBag.Error = "Đã xảy ra lỗi trong quá trình xử lý.";
            }

            return View("ThongKe");
        }

	}
}