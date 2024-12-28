-- Câu hỏi SQL từ cơ bản đến nâng cao, bao gồm trigger

-- Cơ bản:
--1. Liệt kê tất cả chuyên gia trong cơ sở dữ liệu.
SELECT * FROM CHUYENGIA
--2. Hiển thị tên và email của các chuyên gia nữ.
SELECT HOTEN, EMAIL
FROM CHUYENGIA
WHERE GIOITINH=N'Nữ'
--3. Liệt kê các công ty có trên 100 nhân viên.
SELECT TENCONGTY
FROM CONGTY
WHERE SONHANVIEN>100
--4. Hiển thị tên và ngày bắt đầu của các dự án trong năm 2023.
SELECT TENDUAN, DAY(NGAYBATDAU)
FROM DUAN
WHERE YEAR(NGAYBATDAU)=2023

-- Trung cấp:
--6. Liệt kê tên chuyên gia và số lượng dự án họ tham gia.
SELECT * FROM CHUYENGIA
SELECT * FROM DUAN
SELECT * FROM CHUYENGIA_DUAN
SELECT CG.HOTEN,COUNT(CGDA.MADUAN) AS SODUAN
FROM CHUYENGIA CG
JOIN CHUYENGIA_DUAN CGDA ON CG.MACHUYENGIA=CGDA.MACHUYENGIA
GROUP BY CG.HOTEN

--7. Tìm các dự án có sự tham gia của chuyên gia có kỹ năng 'Python' cấp độ 4 trở lên.

SELECT DISTINCT DA.TENDUAN
FROM DUAN DA
JOIN CHUYENGIA_DUAN CGDA ON DA.MADUAN=CGDA.MADUAN
JOIN CHUYENGIA_KYNANG CGKN ON CGDA.MACHUYENGIA=CGKN.MACHUYENGIA
WHERE CGKN.CAPDO>=4

--8. Hiển thị tên công ty và số lượng dự án đang thực hiện.
SELECT CT.TENCONGTY, COUNT(DA.MADUAN) AS SOLUONGDUAN
FROM CONGTY CT
JOIN DUAN DA ON CT.MACONGTY=DA.MACONGTY
GROUP BY CT.TENCONGTY

--9. Tìm chuyên gia có số năm kinh nghiệm cao nhất trong mỗi chuyên ngành.
SELECT MACHUYENGIA,CHUYENNGANH,NAMKINHNGHIEM
FROM CHUYENGIA
ORDER BY NAMKINHNGHIEM DESC


--10. Liệt kê các cặp chuyên gia đã từng làm việc cùng nhau trong ít nhất một dự án.
SELECT CG1.MACHUYENGIA,CG1.HOTEN,CG2.MACHUYENGIA,CG2.HOTEN
FROM (SELECT CG.MACHUYENGIA,CG.HOTEN,CGDA.MADUAN
	FROM CHUYENGIA CG
	JOIN CHUYENGIA_DUAN CGDA ON CG.MACHUYENGIA=CGDA.MACHUYENGIA)AS CG1
JOIN (SELECT CG.MACHUYENGIA,CG.HOTEN,CGDA.MADUAN
	FROM CHUYENGIA CG
	JOIN CHUYENGIA_DUAN CGDA ON CG.MACHUYENGIA=CGDA.MACHUYENGIA)AS CG2 ON CG1.MADUAN=CG2.MADUAN
WHERE CG1.MACHUYENGIA<CG2.MACHUYENGIA

-- Nâng cao:
--11. Tính tổng thời gian (theo ngày) mà mỗi chuyên gia đã tham gia vào các dự án.
SELECT 
    CG.MACHUYENGIA, 
    CG.HOTEN, 
    SUM(DATEDIFF(DAY, DA.NGAYBATDAU, DA.NGAYKETTHUC)) AS TONG_THOIGIAN
FROM 
    CHUYENGIA CG
JOIN 
    CHUYENGIA_DUAN CGDA ON CG.MACHUYENGIA = CGDA.MACHUYENGIA
JOIN 
	DUAN DA ON CGDA.MADUAN=DA.MADUAN
GROUP BY 
    CG.MACHUYENGIA, CG.HOTEN;

