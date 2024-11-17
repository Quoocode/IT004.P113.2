

-- Liệt kê tất cả các chuyên gia và sắp xếp theo họ tên.
select Hoten
from ChuyenGia
order by Hoten

-- Hiển thị tên và số điện thoại của các chuyên gia có chuyên ngành 'Phát triển phần mềm'.
select Hoten,SoDienThoai
from ChuyenGia
where ChuyenNganh=N'Phát triển phần mềm'

-- Liệt kê tất cả các công ty có trên 100 nhân viên.
select TenCongTy
from CongTy
where SoNhanVien>100

-- Hiển thị tên và ngày bắt đầu của các dự án bắt đầu trong năm 2023.
select TenDuAn, NgayBatDau
from DuAn
where year(NgayBatDau)=2023
-- Liệt kê tất cả các kỹ năng và sắp xếp theo tên kỹ năng.
select TenKyNang 
from KyNang
order by TenKyNang

-- Hiển thị tên và email của các chuyên gia có tuổi dưới 35 (tính đến năm 2024).
select HoTen, Email
from ChuyenGia
where (2024-year(NgaySinh))<35

-- Hiển thị tên và chuyên ngành của các chuyên gia nữ.
select HoTen,ChuyenNganh
from ChuyenGia
where GioiTinh=N'nữ'

-- Liệt kê tên các kỹ năng thuộc loại 'Công nghệ'.
select TenKyNang
from KyNang
where LoaiKyNang=N'Công nghệ'

-- Hiển thị tên và địa chỉ của các công ty trong lĩnh vực 'Phân tích dữ liệu'.
select TenCongTy,DiaChi
from CongTy
where LinhVuc=N'Phân tích dữ liệu'

-- Liệt kê tên các dự án có trạng thái 'Hoàn thành'.

select TenDuAn
from DuAn
where TrangThai=N'Hoàn thành'


-- Hiển thị tên và số năm kinh nghiệm của các chuyên gia, sắp xếp theo số năm kinh nghiệm giảm dần.
select Hoten,NamKinhNghiem
from ChuyenGia
order by NamKinhNghiem desc;

-- Liệt kê tên các công ty và số lượng nhân viên, chỉ hiển thị các công ty có từ 100 đến 200 nhân viên.
select TenCongTy,SoNhanVien
from CongTy
where SoNhanVien between 100 and 200

-- Hiển thị tên dự án và ngày kết thúc của các dự án kết thúc trong năm 2023.
select TenDuAN
from DuAn
where year(NgayKetThuc)=2023;

-- Liệt kê tên và email của các chuyên gia có tên bắt đầu bằng chữ 'N'.
select HoTen,Email
from ChuyenGia
where HoTen like N'N%'

-- Hiển thị tên kỹ năng và loại kỹ năng, không bao gồm các kỹ năng thuộc loại 'Ngôn ngữ lập trình'.
select TenKyNang,LoaiKyNang
from KyNang
where LoaiKyNang <> N'Ngôn ngữ lập trình'


-- Hiển thị tên công ty và lĩnh vực hoạt động, sắp xếp theo lĩnh vực.
select TenCongTy,LinhVuc
from CongTy
order by LinhVuc



-- Hiển thị tên và chuyên ngành của các chuyên gia nam có trên 5 năm kinh nghiệm.
select Hoten,ChuyenNganh
from ChuyenGia
where GioiTinh=N'nam' and NamKinhNghiem>5

-- Liệt kê tất cả các chuyên gia trong cơ sở dữ liệu.
select *
from ChuyenGia
-- Hiển thị tên và email của tất cả các chuyên gia nữ.
select Hoten,Email
from ChuyenGia
where GioiTinh=N'nữ'

--  Liệt kê tất cả các công ty và số nhân viên của họ, sắp xếp theo số nhân viên giảm dần.
select TenCongTy,SoNhanVien
from CongTy
order by SoNhanVien desc

-- Hiển thị tất cả các dự án đang trong trạng thái "Đang thực hiện".
select TenDuAn
from DuAn
where TrangThai=N'Đang thực hiện'

-- Liệt kê tất cả các kỹ năng thuộc loại "Ngôn ngữ lập trình".
select TenKyNang
from KyNang
where  LoaiKyNang=N'Ngôn ngữ lập trình'

-- Hiển thị tên và chuyên ngành của các chuyên gia có trên 8 năm kinh nghiệm.
SELECT HoTen, ChuyenNganh 
FROM ChuyenGia 
WHERE NamKinhNghiem > 8;

-- Liệt kê tất cả các dự án của công ty có MaCongTy là 1.
SELECT TenDuAn 
FROM DuAn 
WHERE MaCongTy = 1;


-- Đếm số lượng chuyên gia trong mỗi chuyên ngành.
select ChuyenNganh,COUNT(*) as SoLuongChuyenGia
from ChuyenGia
group by ChuyenNganh

