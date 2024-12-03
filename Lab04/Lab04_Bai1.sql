--19. C� bao nhi�u h�a ??n kh�ng ph?i c?a kh�ch h�ng ??ng k� th�nh vi�n mua?
select count(SOHD) as SoLuongHoaDon 
from HOADON
where MAKH is null
--20. C� bao nhi�u s?n ph?m kh�c nhau ???c b�n ra trong n?m 2006.
select count(distinct SP.MASP) as SoSanPham
from SANPHAM SP
join CTHD on SP.MASP = CTHD.MASP
join HOADON HD on CTHD.SOHD = HD.SOHD
where year(HD.NGHD) = 2006
--21. Cho bi?t tr? gi� h�a ??n cao nh?t, th?p nh?t l� bao nhi�u?
select MAX(TRIGIA) as HoaDonCaoNhat, Min(TRIGiA) as HoaDonThapNhat
from HOADON
--22. Tr? gi� trung b�nh c?a t?t c? c�c h�a ??n ???c b�n ra trong n?m 2006 l� bao nhi�u?
select avg(TRIGIA) as TriGiaTrungBinh
from HOADON
where year(NGHD)=2006
--23. T�nh doanh thu b�n h�ng trong n?m 2006.
select sum(TRIGIA) as DoanhThu
from HOADON 
where year(NGHD)=2006
--24. T�m s? h�a ??n c� tr? gi� cao nh?t trong n?m 2006.
select SOHD  as HoaDonCoTriGiaCaoNhat
from HOADON
where TRIGIA = (
				select top 1 TRIGIA
				from HOADON
				where year(NGHD)=2006
				order by TRIGIA desc )
--25. T�m h? t�n kh�ch h�ng ?� mua h�a ??n c� tr? gi� cao nh?t trong n?m 2006.
select KH.HOTEN 
from KHACHHANG KH
join HOADON HD on KH.MAKH=HD.MAKH 
where HD.TRIGIA = (
				select top 1 TRIGIA
				from HOADON
				where year(NGHD)=2006
				order by TRIGIA desc )
--26. In ra danh s�ch 3 kh�ch h�ng (MAKH, HOTEN) c� doanh s? cao nh?t.
select MAKH,HOTEN
from KHACHHANG KH
where MAKH in (
				select top 3 MAKH
				from KHACHHANG
				order by DOANHSO desc)
--27. In ra danh s�ch c�c s?n ph?m (MASP, TENSP) c� gi� b�n b?ng 1 trong 3 m?c gi� cao nh?t.
select MASP, TENSP 
from SANPHAM
where GIA in (
				select distinct top 3 GIA
				from SANPHAM
				order by GIA desc)
--28. In ra danh s�ch c�c s?n ph?m (MASP, TENSP) do �Thai Lan� s?n xu?t c� gi� b?ng 1 trong 3 m?c gi� cao nh?t (c?a t?t c? c�c s?n ph?m).
select MASP, TENSP
from SANPHAM
where NUOCSX='Thai Lan' and GIA in (
				select distinct top 3 GIA
				from SANPHAM
				order by GIA desc)
--29. In ra danh s�ch c�c s?n ph?m (MASP, TENSP) do �Trung Quoc� s?n xu?t c� gi� b?ng 1 trong 3 m?c gi� cao nh?t (c?a s?n ph?m do �Trung Quoc� s?n xu?t).
select MASP, TENSP
from SANPHAM
where NUOCSX='Trung Quoc' and GIA in (
				select distinct top 3 GIA
				from SANPHAM
				where NUOCSX='Trung Quoc'
				order by GIA desc)
--30. * In ra danh s�ch 3 kh�ch h�ng c� doanh s? cao nh?t (s?p x?p theo ki?u x?p h?ng).
SELECT TOP 3 MAKH, HOTEN, DOANHSO, RANK() OVER (ORDER BY DOANHSO DESC) AS XepHang
FROM KHACHHANG;