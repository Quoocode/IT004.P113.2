-- Câu hỏi và ví dụ về Triggers (101-110)

-- 101. Tạo một trigger để tự động cập nhật trường NgayCapNhat trong bảng ChuyenGia mỗi khi có sự thay đổi thông tin.
ALTER TABLE ChuyenGia ADD NgayCapNhat DATE;

CREATE TRIGGER trg_UpdateNgayCapNhat
ON ChuyenGia
AFTER UPDATE
AS
BEGIN
    -- Cập nhật trường NgayCapNhat thành ngày hiện tại
    UPDATE ChuyenGia
    SET NgayCapNhat = GETDATE()
    WHERE MaChuyenGia IN (SELECT DISTINCT MaChuyenGia FROM Inserted);
END;




-- 102. Tạo một trigger để ghi log mỗi khi có sự thay đổi trong bảng DuAn.

CREATE TABLE LogDuAn (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    MaDuAn INT,                        
    TenDuAn NVARCHAR(200),              
    ThaoTac NVARCHAR(50),               
    ThoiGian DATETIME DEFAULT GETDATE(),
    NguoiThucHien NVARCHAR(100) NULL    
);
CREATE TRIGGER trg_LogDuAn
ON DuAn
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    -- Ghi log cho thao tác INSERT
    IF EXISTS (SELECT 1 FROM Inserted) AND NOT EXISTS (SELECT 1 FROM Deleted)
    BEGIN
        INSERT INTO LogDuAn (MaDuAn, TenDuAn, ThaoTac, ThoiGian)
        SELECT MaDuAn, TenDuAn, 'INSERT', GETDATE()
        FROM Inserted;
    END;

    -- Ghi log cho thao tác UPDATE
    IF EXISTS (SELECT 1 FROM Inserted) AND EXISTS (SELECT 1 FROM Deleted)
    BEGIN
        INSERT INTO LogDuAn (MaDuAn, TenDuAn, ThaoTac, ThoiGian)
        SELECT i.MaDuAn, i.TenDuAn, 'UPDATE', GETDATE()
        FROM Inserted i;
    END;

    -- Ghi log cho thao tác DELETE
    IF EXISTS (SELECT 1 FROM Deleted) AND NOT EXISTS (SELECT 1 FROM Inserted)
    BEGIN
        INSERT INTO LogDuAn (MaDuAn, TenDuAn, ThaoTac, ThoiGian)
        SELECT d.MaDuAn, d.TenDuAn, 'DELETE', GETDATE()
        FROM Deleted d;
    END;
END;


-- 103. Tạo một trigger để đảm bảo rằng một chuyên gia không thể tham gia vào quá 5 dự án cùng một lúc.
CREATE TRIGGER trg_CheckProjectLimit
ON ChuyenGia_DuAn
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM (
            SELECT i.MaChuyenGia, COUNT(cd.MaDuAn) + COUNT(i.MaDuAn) AS TotalProjects
            FROM ChuyenGia_DuAn cd
            RIGHT JOIN Inserted i ON cd.MaChuyenGia = i.MaChuyenGia
            GROUP BY i.MaChuyenGia
            HAVING COUNT(cd.MaDuAn) + COUNT(i.MaDuAn) > 5
        ) AS ProjectCheck
    )
    BEGIN
        RAISERROR (N'Một chuyên gia không thể tham gia vào quá 5 dự án cùng một lúc.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
    INSERT INTO ChuyenGia_DuAn (MaChuyenGia, MaDuAn, VaiTro, NgayThamGia)
    SELECT MaChuyenGia, MaDuAn, VaiTro, NgayThamGia
    FROM Inserted;
END;


-- 104. Tạo một trigger để tự động cập nhật số lượng nhân viên trong bảng CongTy mỗi khi có sự thay đổi trong bảng ChuyenGia.
CREATE TRIGGER trg_UpdateEmployeeCount
ON ChuyenGia
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Inserted) AND NOT EXISTS (SELECT 1 FROM Deleted)
    BEGIN
        UPDATE CongTy
        SET SoNhanVien = SoNhanVien + 1
        WHERE MaCongTy IN (
            SELECT DISTINCT MaCongTy
            FROM ChuyenGia c
            JOIN Inserted i ON c.MaChuyenGia = i.MaChuyenGia
        );
    END;
    IF EXISTS (SELECT 1 FROM Deleted) AND NOT EXISTS (SELECT 1 FROM Inserted)
    BEGIN
        UPDATE CongTy
        SET SoNhanVien = SoNhanVien - 1
        WHERE MaCongTy IN (
            SELECT DISTINCT MaCongTy
            FROM ChuyenGia c
            JOIN Deleted d ON c.MaChuyenGia = d.MaChuyenGia
        );
    END;
    IF EXISTS (SELECT 1 FROM Inserted) AND EXISTS (SELECT 1 FROM Deleted)
    BEGIN
        UPDATE CongTy
        SET SoNhanVien = SoNhanVien - 1
        WHERE MaCongTy IN (
            SELECT DISTINCT MaCongTy
            FROM ChuyenGia c
            JOIN Deleted d ON c.MaChuyenGia = d.MaChuyenGia
        );
        UPDATE CongTy
        SET SoNhanVien = SoNhanVien + 1
        WHERE MaCongTy IN (
            SELECT DISTINCT MaCongTy
            FROM ChuyenGia c
            JOIN Inserted i ON c.MaChuyenGia = i.MaChuyenGia
        );
    END;