-- Tìm chuyên gia có số năm kinh nghiệm cao nhất.
select top 1 *
from ChuyenGia
order by NamKinhNghiem desc

-- Liệt kê tổng số nhân viên cho mỗi công ty mà có số nhân viên lớn hơn 100. Sắp xếp kết quả theo số nhân viên tăng dần.
select TenCongTy,SoNhanVien
from CongTy
where SoNhanVien>100
order by SoNhanVien asc
-- Xác định số lượng dự án mà mỗi công ty tham gia có trạng thái 'Đang thực hiện'. Chỉ bao gồm các công ty có hơn một dự án đang thực hiện. Sắp xếp kết quả theo số lượng dự án giảm dần.
select CongTy.MaCongTy,CongTy.MaCongTy,count(DuAn.MaDuAn) as SoLuongDuAn
from CongTy
join DuAn on CongTy.MaCongTy=DuAn.MaCongTy
where TrangThai=N'Đang thực hiện'
group by CongTy.MaCongTy,CongTy.TenCongTy
having count(DuAn.MaDuAn)>1
order by SoLuongDuAn desc

-- Tìm kiếm các kỹ năng mà chuyên gia có cấp độ từ 4 trở lên và tính tổng số chuyên gia cho mỗi kỹ năng đó. Chỉ bao gồm những kỹ năng có tổng số chuyên gia lớn hơn 2. Sắp xếp kết quả theo tên kỹ năng tăng dần.
select KyNang.TenKyNang,count(ChuyenGia_KyNang.MaChuyenGia) as TongSoChuyenGia
from KyNang
join ChuyenGia_KyNang on KyNang.MaKyNang=ChuyenGia_KyNang.MaKyNang
where ChuyenGia_KyNang.CapDo>=4
group by KyNang.TenKyNang
having count(ChuyenGia_KyNang.MaChuyenGia)>2
order by KyNang.TenKyNang asc
-- Liệt kê tên các công ty có lĩnh vực 'Điện toán đám mây' và tính tổng số nhân viên của họ. Sắp xếp kết quả theo tổng số nhân viên tăng dần.
select TenCongTy,SoNhanVien
from CongTy
where LinhVuc=N'Điện toán đám mây'
order by SoNhanVien asc
-- Liệt kê tên các công ty có số nhân viên từ 50 đến 150 và tính trung bình số nhân viên của họ. Sắp xếp kết quả theo tên công ty tăng dần.
select TenCongTy,AVG(SoNhanVien) as TrungBinhSoNhanVien
from CongTy
where SoNhanVien between 50 and 150
group by TenCongTy
order by TenCongTy asc

-- Xác định số lượng kỹ năng cho mỗi chuyên gia có cấp độ tối đa là 5 và chỉ bao gồm những chuyên gia có ít nhất một kỹ năng đạt cấp độ tối đa này. Sắp xếp kết quả theo tên chuyên gia tăng dần.
select ChuyenGia.HoTen,count(distinct ChuyenGia_KyNang.MaKyNang) as SoLuongKyNang
from ChuyenGia
join ChuyenGia_KyNang on ChuyenGia.MaChuyenGia=ChuyenGia_KyNang.MaChuyenGia
where  ChuyenGia_KyNang.CapDo=5
group by ChuyenGia.HoTen
having count(distinct ChuyenGia_KyNang.MaKyNang)>0
order by ChuyenGia.HoTen asc

-- Liệt kê tên các kỹ năng mà chuyên gia có cấp độ từ 4 trở lên và tính tổng số chuyên gia cho mỗi kỹ năng đó. Chỉ bao gồm những kỹ năng có tổng số chuyên gia lớn hơn 2. Sắp xếp kết quả theo tên kỹ năng tăng dần.
select KyNang.TenKyNang,count(distinct ChuyenGia_KyNang.MaChuyenGia) as TongSoChuyenGia
from KyNang
join ChuyenGia_KyNang on KyNang.MaKyNang=ChuyenGia_KyNang.MaKyNang
where ChuyenGia_KyNang.CapDo>=4
group by KyNang.TenKyNang
having count(distinct ChuyenGia_KyNang.MaChuyenGia)>2
order by KyNang.TenKyNang

-- Tìm kiếm tên của các chuyên gia trong lĩnh vực 'Phát triển phần mềm' và tính trung bình cấp độ kỹ năng của họ. Chỉ bao gồm những chuyên gia có cấp độ trung bình lớn hơn 3. Sắp xếp kết quả theo cấp độ trung bình giảm dần.
SELECT cg.HoTen, AVG(CAST(ck.CapDo AS FLOAT)) AS TrungBinhCapDo
FROM ChuyenGia cg
JOIN ChuyenGia_KyNang ck ON cg.MaChuyenGia = ck.MaChuyenGia
WHERE cg.ChuyenNganh = N'Phát triển phần mềm'
GROUP BY cg.HoTen
HAVING AVG(CAST(ck.CapDo AS FLOAT)) > 3
ORDER BY TrungBinhCapDo DESC;

