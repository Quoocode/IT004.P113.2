insert into NHANVIEN (MANV, HOTEN, SODT, NGVL)
values
('NV01','Nguyen Nhu Nhut','09273456678','2006-04-13'),
('NV02','Le Thi Phi Yen','0987567390','2006-04-21'),
('NV03','Nguyen Van B','0997047382','2006-04-27'),
('NV04','Ngo Thanh Tuan','0913758498','2006-06-24'),
('NV05','Nguyen Thi Truc Thanh','0918590387','2006-07-20');

insert into KHACHHANG (MAKH, HOTEN, DCHI, SODT, NGSINH, DOANHSO, NGDK)
values 
('KH01', 'Nguyen Van A', '731 Tran Hung Dao, Q5, TpHCM', '08823451', '1960-10-22', 13060000, '2006-07-22'),
('KH02', 'Tran Ngoc Han', '23/5 Nguyen Trai, Q5, TpHCM', '0908256478', '1974-04-03', 280000, '2006-07-30'),
('KH03', 'Tran Ngoc Linh', '45 Nguyen Canh Chan, Q1, TpHCM', '0938776266', '1980-06-12', 3860000, '2006-08-05'),
('KH04', 'Tran Minh Long', '50/34 Le Dai Hanh, Q10, TpHCM', '0917325476', '1965-03-09', 250000, '2006-10-02'),
('KH05', 'Le Nhat Minh', '34 Truong Dinh, Q3, TpHCM', '08246108', '1950-03-10', 21000, '2006-11-28'),
('KH06', 'Le Hoai Thuong', '227 Nguyen Van Cu, Q5, TpHCM', '08631738', '1981-12-31', 915000, '2006-11-24'),
('KH07', 'Nguyen Van Tam', '32/3 Tran Binh Trong, Q5, TpHCM', '0916783565', '1971-04-06', 12500, '2006-12-04'),
('KH08', 'Phan Thi Thanh', '45/2 An Duong Vuong, Q5, TpHCM', '0938435756', '1971-10-10', 365000, '2007-01-14'),
('KH09', 'Le Ha Vinh', '873 Le Hong Phong, Q5, TpHCM', '08654763', '1979-03-09', 70000, '2007-01-14'),
('KH10', 'Ha Duy Lap', '34/34B Nguyen Trai, Q1, TpHCM', '08768904', '1983-05-02', 67500, '2007-01-16');

insert into SANPHAM (MASP, TENSP, DVT, NUOCSX, GIA)
values
('BC01', 'But chi', 'cay', 'Singapore', 3000),
('BC02', 'But chi', 'cay', 'Singapore', 5000),
('BC03', 'But chi', 'cay', 'Viet Nam', 3500),
('BC04', 'But chi', 'hop', 'Viet Nam', 30000),
('BB01', 'But bi', 'cay', 'Viet Nam', 5000),
('BB02', 'But bi', 'cay', 'Trung Quoc', 7000),
('BB03', 'But bi', 'hop', 'Thai Lan', 100000),
('TV01', 'Tap 100 giay mong', 'quyen', 'Trung Quoc', 2500),
('TV02', 'Tap 200 giay mong', 'quyen', 'Trung Quoc', 4500),
('TV03', 'Tap 100 giay tot', 'quyen', 'Viet Nam', 3000),
('TV04', 'Tap 200 giay tot', 'quyen', 'Viet Nam', 5500),
('TV05', 'Tap 100 trang', 'chuc', 'Viet Nam', 23000),
('TV06', 'Tap 200 trang', 'chuc', 'Viet Nam', 53000),
('TV07', 'Tap 100 trang', 'chuc', 'Trung Quoc', 34000),
('ST01', 'So tay 500 trang', 'quyen', 'Trung Quoc', 40000),
('ST02', 'So tay loai 1', 'quyen', 'Viet Nam', 55000),
('ST03', 'So tay loai 2', 'quyen', 'Viet Nam', 51000),
('ST04', 'So tay', 'quyen', 'Thai Lan', 55000),
('ST05', 'So tay mong', 'quyen', 'Thai Lan', 20000),
('ST06','Phan viet bang','hop','Viet Nam',5000),
('ST07','Phan khong bui','hop','Viet Nam',7000),
('ST08','Bong bang','cai','Viet Nam',1000),
('ST09','But long','cay','Viet Nam',5000),
('ST10','But long','cay','Trung Quoc',7000);

