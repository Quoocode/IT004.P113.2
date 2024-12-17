--9. Lớp trưởng của một lớp phải là học viên của lớp đó.
CREATE TRIGGER trg_lptrg on LOP
AFTER UPDATE
AS
BEGIN
IF exists (select *
			FROM LOP L
			JOIN HOCVIEN HV ON L.TRGLOP=HV.MAHV
			WHERE L.MALOP!=HV.MALOP)
	BEGIN
	PRINT('Thanh Cong')
	END
ELSE
BEGIN
RAISERROR ('Lop truong phai thuoc lop do',16,1)
ROLLBACK TRANSACTION
END
END

	
--10. Trưởng khoa phải là giáo viên thuộc khoa và có học vị “TS” hoặc “PTS”.
CREATE TRIGGER trg_trgkh on KHOA
AFTER UPDATE
AS
BEGIN
IF exists( SELECT *
		FROM KHOA K
		JOIN GIAOVIEN GV ON K.TRGKHOA=GV.MAGV
		WHERE K.MAKHOA=GV.MAKHOA and GV.HOCVI in('TS','PTS'))
BEGIN
PRINT('Thanh Cong')
END
ELSE
BEGIN
RAISERROR('Giao vien phai thuoc khoa va co hoc vi "TS" hoac "PTS"',16,1)
ROLLBACK TRANSACTION
END
END;

--14. Tất cả các môn học đều có số tín chỉ lý thuyết và tín chỉ thực hành chênh lệch nhau không quá 3.
CREATE  TRIGGER trg_tinchi on MONHOC
AFTER INSERT,UPDATE
AS
BEGIN
IF exists(SELECT*
		FROM inserted, MONHOC
		WHERE inserted.MAMH=MONHOC.MAMH AND (MONHOC.TCLT-MONHOC.TCTH)<=3)
		BEGIN
		PRINT('Thanh Cong')
		END
ELSE
BEGIN
RAISERROR('So tin chi ly thuyet va thuc hanh chenh lech nhau khong qua 3',16,1)
ROLLBACK TRANSACTION
END
END;
--15. Học viên chỉ được thi một môn học nào đó khi lớp của học viên đã học xong môn học này.
CREATE TRIGGER trg_monthi ON KETQUATHI
AFTER INSERT, UPDATE
AS
BEGIN
IF exists (select *
		FROM inserted I
		JOIN HOCVIEN HV on I.MAHV=HV.MAHV
		JOIN GIANGDAY GD on HV.MALOP=GD.MALOP AND I.MAMH=GD.MAMH
		WHERE I.NGTHI<GD.DENNGAY)
		BEGIN 
		RAISERROR(N'Học viên chỉ được thi một môn học nào đó khi lớp của học viên đã học xong môn học này',16,1)
		ROLLBACK TRANSACTION
		END
ELSE
BEGIN
PRINT('Thanh Cong')
END
END;
--16. Mỗi học kỳ của một năm học, một lớp chỉ được học tối đa 3 môn.
CREATE TRIGGER trg_kiemtra_somontoida on GIANGDAY
AFTER INSERT, UPDATE
AS
BEGIN
IF exists(SELECT MALOP, HOCKY, NAM
		FROM GIANGDAY
		GROUP BY MALOP,HOCKY,NAM
		HAVING COUNT(MAMH)>3)
		BEGIN
		RAISERROR(N'Mỗi học kỳ của một năm học, một lớp chỉ được học tối đa 3 môn',16,1)
		ROLLBACK TRANSACTION
		END
ELSE
BEGIN 
PRINT('Thanh Cong')
END
END;
--17. Sỉ số của một lớp bằng với số lượng học viên thuộc lớp đó.
CREATE TRIGGER trg_kiemtra_sisovaslhv ON HOCVIEN
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
UPDATE LOP
SET SISO=(SELECT COUNT(*)
		FROM HOCVIEN HV
		WHERE HV.MALOP=LOP.MALOP)
FROM inserted I
WHERE I.MALOP=LOP.MALOP
UPDATE LOP
SET SISO=(SELECT COUNT(*)
		FROM HOCVIEN HV
		WHERE HV.MALOP=LOP.MALOP)
FROM deleted D
WHERE D.MALOP=LOP.MALOP
PRINT('Si so da duoc cap nhat')
END;