END;


-- 105. Tạo một trigger để ngăn chặn việc xóa các dự án đã hoàn thành.
CREATE TRIGGER trg_PreventDeleteCompletedProjects
ON DuAn
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Deleted d
        WHERE d.TrangThai = N'Hoàn thành'
    )
    BEGIN
        RAISERROR (N'Không thể xóa các dự án đã hoàn thành.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
    DELETE FROM DuAn
    WHERE MaDuAn IN (SELECT MaDuAn FROM Deleted);
END;


-- 106. Tạo một trigger để tự động cập nhật cấp độ kỹ năng của chuyên gia khi họ tham gia vào một dự án mới.
CREATE TRIGGER trg_UpdateSkillLevelOnNewProject
ON ChuyenGia_DuAn
AFTER INSERT
AS
BEGIN
    -- Tăng cấp độ kỹ năng cho chuyên gia khi tham gia dự án mới
    UPDATE ChuyenGia_KyNang
    SET CapDo = CASE 
                   WHEN CapDo < 5 THEN CapDo + 1 -- Cấp độ tối đa là 5
                   ELSE CapDo -- Giữ nguyên nếu đã đạt cấp độ tối đa
               END
    WHERE MaChuyenGia IN (SELECT MaChuyenGia FROM Inserted)
      AND MaKyNang IN (
            SELECT MaKyNang 
            FROM ChuyenGia_KyNang 
            WHERE MaChuyenGia IN (SELECT MaChuyenGia FROM Inserted)
        );
END;


-- 107. Tạo một trigger để ghi log mỗi khi có sự thay đổi cấp độ kỹ năng của chuyên gia.
CREATE TABLE SkillLevelLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    MaChuyenGia INT,
    MaKyNang INT,
    OldCapDo INT,
    NewCapDo INT,
    NgayThayDoi DATETIME DEFAULT GETDATE()
);

CREATE TRIGGER trg_LogSkillLevelChange
ON ChuyenGia_KyNang
AFTER UPDATE
AS
BEGIN
    INSERT INTO SkillLevelLog (MaChuyenGia, MaKyNang, OldCapDo, NewCapDo)
    SELECT 
        i.MaChuyenGia,
        i.MaKyNang,
        d.CapDo AS OldCapDo,
        i.CapDo AS NewCapDo
    FROM Inserted i
    INNER JOIN Deleted d
        ON i.MaChuyenGia = d.MaChuyenGia AND i.MaKyNang = d.MaKyNang
    WHERE i.CapDo <> d.CapDo;
END;