INSERT INTO HOADON (SOHD, NGHD, MAKH, MANV, TRIGIA)
VALUES
(1001, '2006-07-23', 'KH01', 'NV01', 320000),
(1002, '2006-08-12', 'KH01', 'NV02', 840000),
(1003, '2006-08-23', 'KH02', 'NV01', 100000),
(1004, '2006-09-01', 'KH02', 'NV01', 180000),
(1005, '2006-10-20', 'KH01', 'NV02', 3800000),
(1006, '2006-10-16', 'KH01', 'NV03', 2430000),
(1007, '2006-10-28', 'KH03', 'NV03', 510000),
(1008, '2006-10-28', 'KH01', 'NV03', 440000),
(1009, '2006-10-28', 'KH03', 'NV04', 200000),
(1010, '2006-11-01', 'KH01', 'NV01', 5200000),
(1011, '2006-11-04', 'KH04', 'NV03', 250000),
(1012, '2006-11-30', 'KH05', 'NV03', 21000),
(1013, '2006-12-12', 'KH06', 'NV01', 5000),
(1014, '2006-12-31', 'KH03', 'NV02', 3150000),
(1015, '2007-01-01', 'KH06', 'NV01', 910000),
(1016, '2007-01-01', 'KH07', 'NV02', 12500),
(1017, '2007-01-02', 'KH08', 'NV03', 35000),
(1018, '2007-01-13', 'KH08', 'NV03', 330000),
(1019, '2007-01-13', 'KH01', 'NV03', 30000),
(1020, '2007-01-14', 'KH09', 'NV04', 70000),
(1021, '2007-01-16', 'KH10', 'NV03', 67500),
(1022, '2007-01-16', NULL, 'NV03', 7000),
(1023, '2007-01-17', NULL, 'NV01', 330000);

INSERT INTO CTHD (SOHD, MASP, SL) VALUES
(1001, 'TV02', 10),
(1001, 'ST01', 5),
(1001, 'BC01', 5),
(1001, 'BC02', 10),
(1001, 'ST08', 10),
(1002, 'BC04', 20),
(1002, 'BB01', 20),
(1002, 'BB02', 20),
(1003, 'BB03', 10),
(1004, 'TV01', 20),
(1004, 'TV02', 10),
(1004, 'TV03', 10),
(1004, 'TV04', 10),
(1005, 'TV05', 50),
(1005, 'TV06', 50),
(1006, 'TV07', 20),
(1006, 'ST01', 30),
(1006, 'ST02', 10),
(1007, 'ST03', 10),
(1008, 'ST04', 8),
(1009, 'ST05', 10),
(1010, 'TV07', 50),
(1010, 'ST07', 50),
(1010, 'ST08', 100),
(1010, 'ST04', 50),
(1010, 'TV03', 100),
(1011, 'ST06', 50),
(1012, 'ST07', 3),
(1013, 'ST08', 5),
(1014, 'BC02', 80),
(1014, 'BB02', 100),
(1014, 'BC04', 60),
(1014, 'BB01', 50),
(1015, 'BB02', 30),
(1015, 'BB03', 7),
(1016, 'TV01', 5),
(1017, 'TV02', 1),
(1017, 'TV03', 1),
(1017, 'TV04', 5),
(1018, 'ST04', 6),
(1019, 'ST05', 1),
(1019, 'ST06', 2),
(1020, 'ST07', 10),
(1021, 'ST08', 5),
(1021, 'TV01', 7),
(1021, 'TV02', 10),
(1022, 'ST07', 1),
(1023, 'ST04', 6);

--Bài tập 3
--câu 2
SELECT * INTO SANPHAM1
FROM SANPHAM;

SELECT * INTO KHACHHANG1
FROM KHACHHANG;

--câu3
UPDATE SANPHAM1
SET GIA = GIA * 1.05
WHERE NUOCSX = 'Thai Lan';

--câu 4
UPDATE SANPHAM1
SET GIA = GIA * 0.95
WHERE NUOCSX = 'Trung Quoc' AND GIA <= 10000;

