CREATE DATABASE QLBH

CREATE TABLE KHACHHANG
(
	MAKH char(4),
	HOTEN varchar(40),
	DCHI varchar(50),
	SODT varchar(20),
	NGSINH smalldatetime,
	DOANHSO money
)

ALTER TABLE KHACHHANG ADD
CONSTRAINT PK_KH PRIMARY KEY (MAKH)

ALTER TABLE KHACHHANG 
ALTER COLUMN MAKH char(4) NOT NULL

alter table KHACHHANG
add LOAIKH tinyint

alter table KHACHHANG
alter column LOAIKH varchar(20)

alter table KHACHHANG
add constraint CK_LOAIKH
check (LOAIKH IN ('Vang lai','Thuong xuyen','Vip'))

alter table KHACHHANG
add NGDK smalldatetime



CREATE TABLE NHANVIEN
(
	MANV char(4) NOT NULL,
	HOTEN varchar(40),
	NGVL smalldatetime,
	SODT varchar(20)
)

ALTER TABLE NHANVIEN ADD
CONSTRAINT PK_NV PRIMARY KEY (MANV)

CREATE TABLE SANPHAM
(
	MASP char(4) NOT NULL,
	TENSP varchar(40),
	DVT varchar(20),
	NUOCSX varchar(40),
	GIA money
)

ALTER TABLE SANPHAM ADD
CONSTRAINT PK_SP PRIMARY KEY (MASP)

alter table SANPHAM
add GHICHU varchar(20)

alter table SANPHAM
alter column GHICHU varchar(100)

alter table SANPHAM
drop column GHICHU

alter table SANPHAM 
add constraint CHK_DVT check (DVT in ('cay','hop','cai','quyen','chuc'))

alter table SANPHAM
add constraint IF_GIA check (GIA >= 500)	

CREATE TABLE HOADON
(
	SOHD int NOT NULL,
	NGHD smalldatetime,
	MAKH char(4), 
	MANV char(4),
	TRIGIA money
)

ALTER TABLE HOADON ADD
CONSTRAINT PK_HD PRIMARY KEY (SOHD)

alter table HOADON add
constraint FK_HD_KH foreign key (MAKH) references KHACHHANG(MAKH),
constraint FK_HD_NV foreign key (MANV) references NHANVIEN(MANV)

CREATE TABLE CTHD
(
	 SOHD int NOT NULL,
	 MASP char(4) NOT NULL,
	 SL int
)

ALTER TABLE CTHD ADD
CONSTRAINT PK_CTHD PRIMARY KEY (SOHD,MASP)

alter table CTHD add
constraint FK_CTHD_SP foreign key (MASP) references SANPHAM(MASP),
constraint FK_CTHD_HOADON foreign key (SOHD) references HOADON(SOHD)

create database QLGV

create table KHOA
(
	MAKHOA varchar(4) primary key,
	TENKHOA varchar(40),
	NGTLAP smalldatetime,
	TRGKHOA char(4)
)

alter table KHOA add
constraint FK_KH_GV foreign key (TRGKHOA) references GIAOVIEN(MAGV)

create table MONHOC
(
	MAMH varchar(10) primary key,
	TENMH varchar(40),
	TCLT tinyint,
	TCTH tinyint,
	MAKHOA varchar(4)
)

alter table MONHOC add
constraint FK_MH_KH foreign key (MAKHOA) references KHOA(MAKHOA)

create table DIEUKIEN
(
	MAMH varchar(10),
	MAMH_TRUOC varchar(10),
	primary key(MAMH,MAMH_TRUOC)
)

alter table DIEUKIEN add
constraint FK_DK_MH foreign key (MAMH) references MONHOC(MAMH),
constraint FK_DK_MHT foreign key (MAMH_TRUOC) references MONHOC(MAMH)

create table GIAOVIEN
(
	MAGV char(4) primary key,
	HOTEN varchar(40),
	HOCVI varchar(10),
	HOCHAM varchar(10),
	GIOITINH varchar(3),
	NGSINH smalldatetime,
	NGVL smalldatetime,
	HESO numeric(4,2),
	MUCLUONG money,
	MAKHOA varchar(4)
)

alter table GIAOVIEN add
constraint FK_GV_KH foreign key (MAKHOA) references KHOA(MAKHOA)

alter table GIAOVIEN add
constraint CHK_GT check ( GIOITINH in ('Nam','Nu'))

alter table GIAOVIEN add
constraint CHK_HOCVI check ( HOCVI in ('CN', 'KS', 'Ths', 'TS', 'PTS'))

create table LOP
(
	MALOP char(3) primary key,
	TENLOP varchar(40),
	TRGLOP char(5),
	SISO tinyint,
	MAGVCN char(4)
)

alter table LOP add
constraint FK_LOP_HV foreign key (TRGLOP) references HOCVIEN(MAHV),
constraint FK_LOP_GV foreign key (MAGVCN) references GIAOVIEN(MAGV)

create table HOCVIEN
(
	MAHV char(5) primary key,
	HO varchar(40),
	TEN varchar(10),
	NGSINH smalldatetime,
	GIOITINH varchar(3),
	NOISINH varchar(40),
	MALOP char(3)
)

alter table HOCVIEN add
constraint FK_HV_LOP foreign key (MALOP) references LOP(MALOP)

alter table HOCVIEN add
GHICHU varchar(100),
DIEMTB numeric(4,2),
XEPLOAI varchar(10)

alter table HOCVIEN add
constraint CHK_HV check ( GIOITINH in ('Nam','Nu'))

create table GIANGDAY
(
	MALOP char(3),
	MAMH varchar(10),
	primary key(MALOP,MAMH),
	MAGV char(4),
	HOCKY tinyint,
	NAM smallint,
	TUNGAY smalldatetime,
	DENNGAY smalldatetime
)

alter table GIANGDAY add
constraint check_hocky check ( HOCKY between 1 and 3)

alter table GIANGDAY add
constraint FK_GD_LOP foreign key (MALOP) references LOP(MALOP),
constraint FK_GD_MH foreign key (MAMH) references MONHOC(MAMH),
constraint FK_GD_GV foreign key (MAGV) references GIAOVIEN(MAGV)

create table KETQUATHI
(
	MAHV char(5),
	MAMH varchar(10),
	LANTHI tinyint,
	primary key(MAHV,MAMH,LANTHI),
	NGTHI smalldatetime,
	DIEM numeric(4,2),
	KQUA varchar(10)
)

alter table KETQUATHI add
constraint FK_KQT_HV foreign key (MAHV) references HOCVIEN(MAHV),
constraint FK_KQT_MH foreign key (MAMH) references MONHOC(MAMH)

alter table KETQUATHI add
constraint DK_DIEM check ( DIEM>=0 and DIEM<=10)

CREATE TRIGGER TRG_UPDATE_KQUA
ON KETQUATHI
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE KETQUATHI
    SET KQUA = CASE 
                  WHEN inserted.DIEM >= 5 THEN 'Dat' 
                  ELSE 'Khong dat' 
               END
    FROM inserted
    WHERE KETQUATHI.MAHV = inserted.MAHV
      AND KETQUATHI.MAMH = inserted.MAMH
      AND KETQUATHI.LANTHI = inserted.LANTHI;
END;

alter table KETQUATHI add 
constraint check_lanthi check ( LANTHI <=3 and LANTHI>0)


	







