--19. Có bao nhiêu hóa ??n không ph?i c?a khách hàng ??ng ký thành viên mua?
select count(SOHD) as SoLuongHoaDon 
from HOADON
where MAKH is null
--20. Có bao nhiêu s?n ph?m khác nhau ???c bán ra trong n?m 2006.
select count(distinct SP.MASP) as SoSanPham
from SANPHAM SP
join CTHD on SP.MASP = CTHD.MASP
join HOADON HD on CTHD.SOHD = HD.SOHD
where year(HD.NGHD) = 2006
--21. Cho bi?t tr? giá hóa ??n cao nh?t, th?p nh?t là bao nhiêu?
select MAX(TRIGIA) as HoaDonCaoNhat, Min(TRIGiA) as HoaDonThapNhat
from HOADON
--22. Tr? giá trung bình c?a t?t c? các hóa ??n ???c bán ra trong n?m 2006 là bao nhiêu?
select avg(TRIGIA) as TriGiaTrungBinh
from HOADON
where year(NGHD)=2006
--23. Tính doanh thu bán hàng trong n?m 2006.
select sum(TRIGIA) as DoanhThu
from HOADON 
where year(NGHD)=2006
--24. Tìm s? hóa ??n có tr? giá cao nh?t trong n?m 2006.
select SOHD  as HoaDonCoTriGiaCaoNhat
from HOADON
where TRIGIA = (
				select top 1 TRIGIA
				from HOADON
				where year(NGHD)=2006
				order by TRIGIA desc )
--25. Tìm h? tên khách hàng ?ã mua hóa ??n có tr? giá cao nh?t trong n?m 2006.
select KH.HOTEN 
from KHACHHANG KH
join HOADON HD on KH.MAKH=HD.MAKH 
where HD.TRIGIA = (
				select top 1 TRIGIA
				from HOADON
				where year(NGHD)=2006
				order by TRIGIA desc )
--26. In ra danh sách 3 khách hàng (MAKH, HOTEN) có doanh s? cao nh?t.
select MAKH,HOTEN
from KHACHHANG KH
where MAKH in (
				select top 3 MAKH
				from KHACHHANG
				order by DOANHSO desc)
--27. In ra danh sách các s?n ph?m (MASP, TENSP) có giá bán b?ng 1 trong 3 m?c giá cao nh?t.
select MASP, TENSP 
from SANPHAM
where GIA in (
				select distinct top 3 GIA
				from SANPHAM
				order by GIA desc)
--28. In ra danh sách các s?n ph?m (MASP, TENSP) do “Thai Lan” s?n xu?t có giá b?ng 1 trong 3 m?c giá cao nh?t (c?a t?t c? các s?n ph?m).
select MASP, TENSP
from SANPHAM
where NUOCSX='Thai Lan' and GIA in (
				select distinct top 3 GIA
				from SANPHAM
				order by GIA desc)
--29. In ra danh sách các s?n ph?m (MASP, TENSP) do “Trung Quoc” s?n xu?t có giá b?ng 1 trong 3 m?c giá cao nh?t (c?a s?n ph?m do “Trung Quoc” s?n xu?t).
select MASP, TENSP
from SANPHAM
where NUOCSX='Trung Quoc' and GIA in (
				select distinct top 3 GIA
				from SANPHAM
				where NUOCSX='Trung Quoc'
				order by GIA desc)
--30. * In ra danh sách 3 khách hàng có doanh s? cao nh?t (s?p x?p theo ki?u x?p h?ng).
SELECT TOP 3 MAKH, HOTEN, DOANHSO, RANK() OVER (ORDER BY DOANHSO DESC) AS XepHang
FROM KHACHHANG;