--câu 5
UPDATE KHACHHANG1
SET LOAIKH = 'Vip'
WHERE 
    (NGDK < '2007-01-01' AND DOANHSO >= 10000000) 
    OR 
    (NGDK >= '2007-01-01' AND DOANHSO >= 2000000);

--Bài tập 5
--Câu 1
select MASP,TENSP
from SANPHAM
where NUOCSX = 'Trung Quoc';

--Câu 2
select MASP,TENSP
from SANPHAM
where DVT in ('cay','quyen');

--Câu 3
select MASP,TENSP 
from SANPHAM
where MASP like 'B%01';

--Câu 4
select MASP,TENSP
from SANPHAM
where NUOCSX = 'Trung Quốc' and GIA between 30000 and 40000;

--Câu 5
select MASP,TENSP
from SANPHAM
where (NUOCSX = 'Trung Quoc' or NUOCSX = 'Thai Lan') and GIA between 30000 and 40000;

--Câu 6
select SOHD, TRIGIA 
from HOADON
where NGHD IN ('2007-01-01', '2007-01-02');

--Câu 7
select SOHD, TRIGIA 
from HOADON
where NGHD BETWEEN '2007-01-01' AND '2007-01-31'
order by NGHD asc, TRIGIA desc;

--Câu 8
select distinct KH.MAKH, KH.HOTEN
from KHACHHANG KH join HOADON HD on KH.MAKH=HD.MAKH
where HD.NGHD='2007-1-1';

--Câu 9
select HD.SOHD,HD.TRIGIA
from HOADON HD join NHANVIEN NV on HD.MANV=NV.MANV
where NV.HOTEN = 'Nguyen Van B' and HD.NGHD = '2006-10-28';

--Câu 10
select SP.MASP,SP.TENSP
from SANPHAM SP
join CTHD CT on SP.MASP = CT.MASP
join HOADON HD on CT.SOHD = HD.SOHD
join KHACHHANG KH on HD.MAKH = KH.MAKH
where KH.HOTEN = 'Nguyen Van A' and HD.NGHD between '2006-10-01'and'2006-10-31';

--Câu 11
select HD.SOHD
from HOADON HD
join CTHD CT on HD.SOHD = CT.SOHD
join SANPHAM SP on CT.MASP = SP.MASP
where SP.MASP = 'BB01' or SP.MASP = 'BB02';
--Nhap du lieu cho bang QLGV

INSERT INTO KHOA (MAKHOA)
VALUES
('KHMT'), 
('HTTT'), 
('CNPM'), 
('MTT'), 
('KTMT');


INSERT INTO GIAOVIEN (MAGV, HOTEN, HOCVI, HOCHAM, GIOITINH, NGSINH, NGVL, HESO, MUCLUONG, MAKHOA) 
VALUES 
('GV01', 'Ho Thanh Son', 'PTS', 'GS', 'Nam', '1950-02-05', '2004-11-01', 5.00, 2250000, 'KHMT'),
('GV02', 'Tran Tam Thanh', 'TS', 'PGS', 'Nam', '1965-12-17', '2004-04-20', 4.50, 2025000, 'HTTT'),
('GV03', 'Do Nghiem Phung', 'TS', 'GS', 'Nu', '1950-08-01', '2004-09-23', 4.00, 1800000, 'CNPM'),
('GV04', 'Tran Nam Son', 'TS', 'PGS', 'Nam', '1961-02-22', '2005-01-12', 4.50, 2025000, 'KTMT'),
('GV05', 'Mai Thanh Danh', 'ThS', 'GV', 'Nam', '1958-03-12', '2005-01-12', 3.00, 1350000, 'HTTT'),
('GV06', 'Tran Doan Hung', 'TS', 'GV', 'Nam', '1953-11-03', '2005-01-12', 4.50, 2025000, 'KHMT'),
('GV07', 'Nguyen Minh Tien', 'ThS', 'GV', 'Nam', '1971-11-23', '2005-01-04', 4.00, 1800000, 'KHMT'),
('GV08', 'Le Thi Tran', 'KS', NULL, 'Nu', '1974-03-26', '2005-01-12', 1.69, 760500, 'KHMT'),
('GV09', 'Nguyen To Lan', 'ThS', 'GV', 'Nu', '1966-12-31', '2005-01-12', 4.00, 1800000, 'HTTT'),
('GV10', 'Le Tran Anh Loan', 'KS', NULL, 'Nu', '1972-07-17', '2005-01-13', 1.86, 837000, 'CNPM'),
('GV11', 'Ho Thanh Tung', 'CN', 'GV', 'Nam', '1980-12-19', '2005-05-15', 2.67, 1201500, 'KHMT'),
('GV12', 'Tran Van Anh', 'CN', 'Null', 'Nam', '1980-03-29', '2005-05-15', 1.69, 760500, 'KHMT'),
('GV13', 'Nguyen Linh Dan', 'CN', NULL, 'Nu', '1980-05-23', '2005-05-15', 1.69, 760500, 'KTMT'),
('GV14', 'Truong Minh Chau', 'ThS', 'GV', 'Nam', '1975-11-30', '2005-05-15', 3.00, 1350000, 'MTT'),
('GV15', 'Le Ha Thanh', 'ThS', 'GV', 'Nam', '1978-04-05', '2005-05-15', 3.00, 1350000, 'KHMT');

