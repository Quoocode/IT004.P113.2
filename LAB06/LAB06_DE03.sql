﻿CREATE DATABASE QLDP
USE QLDP
SET DATEFORMAT DMY
CREATE TABLE NHACUNGCAP
(
	MANCC CHAR(5) PRIMARY KEY,
	TENNCC VARCHAR(20),
	QUOCGIA VARCHAR(20),
	LOAINCC VARCHAR(20)
)

CREATE TABLE DUOCPHAM
(
	MADP CHAR(4) PRIMARY KEY,
	TENDP VARCHAR(20),
	LOAIDP VARCHAR(10),
	GIA MONEY
)

CREATE TABLE PHIEUNHAP
( 
	SOPN CHAR(5) PRIMARY KEY,
	NGNHAP SMALLDATETIME,
	MANCC CHAR(5),
	LOAINHAP VARCHAR(20)
)

CREATE TABLE CTPN
(
	SOPN CHAR(5),
	MADP CHAR(4),
	PRIMARY KEY(SOPN, MADP),
	SOLUONG INT
)

ALTER TABLE PHIEUNHAP
ADD CONSTRAINT FK_PN_NCC FOREIGN KEY (MANCC) REFERENCES NHACUNGCAP(MANCC)

ALTER TABLE CTPN
ADD CONSTRAINT FK_CTPN_PN FOREIGN KEY (SOPN) REFERENCES PHIEUNHAP(SOPN)

ALTER TABLE CTPN
ADD CONSTRAINT FK_CTPN_DP FOREIGN KEY (MADP) REFERENCES DUOCPHAM(MADP)

INSERT INTO NHACUNGCAP VALUES('NCC01','Phuc Hung','Viet Nam','Thuong xuyen')
INSERT INTO NHACUNGCAP VALUES('NCC02','J. B. Phamaceuticals','India','Vang lai')
INSERT INTO NHACUNGCAP VALUES('NCC03','Sapharco','Singaport','Vang lai')

INSERT INTO DUOCPHAM VALUES('DP01','Thuoc ho ph','Siro',120000)
INSERT INTO DUOCPHAM VALUES('DP02','Zecuf Herbal CouchRemedy','Zecuf Herbal CouchRemedy',200000)
INSERT INTO DUOCPHAM VALUES('DP03','Cotrim','Vien sui',80000)

INSERT INTO PHIEUNHAP VALUES ('00001','22/11/2017','NCC01','Noi dia')
INSERT INTO PHIEUNHAP VALUES ('00002','04/12/2017','NCC03','Nhap khau')
INSERT INTO PHIEUNHAP VALUES ('00003','10/12/2017','NCC02','Nhap khau')

--Hiện thực ràng buộc toàn vẹn sau: Tất cả các dược phẩm có loại là Siro đều có giá lớn hơn 100.000đ 
ALTER TABLE DUOCPHAM
ADD CONSTRAINT CHK_SIRO CHECK(NOT(LOAIDP='Siro' AND GIA<=100000))

--Hiện thực ràng buộc toàn vẹn sau: Phiếu nhập của những nhà cung cấp ở những quốc gia khác Việt Nam đều có loại nhập là Nhập khẩu. 
CREATE TRIGGER TRG_PN_NCC ON NHACUNGCAP
FOR INSERT, UPDATE
AS
BEGIN
IF EXISTS (SELECT *
		FROM inserted I
		JOIN PHIEUNHAP PN ON I.MANCC=PN.MANCC
		WHERE I.QUOCGIA<>'Viet Nam' AND PN.LOAINHAP='Noi dia')
		BEGIN 
		RAISERROR('LOI',16,1)
		ROLLBACK TRANSACTION
		END;
ELSE
BEGIN
PRINT('THANH CONG')
END
END;

CREATE TRIGGER TRG_NCC_PN ON PHIEUNHAP
FOR UPDATE
AS
BEGIN 
IF EXISTS (SELECT *
		FROM inserted I
		JOIN NHACUNGCAP NCC ON I.MANCC=NCC.MANCC
		WHERE NCC.QUOCGIA<>'Viet Nam' AND I.LOAINHAP='Noi dia')
		BEGIN 
		RAISERROR('LOI',16,1)
		ROLLBACK TRANSACTION
		END;
ELSE
BEGIN
PRINT('THANH CONG')
END
END;

--Tìm tất cả các phiếu nhập có ngày nhập trong tháng 12 năm 2017, sắp xếp kết quả tăng dần theo ngày nhập \
SELECT *
FROM PHIEUNHAP 
WHERE MONTH(NGNHAP)=12 AND YEAR(NGNHAP)=2017
ORDER BY DAY(NGNHAP) ASC

--Tìm dược phẩm được nhập số lượng nhiều nhất trong năm 2017 
SELECT TOP 1 WITH TIES DP.MADP, DP.TENDP, SUM(CTPN.SOLUONG) AS TONGSOLUONG
FROM DUOCPHAM DP
JOIN CTPN ON DP.MADP=CTPN.MADP
JOIN PHIEUNHAP PN ON PN.SOPN=CTPN.SOPN
WHERE YEAR(PN.NGNHAP)=2017
GROUP BY DP.MADP, DP.TENDP
ORDER BY TONGSOLUONG DESC

--Tìm dược phẩm chỉ có nhà cung cấp thường xuyên (LOAINCC là Thuong xuyen) cung cấp, nhà cung cấp vãng lai (LOAINCC là Vang lai) không cung cấp
SELECT DP.MADP, DP.TENDP
FROM DUOCPHAM DP
JOIN CTPN ON DP.MADP=CTPN.MADP
JOIN PHIEUNHAP PN ON PN.SOPN=CTPN.SOPN
JOIN NHACUNGCAP NCC ON NCC.MANCC=PN.MANCC
WHERE NCC.LOAINCC='Thuong xuyen' AND NOT EXISTS(SELECT DP.MADP, DP.TENDP
												FROM DUOCPHAM DP
												JOIN CTPN ON DP.MADP=CTPN.MADP
												JOIN PHIEUNHAP PN ON PN.SOPN=CTPN.SOPN
												JOIN NHACUNGCAP NCC ON NCC.MANCC=PN.MANCC
												WHERE NCC.LOAINCC='Vang lai')

--Tìm nhà cung cấp đã từng cung cấp tất cả những dược phẩm có giá trên 100.000đ trong năm 2017
SELECT MANCC,TENNCC
FROM NHACUNGCAP NCC
WHERE NOT EXISTS(SELECT 1
				FROM DUOCPHAM DP
				JOIN CTPN ON DP.MADP=CTPN.MADP
				JOIN PHIEUNHAP PN ON CTPN.SOPN=PN.SOPN 
				WHERE GIA>100000 AND YEAR(PN.NGNHAP)=2017 AND NOT EXISTS(SELECT 1
																		FROM CTPN
																		JOIN PHIEUNHAP PN ON CTPN.SOPN=PN.SOPN
																	WHERE  NCC.MANCC=PN.MANCC AND DP.MADP=CTPN.MADP))