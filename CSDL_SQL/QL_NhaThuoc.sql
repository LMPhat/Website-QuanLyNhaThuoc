--Tạo database
use master
go

create database QL_NhaThuoc
go

use QL_NhaThuoc
go

--Tạo bảng

--Tạo bảng - tạo ràng buộc bảng Nhân viên
create table TaiKhoan
(
	UserName varchar(10) NOT NULL,
	Password varchar(100) NOT NULL,
	PhanQuyen bit NOT NULL,
	
	constraint PK_TaiKhoan primary key(UserName)
)

create table NhanVien
(
	MaNV char(10) NOT NULL,
	TenNV nvarchar(200) NULL,
	SDT char(10) NULL,
	Email nvarchar(100) NULL,
	UserName varchar(10) NOT NULL,
	TrangThai bit NOT NULL,

	constraint PK_NhanVien primary key(MaNV)
)

ALTER TABLE NhanVien 
ADD constraint FK_NhanVien_TaiKhoan foreign key(UserName) references TaiKhoan(UserName),
	constraint CK_SDT_NhanVien CHECK(SDT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
	
CREATE TABLE KhachHang
(
	MaKH char(10) NOT NULL,
	TenKH nvarchar(100) NOT NULL,
	DiaChi nvarchar(100) NULL,
	SDT char(10) NULL,
	Email nvarchar(100) NULL,
	UserName varchar(10) NOT NULL,
	TrangThai bit NOT NULL,
	
	constraint PK_KhachHang primary key (MaKH)
)

ALTER TABLE KhachHang
ADD constraint FK_KhachHang_TaiKhoan foreign key(UserName) references TaiKhoan(UserName),
	constraint DF_DiaChi_KhachHang DEFAULT N'Chưa xác định' for DiaChi,
	constraint CK_SDT_KhachHang CHECK(SDT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
	
CREATE TABLE DanhMucSP
(
	MaDM char(10) NOT NULL,
	TenDM nvarchar(100) NOT NULL,
	
	constraint PK_DanhMucSP primary key (MaDM)
)

CREATE TABLE SanPham
(
	MaSP char(10) NOT NULL,
	TenSP nvarchar(100) NOT NULL,
	GiaBan real NOT NULL,
	HinhAnh varchar(50) NULL,
	MaDM char(10) NOT NULL,
	NuocSX nvarchar(100) NOT NULL,
	TrangThai bit NOT NULL,
	SoLuong int NULL,
	constraint PK_SanPham primary key (MaSP)
)

ALTER table SanPham
add constraint FK_SanPham_DanhMucSP foreign key(MaDM) references DanhMucSP(MaDM)

CREATE TABLE ChiTietSanPham
(
	MaSP char(10) NOT NULL,
	ThanhPhan nvarchar(1000) NULL,
	CongDung nvarchar(1000) NULL,
	LuuY nvarchar(1000) NULL,
	
	constraint PK_ChiTietSanPham primary key (MaSP)
)

ALTER TABLE ChiTietSanPham
ADD constraint FK_ChiTietSanPham_SanPham foreign key(MaSP) references SanPham(MaSP),
	constraint DF_ThanhPhan_ChiTietSanPham DEFAULT N'Chưa xác định' for ThanhPhan,
	constraint DF_CongDung_ChiTietSanPham DEFAULT N'Chưa xác định' for CongDung,
	constraint DF_LuuY_ChiTietSanPham DEFAULT N'Chưa xác định' for LuuY

CREATE TABLE NhaCungCap
(
	MaNCC char(10) NOT NULL,
	TenNCC nvarchar(100) NOT NULL,
	DiaChi nvarchar(200) NULL,
	SoDienThoai varchar(10) NULL,
	
	constraint PK_NhaCungCap primary key (MaNCC)
)

ALTER TABLE NhaCungCap
ADD constraint DF_DiaChi_NhaCungCap DEFAULT N'Chưa xác định' for DiaChi,
	constraint CK_SoDienThoai_NhaCungCap CHECK(SoDienThoai LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')

CREATE TABLE PhieuDat
(
	MaPD char(10) NOT NULL,
	NgayLap datetime NOT NULL,
	TongTien real NULL,
	MaNCC char(10) NOT NULL,
	MaNV char(10) NOT NULL,
	
	constraint PK_PhieuDat primary key (MaPD)
)

ALTER table PhieuDat
add constraint FK_PhieuDat_NhaCungCap foreign key(MaNCC) references NhaCungCap(MaNCC),
	constraint FK_PhieuDat_NhanVien foreign key(MaNV) references NhanVien(MaNV),
	constraint CK_NgayLap_PhieuDat Check(NgayLap < getdate())
CREATE TABLE ChiTietPD
(
	MaPD char(10) NOT NULL,
	MaSP char(10) NOT NULL,
	SoLuongNhap int NOT NULL,
	GiaNhap real NOT NULL, 
	ThanhTien real NULL,
	
	constraint PK_ChiTietPD primary key (MaPD, MaSP)
)

ALTER table ChiTietPD
add constraint FK_ChiTietPD_PhieuDat foreign key(MaPD) references PhieuDat(MaPD),
	constraint FK_ChiTietPD_SanPham foreign key(MaSP) references SanPham(MaSP)

CREATE TABLE PhieuNhap
(
	MaPN char(10) NOT NULL,
	NgayLap datetime NOT NULL,
	TongTien int NULL,
	MaNCC char(10) NULL,
	MaNV char(10) NULL,
	
	constraint PK_PhieuNhap primary key (MaPN)
)

ALTER table PhieuNhap
add constraint FK_PhieuNhap_NhaCungCap foreign key(MaNCC) references NhaCungCap(MaNCC),
	constraint FK_PhieuNhap_NhanVien foreign key(MaNV) references NhanVien(MaNV),
	constraint CK_NgayLap_PhieuNhap Check(NgayLap < getdate())

CREATE TABLE ChiTietPN
(
	MaPN char(10) NOT NULL,
	MaSP char(10) NOT NULL,
	SoLuongNhap int NOT NULL,
	GiaNhap real NOT NULL, 
	ThanhTien int NULL,
	
	constraint PK_ChiTietPN primary key (MaPN, MaSP)
)

ALTER table ChiTietPN
add constraint FK_ChiTietPN_PhieuNhap foreign key(MaPN) references PhieuNhap(MaPN),
	constraint FK_ChiTietPN_SanPham foreign key(MaSP) references SanPham(MaSP)

CREATE TABLE HoaDon(
	SoHD char(10) NOT NULL,
	MaNV char(10) NULL,
	MaKH char(10) NULL,
	NgayLap datetime NOT NULL,
	TongTien int NULL,
	NgayGiao datetime NULL,
	TrangThai bit NULL, 
	PTThanhToan bit NULL,
	DiaChi nvarchar(100) NULL,

	constraint PK_HoaDon primary key (SoHD)
)

ALTER table HoaDon
add constraint FK_HoaDon_NhanVien foreign key(MaNV) references NhanVien(MaNV),
	constraint FK_HoaDon_KhachHang foreign key(MaKH) references KhachHang(MaKH),
	constraint CK_NgayLap_HoaDon Check(NgayLap < getdate()),
	constraint CK_NgayGiao_HoaDon Check(NgayGiao < getdate()),
	constraint DF_DiaChi_HoaDon DEFAULT N'Chưa xác định' for DiaChi

CREATE TABLE ThanhToanOnline(
	MaGD char(100) NOT NULL,
	NganHang nvarchar(100) NULL,
	SoHD char(10) NOT NULL,

	constraint PK_ThanhToanOnline primary key (MaGD)
)

ALTER table ThanhToanOnline
add constraint FK_ThanhToanOnline_HoaDon foreign key(SoHD) references HoaDon(SoHD),
	constraint DF_NganHang_ThanhToanOnline DEFAULT N'Chưa xác định' for NganHang

CREATE TABLE ChiTietHD
(
	SoHD char(10) NOT NULL,
	MaSP char(10) NOT NULL,
	SoLuongBan int NOT NULL,
	GiaBan real NOT NULL, 
	ThanhTien int NULL,
	
	constraint PK_ChiTietHD primary key (SoHD, MaSP)
)

ALTER table ChiTietHD
add constraint FK_ChiTietHD_HoaDon foreign key(SoHD) references HoaDon(SoHD),
	constraint FK_ChiTietHD_SanPham foreign key(MaSP) references SanPham(MaSP)

CREATE TABLE GioHang
(
	MaKH char(10) NOT NULL,
	MaSP char(10) NOT NULL,
	SoLuong int NOT NULL,
	
	constraint PK_GioHang primary key (MaKH, MaSP)
)

ALTER table GioHang
add constraint FK_GioHang_KhachHang foreign key(MaKH) references KhachHang(MaKH),
	constraint FK_GioHang_SanPham foreign key(MaSP) references SanPham(MaSP)

Go
-----------------------------------------------------------------------
---- NHẬP LIỆU
-----------------------------------------------------------------------

Insert into DanhMucSP 
values
	('TL001', N'Thực Phẩm Chức Năng'),
	('TL003', N'Thuốc Xương Khóp'),
	('TL004', N'Thuốc Bổ Thận'),
	('TL005', N'Thuốc Bổ Não'),
	('TL002', N'Thuốc Tây Y, Đông Y')

GO

Insert into SanPham 
values
	('SP001', N'Dielac Mama Gold Vinamilk 400g - Sữa cho mẹ mang thai và cho con bú', 116000, 'TPCN001.png', 'TL001', N'Việt Nam', 1,200),
	('SP002', N'Neo Vita White Plus Kokando 180 viên - Hỗ trợ trắng da', 620000, 'TPCN002.png', 'TL001', N'Nhật Bản', 1,212),
	('SP003', N'Mum Calci K2 Plus Lab Well 2 vỉ x 18 viên - Bổ sung canxi cho phụ nữ mang thai và cho con bú', 270000, 'TPCN003.png', 'TL001', N'Ba Lan', 1,100),
	('SP004', N'NMN 18000mg Bikenn 30 viên - Viên uống trẻ hoá tế bào', 270000, 'TPCN004.png', 'TL001', N'Nhật Bản', 1,500),
	('SP005', N'White Plus LCE Kokando 180 viên - Trị nám, tàn nhang', 760000, 'TPCN005.png', 'TL001', N'Nhật Bản', 1,120),
	('SP006', N'Byurakku Kokando 8 vỉ x 50 viên - Viên uống nhuận tràng', 299000, 'TPCN006.png', 'TL001', N'Nhật Bản', 1,270),
	('SP007', N'Rotuven 300 Natural Origin 60 viên - Hỗ trợ điều trị bệnh suy giãn tĩnh mạch chân', 495000, 'TPCN007.png', 'TL001', N'Mỹ', 1,123),
	('SP008', N'THIÊN HÒA BAN THIÊN HÒA ĐƯỜNG 15ML - HỖ TRỢ TRỊ BỆNH BAN', 8000, 'TPCN008.png', 'TL001', N'Việt Nam', 1,300),
	('SP009', N'Livrich Bhargava 4 vỉ x 15 viên - Tăng cường chức gan', 800000, 'TPCN009.png', 'TL001', N'Ấn Độ', 1, 400),
	('SP0010', N'GH Gold Ohzino 120 viên - Viên uống hỗ trợ tăng chiều cao', 680000, 'TPCN0010.png', 'TL001', N'Nhật Bản', 1,70),
	('SP0011', N'Strepsils Maxpro mật ong & chanh 2 vỉ x 8 viên - Viên ngậm đau họng', 36000, 'TKKD0011.png', 'TL002', N'Thái Lan', 1,566),
	('SP0012', N'Viên ngậm ho Prospan 2 vỉ x 10 viên - Trị viêm đường hô hấp', 36000, 'TKKD0012.png', 'TL002', N'Đức', 1, 677),
	('SP0013', N'Ornihepa Hà Nam 20 gói x 5g - Trị tăng ammoniac', 525000, 'TKKD0013.png', 'TL002', N'Việt Nam', 1, 89),
	('SP0014', N'Dermovate Cream 0,05 50g - Kem trị vảy nến', 360000, 'TKKD0014.png', 'TL002', N'Anh', 1,90),
	('SP0015', N'Canesten Cream Bayer 5g - Trị nấm da', 22000, 'TKKD0015.png', 'TL002', N'Ấn Độ', 1, 123),
	('SP0016', N'A Borraginol Kokando 20 viên - Viên đặt trị trĩ', 430000, 'TKKD0016.png', 'TL002', N'Nhật Bản', 1, 434),
	('SP0017', N'Dung dịch nhỏ mắt Novotane Ultra 5ml', 50000, 'TKKD0017.png', 'TL002', N'Việt Nam', 1,124),
	('SP0018', N'Alsanvin Alsanza 20g - Gel tiêm nội khớp', 1300000, 'TKKD0018.png', 'TL002', N'Đức', 1,890),
	('SP0019', N'Hemo Borragi Kenkan 60 viên - Viên uống hỗ trợ điều trị trĩ', 565000, 'TKKD0019.png', 'TL002', N'Nhật Bản', 1,321),
	('SP0020', N'Glucosamin 1550 Tetesept 40 viên - Viên bổ xương', 310000, 'TKKD0020.png', 'TL003', N'Đức', 1, 738),
	('SP0021', N'Yuan Bone Yuanyan 40 viên - Viên uống hỗ trợ xương', 105000, 'TKKD0021.png', 'TL003', N'Malaysia', 1, 32),
	('SP0022', N'Khương Thảo Đan Gold 30 viên - Giảm thoái hóa khớp', 168000, 'TKKD0022.png', 'TL003', N'Việt Nam', 1,57),
	('SP0023', N'Original Genacol 90 viên - Hỗ trợ tái tạo sụn khớp', 561000, 'TKKD0023.png', 'TL003', N'Canada', 1,47),
	('SP0024', N'Pain Relief Genacol 90 viên - Hỗ trợ tái tạo sụn khớp', 770000, 'TKKD0024.png', 'TL003', N'Canada', 1,89),
	('SP0025', N'Plus Genacol 90 viên - Giúp hỗ trợ tái tạo sụn khớp', 605000, 'TKKD0025.png', 'TL003', N'Canada', 1,32),
	('SP0026', N'Viên Sủi Intact Calcium Vitamin D3 Sanotact 15 viên', 112000, 'TKKD0026.png', 'TL003', N'Đức', 1,546),
	('SP0027', N'Dronagi 5 Agimexpharm 1 vỉ x 10 viên', 50000, 'TKKD0027.png', 'TL003', N'Việt Nam', 1, 87),
	('SP0028', N'Cốt Thoái Vương Á Âu 2 lọ x 90 viên - Viên uống hỗ trợ', 890000, 'TKKD0028.png', 'TL003', N'Việt Nam', 1,43),
	('SP0029', N'Viamen New 30 viên - Hỗ trợ cải thiện sinh lý nam giới', 575000, 'TKKD0029.png', 'TL004', N'Mỹ', 1,78),
	('SP0030', N'Strong Man Plus 30 viên - Viên uống sinh lý nam', 360000, 'TKKD0030.png', 'TL004', N'Việt Nam', 1,46),
	('SP0031', N'Klimakterin Dr Muller Pharma, 60 viên', 436000, 'TKKD0031.png', 'TL004', N'Cộng Hòa Séc', 1,882),
	('SP0032', N'Bổ Thận Nam Gold 30 viên - Giúp tăng cường sinh lý nam', 245000, 'TKKD0032.png', 'TL004', N'Việt Nam', 1,32),
	('SP0033', N'Duracore 20 viên - Viên uống tăng cường sinh lý nam', 590000, 'TKKD0033.png', 'TL004', N'Thái Lan', 1,31),
	('SP0034', N'Mycohydralin 500mg Bayer 1 viên - Viên đặt âm đạo', 270000, 'TKKD0034.png', 'TL004', N'Pháp', 1,11),
	('SP0035', N'A+ Nutrition Womens Enhancement Nature Gift 60', 680000, 'TKKD0035.png', 'TL004', N'Mỹ', 1,12),
	('SP0036', N'Vaginal Care Cream Kolorex 50g - Kem chăm sóc vùng', 515000, 'TKKD0036.png', 'TL004', N'New Zealand', 1,32),
	('SP0037', N'Procare Prostosan Sojilabs 30 viên', 418000, 'TKKD0037.png', 'TL004', N'Việt Nam', 1,120),
	('SP0038', N'AZBrain CVI Pharma 60 viên - Viên Uống Bổ Não', 285000, 'TKKD0038.png', 'TL005', N'Việt Nam', 1,120),
	('SP0039', N'Brain Gold 30 viên - Viên uống bổ não', 148000, 'TKKD0039.png', 'TL005', N'Việt Nam', 1,100),
	('SP0040', N'Silas 1 vỉ x 10 viên - Hoạt huyết dưỡng não', 90000, 'TKKD0040.png', 'TL005', N'Việt Nam', 1,134),
	('SP0041', N'5 HTP 100mg Swanson 60 viên - Hỗ trợ an thần, ngủ', 250000, 'TKKD0041.png', 'TL005', N'Mỹ', 1,111),
	('SP0042', N'Gutes Gehirn B.Braun 60 viên - Viên uống bổ não', 395000, 'TKKD0042.png', 'TL005', N'Đức', 1,222),
	('SP0043', N'Otiv Ecogreen 60 viên - Viên uống bổ não', 590000, 'TKKD0043.png', 'TL005', N'	Mỹ', 1,444),
	('SP0044', N'Hoạt Huyết Dưỡng Não Thiên Cân 60 viên', 160000, 'TKKD0044.png', 'TL005', N'Việt Nam', 1,421),
	('SP0045', N'Nước Cốt Gà Brands 42ml vị dịu nhẹ', 25000, 'TKKD0045.png', 'TL005', N'Thái lan', 1,112),
	('SP0046', N'Neuroforte Healthaid 30 viên - Viên uống bổ não', 390000, 'TKKD0046.png', 'TL005', N'Việt Nam', 1,123),
	('SP0047', N'Viên Sủi Demosana Iron + Vitamin C Sanotact 20', 108000, 'TKKD0047.png', 'TL001', N'Đức', 1,321),
	('SP0048', N'Viên Ngậm Vitaprolis Pastilles Eric Favre', 119000, 'TKKD0048.png', 'TL001', N'Pháp', 1,321),
	('SP0049', N'Quick Sleep Ysana 10ml - Hỗ trợ cải thiện giấc ngủ', 360000, 'TKKD0049.png', 'TL001', N'Tây Ban Nha', 1,121),
	('SP0050', N'Nat C 1000 Mega 60 viên - Viên uống bổ sung vitamin', 223000, 'TKKD0050.png', 'TL001', N'Việt Nam', 1,321),
	('SP0051', N'Thạch Ăn Ngon Ích Nhi 21 gói x 30g - Giúp trẻ biếng', 105000, 'TKKD0051.png', 'TL001', N'Việt Nam', 1,321),
	('SP0052', N'Ocean Multi Orzax 150ml - Hỗ trợ tăng cường sức', 295000, 'TKKD0052.png', 'TL001', N'Thổ Nhĩ Kỳ', 1,213),
	('SP0053', N'Ocean Wellkids Multi-Iron Orzax 30ml - Bổ sung sắt', 275000, 'TKKD0053.png', 'TL001', N'Thổ Nhĩ Kỳ', 1,321),
	('SP0054', N'Eyematin Meracine 30 viên - Hỗ trợ giảm cận thị', 155000, 'TKKD0054.png', 'TL001', N'Pháp', 1,32),
	('SP0055', N'Saticalci Plus MK7 Meracine 15 ống x 10ml', 99000, 'TKKD0055.png', 'TL001', N'Việt Nam', 1,31),
	('SP0056', N'Men vi sinh Blactis Meracine 20 ống', 119000, 'TKKD0056.png', 'TL001', N'Việt Nam', 1,321),
	('SP0057', N'Diva Perfect White Nature Gift 30 viên ', 1150000, 'TKKD0057.png', 'TL001', N'Mỹ', 1,321),
	('SP0058', N'Healthy Choice Brain Nature Gift 60 viên', 565000, 'TKKD0058.png', 'TL001', N'Mỹ', 1,321),
	('SP0059', N'Vitacomplex Gricar 125ml - Siro bổ sung dưỡng chất', 290000, 'TKKD0059.png', 'TL001', N'Italia', 1,321),
	('SP0060', N'Prokavip DHA 30 viên - Viên uống bổ bầu', 330000, 'TKKD0060.png', 'TL001', N'Úc', 1,321),
	('SP0061', N'Special Kid Omega 30 viên - Bổ sung DHA ', 330000, 'TKKD0061.png', 'TL001', N'Pháp', 1,321),
	('SP0062', N'Alltimes Care Whitening Skin 60 viên - Hỗ trợ trắng', 950000, 'TKKD0062.png', 'TL001', N'Úc', 1,321),
	('SP0063', N'Prenatal Folic Acid + DHA Nature Made 150 viên', 650000, 'TKKD0063.png', 'TL001', N'Mỹ', 1,321)


GO
Insert into ChiTietSanPham
values
	('SP001',N'Sữa từ 100% sữa tươi (96%), đường (3,8%), chất ổn định (471, 460(i), 407, 466), vitamin (A, D3), khoáng chất (natri selenit/ sodium selenite).',N'Tăng cường sức khỏe cho mẹ: Sắt: bổ sung nhu cầu gia tăng và hỗ trợ ngăn ngừa thiếu máu, thiếu sắt trong suốt thai kỳ. Chất xơ: bổ sung hệ chất xơ hòa tan tiên tiến SC-FOS và Inulin, giúp ngăn ngừa táo bón và rối loạn tiêu hóa ở mẹ. Chất béo: công thức ít béo, bổ sung dầu thực vật giúp tránh tình trạng tăng cân quá mức cho mẹ sau sinh.',N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.'),
	('SP002',N'Vitamin C (ascorbic acid), L-cysteine, D-α-tocopherol succinate, Butyrate riboflavin (vitamin B ), Cellulose, tinh bột ngô, tế bào Loos, Hypromellose, Sucrose, Talc, TiO2, keo, Povidone, Sáp Carnauba, Axit stearic, Magiê và các chất cần thiết khác',N'Hỗ trợ loại bỏ tế bào chết, tái tạo tế bào tổn thương do sự tàn phá của môi trường; Hỗ trợ tăng cường sức đề kháng cho làn da, giảm viêm nhiễm, các vấn đề về da cũng như ngăn ngừa sự tấn công gây hại của tia UV với làn da.; Kích hoạt các tế bào liên tục vận động để duy trì sự trẻ trung, khỏe mạnh và bảo vệ độ sáng mịn cho làn da.',N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.'),
	('SP003', N'Canxi: 600mg, Magie: 40mg, Vitamin D3: 20mcg, Vitamin k2: 22.5mcg', N'Bổ sung canxi, vitamin D3, vitamin K2 và magie. Hỗ trợ bổ sung canxi và tăng cường hấp thu canxi cho phụ nữ mang thai và cho con bú.', N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.'),
	('SP004',N'NMN/3: 600mg, Chất béo: 0,03g, Đạm: 0,51g, Carbohydrate: 0,49g',N'Giúp tăng cường hệ miễn dịch của cơ thể và phòng ngừa bệnh tật. Giúp hỗ trợ cải thiện sức khỏe toàn diện, trẻ hóa cơ thể ở cấp độ tế bào. Bổ sung chất NAD+ giúp kích hoạt gen trường thọ Sirtuin kéo dài tuổi thọ và ức chế mọi dấu hiệu lão hóa. Hỗ trợ vẻ đẹp và sức khỏe luôn căng tràn và rạng rỡ.',N'Hiệu quả của sản phẩm có thể thay đổi tùy theo cơ địa của mỗi người.'),
	('SP005',N'Calcium ascorbate, vitamin B2, C, E (d-α-tocopherol), Procianidin chiết xuất từ vỏ thông biển Pháp, nhân sâm, rong biển…',N'Ngăn ngừa lão hóa đồng thời tái tạo tế bào tổn thương do sự tàn phá của môi trường, ức chế melanin và chặn đứng những thay đổi về sắc tố. Kích hoạt các tế bào liên tục vận động để duy trì sự trẻ trung, khỏe mạnh và bảo vệ độ sáng mịn cho làn da. Bổ sung chất dinh dưỡng từ bên trong giúp điều hỗ trợ mờ nám và tàn nhang.',N' Thực phẩm bảo vệ sức khỏe  giúp hỗ trợ nâng cao sức đề kháng, giảm nguy cơ mắc bệnh, không có tác dụng điều trị và không thể thay thế thuốc chữa bệnh.'),
	('SP006',N'Bisacodyl “2- (4,4-diacetoxydiphenylmethylpyridine 1 ……… 15mg, lactose hydrat cellulose, crospovidone, chất đồng trùng hợp axit metacrylic S, chất đồng trùng hợp axit metacrylic LD natri lauryl sulfat, làm chất phụ gia, Polysorbate 80. Hypromerose, triethyl citrate, talc, sucrose, gôm arabic, oxit titan, macrogol, povidone, sáp carnauba, magie stearat.',N'Hỗ trợ thúc đẩy nhu động ruột, đẩy các chất độc, chất thải bên trong cơ thể ra ngoài, giảm thiểu nguy cơ táo bón. Nhuận tràng, làm sạch ruột, cho cơ thể thanh thoát, nhẹ nhàng, dễ dàng hấp thu các chất dinh dưỡng. Giảm sự tích tụ mỡ thừa, độc tố, hỗ trợ giảm cân, bụng nhẹ và săn chắc hơn. Hỗ trợ thải độc, detox, tăng cường miễn dịch, dưỡng da săn chắc, căng khoẻ.',N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.'),
	('SP007',N'Cao khô Hạt dẻ ngựa: 300mg, Rutin: 200mg, Phụ liệu: Tinh bột, glycerin, magnesium stearate, silica vừa đủ 1 viên',N'Phòng ngừa và hỗ trợ điều trị bệnh suy giãn tĩnh mạch chân gồm: đau chân, nặng chân, phù chân. Hỗ trợ làm tăng trương lực tĩnh mạch, củng cố sức bền thành mạch',N'Hiệu quả của sản phẩm có thể thay đổi tùy theo cơ địa của mỗi người.'),
	('SP008',N'Công thức cho chai 15ml: Kinh giới: 1,5g, Bạc hà: 1,5g, Sài hồ: 1,2g, Thiên hoa phấn: 0,75g, Hoàng liên: 0,6g, Bạch thược: 0,54g, Cam thảo: 0,45g, Thiên ma: 0,45g, Ngô thù du: 0,3g, Hoàng cầm: 0,3g, Natri benzoat: 0,03g', N'Hỗ trợ giúp thanh nhiệt, giảm tình trạng mẩn ngứa, rôm sẩy, phát ban do nóng trong.',N'Thực phẩm bảo vệ sức khỏe  giúp hỗ trợ nâng cao sức đề kháng, giảm nguy cơ mắc bệnh, không có tác dụng điều trị và không thể thay thế thuốc chữa bệnh.'),
	('SP009',N'Livrich là sự kết hợp từ 3 loại thảo dược: Kế sữa (Silymarin), Xuyên tâm liên, Bồ Công Anh.',N'Thanh nhiệt Gan, giải độc Gan. Bảo vệ Gan khỏi tác nhân gây hại như rượu bia, thuốc gây hại Gan, vi khuẩn,…. Phục hồi, tăng cường chức năng gan nhờ việc tái tạo tế bào tổn thương và tăng cường sản xuất tế bào mới.',N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.'),
	('SP0010',N'Canxi san hô (Coral Calcium): Hàm lượng canxi san hô cao lên đến 500mg cho mỗi lần dùng (2 viên), cao gấp 10 lần so với các sản phẩm cùng loại. Đây là loại canxi được tích tụ và phong hóa hàng trăm năm, giàu Canxi cùng nhiều khoáng chất khác như Magie, Phospho, Sắt, Kẽm, Silic... giúp hấp thu và chuyển hóa Canxi vượt trội hơn.',N'Bổ sung canxi, vitamin D3 cho cơ thể.',N'Thực phẩm bảo vệ sức khỏe  giúp hỗ trợ nâng cao sức đề kháng, giảm nguy cơ mắc bệnh, không có tác dụng điều trị và không thể thay thế thuốc chữa bệnh.'),
	('SP0011',N'Hoạt chất: Flurbiprofen 8,75mg. Tá dược: Polyethylene glycol 300, Pellet kali hydroxid, Hương chanh 502904A, Tinh dầu bạc hà tự nhiên, Glucose lỏng, Đường tinh chế, Mật ong, Nước tinh khiết.', N'Viên ngậm StrepsilsMaxpro được chỉ định để làm giảm đau trong viêm họng nặng có triệu chứng. Giúp loại trừ sưng đau và nhạy cảm đau ở họng. Tác dụng chống viêm.',N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.'),
	('SP0012',N'Cao lá thường xuân khô 26mg. Tá dược: Acacia, sorbitol, maltitol, citric acid khan, acesulfame K, hương cam, hương frescofort, triglycerides, nước tinh khiết.',N'Điều trị triệu chứng trong các bệnh lý viêm phế quản mãn tính.',N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.'),
	('SP0013',N'L-Ornithin L-Aspartat: 3000mg; Tá dược vđ: 5g',N'Điều trị tăng ammoniac do các bệnh liên quan đến bệnh gan cấp tính hoặc mạn tính, xơ gan, gan nhiễm mỡ',N'Sản phẩm có chứa lactose. Những bệnh nhân có vấn đề di truyền hiếm gặp không dung nạp galactose, các trường hợp thiếu lactase hoặc kém hấp thu glucose không nên sử dụng thuốc này.'),
	('SP0014',N'Tá dược: Glyceryl monostearate, Cetostearyl alcohol, Chlorocresol, Natri citrate, Citric acid (monohydrate), Nước tinh khiết, Arlacel 165, Beeswax substitute 6621, Propylene glycol.',N'Dermovate là corticosteroid dùng tại chỗ có hiệu lực rất cao được chỉ định cho người lớn, người cao tuổi và trẻ em trên 12 tuổi nhằm làm giảm các triệu chứng viêm và ngứa của các bệnh da đáp ứng với steroid.',N'Thận trọng khi sử dụng DERMOVATE ở bệnh nhân có tiền sử quá mẫn tại chỗ với corticosteroid hoặc với bất kỳ tá dược nào của thuốc. Các phản ứng quá mẫn tại chỗ (xem Tác dụng không mong muốn) có thể tương tự các triệu chứng của bệnh đang điều trị.'),
	('SP0015',N' Benzyl Alcohol, Cetostearyl Alcohol, Cetyl Palmitate, Octyldodecanol, Polysorbate 60, nước cất, Sorbitan monostearate',N'Các bệnh nhiễm nấm ngoài da do nấm da, nấm men, nấm mốc, và nấm khác (ví dụ nấm kẽ chân, nấm da tay, nấm da thân mình, nấm bẹn, lang ben) và erythrasma ( bệnh nấm do crynebacterium minutissimium)',N'Mẫn cảm với clotrimazole hay bất cứ thành phần nào của thuốc.'),
	('SP0016',N'Lidocaine (60mg), Prednisolone acetate ester (1mg), Vitamin E (50mg), Allantoin (20mg).',N'Nhanh chóng làm giảm cơn đau nhức, ngứa rát, chảy máu. Làm giảm viêm sưng, ức chế các dây thần kinh tạo cảm giác đau đớn. Chống viêm, kháng khuẩn, hỗ trợ làm lành vết thương, vết nứt kẽ. Cải thiện lưu thông máu, giảm tắc nghẽn, hỗ trợ người bệnh dễ dàng hơn khi đi vệ sinh. Hỗ trợ ức chế hình thành búi trĩ, hỗ trợ điều trị bệnh trĩ giúp người bệnh khỏe mạnh, tự tin hơn.',N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.'),
	('SP0017',N'Polyethylen glycol 400(4mg), Propylen glycon(3mg)',N'Để giảm tạm thời các chứng rát và kích ứng do khô mắt.',N'Chỉ dùng nhỏ mắt, không sử dụng trong các trường hợp sau đây: Nếu thuốc bị đổi màu hoặc bị mờ đục; Nếu nhạy cảm với bất kỳ thành phần nào của thuốc; Bệnh nhân có các rối loạn di truyền hiếm gặp về dung nạp fructose'),
	('SP0018',N'20mg/ml (2%) 20mg HA trong 2,4ml dung dịch; Trọng lượng phân tử: 3 TRIỆU DALTON; Độ nhớt: 900.000 mPa.s',N'Ngoại trừ các trường hợp có các biến chứng nặng cần phải phẫu thuật ngoại khoa, chiến lược điều trị thoái hoá khớp chủ yếu là giúp giảm cơn đau, cải thiện chức năng và duy trì về mặt chất lượng cuộc sống cho bệnh nhân. Trong đó, những sản phẩm có chứa thành phần acid hyaluronic (HA) tiêm khớp là một sự lựa chọn tốt nhất nhằm giảm đau do thoái hoá khớp.',N'Chống chỉ định tiêm nội khớp cho các trường hợp đang bị nhiễm trùng hoặc bệnh ngoài da ở vùng tiêm để giảm khả năng phát triên bệnh viêm khớp nhiễm khuẩn.'),
	('SP0019',N'Bột trần bì, Diosmin, Bột diếp cá,...',N'Nhưng đặc tính là khó hòa tan trong nước và rượu, với công nghệ độc đáo, chúng tôi đã phát triển Hesperidin với khả năng hòa tan cao, phát huy tác dụng tối ưu khi vào cơ thể.',N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.'),
	('SP0020',N'Glucosamin, Chondroitinsulfat, Axit hyaluronic, Đồng, Vitamin C, Vitamin D, Vitamin K, Kẽm',N'Giảm đau nhức xương khớp do các bệnh đau lưng, thoái hóa khớp, thoát vị đĩa đệm, đau mỏi vai gáy.',N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.'),
	('SP0021',N'Unitex : 50mg, Glucosamin : 500mg, MSM : 150mg, Chondroitin : 200mg, Boswellia serrata 65% : 100mg, Zin C : 50mg, Selenium : 40mcg',N'Thoái hóa khớp, thoái hóa đốt sống cổ , đau thần kinh tọa, bệnh gout, thoát vị đĩa đệm, đau mỏi vai gáy , đau thần kinh liên sườn, tê bại tứ chi',N'Hiệu quả của sản phẩm có thể thay đổi tùy theo cơ địa của mỗi người.'),
	('SP0022',N'Cao Độc Hoạt, Cao Tang Ký Sinh, Cao Ngưu Tất,...',N'Hỗ trợ giảm nguy cơ thoái hóa khớp, thoái hóa đốt sống, thoát vị đĩa đệm và hỗ trợ làm chậm quá trình thoái hóa khớp, thoái hóa cột sống.',N'Hiệu quả của sản phẩm có thể thay đổi tùy theo cơ địa của mỗi người.'),
	('SP0023',N'Aminolock® Collagen thủy phân (từ bò) 400mg, (Aminolock® hydrolyzed Collagen from bovine source), Phụ liệu: Magnesium Stearate thực vật, Gelatin.',N'Hỗ trợ tái tạo sụn khớp, giảm triệu chứng cứng khớp do thoái hóa khớp.',N'Hiệu quả của sản phẩm có thể thay đổi tùy theo cơ địa của mỗi người.'),
	('SP0024',N'Aminolock® Collagen thủy phân (từ bò) 400mg, (Aminolock® hydrolysed Collagen from bovine source),  Màng vỏ trứng tự nhiên hòa tan 150mg, (Soluble natural eggshell membrane), Phụ liệu: Gelatin, Cellulose vi tinh thể, Magnesium Stearate thực vật.',N'Hỗ trợ tái tạo sụn khớp, giảm triệu chứng cứng khớp do thoái hóa khớp.',N'Hiệu quả của sản phẩm có thể thay đổi tùy theo cơ địa của mỗi người.'),
	('SP0025',N'Glucosamin hydrochloride 500mg, Aminolock® Collagen thủy phân (từ bò) 400mg, Phụ liệu: Magnesium Stearate thực vật, Gelatin.',N'Hỗ trợ tái tạo sụn khớp, giảm triệu chứng cứng khớp do thoái hóa khớp.',N'Hiệu quả của sản phẩm có thể thay đổi tùy theo cơ địa của mỗi người.'),
	('SP0026',N' Vitamin D3 10μg, Canxi 120 mg (bổ sung dưới dạng canxi carbonate)',N'Bổ sung canxi và vitamin D3 giúp thúc đẩy phát triển chiều cao tối đa, Tăng cường hệ miễn dịch',N'Hiệu quả của sản phẩm có thể thay đổi tùy theo cơ địa của mỗi người.'),
	('SP0027',N'Hoạt chất: Risedronat natri (dưới dạng Risedronat natri hemi-pentahydrat) 5mg',N'Điều trị và ngăn ngừa bệnh loãng xương ở phụ nữ sau mãn kinh. Đề phòng gãy xương ở phụ nữ sau mãn kinh bị loãng xương.',N'Hiệu quả của sản phẩm có thể thay đổi tùy theo cơ địa của mỗi người.'),
	('SP0028',N'Dầu vẹm xanh 1mg, Cao Thiên niên kiện 300mg, Nhũ hương 50mg, Glycine 100mg, Canxi Gluconat 50mg, Vitamin K 4mg, Vitamin B1 0.5mg, Vitamin B2 0.5mg, Magie 5.8mg.',N'Hỗ trợ giảm đau xương khớp, góp phần giúp xương khớp chắc khỏe, làm chậm quá trình thoái hóa khớp.',N'Hiệu quả của sản phẩm có thể thay đổi tùy theo cơ địa của mỗi người.'),
	('SP0029',N'Vỏ nang gelatin, glycerine - INS 422, dầu đậu nành - INS 479, sorbitol - INS 420(i) , lecithin - INS 322(i), chất màu FD$C Red #40 - INS129',N'Hỗ trợ cải thiện sinh lý nam giới.',N'Hiệu quả của sản phẩm có thể thay đổi tùy theo cơ địa của mỗi người.'),
	('SP0030',N'Cao Bách Bệnh 150mg, Cao Dâm Dương Hoắc 50mg, Cao Bạch Tật Lê 25mg, Cao Ba Kích Thiên 25mg, L-arginine HCl 25mg, Kẽm gluconat (tương đương 3.6mg kẽm) 25mg, Bột nấm ngọc cẩu 20mg, Bột Nhục Thung Dung 20mg, Bột, Nhân sâm 20mg, Cao Bạch Quả 10mg. Vỏ nang (gelatin), (magnesi stearate), chất độn (tinh bột sắn).',N'Giúp hỗ trợ cải thiện sinh lý nam',N'Hiệu quả của sản phẩm có thể thay đổi tùy theo cơ địa của mỗi người.'),
	('SP0031',N'Dầu cá (chứa 18% EPA và 12% DHA), Chiết xuất cỏ ba lá đỏ (Red clover extract), Chiết xuất đậu nành (Soya bean extract), Vitamin D và một số thành phần phụ khác',N'Hỗ trợ giảm các chứng do thiết hụt nội tiết tố nữ giai đoạn tiền mãn kinh như bốc hỏa, đổ mồ hôi, hay cáu gắt, da và tóc khô, da sạm, nám.',N'Hiệu quả của sản phẩm có thể thay đổi tùy theo cơ địa của mỗi người.'),
	('SP0032',N'Nấm toả dương, Bột đông trùng hạ thảo, Bôt hàu biển',N'Hỗ trợ cải thiện sinh lý nam giới',N'Hiệu quả của sản phẩm có thể thay đổi tùy theo cơ địa của mỗi người.'),
	('SP0033',N'Chất chống đông vón (INS 470iii, INS 551, INS 553iii), Gelatin thực phẩm (INS 428), màu tổng hợp (INS 171)',N'Giúp hỗ trợ cải thiện sinh lý nam',N'Hiệu quả của sản phẩm có thể thay đổi tùy theo cơ địa của mỗi người.'),
	('SP0034',N'Tinh bột ngô, Axit lactic, Canxi lactate, Microcrystalline cellulose, Pentahydrate, Crospovidone, Lactose monohydrate, Hypromellose, Magie Stearate, Colloidal silica anhydular.',N'Điều trị với các trường hợp chị em phụ nữ bị căng thẳng, sụt cân đột ngột sau sinh, do thay đổi nội tiết tố dẫn đến viêm nhiễm âm đạo.',N'Hiệu quả của sản phẩm có thể thay đổi tùy theo cơ địa của mỗi người.'),
	('SP0035',N'Gelatin, magnesium stearate, cám gạo, silicon dioxide, titanium dioxide',N'Hỗ trợ giảm các triệu chứng tiền mãn kinh, mãn kinh.',N'Hiệu quả của sản phẩm có thể thay đổi tùy theo cơ địa của mỗi người.'),
	('SP0036',N'Trà tràm, Lô hội, Dầu Olive, Dầu chanh và thành phần khác',N'Hỗ trợ điều trị hiệu quả bệnh viêm nhiễm nấm Candida, ức chế sự tăng trưởng nấm candida quá mức ở vùng kín.',N'Hiệu quả của sản phẩm có thể thay đổi tùy theo cơ địa của mỗi người.'),
	('SP0037',N'Cao lá náng: 200 mg; Cao phá cố chỉ: 100mg; Cao Hải Trung Kim: 100 mg; Cao Sài hồ nam: 100mg; Cao ích trí nhân: 50 mg; Saw palmetto extract (chiết xuất cây cọ lùn): 30mg; Equisetum extract (chiết xuất cỏ đuôi ngựa): 50mg',N' Sojilabs được chiết xuất hoàn toàn từ tự nhiên giúp hỗ trợ cải thiện chức năng thận, hỗ trợ hạn chế tình trạng tiểu đêm đáng ở người lớn tuổi ngoài ra Prostosan còn hỗ trợ.',N'Hiệu quả của sản phẩm có thể thay đổi tùy theo cơ địa của mỗi người.'),
	('SP0038',N'200mg Cao hỗn hợp chiết xuất từ lượng thảo mộc khô, Kê huyết đằng 600mg, Đan sâm 340mg, Nghệ vàng 225mg, Ngưu tất bắc 150mg, Đương quy 100mg, Can khương 50mg, Mật ong: 30mg',N'Hỗ trợ bổ huyết, hoạt huyết, giúp làm giảm các triệu chứng của thiểu năng tuần hoàn não như: đau đầu, hoa mắt, chóng mặt, mất ngủ, suy nhược thần kinh.',N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.'),
	('SP0039',N'Ginkgo biloba extract: 250 mg, Blueberry extract: 50 mg, Polyscias fruticosa extract: 50 mg, Cao tâm sen: 30 mg, Magnesium gluconate: 30 mg, Cao hòe hoa: 5 mg, Nattokinase: 50 FU, Vitamin B6: 2 mg 1 mg, Melatonin: 50 mcg, Coenzyme Q10 50 mg, Citicoline: 50 mg',N'Giúp giảm các biểu hiện của thiếu năng tuần hoàn não. Hỗ trợ giảm nguy cơ di chứng sau tại biến mạch máu não do tắc mạch',N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.'),
	('SP0040',N'Ginkgo Biloba Extract ( Chiết xuất bạch quả): 200mg, Gotu Kola Extract ( Chiết xuất rau má): 60mg, Polyscias Fruticose Extract (Chiết xuất đinh lăng): 60mg, Polygala Myrtifolia Extract ( Chiết xuất Viễn chí): 30mg, Ginseng Extract ( Chiết xuất nhân sâm): 20mg, Phụ liệu : Gelatin capsule shell, Corn Starch, Magie Stearate vừa đủ 1 viên',N'Hỗ trợ: hoạt huyết, tăng cường tuần hoàn não, người có biểu hiện mệt mỏi, đau đầu, hoa mắt, chóng mặt, tê bì chân tay, suy nhược thần kinh, hội chứng tiền đình, giảm trí nhớ, đau mỏi vai gáy, thiếu ngủ, mất ngủ.',N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.'),
	('SP0041',N'L-5 HTP (L-5 hydroxytryptophan) (Chiết xuất hạt Griffonia simplicifolia)',N'Hỗ trợ sản xuất serotonin, điều chỉnh tâm trạng và là tiền chất của melatonin. Hỗ trợ sức khỏe tinh thần và cảm xúc, giúp thúc đẩy tâm trạng cân bằng, lành mạnh. Một hợp chất độc đáo được chiết xuất từ hạt griffonia. Tăng sức khỏe tổng thể',N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.'),
	('SP0042',N'Dầu đậu nành, carboxil, gelatin, lecithin, sáp ong, glucerin, sorbitol, nước tinh khiết, ethanol, nipagin, nipasol, vanillin, titanium, dioxyd, phẩm màu vừa đủ 1 viên.',N'Giúp hoạt huyết, tăng cường tuần hoàn máu não, giúp giảm triệu chứng với các biểu hiện: đau đầu, hoa mắt, chóng mặt, mất thăng bằng, hay quên do thiểu năng tuần hoàn não.',N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.'),
	('SP0043',N'Blueberry Extract (4:1): 100 mg, GinkgoPure (Ginkgo Biloba Extract): 80 mg, Gelatin, Maltodextrin & Magnesium stearate',N'Giúp cải thiện tình trạng thiếu máu não, mất ngủ, đau nửa đầu; giảm nguy cơ tai biến mạch máu não.',N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.'),
	('SP0044',N'Cao Đương Quy (200mg), Cao Toan Táo Nhân (200mg), Cao Viễn Chí (120mg), Cao Hồng Hoa (100mg), Cao Xuyên Khung (100mg)',N'Hỗ trợ giảm các triệu chứng hoa mắt, chóng mặt, suy giảm trí nhớ, mất ngủ do thiểu năng tuần hoàn não.',N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.'),
	('SP0045',N'Nước cốt gà 97%, đường phèn, chiết xuất mạch nha, chất tạo màu tự nhiên INS150a, hương giống tự nhiên',N'Bồi bổ cơ thể, tăng cường sức khỏe và sức đề kháng. Giảm căng thẳng mệt mỏi. Cải thiện sự tập trung',N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.'),
	('SP0046',N'Vitamin C, Niacin (Vitamin B3), Vitamin B6, Magnesium, Lecithin, L-phenylalanin, L-Tyrosine, L-glutamine, Choline, Inositol, Ginkgo Biloba.',N'Bổ sung một số amino acid, vitamin, khoáng chất và bạch quả giúp não bộ và hệ thần kinh khỏe mạnh.',N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.'),
	('SP0047',N'Iron (Sat Citrate): 14mg (100% NRV ), Vitamin C: 80mg (100% NRV)',N'Nâng cao sức đề kháng. Tăng tái tạo hồng cầu',N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.'),
	('SP0048',N'Keo ong 50mg, Vitamin C 12.12mg, Dịch chiết Mật ong 10mg, Bromelain 2.5GDU, Tinh dầu Eucalyptus globulus/Khuynh diệp 1mg.',N'Hỗ trợ làm giảm viêm đường hô hấp trên. Giúp làm giảm ho.',N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.'),
	('SP0049',N'Melatonin, Tinh Dầu Cam Đắng (Citrus Aurantium Ssp Amara)',N'Giúp hỗ trợ cải thiện giấc ngủ. Hỗ trợ thúc đẩy quá trình đi vào giấc ngủ nhanh hơn. Giúp ngủ ngon.',N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.'),
	('SP0050',N'Vitamin C: 400mg, Rutin: 50mg, Hesperidin: 50mg, Acerola: 12,5mg.',N'Cung cấp Vitamin C cho cơ thể, tăng cường sức đề kháng. Giảm nguy cơ cảm lạnh, cảm cúm.',N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.'),
	('SP0051',N'Lysine, Taurine, bột làm thạch, chất tạo ngọt, chất điều chỉnh độ acid, chất tạo ngọt tổng hợp, chất bảo quản, hương vải tổng hợp.',N'Kích thích trẻ ăn ngon miệng. Hấp thu tối đa dinh dưỡng. Phát triển chiều cao, xương khớp và tăng cường chuyển hóa hấp thụ. Giúp trẻ ăn ngon hơn, hấp thu tốt hơn nhờ có chứa Lysine, Taurine.',N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.'),
	('SP0052',N'Omega 3 , Vitamin C (Acid Ascorbic) , Vitamin B3 (Niacinamide) , Vitamin E (All-rac-α-tocopheryl acetat) , Kẽm (Zinc) , Mangan , Molypden , Vitamin B1 (Thiamine HCL) , Vitamin B2 (Riboflavin) , Vitamin B5 (Axit pantothenic) , Vitamin B6 (Pyridoxine) , Acid Folic (Vitamin B9) , Vitamin B12 (Cyanocobalamine)',N'Bổ sung Omega 3, DHA, EPA, vitamin và khoáng chất cho cơ thể giúp con thông minh, phát triển toàn diện thể chất và trí tuệ.',N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.'),
	('SP0053',N'Vitamin C (Acid Ascorbic) , Lysine , Sắt (Iron) , Vitamin B3 (Niacinamide) , Kẽm (Zinc) , Vitamin B5 (Axit pantothenic) , Vitamin B1 (Thiamine HCL) , Vitamin B2 (Riboflavin) , Vitamin B6 (Pyridoxine) , Acid Folic (Vitamin B9) , Vitamin D3 (Cholecalciferol) , Vitamin B12 (Cyanocobalamine)',N'Bổ sung các vitamin và sắt giúp hỗ trợ tăng cường sức khỏe.',N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.'),
	('SP0054',N'Fish oil (tương đương EPA 45mg, DHA 30mg) 250mg, Vitamin C 45mg, Ginkgo biloba extrat (Cao bạch quả) 40mg, Vaccinium myrtillus extract (Cao việt quất) 35mg, Kẽm gluconat 25mg, Vitamin E 10IU, Lutein 8mg, Zeaxanthin 2mg, Vitamin B2 1mg, Vitamin A 500IU, Selen 10mcg. Phụ liệu: Gelatin, dầu đậu nành vừa đủ 1 viên.',N'Hỗ trợ tăng cường thị lực cho mắt, hỗ trợ giảm các chứng rối loạn thị giác như cận thị, viễn thị, nhức mỏi mắt, mờ mắt, khô mắt.',N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.'),
	('SP0055',N'Calcium , Vitamin D3 (Cholecalciferol) , Vitamin K2 (Menaquinone)',N'Hỗ trợ phát triển chiều cao, hỗ trợ giảm nguy cơ còi xương ở trẻ em, loãng xương ở người lớn.',N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.'),
	('SP0056',N'Bacillus clausii: 2 x10⁹ CFU, Bacillus subtilis: 10⁹ CFU',N'Hỗ trợ cải thiện biểu hiện và giảm nguy cơ rối loạn tiêu hóa do loạn khuẩn đường ruột Hỗ trợ tăng cường tiêu hóa.',N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.'),
	('SP0057',N'Glutathione 250 mg, Chiết xuất dương xỉ 240 mg, Vitamin C 114 mg, Collagen 100 mg, Thành phần khác: Cám gạo, Gelatin, Magnesium Stearate thực vật vừa đủ 1 viên',N'Tăng độ đàn hồi da, trẻ hoá da, Collagen. Bổ sung dưỡng chất giúp làm đẹp da. Chống nắng và bảo vệ da toàn diện. Bảo vệ da khỏi tác hại của tia UV. Dưỡng da trắng sáng, mịn màng. Làm mờ các vết thâm nám, tàn nhang. Tăng cường khả năng miễn dịch cho da. Chống lão hóa da, trẻ hóa da.',N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.'),
	('SP0058',N'Chiết xuất Bạch quả: 100mg, Chiết xuất Việt quất: 100mg, Chiết xuất lá Yerba Mate: 100mg, Lecithin đậu nành: 50mg',N'Hỗ trợ tăng cường tuần hoàn não. Giúp cải thiện các triệu chứng thiểu năng tuần hoàn não.',N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.'),
	('SP0059',N'Lutein , Zeaxanthin , Vitamin A , Calcium , Magnesium , Kẽm (Zinc) , Vitamin C (Acid Ascorbic) , Vitamin E (All-rac-α-tocopheryl acetat) , Vitamin PP (Nicotinamide) , Vitamin B5 (Axit pantothenic) , Vitamin D3 (Cholecalciferol) , Vitamin B1 (Thiamine HCL) , Vitamin B2 (Riboflavin) , Vitamin B3 (Niacinamide) , Vitamin B6 (Pyridoxine) , Acid Folic (Vitamin B9) , Vitamin B12 (Cyanocobalamine) , Kali Iodid',N'Bổ sung các vitamin và khoáng chất cho cơ thể',N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.'),
	('SP0060',N'Acid Folic (Vitamin B9) , Vitamin B6 (Pyridoxine) , Vitamin B1 (Thiamine HCL) , Vitamin B2 (Riboflavin) , Vitamin B3 (Niacinamide) , Vitamin B5 (Axit pantothenic) , Vitamin B12 (Cyanocobalamine) , Calcium , Sắt (Iron) , Kali , Beta-Caroten , Vitamin C (Acid Ascorbic) , Magnesium , Kẽm (Zinc) , DHA , EPA',N'Viên uống Prokavip DHA bổ sung DHA, EPA, các vitamin và khoáng chất cho phụ nữ trước khi mang thai, đang mang thai và cho bà mẹ đang cho con bú, người thiếu vitamin, mỏi mệt.',N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.'),
	('SP0061',N'DHA, Vitamin A, Vitamin E (All-rac-α-tocopheryl acetat) , Vitamin D3 (Cholecalciferol)',N'Special kid Omega có thành phần gồm DHA, vitamin A, D3, E giúp tối ưu hóa sự phát triển của trẻ, cung cấp hàm lượng dưỡng chất cần thiết cho nhu cầu dinh dưỡng của bé yêu, mang đến cho bé khởi đầu hoàn hảo nhất về cả trí tuệ và thể chất.',N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.'),
	('SP0062',N'Hoa anh đào , Lựu (Pomegranate) , Nhau thai cừu , Collagen',N'Hỗ trợ sáng da. Hỗ trợ hạn chế lão hóa da. Hỗ trợ chống oxy hóa và làm đẹp da.',N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.'),
	('SP0063',N'Acid Folic (Vitamin B9) , DHA , Vitamin B1 (Thiamine HCL) , Vitamin B2 (Riboflavin) , Vitamin B3 (Niacinamide) , Vitamin B6 (Pyridoxine) , Vitamin B12 (Cyanocobalamine) , Vitamin D3 (Cholecalciferol) , Vitamin E (All-rac-α-tocopheryl acetat) , EPA',N'Bổ sung DHA và các vitamin thiết yếu hỗ trợ sức khỏe mẹ và bé. Hỗ trợ sự phát triển não bộ và thị lực thai nhi trong bụng mẹ ',N'Sản phẩm này không phải là thuốc, không có tác dụng thay thế thuốc chữa bệnh.')
GO

Insert into TaiKhoan 
values
	('admin', N'123', 0),
	('lephat', N'123', 0),
	('kimtuyen', N'123', 0),
	('thaiduong', N'123', 0),
	('vanan', N'123', 1),
	('vancuong', N'123', 1),
	('minhcuong', N'123', 1),
	('phuongduy', N'123', 1)

GO

Insert into NhanVien
values('NV001', N'Lê Minh Phát', '0194526681', N'lephat@gmail.com', 'lephat', 1),
	('NV002', N'Nguyễn Thị Kim Tuyền', '0194526682', N'kimtuyen@gmail.com', 'kimtuyen', 1),
	('NV003', N'Lê Thành Thái Dương', '0194526683', N'thaiduong@gmail.com', 'thaiduong', 1)

GO

Insert into KhachHang 
values
	('KH001', N'Nguyễn Văn An', N'TP HCM', '0938471623', 'vanan@gmail.com', 'vanan', 1),
	('KH002', N'Lưu Văn Cường', N'TPHCM', '0985512236', 'luuluong@gmail.com', 'vancuong', 1),
	('KH003', N'Hoàng Minh Cường', N'Quảng Bình', '0985512223', 'hoangminhcuong@gmail.com', 'minhcuong', 1),
	('KH004', N'Nguyễn Phương Duy', N'Đà Nẵng', '0985554523', 'phuongduy@gmail.com', 'phuongduy', 1)

GO

Insert into NhaCungCap 
values ('NCC001', N'Mediphar USA', N'Đà Nẵng', '0984384378'),
	('NCC002', N'Traphaco', N'Đà Nẵng', '0123892833'),
	('NCC003', N'Dược phẩm Hà Tây', N'Đà Nẵng', '0123892382')

GO

Insert into HoaDon 
values ('HD001', 'NV002', 'KH001', '2023-01-10' , 502000, '2023-01-10', 1, 0, N'140 Lê Trọng Tân, Tân Phú, TP HCM')
Insert into HoaDon 
values('HD002', 'NV002', 'KH002', '2023-01-11', 3800000, '2023-01-11', 1, 0, N'140 Lê Trọng Tân, Tân Phú, TP HCM')
Insert into HoaDon 
values('HD003', 'NV002', 'KH003', '2023-05-12', 1380000, '2023-05-12', 1, 0, N'140 Lê Trọng Tân, Tân Phú, TP HCM')
Insert into HoaDon 
values('HD004', 'NV003', 'KH002', '2023-08-13', 1810000, '2023-08-13', 1, 0, N'140 Lê Trọng Tân, Tân Phú, TP HCM')
Insert into HoaDon 
values('HD005', 'NV003', 'KH002', '2023-11-14', 670000, '2023-11-14', 1, 0, N'140 Lê Trọng Tân, Tân Phú, TP HCM')
Insert into HoaDon 
values('HD006', 'NV003', 'KH002', '2023-11-15', 670000, '2023-11-15', 1, 0, N'140 Lê Trọng Tân, Tân Phú, TP HCM')
Insert into HoaDon 
values('HD007', 'NV003', 'KH002', '2023-10-15', 670000, '2023-10-15', 1, 0, N'140 Lê Trọng Tân, Tân Phú, TP HCM')
Insert into HoaDon 
values('HD008', 'NV003', 'KH002', '2023-10-17', 670000, '2023-10-17', 1, 0, N'140 Lê Trọng Tân, Tân Phú, TP HCM')
Insert into HoaDon 
values('HD009', 'NV003', 'KH002', '2023-12-11', 670000, '2023-12-11', 1, 0, N'140 Lê Trọng Tân, Tân Phú, TP HCM')
Insert into HoaDon 
values('HD0010', 'NV003', 'KH002', '2023-12-05', 670000, '2023-12-05', 1, 0, N'140 Lê Trọng Tân, Tân Phú, TP HCM')
Insert into HoaDon 
values('HD0011', 'NV003', 'KH002', '2023-10-11', 670000, '2023-10-11', 1, 0, N'140 Lê Trọng Tân, Tân Phú, TP HCM')
Insert into HoaDon 
values('HD0012', 'NV003', 'KH002', '2023-10-12', 670000, '2023-10-12', 1, 0, N'140 Lê Trọng Tân, Tân Phú, TP HCM')
Insert into HoaDon 
values('HD0013', 'NV003', 'KH002', '2023-09-12', 670000, '2023-09-12', 1, 0, N'140 Lê Trọng Tân, Tân Phú, TP HCM')
Insert into HoaDon 
values('HD0014', 'NV003', 'KH002', '2023-10-11', 670000, '2023-10-11', 1, 0, N'140 Lê Trọng Tân, Tân Phú, TP HCM')
Insert into HoaDon 
values('HD0015', 'NV003', 'KH002', '2023-03-12', 670000, '2023-03-12', 1, 0, N'140 Lê Trọng Tân, Tân Phú, TP HCM')
Insert into HoaDon 
values('HD0016', 'NV003', 'KH002', '2023-12-12', 670000, '2023-12-12', 1, 0, N'140 Lê Trọng Tân, Tân Phú, TP HCM')
Insert into HoaDon 
values('HD0017', 'NV003', 'KH002', '2023-08-12', 670000, '2023-08-12', 1, 0, N'140 Lê Trọng Tân, Tân Phú, TP HCM')
Insert into HoaDon 
values('HD0018', 'NV003', 'KH002', '2023-09-12', 670000, '2023-09-12', 1, 0, N'140 Lê Trọng Tân, Tân Phú, TP HCM')
Insert into HoaDon 
values('HD0019', 'NV003', 'KH002', '2023-10-02', 670000, '2023-10-02', 1, 0, N'140 Lê Trọng Tân, Tân Phú, TP HCM')
Insert into HoaDon 
values('HD0020', 'NV003', 'KH002', '2023-10-07', 670000, '2023-10-07', 1, 0, N'140 Lê Trọng Tân, Tân Phú, TP HCM')
Insert into HoaDon 
values('HD0021', 'NV003', 'KH002', '2023-10-18', 670000, '2023-10-18', 1, 0, N'140 Lê Trọng Tân, Tân Phú, TP HCM')
Insert into HoaDon 
values('HD0022', 'NV003', 'KH002', '2023-10-18', 670000, '2023-10-18', 1, 0, N'140 Lê Trọng Tân, Tân Phú, TP HCM')
Insert into HoaDon 
values('HD0023', 'NV003', 'KH002', '2023-08-12', 670000, '2023-08-12', 1, 0, N'140 Lê Trọng Tân, Tân Phú, TP HCM')
Insert into HoaDon 
values('HD0024', 'NV003', 'KH002', '2023-10-14', 670000, '2023-10-14', 1, 0, N'140 Lê Trọng Tân, Tân Phú, TP HCM')
Insert into HoaDon 
values('HD0025', 'NV003', 'KH002', '2023-02-12', 670000, '2023-02-12', 1, 0, N'140 Lê Trọng Tân, Tân Phú, TP HCM')
Insert into HoaDon 
values('HD0026', 'NV003', 'KH002', '2023-02-12', 670000, '2023-02-12', 1, 0, N'140 Lê Trọng Tân, Tân Phú, TP HCM')
Insert into HoaDon 
values('HD0027', 'NV003', 'KH002', '2023-10-12', 670000, '2023-10-12', 1, 0, N'140 Lê Trọng Tân, Tân Phú, TP HCM')
Insert into HoaDon 
values('HD0028', 'NV003', 'KH002', '2023-09-11', 670000, '2023-09-11', 1, 0, N'140 Lê Trọng Tân, Tân Phú, TP HCM')
Insert into HoaDon 
values('HD0029', 'NV003', 'KH002', '2023-10-22', 670000, '2023-10-22', 1, 0, N'140 Lê Trọng Tân, Tân Phú, TP HCM')
Insert into HoaDon 
values('HD0030', 'NV003', 'KH002', '2023-10-22', 670000, '2023-10-22', 1, 0, N'140 Lê Trọng Tân, Tân Phú, TP HCM')

GO

Insert into ChiTietHD 
values ('HD001', 'SP001', 2, 116000, 232000)
Insert into ChiTietHD 
values('HD001', 'SP003', 1, 270000, 270000)

Insert into ChiTietHD 
values('HD002', 'SP005', 5, 760000, 3800000)

Insert into ChiTietHD 
values('HD003', 'SP002', 1, 620000, 620000)
Insert into ChiTietHD 
values('HD003', 'SP005', 1, 760000, 760000)

Insert into ChiTietHD 
values('HD004', 'SP005', 1, 760000, 760000)
Insert into ChiTietHD 
values('HD004', 'SP002', 1, 620000, 620000)
Insert into ChiTietHD 
values('HD004', 'SP0016', 1, 430000, 430000)

Insert into ChiTietHD 
values('HD005', 'SP002', 1, 620000, 620000)
Insert into ChiTietHD 
values('HD005', 'SP0017', 1, 50000, 50000)
Insert into ChiTietHD 
values('HD006', 'SP002', 1, 620000, 620000)
Insert into ChiTietHD 
values('HD006', 'SP0017', 1, 50000, 50000)
Insert into ChiTietHD 
values('HD007', 'SP002', 1, 620000, 620000)
Insert into ChiTietHD 
values('HD007', 'SP0017', 1, 50000, 50000)
Insert into ChiTietHD 
values('HD008', 'SP002', 1, 620000, 620000)
Insert into ChiTietHD 
values('HD008', 'SP0017', 1, 50000, 50000)
Insert into ChiTietHD 
values('HD009', 'SP002', 1, 620000, 620000)
Insert into ChiTietHD 
values('HD009', 'SP0017', 1, 50000, 50000)
Insert into ChiTietHD 
values('HD0010', 'SP002', 1, 620000, 620000)
Insert into ChiTietHD 
values('HD0010', 'SP0017', 1, 50000, 50000)
Insert into ChiTietHD 
values('HD0011', 'SP002', 1, 620000, 620000)
Insert into ChiTietHD 
values('HD0011', 'SP0017', 1, 50000, 50000)
Insert into ChiTietHD 
values('HD0012', 'SP002', 1, 620000, 620000)
Insert into ChiTietHD 
values('HD0012', 'SP0017', 1, 50000, 50000)
Insert into ChiTietHD 
values('HD0013', 'SP002', 1, 620000, 620000)
Insert into ChiTietHD 
values('HD0013', 'SP0017', 1, 50000, 50000)
Insert into ChiTietHD 
values('HD0014', 'SP002', 1, 620000, 620000)
Insert into ChiTietHD 
values('HD0014', 'SP0017', 1, 50000, 50000)
Insert into ChiTietHD 
values('HD0015', 'SP002', 1, 620000, 620000)
Insert into ChiTietHD 
values('HD0015', 'SP0017', 1, 50000, 50000)
Insert into ChiTietHD 
values('HD0016', 'SP002', 1, 620000, 620000)
Insert into ChiTietHD 
values('HD0016', 'SP0017', 1, 50000, 50000)
Insert into ChiTietHD 
values('HD0017', 'SP002', 1, 620000, 620000)
Insert into ChiTietHD 
values('HD0017', 'SP0017', 1, 50000, 50000)
Insert into ChiTietHD 
values('HD0018', 'SP002', 1, 620000, 620000)
Insert into ChiTietHD 
values('HD0018', 'SP0017', 1, 50000, 50000)
Insert into ChiTietHD 
values('HD0019', 'SP002', 1, 620000, 620000)
Insert into ChiTietHD 
values('HD0019', 'SP0017', 1, 50000, 50000)
Insert into ChiTietHD 
values('HD0020', 'SP002', 1, 620000, 620000)
Insert into ChiTietHD 
values('HD0020', 'SP0017', 1, 50000, 50000)
Insert into ChiTietHD 
values('HD0021', 'SP002', 1, 620000, 620000)
Insert into ChiTietHD 
values('HD0021', 'SP0017', 1, 50000, 50000)
Insert into ChiTietHD 
values('HD0022', 'SP002', 1, 620000, 620000)
Insert into ChiTietHD 
values('HD0022', 'SP0017', 1, 50000, 50000)
Insert into ChiTietHD 
values('HD0023', 'SP002', 1, 620000, 620000)
Insert into ChiTietHD 
values('HD0023', 'SP0017', 1, 50000, 50000)
Insert into ChiTietHD 
values('HD0024', 'SP002', 1, 620000, 620000)
Insert into ChiTietHD 
values('HD0024', 'SP0017', 1, 50000, 50000)
Insert into ChiTietHD 
values('HD0025', 'SP002', 1, 620000, 620000)
Insert into ChiTietHD 
values('HD0025', 'SP0017', 1, 50000, 50000)
Insert into ChiTietHD 
values('HD0026', 'SP002', 1, 620000, 620000)
Insert into ChiTietHD 
values('HD0026', 'SP0017', 1, 50000, 50000)
Insert into ChiTietHD 
values('HD0027', 'SP002', 1, 620000, 620000)
Insert into ChiTietHD 
values('HD0027', 'SP0017', 1, 50000, 50000)
Insert into ChiTietHD 
values('HD0028', 'SP002', 1, 620000, 620000)
Insert into ChiTietHD 
values('HD0028', 'SP0017', 1, 50000, 50000)
Insert into ChiTietHD 
values('HD0029', 'SP002', 1, 620000, 620000)
Insert into ChiTietHD 
values('HD0029', 'SP0017', 1, 50000, 50000)
Insert into ChiTietHD 
values('HD0030', 'SP002', 1, 620000, 620000)
Insert into ChiTietHD 
values('HD0030', 'SP0017', 1, 50000, 50000)

GO

Insert into PhieuNhap
values('PN001', '2022-07-20', 38000000, 'NCC002', 'NV001')
Insert into PhieuNhap
values('PN002', '2022-10-23', 6950000, 'NCC001', 'NV001')
Insert into PhieuNhap
values('PN003', '2022-11-23', 10000000, 'NCC002', 'NV001')
Insert into PhieuNhap
values('PN004', '2022-12-05', 17395000, 'NCC003', 'NV001')

GO

Insert into ChiTietPN 
values ('PN001', 'SP003', 100, 60000, 6000000)
Insert into ChiTietPN 
values ('PN001', 'SP0010', 100, 80000, 8000000)
Insert into ChiTietPN 
values ('PN001', 'SP0011', 100, 20000, 2000000)
Insert into ChiTietPN 
values ('PN001', 'SP0013', 100, 80000, 8000000)
Insert into ChiTietPN 
values('PN001', 'SP001', 100, 80000, 8000000)
Insert into ChiTietPN 
values('PN001', 'SP004', 100, 60000, 6000000)

Insert into ChiTietPN 
values('PN002', 'SP002', 50, 40000, 2000000)
Insert into ChiTietPN 
values('PN002', 'SP0015', 10, 15000, 150000)
Insert into ChiTietPN 
values('PN002', 'SP0018', 5, 60000, 300000)
Insert into ChiTietPN 
values('PN002', 'SP001', 50, 70000, 3500000)

Insert into ChiTietPN 
values('PN003', 'SP007', 100, 90000, 9000000)
Insert into ChiTietPN 
values('PN003', 'SP005', 50, 20000, 1000000)

Insert into ChiTietPN 
values('PN004', 'SP006', 50, 60000, 3000000)
Insert into ChiTietPN 
values('PN004', 'SP008', 50, 6000, 300000)
Insert into ChiTietPN 
values('PN004', 'SP009', 50, 60000, 3000000)
Insert into ChiTietPN 
values('PN004', 'SP005', 100, 20000, 2000000)
Insert into ChiTietPN 
values('PN004', 'SP0014', 100, 80000, 8000000)
Insert into ChiTietPN 
values('PN004', 'SP0012', 50, 20000, 1000000)
Insert into ChiTietPN 
values('PN004', 'SP0016', 1, 80000, 80000)
Insert into ChiTietPN 
values('PN004', 'SP0017', 1, 15000, 15000)

GO



