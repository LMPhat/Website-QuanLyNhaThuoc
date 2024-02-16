using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DoAnChuyenNganh_WebNhaThuoc.Models
{
    public class CTPN
    {
        public string masp { get; set; }
        public string tenSP { get; set; }
        public string tenLoai { get; set; }
        public int giaNhap { get; set; }
        public int soluong { get; set; }
        public int thanhTien { get { return soluong * giaNhap; } }

        public CTPN(string masp, string tenSP, string tenLoai, int giaNhap, int soluong)
        {
            this.masp = masp;
            this.tenSP = tenSP;
            this.tenLoai = tenLoai;
            this.giaNhap = giaNhap;
            this.soluong = soluong;
        }
        public CTPN(string masp, string tenSP, string tenLoai, int soluong)
        {
            this.masp = masp;
            this.tenSP = tenSP;
            this.tenLoai = tenLoai;
            this.soluong = soluong;
        }

        public CTPN(string masp, string tenSP, string tenLoai)
        {
            this.masp = masp;
            this.tenSP = tenSP;
            this.tenLoai = tenLoai;
        }
    }
}