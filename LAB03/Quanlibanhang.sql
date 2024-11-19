--1. Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”, mỗi sản phẩm mua với số
--lượng từ 10 đến 20, và tổng trị giá hóa đơn lớn hơn 500.000.
SELECT DISTINCT CTHD.SOHD
FROM CTHD
JOIN HOADON ON CTHD.SOHD = HOADON.SOHD
WHERE CTHD.MASP IN ('BB01', 'BB02')
AND CTHD.SL BETWEEN 10 AND 20
AND HOADON.TRIGIA > 500000;
--2. Tìm các số hóa đơn mua cùng lúc 3 sản phẩm có mã số “BB01”, “BB02” và “BB03”, mỗi sản
--phẩm mua với số lượng từ 10 đến 20, và ngày mua hàng trong năm 2023.
SELECT HOADON.SOHD
FROM HOADON
JOIN CTHD AS C1 ON HOADON.SOHD = C1.SOHD AND C1.MASP = 'BB01' AND C1.SL BETWEEN 10 AND 20
JOIN CTHD AS C2 ON HOADON.SOHD = C2.SOHD AND C2.MASP = 'BB02' AND C2.SL BETWEEN 10 AND 20
JOIN CTHD AS C3 ON HOADON.SOHD = C3.SOHD AND C3.MASP = 'BB03' AND C3.SL BETWEEN 10 AND 20
WHERE YEAR(HOADON.NGHD) = 2023;
--3. Tìm các khách hàng đã mua ít nhất một sản phẩm có mã số “BB01” với số lượng từ 10 đến 20, và
--tổng trị giá tất cả các hóa đơn của họ lớn hơn hoặc bằng 1 triệu đồng
SELECT KHACHHANG.MAKH, KHACHHANG.HOTEN
FROM KHACHHANG
JOIN HOADON ON KHACHHANG.MAKH = HOADON.MAKH
JOIN CTHD ON HOADON.SOHD = CTHD.SOHD
WHERE CTHD.MASP = 'BB01' AND CTHD.SL BETWEEN 10 AND 20
GROUP BY KHACHHANG.MAKH, KHACHHANG.HOTEN
HAVING SUM(HOADON.TRIGIA) >= 1000000;
--4. Tìm các nhân viên bán hàng đã thực hiện giao dịch bán ít nhất một sản phẩm có mã số “BB01”
--hoặc “BB02”, mỗi sản phẩm bán với số lượng từ 15 trở lên, và tổng trị giá của tất cả các hóa đơn mà
--nhân viên đó xử lý lớn hơn hoặc bằng 2 triệu đồng.
SELECT NHANVIEN.MANV, NHANVIEN.HOTEN
FROM NHANVIEN
JOIN HOADON ON NHANVIEN.MANV = HOADON.MANV
JOIN CTHD ON HOADON.SOHD = CTHD.SOHD
WHERE CTHD.MASP IN ('BB01', 'BB02') AND CTHD.SL >= 15
GROUP BY NHANVIEN.MANV, NHANVIEN.HOTEN
HAVING SUM(HOADON.TRIGIA) >= 2000000;
--5. Tìm các khách hàng đã mua ít nhất hai loại sản phẩm khác nhau với tổng số lượng từ tất cả các hóa
--đơn của họ lớn hơn hoặc bằng 50 và tổng trị giá của họ lớn hơn hoặc bằng 5 triệu đồng.
SELECT KHACHHANG.MAKH, KHACHHANG.HOTEN
FROM KHACHHANG
JOIN HOADON ON KHACHHANG.MAKH = HOADON.MAKH
JOIN CTHD ON HOADON.SOHD = CTHD.SOHD
GROUP BY KHACHHANG.MAKH, KHACHHANG.HOTEN
HAVING COUNT(DISTINCT CTHD.MASP) >= 2 
AND SUM(CTHD.SL) >= 50 
AND SUM(HOADON.TRIGIA) >= 5000000;
--6. Tìm những khách hàng đã mua n phẩm đều có số lượng từ 5 trở lên.cùng lúc ít nhất ba sản phẩm khác nhau trong cùng một hóa đơn và
--mỗi sả
SELECT DISTINCT KH.MAKH, KH.HOTEN, HD.SOHD
FROM KHACHHANG KH
JOIN HOADON HD ON KH.MAKH = HD.MAKH
JOIN CTHD CT ON HD.SOHD = CT.SOHD
WHERE HD.MAKH IS NOT NULL
GROUP BY KH.MAKH, KH.HOTEN, HD.SOHD
HAVING COUNT(DISTINCT CT.MASP) >= 3 AND MIN(CT.SL) >= 5;
--7. Tìm các sản phẩm (MASP, TENSP) do “Trung Quoc” sản xuất và đã được bán ra ít nhất 5 lần
--trong năm 2007
SELECT SP.MASP, SP.TENSP
FROM SANPHAM SP
JOIN CTHD CT ON SP.MASP = CT.MASP
JOIN HOADON HD ON CT.SOHD = HD.SOHD
WHERE SP.NUOCSX = N'Trung Quoc'
AND YEAR(HD.NGHD) = 2007
GROUP BY SP.MASP, SP.TENSP
HAVING COUNT(CT.SOHD) >= 5;
--8. Tìm các khách hàng đã mua ít nhất một sản phẩm do “Singapore” sản xuất trong năm 2006 và tổng
--trị giá hóa đơn của họ trong năm đó lớn hơn 1 triệu đồng.
SELECT DISTINCT KH.MAKH, KH.HOTEN
FROM KHACHHANG KH
JOIN HOADON HD ON KH.MAKH = HD.MAKH
JOIN CTHD CT ON HD.SOHD = CT.SOHD
JOIN SANPHAM SP ON CT.MASP = SP.MASP
WHERE SP.NUOCSX = N'Singapore'
  AND YEAR(HD.NGHD) = 2006
  AND KH.MAKH IN (
      SELECT KH1.MAKH
      FROM KHACHHANG KH1
      JOIN HOADON HD1 ON KH1.MAKH = HD1.MAKH
      WHERE YEAR(HD1.NGHD) = 2006
      GROUP BY KH1.MAKH
      HAVING SUM(HD1.TRIGIA) > 1000000
  );