--12. Tìm các công ty có tỷ lệ dự án hoàn thành cao nhất (trên 90%).
SELECT 
    ct.MaCongTy,
    ct.TenCongTy,
    COUNT(da.MaDuAn) AS TongDuAn,
    SUM(CASE WHEN da.TrangThai = N'Hoàn thành' THEN 1 ELSE 0 END) AS SoDuAnHoanThanh,
    (CAST(SUM(CASE WHEN da.TrangThai = N'Hoàn thành' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(da.MaDuAn)) * 100 AS TyLeHoanThanh
FROM 
    CongTy ct
LEFT JOIN 
    DuAn da ON ct.MaCongTy = da.MaCongTy
GROUP BY 
    ct.MaCongTy, ct.TenCongTy
HAVING 
    (CAST(SUM(CASE WHEN da.TrangThai = N'Hoàn thành' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(da.MaDuAn)) * 100 > 90;

--13. Liệt kê top 3 kỹ năng được yêu cầu nhiều nhất trong các dự án.

SELECT TOP 3
    kn.MaKyNang,
    kn.TenKyNang,
    COUNT(ck.MaKyNang) AS SoLanYeuCau
FROM 
    KyNang kn
JOIN 
    ChuyenGia_KyNang ck ON kn.MaKyNang = ck.MaKyNang
GROUP BY 
    kn.MaKyNang, kn.TenKyNang
ORDER BY 
    SoLanYeuCau DESC;


--14. Tính lương trung bình của chuyên gia theo từng cấp độ kinh nghiệm (Junior: 0-2 năm, Middle: 3-5 năm, Senior: >5 năm).

SELECT 
    CASE 
        WHEN NamKinhNghiem BETWEEN 0 AND 2 THEN 'Junior'
        WHEN NamKinhNghiem BETWEEN 3 AND 5 THEN 'Middle'
        WHEN NamKinhNghiem > 5 THEN 'Senior'
    END AS ExperienceLevel,
    AVG(Luong) AS AverageSalary
FROM 
    ChuyenGia
GROUP BY 
    CASE 
        WHEN NamKinhNghiem BETWEEN 0 AND 2 THEN 'Junior'
        WHEN NamKinhNghiem BETWEEN 3 AND 5 THEN 'Middle'
        WHEN NamKinhNghiem > 5 THEN 'Senior'
    END;


--15. Tìm các dự án có sự tham gia của chuyên gia từ tất cả các chuyên ngành.
SELECT TENDUAN
FROM DUAN DA
WHERE NOT EXISTS(SELECT *
				FROM CHUYENGIA CG
				WHERE NOT EXISTS(SELECT*
								FROM CHUYENGIA_DUAN CGDA
								WHERE CG.MACHUYENGIA=CGDA.MACHUYENGIA AND CGDA.MADUAN=DA.MADUAN))
								
-- Trigger:
--16. Tạo một trigger để tự động cập nhật số lượng dự án của công ty khi thêm hoặc xóa dự án.
ALTER TABLE CongTy ADD SOLUONGDUAN INT DEFAULT 0;

CREATE TRIGGER TRG_CAPNHATDUAN ON DUAN
FOR INSERT
AS
BEGIN
UPDATE CONGTY
SET SOLUONGDUAN = SOLUONGDUAN + (SELECT COUNT(MADUAN)
								FROM inserted I
								WHERE I.MACONGTY=CONGTY.MACONGTY)
FROM inserted I
WHERE CONGTY.MACONGTY=I.MACONGTY
END;

CREATE TRIGGER TRG_XOADUAN ON DUAN
FOR DELETE
AS
BEGIN
UPDATE CONGTY
SET SOLUONGDUAN = SOLUONGDUAN - (SELECT COUNT(MADUAN)
								FROM deleted D
								WHERE D.MACONGTY=CONGTY.MACONGTY)
FROM deleted D
WHERE CONGTY.MACONGTY=D.MACONGTY
END;
--17. Tạo một trigger để ghi log mỗi khi có sự thay đổi trong bảng ChuyenGia.
CREATE TABLE LogChuyenGia (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    HanhDong NVARCHAR(10),  -- Loại hành động: INSERT, UPDATE, DELETE
    MaChuyenGia INT,
    HoTen NVARCHAR(100),
    NgaySinh DATE,
    GioiTinh NVARCHAR(10),
    Email NVARCHAR(100),
    SoDienThoai NVARCHAR(20),
    ChuyenNganh NVARCHAR(50),
    NamKinhNghiem INT,
    ThoiGianThayDoi DATETIME DEFAULT GETDATE()  -- Thời gian thay đổi
);
CREATE TRIGGER TRG_Log_ChuyenGia_INSERT
ON ChuyenGia
AFTER INSERT
AS
BEGIN
    INSERT INTO LogChuyenGia (HanhDong, MaChuyenGia, HoTen, NgaySinh, GioiTinh, Email, SoDienThoai, ChuyenNganh, NamKinhNghiem)
    SELECT 'INSERT', MaChuyenGia, HoTen, NgaySinh, GioiTinh, Email, SoDienThoai, ChuyenNganh, NamKinhNghiem
    FROM inserted;
END;

CREATE TRIGGER TRG_Log_ChuyenGia_UPDATE
ON ChuyenGia
AFTER UPDATE
AS
BEGIN
    INSERT INTO LogChuyenGia (HanhDong, MaChuyenGia, HoTen, NgaySinh, GioiTinh, Email, SoDienThoai, ChuyenNganh, NamKinhNghiem)
    SELECT 'UPDATE', MaChuyenGia, HoTen, NgaySinh, GioiTinh, Email, SoDienThoai, ChuyenNganh, NamKinhNghiem
    FROM inserted;
END;

CREATE TRIGGER TRG_Log_ChuyenGia_DELETE
ON ChuyenGia
AFTER DELETE
AS
BEGIN
    INSERT INTO LogChuyenGia (HanhDong, MaChuyenGia, HoTen, NgaySinh, GioiTinh, Email, SoDienThoai, ChuyenNganh, NamKinhNghiem)
    SELECT 'DELETE', MaChuyenGia, HoTen, NgaySinh, GioiTinh, Email, SoDienThoai, ChuyenNganh, NamKinhNghiem
    FROM deleted;
END;




--18. Tạo một trigger để đảm bảo rằng một chuyên gia không thể tham gia vào quá 5 dự án cùng một lúc.
CREATE TRIGGER TRG_TGDA ON CHUYENGIA_DUAN
FOR INSERT, UPDATE
AS
BEGIN
IF EXISTS (SELECT * 
		FROM (SELECT CG.MACHUYENGIA, COUNT(CGDA.MADUAN)AS DUANTHAMGIA
			FROM CHUYENGIA CG
			JOIN CHUYENGIA_DUAN CGDA ON CG.MACHUYENGIA=CGDA.MACHUYENGIA
			GROUP BY CG.MACHUYENGIA) AS TEMP
		WHERE TEMP.DUANTHAMGIA>5)
		BEGIN 
		RAISERROR('LOI',16,1)
		ROLLBACK TRANSACTION
		END
ELSE 
BEGIN
PRINT('THANH CONG')
END
END;
--19. Tạo một trigger để tự động cập nhật trạng thái của dự án thành 'Hoàn thành' khi tất cả chuyên gia đã kết thúc công việc.

CREATE TRIGGER TRG_TUDONGCAPNHAT ON CHUYENGIA
FOR UPDATE
AS
BEGIN
IF NOT EXISTS(SELECT 1
			FROM inserted I
			JOIN CHUYENGIA CG ON I.MACHUYENGIA=CG.MACHUYENGIA
			WHERE CG.TrangThai <> N'Hoàn thành' AND I.TrangThai <> N'Hoàn thành')
			BEGIN 
			UPDATE DUAN
			SET TrangThai = N'Hoàn thành'
			END
END

--20. Tạo một trigger để tự động tính toán và cập nhật điểm đánh giá trung bình của công ty dựa trên điểm đánh giá của các dự án.
CREATE TRIGGER TRG_CAPNHATDIEMDANHGIA ON DUAN
FOR INSERT, UPDATE, DELETE
AS
BEGIN
    -- Cập nhật điểm đánh giá trung bình của công ty sau khi thêm hoặc sửa dự án
    DECLARE @MaCongTy INT;
    
    -- Cập nhật điểm đánh giá trung bình của công ty khi thêm dự án mới
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        SELECT @MaCongTy = MaCongTy FROM inserted;
    END
    -- Cập nhật điểm đánh giá trung bình của công ty khi xóa dự án
    ELSE IF EXISTS (SELECT * FROM deleted)
    BEGIN
        SELECT @MaCongTy = MaCongTy FROM deleted;
    END
    
    -- Tính toán điểm đánh giá trung bình của công ty
    DECLARE @DiemTrungBinh FLOAT;
    
    SELECT @DiemTrungBinh = AVG(DiemDanhGia)
    FROM DUAN
    WHERE MaCongTy = @MaCongTy;
    
    -- Cập nhật điểm đánh giá trung bình cho công ty
    UPDATE CONGTY
    SET DiemDanhGiaTrungBinh = @DiemTrungBinh
    WHERE MaCongTy = @MaCongTy;
END;