INSERT INTO KHOA (MAKHOA, TENKHOA, NGTLAP, TRGKHOA)
VALUES
('KHMT', 'Khoa hoc may tinh', '2005-06-07', 'GV01'),
('HTTT', 'He thong thong tin', '2005-06-07', 'GV02'),
('CNPM', 'Cong nghe phan mem', '2005-06-07', 'GV04'),
('MTT', 'Mang va truyen thong', '2005-10-20', 'GV03'),
('KTMT', 'Ky thuat may tinh', '2005-12-20', NULL);

UPDATE KHOA
SET TENKHOA = 'Khoa hoc may tinh'
where MAKHOA = 'KHMT';

UPDATE KHOA
SET TENKHOA = 'He thong thong tin'
where MAKHOA = 'HTTT';

UPDATE KHOA
SET TENKHOA = 'Cong nghe phan mem'
where MAKHOA = 'CNPM';

UPDATE KHOA
SET TENKHOA = 'Mang va truyen thong'
where MAKHOA = 'MTT';

UPDATE KHOA
SET TENKHOA = 'Ky thuat may tinh'
where MAKHOA = 'KTMT';

UPDATE KHOA
SET NGTLAP = '2005-06-07', TRGKHOA ='GV01'
where MAKHOA = 'KHMT';

UPDATE KHOA
SET NGTLAP = '2005-06-07', TRGKHOA ='GV02'
where MAKHOA = 'HTTT';

UPDATE KHOA
SET NGTLAP = '2005-06-07', TRGKHOA ='GV04'
where MAKHOA = 'CNPM';

UPDATE KHOA
SET NGTLAP = '2005-10-20', TRGKHOA ='GV03'
where MAKHOA = 'MTT';

UPDATE KHOA
SET NGTLAP = '2005-12-20'
where MAKHOA = 'KTMT';

INSERT INTO MONHOC (MAMH, TENMH, TCLT, TCTH, MAKHOA)
VALUES
('THDC', 'Tin hoc dai cuong', 4, 1, 'KHMT'),
('CTRR', 'Cau truc roi rac', 5, 2, 'KHMT'),
('CSDL', 'Co so du lieu', 3, 1, 'HTTT'),
('CTDLGT', 'Cau truc du lieu va giai thuat', 3, 1, 'KHMT'),
('PTTKTT', 'Phan tich thiet ke thuat toan', 3, 0, 'KHMT'),
('DHMT', 'Do hoa may tinh', 3, 1, 'KHMT'),
('KTMT', 'Kien truc may tinh', 3, 1, 'KTMT'),
('TKCSDL', 'Thiet ke co so du lieu', 3, 1, 'HTTT'),
('PTTKHTTT', 'Phan tich thiet ke he thong thong tin', 4, 1, 'HTTT'),
('HDH', 'He dieu hanh', 4, 1, 'KTMT'),
('NMCNPM', 'Nhap mon cong nghe phan mem', 3, 1, 'CNPM'),
('LTCFW', 'Lap trinh C for win', 3, 1, 'CNPM'),
('LTHDT', 'Lap trinh huong doi tuong', 3, 1, 'CNPM');