--  9. Tìm những nhân viên bán hàng đã thực hiện giao dịch bán nhiều nhất các sản phẩm do “Trung
--Quoc” sản xuất trong năm 2006
WITH SalesByEmployee AS (
    SELECT 
        HD.MANV,
        SUM(CT.SL) AS TotalQuantity
    FROM HOADON HD
    JOIN CTHD CT ON HD.SOHD = CT.SOHD
    JOIN SANPHAM SP ON CT.MASP = SP.MASP
    WHERE SP.NUOCSX = N'Trung Quoc'
      AND YEAR(HD.NGHD) = 2006
    GROUP BY HD.MANV
),
MaxSales AS (
    SELECT 
        MAX(TotalQuantity) AS MaxQuantity
    FROM SalesByEmployee
)
SELECT 
    NV.MANV,
    NV.HOTEN,
    SB.TotalQuantity
FROM SalesByEmployee SB
JOIN MaxSales MS ON SB.TotalQuantity = MS.MaxQuantity
JOIN NHANVIEN NV ON SB.MANV = NV.MANV;

--10. Tìm những khách hàng chưa từng mua bất kỳ sản phẩm nào do “Singapore” sản xuất nhưng đã
--mua ít nhất một sản phẩm do “Trung Quoc” sản xuất.
SELECT DISTINCT KH.MAKH, KH.HOTEN
FROM KHACHHANG KH
JOIN HOADON HD ON KH.MAKH = HD.MAKH
JOIN CTHD CT ON HD.SOHD = CT.SOHD
JOIN SANPHAM SP ON CT.MASP = SP.MASP
WHERE SP.NUOCSX = N'Trung Quoc'
  AND KH.MAKH NOT IN (
      SELECT KH1.MAKH
      FROM KHACHHANG KH1
      JOIN HOADON HD1 ON KH1.MAKH = HD1.MAKH
      JOIN CTHD CT1 ON HD1.SOHD = CT1.SOHD
      JOIN SANPHAM SP1 ON CT1.MASP = SP1.MASP
      WHERE SP1.NUOCSX = N'Singapore'
  );

--11. Tìm những hóa đơn có chứa tất cả các sản phẩm do “Singapore” sản xuất và trị giá hóa đơn lớn
--hơn tổng trị giá trung bình của tất cả các hóa đơn trong hệ thống.
-- Tìm danh sách tất cả sản phẩm do Singapore sản xuất
WITH ProductsFromSingapore AS (
    SELECT MASP
    FROM SANPHAM
    WHERE NUOCSX = 'Singapore'
),
AverageInvoiceValue AS (
    SELECT AVG(TRIGIA) AS AvgValue
    FROM HOADON
)
SELECT DISTINCT HD.SOHD, HD.NGHD, HD.MAKH, HD.MANV, HD.TRIGIA
FROM HOADON HD
JOIN CTHD CT ON HD.SOHD = CT.SOHD
WHERE NOT EXISTS (
    SELECT 1
    FROM ProductsFromSingapore PFS
    WHERE NOT EXISTS (
        SELECT 1
        FROM CTHD CT1
        WHERE CT1.SOHD = HD.SOHD AND CT1.MASP = PFS.MASP
    )
)
AND HD.TRIGIA > (SELECT AvgValue FROM AverageInvoiceValue);

--12. Tìm danh sách các nhân viên có tổng số lượng bán ra của tất cả các loại sản phẩm vượt quá số
--lượng trung bình của tất cả các nhân viên khác.
WITH EmployeeSales AS (
    SELECT 
        NV.MANV,
        NV.HOTEN,
        SUM(CT.SL) AS TotalSales
    FROM NHANVIEN NV
    JOIN HOADON HD ON NV.MANV = HD.MANV
    JOIN CTHD CT ON HD.SOHD = CT.SOHD
    GROUP BY NV.MANV, NV.HOTEN
),
AverageSales AS (
    SELECT AVG(TotalSales) AS AvgSales
    FROM EmployeeSales
)
SELECT ES.MANV, ES.HOTEN, ES.TotalSales
FROM EmployeeSales ES
WHERE ES.TotalSales > (SELECT AvgSales FROM AverageSales);
--13. Tìm danh sách các hóa đơn có chứa ít nhất một sản phẩm từ mỗi nước sản xuất khác nhau có
--trong hệ thống.

WITH CountryList AS (
    SELECT DISTINCT NUOCSX
    FROM SANPHAM
),
InvoiceCountries AS (
    SELECT DISTINCT HD.SOHD, SP.NUOCSX
    FROM HOADON HD
    JOIN CTHD CT ON HD.SOHD = CT.SOHD
    JOIN SANPHAM SP ON CT.MASP = SP.MASP
),
InvoiceCountryCount AS (
    SELECT IC.SOHD, COUNT(DISTINCT IC.NUOCSX) AS CountryCount
    FROM InvoiceCountries IC
    GROUP BY IC.SOHD
)
SELECT ICC.SOHD
FROM InvoiceCountryCount ICC
WHERE ICC.CountryCount = (SELECT COUNT(DISTINCT NUOCSX) FROM CountryList);