-- 108. Tạo một trigger để đảm bảo rằng ngày kết thúc của dự án luôn lớn hơn ngày bắt đầu.
CREATE TRIGGER trg_ValidateProjectDates
ON DuAn
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Inserted
        WHERE NgayKetThuc <= NgayBatDau
    )
    BEGIN
        RAISERROR (N'Ngày kết thúc phải lớn hơn ngày bắt đầu.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;


-- 109. Tạo một trigger để tự động xóa các bản ghi liên quan trong bảng ChuyenGia_KyNang khi một kỹ năng bị xóa.
CREATE TRIGGER trg_DeleteSkillDependencies
ON KyNang
AFTER DELETE
AS
BEGIN
    DELETE FROM ChuyenGia_KyNang
    WHERE MaKyNang IN (SELECT MaKyNang FROM Deleted);
END;


-- 110. Tạo một trigger để đảm bảo rằng một công ty không thể có quá 10 dự án đang thực hiện cùng một lúc.
CREATE TRIGGER trg_LimitActiveProjectsPerCompany
ON DuAn
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @MaCongTy INT;
    SELECT @MaCongTy = MaCongTy FROM Inserted;
    IF (SELECT COUNT(*) FROM DuAn WHERE MaCongTy = @MaCongTy AND TrangThai = N'Đang thực hiện') > 10
    BEGIN
        RAISERROR (N'Công ty không thể có quá 10 dự án đang thực hiện cùng một lúc.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;


-- Câu hỏi và ví dụ về Triggers bổ sung (123-135)

-- 123. Tạo một trigger để tự động cập nhật lương của chuyên gia dựa trên cấp độ kỹ năng và số năm kinh nghiệm.\
ALTER TABLE ChuyenGia
ADD Luong INT;

CREATE TRIGGER trg_UpdateSalaryBasedOnSkillsAndExperience
ON ChuyenGia_KyNang
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @MaChuyenGia INT, @CapDo INT, @NamKinhNghiem INT;
    DECLARE @LuongBase INT, @LuongSkillAdjustment INT, @LuongExperienceAdjustment INT;
    
    -- Lấy thông tin chuyên gia từ bảng Inserted (dữ liệu vừa thay đổi)
    SELECT @MaChuyenGia = MaChuyenGia, @CapDo = CapDo
    FROM Inserted;
    
    -- Lấy số năm kinh nghiệm của chuyên gia từ bảng Chuyên gia
    SELECT @NamKinhNghiem = NamKinhNghiem
    FROM ChuyenGia
    WHERE MaChuyenGia = @MaChuyenGia;
    
    -- Xác định mức lương cơ bản (Ví dụ: 10 triệu đồng)
    SET @LuongBase = 10000000; -- 10 triệu đồng
    
    -- Tính lương dựa trên cấp độ kỹ năng (Ví dụ: mỗi cấp độ kỹ năng tăng thêm 1 triệu đồng)
    SET @LuongSkillAdjustment = @CapDo * 1000000; -- Cấp độ kỹ năng từ 1 đến 5
    
    -- Tính lương dựa trên số năm kinh nghiệm (Ví dụ: mỗi năm kinh nghiệm tăng thêm 500k đồng)
    SET @LuongExperienceAdjustment = @NamKinhNghiem * 500000; -- Mỗi năm kinh nghiệm thêm 500k
    
    -- Tính tổng lương
    DECLARE @TotalSalary INT;
    SET @TotalSalary = @LuongBase + @LuongSkillAdjustment + @LuongExperienceAdjustment;
    
    -- Cập nhật lương của chuyên gia trong bảng Chuyên gia
    UPDATE ChuyenGia
    SET Luong = @TotalSalary
    WHERE MaChuyenGia = @MaChuyenGia;
END;


-- 124. Tạo một trigger để tự động gửi thông báo khi một dự án sắp đến hạn (còn 7 ngày).

-- Tạo bảng ThongBao nếu chưa có
CREATE TABLE ThongBao (
    MaThongBao INT IDENTITY(1,1) PRIMARY KEY,
    MaDuAn INT,
    NoiDung NVARCHAR(255),
    NgayThongBao DATETIME,
    DaDoc BIT DEFAULT 0,
    FOREIGN KEY (MaDuAn) REFERENCES DuAn(MaDuAn)
);

CREATE TRIGGER NotifyProjectDeadline
ON DuAn
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @MaDuAn INT, @NgayKetThuc DATE, @NgayThongBao DATETIME;
    
    -- Lấy thông tin từ bảng inserted
    SELECT @MaDuAn = MaDuAn, @NgayKetThuc = NgayKetThuc FROM inserted;

    -- Kiểm tra nếu ngày kết thúc còn 7 ngày
    IF DATEDIFF(DAY, GETDATE(), @NgayKetThuc) = 7
    BEGIN
        -- Tạo thông báo vào bảng ThongBao
        SET @NgayThongBao = GETDATE();
        INSERT INTO ThongBao (MaDuAn, NoiDung, NgayThongBao)
        VALUES (@MaDuAn, N'Dự án sắp đến hạn, chỉ còn 7 ngày để hoàn thành.', @NgayThongBao);
    END
END;


-- 125. Tạo một trigger để ngăn chặn việc xóa hoặc cập nhật thông tin của chuyên gia đang tham gia dự án.
CREATE TRIGGER PreventDeleteOrUpdateChuyenGia
ON ChuyenGia
AFTER DELETE, UPDATE
AS
BEGIN
    DECLARE @MaChuyenGia INT;
    
    -- Kiểm tra các thao tác xóa (DELETE) và cập nhật (UPDATE)
    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        SELECT @MaChuyenGia = MaChuyenGia FROM deleted;
        
        -- Kiểm tra nếu chuyên gia đang tham gia vào dự án
        IF EXISTS (SELECT 1 FROM ChuyenGia_DuAn WHERE MaChuyenGia = @MaChuyenGia)
        BEGIN
            -- Nếu chuyên gia đang tham gia vào dự án, ngừng xóa hoặc cập nhật và thông báo lỗi
            RAISERROR(N'Không thể xóa hoặc cập nhật thông tin chuyên gia vì đang tham gia vào một dự án.', 16, 1);
            ROLLBACK TRANSACTION;
        END
    END

    -- Kiểm tra nếu thao tác là cập nhật (UPDATE)
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        SELECT @MaChuyenGia = MaChuyenGia FROM inserted;
        
        -- Kiểm tra nếu chuyên gia đang tham gia vào dự án
        IF EXISTS (SELECT 1 FROM ChuyenGia_DuAn WHERE MaChuyenGia = @MaChuyenGia)
        BEGIN
            -- Nếu chuyên gia đang tham gia vào dự án, ngừng xóa hoặc cập nhật và thông báo lỗi
            RAISERROR(N'Không thể xóa hoặc cập nhật thông tin chuyên gia vì đang tham gia vào một dự án.', 16, 1);
            ROLLBACK TRANSACTION;
        END
    END
END;


-- 126. Tạo một trigger để tự động cập nhật số lượng chuyên gia trong mỗi chuyên ngành.

-- Tạo bảng ThongKeChuyenNganh nếu chưa có
CREATE TRIGGER UpdateSoLuongChuyenGia
ON ChuyenGia
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @ChuyenNganh NVARCHAR(50);
    
    -- Cập nhật số lượng chuyên gia khi có thêm chuyên gia mới (INSERT)
    IF EXISTS (SELECT 1 FROM inserted)
    BEGIN
        -- Lấy chuyên ngành của các chuyên gia mới được thêm vào
        SELECT @ChuyenNganh = ChuyenNganh FROM inserted;
        
        -- Kiểm tra xem chuyên ngành đã có trong bảng thống kê chưa
        IF EXISTS (SELECT 1 FROM ThongKeChuyenNganh WHERE ChuyenNganh = @ChuyenNganh)
        BEGIN
            -- Cập nhật số lượng chuyên gia trong chuyên ngành
            UPDATE ThongKeChuyenNganh
            SET SoLuongChuyenGia = SoLuongChuyenGia + 1
            WHERE ChuyenNganh = @ChuyenNganh;
        END
        ELSE
        BEGIN
            -- Nếu chuyên ngành chưa có trong bảng thống kê, thêm mới
            INSERT INTO ThongKeChuyenNganh (ChuyenNganh, SoLuongChuyenGia)
            VALUES (@ChuyenNganh, 1);
        END
    END

    -- Cập nhật số lượng chuyên gia khi có chuyên gia bị xóa (DELETE)
    IF EXISTS (SELECT 1 FROM deleted)
    BEGIN
        -- Lấy chuyên ngành của các chuyên gia bị xóa
        SELECT @ChuyenNganh = ChuyenNganh FROM deleted;
        
        -- Cập nhật số lượng chuyên gia trong chuyên ngành
        UPDATE ThongKeChuyenNganh
        SET SoLuongChuyenGia = SoLuongChuyenGia - 1
        WHERE ChuyenNganh = @ChuyenNganh;
    END

    -- Cập nhật số lượng chuyên gia khi có chuyên gia bị thay đổi chuyên ngành (UPDATE)
    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        -- Lấy chuyên ngành cũ và mới của chuyên gia
        DECLARE @OldChuyenNganh NVARCHAR(50);
        DECLARE @NewChuyenNganh NVARCHAR(50);
        
        SELECT @OldChuyenNganh = ChuyenNganh FROM deleted;
        SELECT @NewChuyenNganh = ChuyenNganh FROM inserted;

        -- Nếu chuyên ngành thay đổi, cập nhật số lượng cho chuyên ngành cũ và mới
        IF @OldChuyenNganh <> @NewChuyenNganh
        BEGIN
            -- Giảm số lượng chuyên gia trong chuyên ngành cũ
            UPDATE ThongKeChuyenNganh
            SET SoLuongChuyenGia = SoLuongChuyenGia - 1
            WHERE ChuyenNganh = @OldChuyenNganh;
            
            -- Tăng số lượng chuyên gia trong chuyên ngành mới
            IF EXISTS (SELECT 1 FROM ThongKeChuyenNganh WHERE ChuyenNganh = @NewChuyenNganh)
            BEGIN
                UPDATE ThongKeChuyenNganh
                SET SoLuongChuyenGia = SoLuongChuyenGia + 1
                WHERE ChuyenNganh = @NewChuyenNganh;
            END
            ELSE
            BEGIN
                INSERT INTO ThongKeChuyenNganh (ChuyenNganh, SoLuongChuyenGia)
                VALUES (@NewChuyenNganh, 1);
            END
        END
    END
END;

-- 127. Tạo một trigger để tự động tạo bản sao lưu của dự án khi nó được đánh dấu là hoàn thành.

-- Tạo bảng DuAnHoanThanh nếu chưa có
CREATE TABLE DuAnHoanThanh (
    MaDuAn INT PRIMARY KEY,
    TenDuAn NVARCHAR(200),
    MaCongTy INT,
    NgayBatDau DATE,
    NgayKetThuc DATE,
    TrangThai NVARCHAR(50),
    NgayHoanThanh DATE
);
CREATE TRIGGER BackupDuAnKhiHoanThanh
ON DuAn
AFTER UPDATE
AS
BEGIN
    -- Kiểm tra xem dự án có được đánh dấu là "Hoàn thành" không
    IF EXISTS (SELECT 1 FROM inserted WHERE TrangThai = N'Hoàn thành')
    BEGIN
        -- Sao lưu dữ liệu của dự án vào bảng DuAnHoanThanh
        INSERT INTO DuAnHoanThanh (MaDuAn, TenDuAn, MaCongTy, NgayBatDau, NgayKetThuc, TrangThai, NgayHoanThanh)
        SELECT MaDuAn, TenDuAn, MaCongTy, NgayBatDau, NgayKetThuc, TrangThai, GETDATE()
        FROM inserted
        WHERE TrangThai = N'Hoàn thành';
    END
END;



-- 128. Tạo một trigger để tự động cập nhật điểm đánh giá trung bình của công ty dựa trên điểm đánh giá của các dự án.

ALTER TABLE CongTy
ADD DiemDanhGiaTrungBinh DECIMAL(3, 2);

ALTER TABLE DuAn
ADD DiemDanhGia DECIMAL(3, 2);  


CREATE TRIGGER UpdateDiemDanhGiaTrungBinh
ON DuAn
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @MaCongTy INT;

    -- Lấy mã công ty của các dự án bị thay đổi
    IF EXISTS (SELECT 1 FROM inserted)
    BEGIN
        SELECT @MaCongTy = MaCongTy FROM inserted;
    END
    ELSE IF EXISTS (SELECT 1 FROM deleted)
    BEGIN
        SELECT @MaCongTy = MaCongTy FROM deleted;
    END

    -- Tính điểm đánh giá trung bình của công ty
    DECLARE @DiemTrungBinh DECIMAL(3, 2);
    
    SELECT @DiemTrungBinh = AVG(DiemDanhGia)
    FROM DuAn
    WHERE MaCongTy = @MaCongTy AND DiemDanhGia IS NOT NULL;

    -- Cập nhật điểm đánh giá trung bình của công ty
    UPDATE CongTy
    SET DiemDanhGiaTrungBinh = @DiemTrungBinh
    WHERE MaCongTy = @MaCongTy;
END;

-- 129. Tạo một trigger để tự động phân công chuyên gia vào dự án dựa trên kỹ năng và kinh nghiệm.
-- Bảng phân công chuyên gia vào dự án
CREATE TRIGGER AutoAssignChuyenGiaToDuAn
ON DuAn
AFTER INSERT
AS
BEGIN
    DECLARE @MaDuAn INT, @MaCongTy INT, @ChuyenNganhDuAn NVARCHAR(50);
    DECLARE @MaChuyenGia INT, @CapDo INT, @NamKinhNghiem INT, @ChuyenNganhChuyenGia NVARCHAR(50);
    
    -- Lấy thông tin dự án mới từ bảng DuAn
    SELECT @MaDuAn = MaDuAn, @MaCongTy = MaCongTy
    FROM inserted;
    
    -- Lấy thông tin LinhVuc (Chuyên ngành) từ bảng CongTy dựa trên MaCongTy
    SELECT @ChuyenNganhDuAn = LinhVuc
    FROM CongTy
    WHERE MaCongTy = @MaCongTy;
    
    -- Lấy thông tin chuyên gia đủ điều kiện phân công dựa trên kỹ năng và kinh nghiệm
    DECLARE ChuyenGiaCursor CURSOR FOR
    SELECT c.MaChuyenGia, cgk.CapDo, c.NamKinhNghiem, c.ChuyenNganh
    FROM ChuyenGia c
    JOIN ChuyenGia_KyNang cgk ON c.MaChuyenGia = cgk.MaChuyenGia
    JOIN KyNang k ON cgk.MaKyNang = k.MaKyNang
    WHERE k.LoaiKyNang = @ChuyenNganhDuAn  -- Chuyên gia có kỹ năng phù hợp với dự án
    AND c.NamKinhNghiem >= 3  -- Giả sử yêu cầu có ít nhất 3 năm kinh nghiệm
    AND cgk.CapDo >= 4  -- Chuyên gia có cấp độ kỹ năng >= 4
    ORDER BY c.NamKinhNghiem DESC, cgk.CapDo DESC;  -- Sắp xếp theo kinh nghiệm và cấp độ kỹ năng
    
    OPEN ChuyenGiaCursor;
    FETCH NEXT FROM ChuyenGiaCursor INTO @MaChuyenGia, @CapDo, @NamKinhNghiem, @ChuyenNganhChuyenGia;
    
    -- Phân công chuyên gia vào dự án
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Thêm chuyên gia vào dự án
        INSERT INTO ChuyenGia_DuAn (MaChuyenGia, MaDuAn, VaiTro, NgayThamGia)
        VALUES (@MaChuyenGia, @MaDuAn, N'Chuyên gia', GETDATE());  -- Vai trò mặc định là 'Chuyên gia'
        
        FETCH NEXT FROM ChuyenGiaCursor INTO @MaChuyenGia, @CapDo, @NamKinhNghiem, @ChuyenNganhChuyenGia;
    END
    
    CLOSE ChuyenGiaCursor;
    DEALLOCATE ChuyenGiaCursor;
END;




-- 130. Tạo một trigger để tự động cập nhật trạng thái "bận" của chuyên gia khi họ được phân công vào dự án mới.
ALTER TABLE ChuyenGia
ADD TrangThai NVARCHAR(20) DEFAULT N'Rảnh';  

CREATE TRIGGER UpdateChuyenGiaStatus
ON ChuyenGia_DuAn
AFTER INSERT
AS
BEGIN
    DECLARE @MaChuyenGia INT;

    -- Lấy mã chuyên gia từ bảng inserted (các bản ghi mới được thêm vào bảng ChuyenGia_DuAn)
    SELECT @MaChuyenGia = MaChuyenGia
    FROM inserted;

    -- Cập nhật trạng thái của chuyên gia thành "Bận" khi họ được phân công vào dự án
    UPDATE ChuyenGia
    SET TrangThai = N'Bận'
    WHERE MaChuyenGia = @MaChuyenGia;
END;


-- 131. Tạo một trigger để ngăn chặn việc thêm kỹ năng trùng lặp cho một chuyên gia.
CREATE TRIGGER PreventDuplicateSkill
ON ChuyenGia_KyNang
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @MaChuyenGia INT, @MaKyNang INT;

    -- Lấy thông tin từ bảng inserted (bảng chứa các bản ghi mới được thêm vào)
    SELECT @MaChuyenGia = MaChuyenGia, @MaKyNang = MaKyNang
    FROM inserted;

    -- Kiểm tra nếu chuyên gia đã có kỹ năng này rồi
    IF EXISTS (SELECT 1 FROM ChuyenGia_KyNang WHERE MaChuyenGia = @MaChuyenGia AND MaKyNang = @MaKyNang)
    BEGIN
        -- Nếu có, thông báo lỗi và ngừng việc thêm dữ liệu
        RAISERROR('Kỹ năng này đã được thêm cho chuyên gia!', 16, 1);
    END
    ELSE
    BEGIN
        -- Nếu không có, thực hiện thêm dữ liệu vào bảng ChuyenGia_KyNang
        INSERT INTO ChuyenGia_KyNang (MaChuyenGia, MaKyNang, CapDo)
        SELECT MaChuyenGia, MaKyNang, CapDo
        FROM inserted;
    END
END;



-- 132. Tạo một trigger để tự động tạo báo cáo tổng kết khi một dự án kết thúc.
CREATE TABLE BaoCaoTongKet (
    MaBaoCao INT IDENTITY(1,1) PRIMARY KEY,
    MaDuAn INT,
    TenDuAn NVARCHAR(200),
    MaCongTy INT,
    NgayHoanThanh DATE,
    SoLuongChuyenGia INT,
    MoTa NVARCHAR(500),
    FOREIGN KEY (MaDuAn) REFERENCES DuAn(MaDuAn),
    FOREIGN KEY (MaCongTy) REFERENCES CongTy(MaCongTy)
);

CREATE TRIGGER CreateReportOnProjectCompletion
ON DuAn
AFTER UPDATE
AS
BEGIN
    DECLARE @MaDuAn INT, @TenDuAn NVARCHAR(200), @MaCongTy INT, @NgayKetThuc DATE;

    -- Lấy thông tin từ bảng inserted (bảng chứa các bản ghi đã được cập nhật)
    SELECT @MaDuAn = MaDuAn, @TenDuAn = TenDuAn, @MaCongTy = MaCongTy, @NgayKetThuc = NgayKetThuc
    FROM inserted;

    -- Kiểm tra nếu trạng thái của dự án là 'Hoàn thành'
    IF EXISTS (SELECT 1 FROM inserted WHERE TrangThai = N'Hoàn thành')
    BEGIN
        -- Tạo báo cáo tổng kết cho dự án
        INSERT INTO BaoCaoTongKet (MaDuAn, TenDuAn, MaCongTy, NgayHoanThanh, SoLuongChuyenGia, MoTa)
        SELECT 
            @MaDuAn, 
            @TenDuAn, 
            @MaCongTy, 
            @NgayKetThuc, 
            (SELECT COUNT(*) FROM ChuyenGia_DuAn WHERE MaDuAn = @MaDuAn), 
            N'Dự án đã hoàn thành, tất cả các mục tiêu đã được thực hiện thành công.'; -- Mô tả có thể tùy chỉnh thêm
    END
END;


-- 133. Tạo một trigger để tự động cập nhật thứ hạng của công ty dựa trên số lượng dự án hoàn thành và điểm đánh giá.
ALTER TABLE CongTy
ADD ThuHang INT;

CREATE TRIGGER UpdateCompanyRanking
ON DuAn
AFTER UPDATE
AS
BEGIN
    DECLARE @MaCongTy INT, @TrangThaiDuAn NVARCHAR(50);

    -- Lấy thông tin từ bảng inserted (bảng chứa các bản ghi đã được cập nhật)
    SELECT @MaCongTy = MaCongTy, @TrangThaiDuAn = TrangThai
    FROM inserted;

    -- Kiểm tra nếu trạng thái của dự án là 'Hoàn thành'
    IF EXISTS (SELECT 1 FROM inserted WHERE TrangThai = N'Hoàn thành')
    BEGIN
        -- Cập nhật thứ hạng của công ty dựa trên số lượng dự án hoàn thành và điểm đánh giá
        DECLARE @SoLuongDuAnHoanThanh INT, @DiemDanhGia DECIMAL(5,2);

        -- Lấy số lượng dự án hoàn thành và điểm đánh giá của công ty
        SELECT 
            @SoLuongDuAnHoanThanh = COUNT(*)
        FROM DuAn
        WHERE MaCongTy = @MaCongTy AND TrangThai = N'Hoàn thành';

        SELECT @DiemDanhGia = AVG(DiemDanhGia) 
        FROM DuAn 
        WHERE MaCongTy = @MaCongTy AND TrangThai = N'Hoàn thành';

        -- Cập nhật thứ hạng của công ty
        -- Cách tính thứ hạng có thể tùy chỉnh theo yêu cầu, ví dụ: thứ hạng là tổng của số lượng dự án hoàn thành và điểm đánh giá.
        UPDATE CongTy
        SET ThuHang = ( @SoLuongDuAnHoanThanh * 10 + @DiemDanhGia )  -- Ví dụ: trọng số cho số lượng dự án và điểm đánh giá
        WHERE MaCongTy = @MaCongTy;
    END
END;


-- 133. (tiếp tục) Tạo một trigger để tự động cập nhật thứ hạng của công ty dựa trên số lượng dự án hoàn thành và điểm đánh giá.


-- 134. Tạo một trigger để tự động gửi thông báo khi một chuyên gia được thăng cấp (dựa trên số năm kinh nghiệm).
CREATE TABLE ThongBaoThangCap (
    MaThongBao INT IDENTITY(1,1) PRIMARY KEY,
    MaChuyenGia INT,
    NoiDung NVARCHAR(500),
    NgayThongBao DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (MaChuyenGia) REFERENCES ChuyenGia(MaChuyenGia)
);
CREATE TRIGGER SendUpgradeNotification
ON ChuyenGia
AFTER UPDATE
AS
BEGIN
    DECLARE @MaChuyenGia INT, @NamKinhNghiemCu INT, @NamKinhNghiemMoi INT, @ThongBao NVARCHAR(500);

    -- Lấy MaChuyenGia và NamKinhNghiem cũ và mới từ bảng inserted và deleted
    SELECT @MaChuyenGia = MaChuyenGia, @NamKinhNghiemCu = NamKinhNghiem
    FROM deleted;

    SELECT @NamKinhNghiemMoi = NamKinhNghiem
    FROM inserted;

    -- Kiểm tra nếu số năm kinh nghiệm của chuyên gia tăng
    IF @NamKinhNghiemMoi > @NamKinhNghiemCu
    BEGIN
        -- Tạo nội dung thông báo
        SET @ThongBao = N'Chuyên gia ' + (SELECT HoTen FROM ChuyenGia WHERE MaChuyenGia = @MaChuyenGia) + 
                        N' đã được thăng cấp với số năm kinh nghiệm mới là ' + CAST(@NamKinhNghiemMoi AS NVARCHAR) + N' năm.';
        
        -- Gửi thông báo vào bảng ThongBao
        INSERT INTO ThongBaoThangCap (MaChuyenGia, NoiDung)
        VALUES (@MaChuyenGia, @ThongBao);
    END
END;


-- 135. Tạo một trigger để tự động cập nhật trạng thái "khẩn cấp" cho dự án khi thời gian còn lại ít hơn 10% tổng thời gian dự án.
CREATE TRIGGER UpdateProjectStatusToEmergency
ON DuAn
AFTER UPDATE
AS
BEGIN
    DECLARE @MaDuAn INT, @NgayBatDau DATE, @NgayKetThuc DATE, @TrangThai NVARCHAR(50), @HienTai DATE;
    DECLARE @TongThoiGian INT, @ThoiGianConLai INT, @TienTrinh INT;

    -- Lấy thông tin dự án từ bảng inserted
    SELECT @MaDuAn = MaDuAn, 
           @NgayBatDau = NgayBatDau, 
           @NgayKetThuc = NgayKetThuc, 
           @TrangThai = TrangThai
    FROM inserted;

    -- Lấy ngày hiện tại
    SET @HienTai = GETDATE();

    -- Tính tổng thời gian và thời gian còn lại
    SET @TongThoiGian = DATEDIFF(DAY, @NgayBatDau, @NgayKetThuc);
    SET @ThoiGianConLai = DATEDIFF(DAY, @HienTai, @NgayKetThuc);

    -- Tính tỷ lệ thời gian còn lại
    SET @TienTrinh = (@ThoiGianConLai * 100) / @TongThoiGian;

    -- Nếu thời gian còn lại ít hơn 10% tổng thời gian, cập nhật trạng thái thành "khẩn cấp"
    IF @TienTrinh < 10 AND @TrangThai <> N'Khẩn cấp'
    BEGIN
        UPDATE DuAn
        SET TrangThai = N'Khẩn cấp'
        WHERE MaDuAn = @MaDuAn;
    END
END;


-- 136. Tạo một trigger để tự động cập nhật số lượng dự án đang thực hiện của mỗi chuyên gia.
ALTER TABLE ChuyenGia
ADD SoLuongDuAn INT DEFAULT 0;

CREATE TRIGGER UpdateProjectCountForExpert
ON ChuyenGia_DuAn
AFTER INSERT, DELETE
AS
BEGIN
    -- Khai báo biến để lưu mã chuyên gia
    DECLARE @MaChuyenGia INT;

    -- Cập nhật số lượng dự án cho chuyên gia sau khi thêm một dự án
    IF EXISTS (SELECT 1 FROM inserted)
    BEGIN
        SELECT @MaChuyenGia = MaChuyenGia FROM inserted;
        UPDATE ChuyenGia
        SET SoLuongDuAn = (SELECT COUNT(*) 
                           FROM ChuyenGia_DuAn 
                           WHERE MaChuyenGia = @MaChuyenGia AND TrangThai = 'Đang thực hiện')
        WHERE MaChuyenGia = @MaChuyenGia;
    END

    -- Cập nhật số lượng dự án cho chuyên gia sau khi xóa một dự án
    IF EXISTS (SELECT 1 FROM deleted)
    BEGIN
        SELECT @MaChuyenGia = MaChuyenGia FROM deleted;
        UPDATE ChuyenGia
        SET SoLuongDuAn = (SELECT COUNT(*) 
                           FROM ChuyenGia_DuAn 
                           WHERE MaChuyenGia = @MaChuyenGia AND TrangThai = 'Đang thực hiện')
        WHERE MaChuyenGia = @MaChuyenGia;
    END
END;


-- 137. Tạo một trigger để tự động tính toán và cập nhật tỷ lệ thành công của công ty dựa trên số dự án hoàn thành và tổng số dự án.
ALTER TABLE CongTy
ADD TyLeThanhCong DECIMAL(5,2) DEFAULT 0.00;
CREATE TRIGGER UpdateSuccessRateForCompany
ON DuAn
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @MaCongTy INT;
    DECLARE @SoDuAnHoanThanh INT;
    DECLARE @SoDuAnTong INT;
    DECLARE @TyLeThanhCong DECIMAL(5,2);

    -- Lấy mã công ty từ bảng inserted (dự án mới thêm vào) hoặc deleted (dự án bị xóa)
    IF EXISTS (SELECT 1 FROM inserted)
    BEGIN
        SELECT @MaCongTy = MaCongTy FROM inserted;
    END
    ELSE IF EXISTS (SELECT 1 FROM deleted)
    BEGIN
        SELECT @MaCongTy = MaCongTy FROM deleted;
    END

    -- Tính số lượng dự án hoàn thành và tổng số dự án của công ty
    SELECT @SoDuAnHoanThanh = COUNT(*) 
    FROM DuAn
    WHERE MaCongTy = @MaCongTy AND TrangThai = N'Hoàn thành';

    SELECT @SoDuAnTong = COUNT(*) 
    FROM DuAn
    WHERE MaCongTy = @MaCongTy;

    -- Tính tỷ lệ thành công
    IF @SoDuAnTong > 0
    BEGIN
        SET @TyLeThanhCong = (CAST(@SoDuAnHoanThanh AS DECIMAL(5,2)) / @SoDuAnTong) * 100;
    END
    ELSE
    BEGIN
        SET @TyLeThanhCong = 0;
    END

    -- Cập nhật tỷ lệ thành công của công ty
    UPDATE CongTy
    SET TyLeThanhCong = @TyLeThanhCong
    WHERE MaCongTy = @MaCongTy;
END;

-- 138. Tạo một trigger để tự động ghi log mỗi khi có thay đổi trong bảng lương của chuyên gia.
CREATE TABLE LuongLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    MaChuyenGia INT,
    OldLuong DECIMAL(18, 2) NULL,
    NewLuong DECIMAL(18, 2) NULL,
    ThoiGian DATETIME DEFAULT GETDATE(),
    HanhDong NVARCHAR(50) -- Mô tả hành động: Insert, Update, Delete
);
CREATE TRIGGER LogLuongChange
ON ChuyenGia
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @MaChuyenGia INT;
    DECLARE @OldLuong DECIMAL(18, 2);
    DECLARE @NewLuong DECIMAL(18, 2);
    DECLARE @HanhDong NVARCHAR(50);

    -- Kiểm tra hành động Insert
    IF EXISTS (SELECT 1 FROM inserted)
    BEGIN
        -- Lấy thông tin của chuyên gia vừa được thêm vào
        SELECT @MaChuyenGia = MaChuyenGia, @NewLuong = Luong FROM inserted;
        SET @HanhDong = N'Insert';

        -- Ghi log
        INSERT INTO LuongLog (MaChuyenGia, OldLuong, NewLuong, HanhDong)
        VALUES (@MaChuyenGia, NULL, @NewLuong, @HanhDong);
    END

    -- Kiểm tra hành động Update
    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        -- Lấy thông tin trước và sau khi cập nhật
        SELECT @MaChuyenGia = MaChuyenGia, @OldLuong = Luong FROM deleted;
        SELECT @NewLuong = Luong FROM inserted;
        SET @HanhDong = N'Update';

        -- Ghi log
        INSERT INTO LuongLog (MaChuyenGia, OldLuong, NewLuong, HanhDong)
        VALUES (@MaChuyenGia, @OldLuong, @NewLuong, @HanhDong);
    END

    -- Kiểm tra hành động Delete
    IF EXISTS (SELECT 1 FROM deleted)
    BEGIN
        -- Lấy thông tin của chuyên gia bị xóa
        SELECT @MaChuyenGia = MaChuyenGia, @OldLuong = Luong FROM deleted;
        SET @HanhDong = N'Delete';

        -- Ghi log
        INSERT INTO LuongLog (MaChuyenGia, OldLuong, NewLuong, HanhDong)
        VALUES (@MaChuyenGia, @OldLuong, NULL, @HanhDong);
    END
END;

-- 139. Tạo một trigger để tự động cập nhật số lượng chuyên gia cấp cao trong mỗi công ty.
CREATE TABLE SoLuongChuyenGiaCapCao (
    MaCongTy INT PRIMARY KEY,
    SoLuong INT DEFAULT 0,
    FOREIGN KEY (MaCongTy) REFERENCES CongTy(MaCongTy)
);




-- 140. Tạo một trigger để tự động cập nhật trạng thái "cần bổ sung nhân lực" cho dự án khi số lượng chuyên gia tham gia ít hơn yêu cầu.