INSERT INTO LOP (MALOP, TENLOP, SISO, MAGVCN)
VALUES
('K11', 'Lop 1 khoa 1', 11, 'GV07'),
('K12', 'Lop 2 khoa 1', 12, 'GV09'),
('K13', 'Lop 3 khoa 1', 12, 'GV14');

update LOP
set TRGLOP = 'K1108'
where MALOP = 'K11';

update LOP
set TRGLOP = 'K1205'
where MALOP = 'K12';

update LOP
set TRGLOP = 'K1305'
where MALOP = 'K13';

INSERT INTO HOCVIEN (MAHV, HO, TEN, NGSINH, GIOITINH, NOISINH, MALOP)
VALUES
('K1101', 'Nguyen Van', 'A', '1998-07-27', 'Nam', 'TpHCM', 'K11'),
('K1102', 'Tran Ngoc', 'Han', '1998-03-14', 'Nu', 'Kien Giang', 'K11'),
('K1103', 'Ha', 'Duy', '1998-04-18', 'Nam', 'Nghe An', 'K11'),
('K1104', 'Tran Ngoc', 'Linh', '1998-09-30', 'Nu', 'Tay Ninh', 'K11'),
('K1105', 'Tran Minh', 'Long', '1998-12-27', 'Nam', 'TpHCM', 'K11'),
('K1106', 'Le Nhat', 'Minh', '1998-04-24', 'Nam', 'Ha Noi', 'K11'),
('K1107', 'Nguyen Nuu', 'Nhut', '1998-12-27', 'Nam', 'Ha Noi', 'K11'),
('K1108', 'Nguyen Nhan', 'Tam', '1998-07-27', 'Nam', 'Kien Giang', 'K11'),
('K1109', 'Phan Thi Thanh', 'Tam', '1998-07-27', 'Nu', 'Vinh Long', 'K11'),
('K1110', 'Le', 'Hoa', '1998-05-29', 'Nu', 'Can Tho', 'K11'),
('K1111', 'Le', 'Vinh', '1998-12-25', 'Nam', 'Vinh Long', 'K11'),
('K1201', 'Nguyen Van', 'B', '1998-11-15', 'Nam', 'TpHCM', 'K12'),
('K1202', 'Nguyen Thi Kim', 'Duyen', '1998-07-18', 'Nu', 'TpHCM', 'K12'),
('K1203', 'Tran Thi Kim', 'Duyen', '1998-09-19', 'Nu', 'TpHCM', 'K12'),
('K1204', 'Truong My', 'Hanh', '1998-05-19', 'Nu', 'Dong Nai', 'K12'),
('K1205', 'Nguyen Thanh', 'Nam', '1998-11-17', 'Nam', 'TpHCM', 'K12'),
('K1206', 'Nguyen Thi Thu', 'Hanh', '1998-05-03', 'Nu', 'Kien Giang', 'K12'),
('K1207', 'Tran Thi Bich', 'Thuy', '1998-08-12', 'Nu', 'Nghe An', 'K12'),
('K1208', 'Huynh Thi Kim', 'Thieu', '1998-04-03', 'Nu', 'Kien Giang', 'K12'),
('K1209', 'Phan Thanh', 'Trieu', '1998-12-23', 'Nam', 'TpHCM', 'K12'),
('K1210', 'Ngo', 'Thanh', '1998-11-13', 'Nam', 'TpHCM', 'K12'),
('K1211', 'Do Thi', 'Xuan', '1998-09-03', 'Nu', 'Ha Noi', 'K12'),
('K1212', 'Le Thi Phi', 'Yen', '1998-05-19', 'Nu', 'TpHCM', 'K12'),
('K1301', 'Nguyen Thi Kim', 'Cuc', '1998-09-18', 'Nu', 'Kien Giang', 'K13'),
('K1302', 'Truong Thi', 'Hen', '1998-09-18', 'Nu', 'Kien Giang', 'K13'),
('K1303', 'Le Duc', 'Hien', '1998-08-24', 'Nam', 'TpHCM', 'K13'),
('K1304', 'Le Quang', 'Hen', '1998-08-18', 'Nam', 'TpHCM', 'K13'),
('K1305', 'Le Minh', 'Tam', '1998-04-23', 'Nam', 'TpHCM', 'K13'),
('K1306', 'Nguyen Thanh', 'Huu', '1998-09-30', 'Nam', 'Ha Noi', 'K13'),
('K1307', 'Tran Thi', 'Hanh', '1998-10-03', 'Nu', 'Nghe An', 'K13'),
('K1308', 'Nguyen Huu', 'Nghia', '1998-08-04', 'Nam', 'Kien Giang', 'K13'),
('K1309', 'Nguyen Trung', 'Hieu', '1998-11-09', 'Nam', 'Nghe An', 'K13'),
('K1310', 'Tran Thi Hong', 'Thanh', '1998-03-22', 'Nu', 'Nghe An', 'K13'),
('K1311', 'Nguyen Thi Thu', 'Hanh', '1998-04-04', 'Nu', 'Nam Dinh', 'K13'),
('K1312', 'Nguyen Thi Kim', 'Yen', '1998-07-19', 'Nu', 'TpHCM', 'K13');

