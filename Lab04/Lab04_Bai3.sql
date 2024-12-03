--31. Tính t?ng s? s?n ph?m do “Trung Quoc” s?n xu?t.
select count(MASP) as SoSanPham
from SANPHAM 
where NUOCSX = 'Trung Quoc'
--32. Tính t?ng s? s?n ph?m c?a t?ng n??c s?n xu?t.
select NUOCSX, count(MASP) as TongSoSanPham
from SANPHAM
group by NUOCSX
--33. V?i t?ng n??c s?n xu?t, tìm giá bán cao nh?t, th?p nh?t, trung bình c?a các s?n ph?m.
select NUOCSX, max(GIA) as GiaCaoNhat, min(GIA) as GiaThapNhat, avg(GIA) as GiaTrungBinh
from SANPHAM 
group by NUOCSX
--34. Tính doanh thu bán hàng m?i ngày.
select NGHD, sum(TRIGIA) as DoanhThu
from HOADON
group by NGHD
--35. Tính t?ng s? l??ng c?a t?ng s?n ph?m bán ra trong tháng 10/2006.
select MASP, sum(SL) as TongSoLuong
from CTHD 
join HOADON HD on HD.SOHD=CTHD.SOHD
where year(HD.NGHD)=2006 and month(HD.NGHD)=10
group by MASP
--36. Tính doanh thu bán hàng c?a t?ng tháng trong n?m 2006.
select distinct month(NGHD) as Thang, sum(TRIGIA) as DoangThu
from HOADON
where year(NGHD)=2006
group by month(NGHD)
--37. Tìm hóa ??n có mua ít nh?t 4 s?n ph?m khác nhau.
select SOHD
from CTHD
group by SOHD
having count(MASP)>=4
--38. Tìm hóa ??n có mua 3 s?n ph?m do “Viet Nam” s?n xu?t (3 s?n ph?m khác nhau).
select SOHD
from CTHD
join SANPHAM SP on CTHD.MASP=SP.MASP
where SP.NUOCSX='Viet Nam' 
group by SOHD
having count(CTHD.MASP)=3
--39. Tìm khách hàng (MAKH, HOTEN) có s? l?n mua hàng nhi?u nh?t.
select MAKH, HOTEN 
from KHACHHANG
where MAKH in (
				select MAKH
				from HOADON
				group by MAKH
				having count(MAKH)>= all(
										select count(MAKH)
										from HOADON
										group by MAKH
										)
				)
--40. Tháng m?y trong n?m 2006, doanh s? bán hàng cao nh?t ?
select MONTH(NGHD) as Thang, sum(TRIGIA) as DoanhSo
from HOADON
where year(NGHD)=2006
group by MONTH(NGHD)
having sum(TRIGIA)>=all(
						select sum(TRIGIA)
						from HOADON
						group by MONTH(NGHD)
						)

--41. Tìm s?n ph?m (MASP, TENSP) có t?ng s? l??ng bán ra th?p nh?t trong n?m 2006.
select MASP, TENSP 
from SANPHAM 
where MASP in (
				select MASP
				from CTHD 
				join HOADON HD on CTHD.SOHD=HD.SOHD
				where year(HD.NGHD)=2006
				group by MASP
				having sum(SL)<=all(
									select sum(SL)
									from CTHD
									join HOADON HD on CTHD.SOHD=HD.SOHD
									where year(HD.NGHD)=2006
									group by MASP
									)
				)

--42. *M?i n??c s?n xu?t, tìm s?n ph?m (MASP,TENSP) có giá bán cao nh?t.
select NUOCSX, MASP, TENSP
from SANPHAM SP1
where GIA=(
			select MAX(GIA)
			from SANPHAM SP2
			where SP1.NUOCSX = SP2.NUOCSX
			)
group by NUOCSX, MASP, TENSP
--43. Tìm n??c s?n xu?t s?n xu?t ít nh?t 3 s?n ph?m có giá bán khác nhau.
SELECT NUOCSX AS Country
FROM SANPHAM
GROUP BY NUOCSX
HAVING COUNT(DISTINCT GIA) >= 3;

--44. *Trong 10 khách hàng có doanh s? cao nh?t, tìm khách hàng có s? l?n mua hàng nhi?u nh?t.
SELECT MAKH, HOTEN
FROM KHACHHANG
WHERE MAKH IN (SELECT TOP 10 MAKH FROM HOADON GROUP BY MAKH ORDER BY SUM(TRIGIA) DESC)
GROUP BY MAKH, HOTEN
HAVING COUNT(MAKH) >= ALL (
    SELECT COUNT(MAKH)
    FROM KHACHHANG
    WHERE MAKH IN (SELECT TOP 10 MAKH FROM HOADON GROUP BY MAKH ORDER BY SUM(TRIGIA) DESC)
    GROUP BY MAKH
);