--18. Trong quan hệ DIEUKIEN giá trị của thuộc tính MAMH và MAMH_TRUOC trong cùng một bộ không được giống nhau (“A”,”A”) và cũng không tồn tại hai bộ (“A”,”B”) và (“B”,”A”).
CREATE TRIGGER trg_mamhtruocsau on DIEUKIEN
AFTER INSERT, UPDATE
AS
BEGIN
IF exists(SELECT*
		FROM inserted I
		WHERE MAMH=MAMH_TRUOC)
		BEGIN 
		RAISERROR(N'thuộc tính MAMH và MAMH_TRUOC trong cùng một bộ không được giống nhau (“A”,”A”)',16,1)
		ROLLBACK TRANSACTION
		END
IF exists(SELECT*
		FROM inserted I
		JOIN DIEUKIEN DK ON I.MAMH=DK.MAMH AND I.MAMH_TRUOC=DK.MAMH)
		BEGIN 
		RAISERROR(N'không tồn tại hai bộ (“A”,”B”) và (“B”,”A”)',16,1)
		ROLLBACK TRANSACTION
		END
END;
--19. Các giáo viên có cùng học vị, học hàm, hệ số lương thì mức lương bằng nhau.
CREATE TRIGGER trg_gv_hhhv ON GIAOVIEN
AFTER INSERT,UPDATE
AS
BEGIN
IF exists(SELECT *
		FROM inserted I
		JOIN GIAOVIEN GV ON I.HOCVI=GV.HOCVI AND I.HOCHAM=GV.HOCHAM AND I.HESO=GV.HESO
		WHERE I.MUCLUONG!=GV.MUCLUONG)
		BEGIN 
		RAISERROR(N'Các giáo viên có cùng học vị, học hàm, hệ số lương thì mức lương bằng nhau',16,1)
		ROLLBACK TRANSACTION
		END
ELSE
BEGIN
PRINT('Thanh Cong')
END
END;
--20. Học viên chỉ được thi lại (lần thi >1) khi điểm của lần thi trước đó dưới 5.
CREATE TRIGGER trg_kiemtra_thilai 
ON KETQUATHI
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted I
        JOIN KETQUATHI KQ
        ON I.MAHV = KQ.MAHV AND I.MAMH = KQ.MAMH
        WHERE I.LANTHI > 1 AND KQ.LANTHI = I.LANTHI - 1 AND KQ.DIEM >= 5
    )
    BEGIN
        RAISERROR(N'Học viên chỉ được thi lại khi điểm của lần thi trước dưới 5.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

--21. Ngày thi của lần thi sau phải lớn hơn ngày thi của lần thi trước (cùng học viên, cùng môn học).
CREATE TRIGGER trg_kiemtra_ngaythi 
ON KETQUATHI
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted I
        JOIN KETQUATHI KQ
        ON I.MAHV = KQ.MAHV AND I.MAMH = KQ.MAMH
        WHERE I.LANTHI > 1 
          AND KQ.LANTHI = I.LANTHI - 1 
          AND I.NGTHI <= KQ.NGTHI
    )
    BEGIN
        RAISERROR(N'Ngày thi của lần thi sau phải lớn hơn ngày thi của lần thi trước.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

--22. Khi phân công giảng dạy một môn học, phải xét đến thứ tự trước sau giữa các môn học (sau khi học xong những môn học phải học trước mới được học những môn liền sau).
CREATE TRIGGER trg_kiemtra_dieukien 
ON GIANGDAY
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted I
        JOIN DIEUKIEN DK
        ON I.MAMH = DK.MAMH
        JOIN KETQUATHI KQ
        ON KQ.MAMH = DK.MAMH_TRUOC
        WHERE NOT EXISTS (
            SELECT 1
            FROM KETQUATHI KQ2
            WHERE KQ2.MAHV = KQ.MAHV 
              AND KQ2.MAMH = DK.MAMH_TRUOC 
              AND KQ2.DIEM >= 5
        )
    )
    BEGIN
        RAISERROR(N'Không thể phân công giảng dạy môn học khi chưa học xong môn học điều kiện.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

--23. Giáo viên chỉ được phân công dạy những môn thuộc khoa giáo viên đó phụ trách.
CREATE TRIGGER trg_kiemtra_gv_khoa
ON GIANGDAY
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted I
        JOIN MONHOC MH
        ON I.MAMH = MH.MAMH
        JOIN GIAOVIEN GV
        ON I.MAGV = GV.MAGV
        WHERE GV.MAKHOA != MH.MAKHOA
    )
    BEGIN
        RAISERROR(N'Giáo viên chỉ được phân công dạy những môn thuộc khoa giáo viên phụ trách.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