INSERT INTO KETQUATHI (MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES
('K1101', 'CSDL', 1, '2006-07-28', 10.00, 'Dat'),
('K1101', 'CTDLGT', 1, '2006-12-28', 9.00, 'Dat'),
('K1101', 'THDC', 1, '2006-05-20', 9.00, 'Dat'),
('K1101', 'CTRR', 1, '2006-05-13', 9.50, 'Dat'),
('K1102', 'CSDL', 1, '2006-07-28', 4.00, 'Khong Dat'),
('K1102', 'CSDL', 2, '2006-07-27', 4.25, 'Khong Dat'),
('K1102', 'CSDL', 3, '2006-08-10', 4.50, 'Khong Dat'),
('K1102', 'CTDLGT', 1, '2006-12-28', 4.50, 'Khong Dat'),
('K1102', 'CTDLGT', 2, '2007-01-05', 4.00, 'Khong Dat'),
('K1102', 'CTDLGT', 3, '2007-01-15', 6.00, 'Dat'),
('K1102', 'THDC', 1, '2006-05-20', 5.00, 'Dat'),
('K1102', 'CTRR', 1, '2006-05-13', 7.00, 'Dat'),
('K1103', 'CSDL', 1, '2006-07-28', 3.50, 'Khong Dat'),
('K1103', 'CSDL', 2, '2006-07-27', 8.25, 'Dat'),
('K1103', 'CTDLGT', 1, '2006-12-28', 7.00, 'Dat'),
('K1103', 'THDC', 1, '2006-05-20', 8.00, 'Dat'),
('K1103', 'CTRR', 1, '2006-05-13', 6.50, 'Dat'),
('K1104', 'CSDL', 1, '2006-07-28', 3.75, 'Khong Dat'),
('K1104', 'CTDLGT', 1, '2006-12-28', 4.00, 'Khong Dat'),
('K1104', 'THDC', 1, '2006-05-20', 4.00, 'Khong Dat'),
('K1104', 'CTRR', 1, '2006-05-13', 4.00, 'Khong Dat'),
('K1104', 'CTRR', 2, '2006-05-20', 3.50, 'Khong Dat'),
('K1104', 'CTRR', 3, '2006-06-30', 4.00, 'Khong Dat'),
('K1201', 'CSDL', 1, '2006-07-28', 6.00, 'Dat'),
('K1201', 'CTDLGT', 1, '2006-12-28', 5.00, 'Dat'),
('K1201', 'THDC', 1, '2006-05-20', 8.50, 'Dat'),
('K1201', 'CTRR', 1, '2006-05-13', 9.00, 'Dat'),
('K1202', 'CSDL', 1, '2006-07-28', 8.00, 'Dat'),
('K1202', 'CTDLGT', 1, '2006-12-28', 4.00, 'Khong Dat'),
('K1202', 'CTDLGT', 2, '2007-01-05', 5.00, 'Dat'),
('K1202', 'THDC', 1, '2006-05-20', 4.00, 'Khong Dat'),
('K1202', 'THDC', 2, '2006-05-27', 4.00, 'Khong Dat'),
('K1202', 'CTRR', 1, '2006-05-13', 3.00, 'Khong Dat'),
('K1202', 'CTRR', 2, '2006-05-27', 4.00, 'Khong Dat');

-- Insert dữ liệu vào bảng KETQUATHI
INSERT INTO KETQUATHI (MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES
--('K1202', 'CTRR', 2, '2006-05-27', 4.00, 'Khong Dat'),
('K1202', 'CTRR', 3, '2006-06-30', 6.25, 'Dat'),
('K1203', 'CSDL', 1, '2006-07-28', 9.25, 'Dat'),
('K1203', 'CTDLGT', 1, '2006-12-28', 9.50, 'Dat'),
('K1203', 'THDC', 1, '2006-05-20', 10.00, 'Dat'),
('K1203', 'CTRR', 1, '2006-05-13', 10.00, 'Dat'),
('K1204', 'CSDL', 1, '2006-07-28', 8.50, 'Dat'),
('K1204', 'CTDLGT', 1, '2006-12-28', 6.75, 'Dat'),
('K1204', 'THDC', 1, '2006-05-20', 4.00, 'Khong Dat'),
('K1204', 'CTRR', 1, '2006-05-13', 6.00, 'Dat'),
('K1301', 'CSDL', 1, '2006-12-20', 4.25, 'Khong Dat'),
('K1301', 'CTDLGT', 1, '2006-07-25', 8.00, 'Dat'),
('K1301', 'THDC', 1, '2006-05-20', 7.75, 'Dat'),
('K1301', 'CTRR', 1, '2006-05-13', 8.00, 'Dat'),
('K1302', 'CSDL', 1, '2006-12-20', 6.75, 'Dat'),
('K1302', 'CTDLGT', 1, '2006-07-25', 5.00, 'Dat'),
('K1302', 'THDC', 1, '2006-05-20', 8.00, 'Dat'),
('K1302', 'CTRR', 1, '2006-05-13', 8.50, 'Dat'),
('K1303', 'CSDL', 1, '2006-12-20', 4.00, 'Khong Dat'),
('K1303', 'CTDLGT', 1, '2006-07-25', 4.50, 'Khong Dat'),
('K1303', 'CTDLGT', 2, '2006-08-07', 4.00, 'Khong Dat'),
('K1303', 'CTDLGT', 3, '2006-08-15', 4.25, 'Khong Dat'),
('K1303', 'THDC', 1, '2006-05-20', 4.50, 'Khong Dat'),
('K1303', 'CTRR', 1, '2006-05-13', 3.25, 'Khong Dat'),
('K1303', 'CTRR', 2, '2006-05-20', 5.00, 'Dat'),
('K1304', 'CSDL', 1, '2006-12-20', 7.75, 'Dat'),
('K1304', 'CTDLGT', 1, '2006-07-25', 9.75, 'Dat'),
('K1304', 'THDC', 1, '2006-05-20', 5.50, 'Dat'),
('K1304', 'CTRR', 1, '2006-05-13', 5.00, 'Dat'),
('K1305', 'CSDL', 1, '2006-12-20', 9.25, 'Dat'),
('K1305', 'CTDLGT', 1, '2006-07-25', 10.00, 'Dat'),
('K1305', 'THDC', 1, '2006-05-20', 8.00, 'Dat'),
('K1305', 'CTRR', 1, '2006-05-13', 10.00, 'Dat');

-- Insert dữ liệu vào bảng DIEUKIEN
INSERT INTO DIEUKIEN (MAMH, MAMH_TRUOC) VALUES
('CSDL', 'CTRR'),
('CSDL', 'CTDLGT'),
('CTDLGT', 'THDC'),
('PTTKTT', 'THDC'),
('PTTKTT', 'CTDLGT'),
('DHMT', 'THDC'),
('LTHDT', 'THDC'),
('PTTKHTTT', 'CSDL');

-- Insert dữ liệu vào bảng GIANGDAY
INSERT INTO GIANGDAY (MALOP, MAMH, MAGV, HOCKY, NAM, TUNGAY, DENNGAY) VALUES
('K11', 'THDC', 'GV07', 1, 2006, '2006-01-02', '2006-05-12'),
('K12', 'THDC', 'GV06', 1, 2006, '2006-01-02', '2006-05-12'),
('K13', 'THDC', 'GV15', 1, 2006, '2006-01-02', '2006-05-12'),
('K11', 'CTRR', 'GV02', 1, 2006, '2006-01-09', '2006-05-17'),
('K12', 'CTRR', 'GV02', 1, 2006, '2006-01-09', '2006-05-17'),
('K13', 'CTRR', 'GV08', 1, 2006, '2006-01-09', '2006-05-17'),
('K11', 'CSDL', 'GV05', 2, 2006, '2006-06-01', '2006-07-15'),
('K12', 'CSDL', 'GV09', 2, 2006, '2006-06-01', '2006-07-15'),
('K13', 'CTDLGT', 'GV15', 2, 2006, '2006-06-01', '2006-07-15'),
('K13', 'CSDL', 'GV05', 3, 2006, '2006-08-01', '2006-12-15'),
('K13', 'DHMT', 'GV07', 3, 2006, '2006-08-01', '2006-12-15'),
('K11', 'CTDLGT', 'GV15', 3, 2006, '2006-08-01', '2006-12-15'),
('K12', 'CTDLGT', 'GV15', 3, 2006, '2006-08-01', '2006-12-15'),
('K11', 'HDH', 'GV04', 1, 2007, '2007-01-02', '2007-02-18'),
('K12', 'HDH', 'GV04', 1, 2007, '2007-01-02', '2007-03-20'),
('K11', 'DHMT', 'GV07', 1, 2007, '2007-02-18', '2007-03-20');

--Bài tập 4
--Câu 11
alter table HOCVIEN
add constraint CK_HV check (year(getdate())-year(NGSINH) >=18);

--Câu 12
alter table GIANGDAY
add constraint CK_MH check (TUNGAY<DENNGAY);

--Câu 13
alter table GIAOVIEN
add constraint CK_GV check (year(getdate())-year(NGSINH) >=22);

--Câu 14
alter table MONHOC
add constraint CK_TC check (abs(TCLT-TCTH) <=3);

--Bài tập 6
--Câu 1
select HV.MAHV,HV.HO + ' ' + HV.TEN AS HOTEN,HV.NGSINH,HV.MALOP
from HOCVIEN HV
join LOP L on HV.MAHV = L.TRGLOP;

--Câu 2
select HV.MAHV,HV.HO + ' ' + HV.TEN as HOTEN,KQ.LANTHI,KQ.DIEM
from HOCVIEN HV
join KETQUATHI KQ on HV.MAHV = KQ.MAHV
join MONHOC MH on KQ.MAMH = MH.MAMH
where MH.TENMH = 'Cau truc roi rac' and HV.MALOP = 'K12'
order by HV.TEN, HV.HO;

--Câu 3
SELECT HV.MAHV, HV.HO + ' ' + HV.TEN AS HOTEN, MH.TENMH
FROM HOCVIEN HV
INNER JOIN KETQUATHI KQ ON HV.MAHV = KQ.MAHV
INNER JOIN MONHOC MH ON KQ.MAMH = MH.MAMH
WHERE KQ.LANTHI = 1 AND KQ.KQUA = 'Dat';

--Câu 4
SELECT HV.MAHV, HV.HO + ' ' + HV.TEN AS HOTEN
FROM HOCVIEN HV
INNER JOIN KETQUATHI KQ ON HV.MAHV = KQ.MAHV
INNER JOIN MONHOC MH ON KQ.MAMH = MH.MAMH
WHERE HV.MALOP = 'K11' AND MH.TENMH = 'Cau truc roi rac' AND KQ.LANTHI = 1 AND KQ.KQUA = 'Khong Dat';

--Câu 5
SELECT HV.MAHV, HV.HO + ' ' + HV.TEN AS HOTEN
FROM HOCVIEN HV
INNER JOIN KETQUATHI KQ ON HV.MAHV = KQ.MAHV
INNER JOIN MONHOC MH ON KQ.MAMH = MH.MAMH
WHERE HV.MALOP LIKE 'K%' AND MH.TENMH = 'Cau truc roi rac' AND KQ.KQUA = 'Khong Dat'
GROUP BY HV.MAHV, HV.HO, HV.TEN
HAVING COUNT(KQ.MAHV) = (SELECT COUNT(*) FROM KETQUATHI KQ2 WHERE KQ2.MAHV = HV.MAHV AND KQ2.MAMH = 'CTRR');

