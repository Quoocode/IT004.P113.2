-- 25 câu truy vấn cơ bản mới cho người mới bắt đầu, không sử dụng JOIN (51-75)

-- 51. Hiển thị tất cả thông tin của bảng ChuyenGia.
select * from ChuyenGia
-- 52. Liệt kê họ tên và email của tất cả chuyên gia.
select HoTen,Email from ChuyenGia
-- 53. Hiển thị tên công ty và số nhân viên của tất cả các công ty.
select TenCongTy,SoNhanVien from CongTy
-- 54. Liệt kê tên các dự án đang trong trạng thái 'Đang thực hiện'.
select TenDuAn from DuAn where TrangThai=N'Đang thực hiện'

-- 55. Hiển thị tên và loại của tất cả các kỹ năng.
select TenKyNang,LoaiKyNang from KyNang
-- 56. Liệt kê họ tên và chuyên ngành của các chuyên gia nam.
select HoTen,ChuyenNganh from ChuyenGia where GioiTinh=N'Nam'

-- 57. Hiển thị tên công ty và lĩnh vực của các công ty có trên 150 nhân viên.
select TenCongTy,LinhVuc from CongTy where SoNhanVien>150
-- 58. Liệt kê tên các dự án bắt đầu trong năm 2023.
select TenDuAn from DuAn where year(NgayBatDau)=2023
-- 59. Hiển thị tên kỹ năng thuộc loại 'Công cụ'.
select TenKyNang from KyNang where LoaiKyNang=N'Công cụ'
-- 60. Liệt kê họ tên và số năm kinh nghiệm của các chuyên gia có trên 5 năm kinh nghiệm.
select HoTen,NamKinhNghiem from ChuyenGia where NamKinhNghiem>5

-- 61. Hiển thị tên công ty và địa chỉ của các công ty trong lĩnh vực 'Phát triển phần mềm'.
select TenCongTy, DiaChi from CongTy where LinhVuc=N'Phát triển phần mềm'
-- 62. Liệt kê tên các dự án có ngày kết thúc trong năm 2023.
select TenDuAn from DuAn where year(NgayKetThuc)=2023

-- 63. Hiển thị tên và cấp độ của các kỹ năng trong bảng ChuyenGia_KyNang.
select KyNang.TenKyNang, ChuyenGia_KyNang.CapDo
from ChuyenGia_KyNang
join KyNang on ChuyenGia_KyNang.MaKyNang=KyNang.MaKyNang
-- 64. Liệt kê mã chuyên gia và vai trò trong các dự án từ bảng ChuyenGia_DuAn.
select MaChuyenGia,VaiTro from ChuyenGia_DuAn
-- 65. Hiển thị họ tên và ngày sinh của các chuyên gia sinh năm 1990 trở về sau.
select HoTen,NgaySinh from ChuyenGia where year(NgaySinh)>=1990
-- 66. Liệt kê tên công ty và số nhân viên, sắp xếp theo số nhân viên giảm dần.
select TenCongTy,SoNhanVien from CongTy
order by SoNhanVien desc
-- 67. Hiển thị tên dự án và ngày bắt đầu, sắp xếp theo ngày bắt đầu tăng dần.
select TenDuAn,NgayBatDau from DuAn
order by day(NgayBatDau) asc
-- 68. Liệt kê tên kỹ năng, chỉ hiển thị mỗi tên một lần (loại bỏ trùng lặp).
select distinct TenKyNang from KyNang
-- 69. Hiển thị họ tên và email của 5 chuyên gia đầu tiên trong danh sách.
select top 5 HoTen,Email from ChuyenGia

-- 70. Liệt kê tên công ty có chứa từ 'Tech' trong tên.
select TenCongTy from CongTy
where TenCongTy like '%Tech%'

-- 71. Hiển thị tên dự án và trạng thái, không bao gồm các dự án đã hoàn thành.
select TenDuAn,TrangThai from DuAn
where TrangThai!=N'Hoàn thành'

-- 72. Liệt kê họ tên và chuyên ngành của các chuyên gia, sắp xếp theo chuyên ngành và họ tên.
select HoTen,ChuyenNganh from ChuyenGia 
order by ChuyenNganh,HoTen

-- 73. Hiển thị tên công ty và lĩnh vực, chỉ bao gồm các công ty có từ 100 đến 200 nhân viên.
select TenCongTy,LinhVuc from CongTy
where SoNhanVien between 100 and 200

-- 74. Liệt kê tên kỹ năng và loại kỹ năng, sắp xếp theo loại kỹ năng giảm dần và tên kỹ năng tăng dần.
select TenKyNang,LoaiKyNang from KyNang
order by LoaiKyNang desc, TenKyNang asc

-- 75. Hiển thị họ tên và số điện thoại của các chuyên gia có email sử dụng tên miền 'email.com'.
select HoTen,SoDienThoai from ChuyenGia
where Email like '%email.com%'
