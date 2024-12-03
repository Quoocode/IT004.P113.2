--31. T�nh t?ng s? s?n ph?m do �Trung Quoc� s?n xu?t.
select count(MASP) as SoSanPham
from SANPHAM 
where NUOCSX = 'Trung Quoc'
--32. T�nh t?ng s? s?n ph?m c?a t?ng n??c s?n xu?t.
select NUOCSX, count(MASP) as TongSoSanPham
from SANPHAM
group by NUOCSX
--33. V?i t?ng n??c s?n xu?t, t�m gi� b�n cao nh?t, th?p nh?t, trung b�nh c?a c�c s?n ph?m.
select NUOCSX, max(GIA) as GiaCaoNhat, min(GIA) as GiaThapNhat, avg(GIA) as GiaTrungBinh
from SANPHAM 
group by NUOCSX
--34. T�nh doanh thu b�n h�ng m?i ng�y.
select NGHD, sum(TRIGIA) as DoanhThu
from HOADON
group by NGHD
--35. T�nh t?ng s? l??ng c?a t?ng s?n ph?m b�n ra trong th�ng 10/2006.
select MASP, sum(SL) as TongSoLuong
from CTHD 
join HOADON HD on HD.SOHD=CTHD.SOHD
where year(HD.NGHD)=2006 and month(HD.NGHD)=10
group by MASP
--36. T�nh doanh thu b�n h�ng c?a t?ng th�ng trong n?m 2006.
select distinct month(NGHD) as Thang, sum(TRIGIA) as DoangThu
from HOADON
where year(NGHD)=2006
group by month(NGHD)
--37. T�m h�a ??n c� mua �t nh?t 4 s?n ph?m kh�c nhau.
select SOHD
from CTHD
group by SOHD
having count(MASP)>=4
--38. T�m h�a ??n c� mua 3 s?n ph?m do �Viet Nam� s?n xu?t (3 s?n ph?m kh�c nhau).
select SOHD
from CTHD
join SANPHAM SP on CTHD.MASP=SP.MASP
where SP.NUOCSX='Viet Nam' 
group by SOHD
having count(CTHD.MASP)=3
--39. T�m kh�ch h�ng (MAKH, HOTEN) c� s? l?n mua h�ng nhi?u nh?t.
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
--40. Th�ng m?y trong n?m 2006, doanh s? b�n h�ng cao nh?t ?
select MONTH(NGHD) as Thang, sum(TRIGIA) as DoanhSo
from HOADON
where year(NGHD)=2006
group by MONTH(NGHD)
having sum(TRIGIA)>=all(
						select sum(TRIGIA)
						from HOADON
						group by MONTH(NGHD)
						)

--41. T�m s?n ph?m (MASP, TENSP) c� t?ng s? l??ng b�n ra th?p nh?t trong n?m 2006.
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

--42. *M?i n??c s?n xu?t, t�m s?n ph?m (MASP,TENSP) c� gi� b�n cao nh?t.
select NUOCSX, MASP, TENSP
from SANPHAM SP1
where GIA=(
			select MAX(GIA)
			from SANPHAM SP2
			where SP1.NUOCSX = SP2.NUOCSX
			)
group by NUOCSX, MASP, TENSP
--43. T�m n??c s?n xu?t s?n xu?t �t nh?t 3 s?n ph?m c� gi� b�n kh�c nhau.
SELECT NUOCSX AS Country
FROM SANPHAM
GROUP BY NUOCSX
HAVING COUNT(DISTINCT GIA) >= 3;

--44. *Trong 10 kh�ch h�ng c� doanh s? cao nh?t, t�m kh�ch h�ng c� s? l?n mua h�ng nhi?u nh?t.
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