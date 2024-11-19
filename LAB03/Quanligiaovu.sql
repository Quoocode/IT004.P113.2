--1. Tìm danh sách các giáo viên có mức lương cao nhất trong mỗi khoa, kèm theo tên khoa và hệ
--số lương.
SELECT 
    GV.MAGV,
    GV.HOTEN,
    GV.MUCLUONG,
    GV.HESO,
    KH.TENKHOA
FROM 
    GIAOVIEN GV
JOIN 
    KHOA KH ON GV.MAKHOA = KH.MAKHOA
WHERE 
    GV.MUCLUONG = (
        SELECT MAX(MUCLUONG)
        FROM GIAOVIEN GV2
        WHERE GV2.MAKHOA = GV.MAKHOA
    );
--2. Liệt kê danh sách các học viên có điểm trung bình cao nhất trong mỗi lớp, kèm theo tên lớp và
--mã lớp.
WITH DiemTrungBinh AS (
    SELECT 
        HV.MAHV,
        HV.HO,
        HV.TEN,
        HV.MALOP,
        L.TENLOP,
        AVG(KQT.DIEM) AS DIEM_TB
    FROM 
        HOCVIEN HV
    JOIN 
        KETQUATHI KQT ON HV.MAHV = KQT.MAHV
    JOIN 
        LOP L ON HV.MALOP = L.MALOP
    GROUP BY 
        HV.MAHV, HV.HO, HV.TEN, HV.MALOP, L.TENLOP
)
SELECT 
    DTB.MAHV,
    DTB.HO,
    DTB.TEN,
    DTB.MALOP,
    DTB.TENLOP,
    DTB.DIEM_TB
FROM 
    DiemTrungBinh DTB
WHERE 
    DTB.DIEM_TB = (
        SELECT MAX(DIEM_TB)
        FROM DiemTrungBinh DTB2
        WHERE DTB2.MALOP = DTB.MALOP
    );
--3. Tính tổng số tiết lý thuyết (TCLT) và thực hành (TCTH) mà mỗi giáo viên đã giảng dạy trong
--năm học 2023, sắp xếp theo tổng số tiết từ cao xuống thấp.
SELECT 
    GV.MAGV,
    GV.HOTEN,
    SUM(MH.TCLT) AS TONG_TCLT,
    SUM(MH.TCTH) AS TONG_TCTH,
    (SUM(MH.TCLT) + SUM(MH.TCTH)) AS TONG_TONG_TIET
FROM 
    GIANGDAY GD
JOIN 
    MONHOC MH ON GD.MAMH = MH.MAMH
JOIN 
    GIAOVIEN GV ON GD.MAGV = GV.MAGV
WHERE 
    GD.NAM = 2023
GROUP BY 
    GV.MAGV, GV.HOTEN
ORDER BY 
    TONG_TONG_TIET DESC;
--4. Tìm những học viên thi cùng một môn học nhiều hơn 2 lần nhưng chưa bao giờ đạt điểm trên
--7, kèm theo mã học viên và mã môn học.
SELECT 
    KQT.MAHV,
    KQT.MAMH
FROM 
    KETQUATHI KQT
GROUP BY 
    KQT.MAHV, KQT.MAMH
HAVING 
    COUNT(KQT.LANTHI) > 2
    AND MAX(KQT.DIEM) <= 7;
--5. Xác định những giáo viên đã giảng dạy ít nhất 3 môn học khác nhau trong cùng một năm học,
--kèm theo năm học và số lượng môn giảng dạy.
SELECT 
    GD.MAGV,
    GV.HOTEN,
    GD.NAM,
    COUNT(DISTINCT GD.MAMH) AS SO_LUONG_MON
FROM 
    GIANGDAY GD
JOIN 
    GIAOVIEN GV ON GD.MAGV = GV.MAGV
GROUP BY 
    GD.MAGV, GV.HOTEN, GD.NAM
HAVING 
    COUNT(DISTINCT GD.MAMH) >= 3;
--6. Tìm những học viên có sinh nhật trùng với ngày thành lập của khoa mà họ đang theo học, kèm
--theo tên khoa và ngày sinh của học viên.
SELECT 
    HV.HO + ' ' + HV.TEN AS HOTEN,
    KHOA.TENKHOA,
    HV.NGSINH
FROM 
    HOCVIEN HV
JOIN 
    LOP L ON HV.MALOP = L.MALOP
JOIN 
    GIAOVIEN GV ON L.MAGVCN = GV.MAGV
JOIN 
    KHOA ON GV.MAKHOA = KHOA.MAKHOA
WHERE 
    DAY(HV.NGSINH) = DAY(KHOA.NGTLAP)
    AND MONTH(HV.NGSINH) = MONTH(KHOA.NGTLAP)
ORDER BY 
    HV.HO, HV.TEN;

--7. Liệt kê các môn học không có điều kiện tiên quyết (không yêu cầu môn học trước), kèm theo
--mã môn và tên môn học.
SELECT 
    MH.MAMH,
    MH.TENMH
FROM 
    MONHOC MH
LEFT JOIN 
    DIEUKIEN DK ON MH.MAMH = DK.MAMH
WHERE 
    DK.MAMH_TRUOC IS NULL;
--8. Tìm danh sách các giáo viên dạy nhiều môn học nhất trong học kỳ 1 năm 2006, kèm theo số
--lượng môn học mà họ đã dạy.
SELECT 
    GD.MAGV,
    GV.HOTEN,
    COUNT(DISTINCT GD.MAMH) AS SO_LUONG_MON
FROM 
    GIANGDAY GD
JOIN 
    GIAOVIEN GV ON GD.MAGV = GV.MAGV
WHERE 
    GD.HOCKY = 1 AND GD.NAM = 2006
GROUP BY 
    GD.MAGV, GV.HOTEN
HAVING 
    COUNT(DISTINCT GD.MAMH) = (
        SELECT MAX(SO_LUONG)
        FROM (
            SELECT 
                COUNT(DISTINCT GD2.MAMH) AS SO_LUONG
            FROM 
                GIANGDAY GD2
            WHERE 
                GD2.HOCKY = 1 AND GD2.NAM = 2006
            GROUP BY 
                GD2.MAGV
        ) AS MAX_MON
    );
--9. Tìm những giáo viên đã dạy cả môn “Co So Du Lieu” và “Cau Truc Roi Rac” trong cùng một
--học kỳ, kèm theo học kỳ và năm học.
SELECT 
    GD.MAGV,
    GV.HOTEN,
    GD.HOCKY,
    GD.NAM
FROM 
    GIANGDAY GD
JOIN 
    GIAOVIEN GV ON GD.MAGV = GV.MAGV
JOIN 
    MONHOC MH ON GD.MAMH = MH.MAMH
WHERE 
    MH.TENMH IN ('Co So Du Lieu', 'Cau Truc Roi Rac')
GROUP BY 
    GD.MAGV, GV.HOTEN, GD.HOCKY, GD.NAM
HAVING 
    COUNT(DISTINCT MH.TENMH) = 2;
--10. Liệt kê danh sách các môn học mà tất cả các giáo viên trong khoa “CNTT” đều đã giảng dạy ít
--nhất một lần trong năm 2006
SELECT 
    MH.MAMH,
    MH.TENMH
FROM 
    MONHOC MH
JOIN 
    GIANGDAY GD ON MH.MAMH = GD.MAMH
JOIN 
    GIAOVIEN GV ON GD.MAGV = GV.MAGV
JOIN 
    KHOA KH ON GV.MAKHOA = KH.MAKHOA
WHERE 
    KH.TENKHOA = 'CNTT'
    AND GD.NAM = 2006
GROUP BY 
    MH.MAMH, MH.TENMH
HAVING 
    COUNT(DISTINCT GD.MAGV) = (SELECT COUNT(DISTINCT MAGV) 
                                FROM GIAOVIEN 
                                WHERE MAKHOA = (SELECT MAKHOA FROM KHOA WHERE TENKHOA = 'CNTT'));
--11. Tìm những giáo viên có hệ số lương cao hơn mức lương trung bình của tất cả giáo viên trong
--khoa của họ, kèm theo tên khoa và hệ số lương của giáo viên đó.
SELECT 
    GV.HOTEN AS TenGiaoVien,
    KH.TENKHOA AS TenKhoa,
    GV.HESO AS HeSoLuong
FROM 
    GIAOVIEN GV
JOIN 
    KHOA KH ON GV.MAKHOA = KH.MAKHOA
WHERE 
    GV.HESO > (
        SELECT 
            AVG(GV2.HESO) 
        FROM 
            GIAOVIEN GV2
        WHERE 
            GV2.MAKHOA = GV.MAKHOA
    )
--12. Xác định những lớp có sĩ số lớn hơn 40 nhưng không có giáo viên nào dạy quá 2 môn trong
--học kỳ 1 năm 2006, kèm theo tên lớp và sĩ số.
SELECT 
    L.TENLOP, 
    L.SISO
FROM 
    LOP L
WHERE 
    L.SISO > 40 
    AND NOT EXISTS (
        SELECT 
            1
        FROM 
            GIANGDAY GD
        WHERE 
            GD.MALOP = L.MALOP
            AND GD.HOCKY = 1
            AND GD.NAM = 2006
        GROUP BY 
            GD.MAGV
        HAVING 
            COUNT(GD.MAMH) > 2
    )
--13. Tìm những môn học mà tất cả các học viên của lớp “K11” đều đạt điểm trên 7 trong lần thi
--cuối cùng của họ, kèm theo mã môn và tên môn học.
SELECT 
    MH.MAMH, 
    MH.TENMH
FROM 
    MONHOC MH
WHERE 
    NOT EXISTS (
        SELECT 
            1
        FROM 
            KETQUATHI KQ
        JOIN 
            HOCVIEN HV ON KQ.MAHV = HV.MAHV
        WHERE 
            HV.MALOP = 'K11' 
            AND KQ.MAMH = MH.MAMH
            AND KQ.DIEM <= 7
            AND KQ.LANTHI = (
                SELECT MAX(LANTHI) 
                FROM KETQUATHI 
                WHERE MAHV = KQ.MAHV AND MAMH = KQ.MAMH
            )
    )
--14. Liệt kê danh sách các giáo viên đã dạy ít nhất một môn học trong mỗi học kỳ của năm 2006,
--kèm theo mã giáo viên và số lượng học kỳ mà họ đã giảng dạy.
SELECT 
    GD.MAGV, 
    COUNT(DISTINCT GD.HOCKY) AS SoLuongHocKy
FROM 
    GIANGDAY GD
WHERE 
    GD.NAM = 2006
GROUP BY 
    GD.MAGV
HAVING 
    COUNT(DISTINCT GD.HOCKY) = 3
--15. Tìm những giáo viên vừa là trưởng khoa vừa giảng dạy ít nhất 2 môn khác nhau trong năm
--2006, kèm theo tên khoa và mã giáo viên.
SELECT 
    GV.HOTEN AS TenGiaoVien, 
    GV.MAGV, 
    KH.TENKHOA
FROM 
    GIAOVIEN GV
JOIN 
    KHOA KH ON GV.MAKHOA = KH.MAKHOA
WHERE 
    GV.MAGV IN (
        SELECT MAGV
        FROM GIAOVIEN
        WHERE TRGKHOA = MAGV
    )
AND 
    GV.MAGV IN (
        SELECT GD.MAGV
        FROM GIANGDAY GD
        WHERE GD.NAM = 2006
        GROUP BY GD.MAGV
        HAVING COUNT(DISTINCT GD.MAMH) >= 2
    )
--16. Xác định những môn học mà tất cả các lớp do giáo viên chủ nhiệm “Nguyen To Lan” đều phải
--học trong năm 2006, kèm theo mã lớp và tên lớp.
SELECT 
    L.MALOP, 
    L.TENLOP
FROM 
    LOP L
JOIN 
    GIAOVIEN GV ON L.MAGVCN = GV.MAGV
WHERE 
    GV.HOTEN = 'Nguyen To Lan'
    AND L.MALOP IN (
        SELECT 
            GD.MALOP
        FROM 
            GIANGDAY GD
        JOIN 
            MONHOC MH ON GD.MAMH = MH.MAMH
        WHERE 
            GD.NAM = 2006
        GROUP BY 
            GD.MALOP
        HAVING 
            COUNT(DISTINCT GD.MAMH) = (
                SELECT COUNT(DISTINCT GD2.MAMH)
                FROM 
                    GIANGDAY GD2
                WHERE 
                    GD2.MALOP = GD.MALOP AND GD2.NAM = 2006
            )
    )
--17. Liệt kê danh sách các môn học mà không có điều kiện tiên quyết (không cần phải học trước
--bất kỳ môn nào), nhưng lại là điều kiện tiên quyết cho ít nhất 2 môn khác nhau, kèm theo mã môn và
--tên môn học.
SELECT 
    MH.MAMH, 
    MH.TENMH
FROM 
    MONHOC MH
WHERE 
    MH.MAMH NOT IN (
        SELECT 
            DK.MAMH
        FROM 
            DIEUKIEN DK
    )
    AND MH.MAMH IN (
        SELECT 
            DK.MAMH_TRUOC
        FROM 
            DIEUKIEN DK
        GROUP BY 
            DK.MAMH_TRUOC
        HAVING 
            COUNT(DK.MAMH) >= 2
    )
--18. Tìm những học viên (mã học viên, họ tên) thi không đạt môn CSDL ở lần thi thứ 1 nhưng
--chưa thi lại môn này và cũng chưa thi bất kỳ môn nào khác sau lần đó.
SELECT 
    HV.MAHV, 
    HV.HO + ' ' + HV.TEN AS HOTEN
FROM 
    HOCVIEN HV
JOIN 
    KETQUATHI KQ ON HV.MAHV = KQ.MAHV
JOIN 
    MONHOC MH ON KQ.MAMH = MH.MAMH
WHERE 
    MH.TENMH = 'CSDL' 
    AND KQ.LANTHI = 1 
    AND KQ.DIEM < 5
    AND NOT EXISTS (
        SELECT 1
        FROM KETQUATHI KQ2
        WHERE KQ2.MAHV = HV.MAHV
        AND KQ2.MAMH = 'CSDL'
        AND KQ2.LANTHI > 1
    )
    AND NOT EXISTS (
        SELECT 1
        FROM KETQUATHI KQ3
        WHERE KQ3.MAHV = HV.MAHV
        AND KQ3.LANTHI > 1
        AND KQ3.DIEM >= 0
    )
--19. Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào
--trong năm 2006, nhưng đã từng giảng dạy trước đó
SELECT 
    GV.MAGV, 
    GV.HOTEN
FROM 
    GIAOVIEN GV
WHERE 
    GV.MAGV NOT IN (
        SELECT GD.MAGV
        FROM GIANGDAY GD
        WHERE GD.NAM = 2006
    )
    AND GV.MAGV IN (
        SELECT GD.MAGV
        FROM GIANGDAY GD
        WHERE GD.NAM < 2006
    )
--20. Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào
--thuộc khoa giáo viên đó phụ trách trong năm 2006, nhưng đã từng giảng dạy các môn khác của khoa
--khác.
SELECT 
    GV.MAGV, 
    GV.HOTEN
FROM 
    GIAOVIEN GV
JOIN 
    KHOA KH ON GV.MAKHOA = KH.MAKHOA
WHERE 
    GV.MAGV NOT IN (
        SELECT GD.MAGV
        FROM GIANGDAY GD
        JOIN MONHOC MH ON GD.MAMH = MH.MAMH
        WHERE GD.NAM = 2006
        AND MH.MAKHOA = GV.MAKHOA
    )
    AND GV.MAGV IN (
        SELECT GD.MAGV
        FROM GIANGDAY GD
        JOIN MONHOC MH ON GD.MAMH = MH.MAMH
        WHERE GD.NAM < 2006
        AND MH.MAKHOA != GV.MAKHOA
    )
--21. Tìm họ tên các học viên thuộc lớp “K11” thi một môn bất kỳ quá 3 lần vẫn "Khong dat",
--nhưng có điểm trung bình tất cả các môn khác trên 7.
SELECT 
    HV.HO + ' ' + HV.TEN AS HOTEN
FROM 
    HOCVIEN HV
JOIN 
    LOP L ON HV.MALOP = L.MALOP
JOIN 
    KETQUATHI KQ ON HV.MAHV = KQ.MAHV
WHERE 
    L.TENLOP = 'K11' 
    AND KQ.LANTHI > 3 
    AND KQ.KQUA = 'Khong dat'
    AND HV.MAHV IN (
        SELECT MAHV
        FROM KETQUATHI KQ2
        WHERE KQ2.MAHV = HV.MAHV
        GROUP BY KQ2.MAHV
        HAVING AVG(CASE WHEN KQ2.KQUA = 'Dat' THEN KQ2.DIEM ELSE NULL END) > 7
    )
--22. Tìm họ tên các học viên thuộc lớp “K11” thi một môn bất kỳ quá 3 lần vẫn "Khong dat" và thi
--lần thứ 2 của môn CTRR đạt đúng 5 điểm, nhưng điểm trung bình của tất cả các môn khác đều dưới
SELECT 
    HV.HO + ' ' + HV.TEN AS HOTEN
FROM 
    HOCVIEN HV
JOIN 
    LOP L ON HV.MALOP = L.MALOP
JOIN 
    KETQUATHI KQ ON HV.MAHV = KQ.MAHV
JOIN 
    MONHOC MH ON KQ.MAMH = MH.MAMH
WHERE 
    L.TENLOP = 'K11' 
    AND KQ.LANTHI > 3 
    AND KQ.KQUA = 'Khong dat'
    AND HV.MAHV IN (
        SELECT KQ2.MAHV
        FROM KETQUATHI KQ2
        JOIN MONHOC MH2 ON KQ2.MAMH = MH2.MAMH
        WHERE MH2.TENMH = 'CTRR' 
        AND KQ2.LANTHI = 2
        AND KQ2.DIEM = 5
    )
    AND HV.MAHV IN (
        SELECT KQ3.MAHV
        FROM KETQUATHI KQ3
        WHERE KQ3.MAHV = HV.MAHV
        GROUP BY KQ3.MAHV
        HAVING AVG(CASE WHEN KQ3.MAMH != 'CTRR' AND KQ3.KQUA = 'Dat' THEN KQ3.DIEM ELSE NULL END) < 7
    )
--23. Tìm họ tên giáo viên dạy môn CTRR cho ít nhất hai lớp trong cùng một học kỳ của một năm
--học và có tổng số tiết giảng dạy (TCLT + TCTH) lớn hơn 30 tiết.
SELECT 
    GV.HOTEN
FROM 
    GIAOVIEN GV
JOIN 
    GIANGDAY GD ON GV.MAGV = GD.MAGV
JOIN 
    MONHOC MH ON GD.MAMH = MH.MAMH
WHERE 
    MH.TENMH = 'CTRR' 
GROUP BY 
    GV.MAGV, GD.HOCKY, GD.NAM, GV.HOTEN
HAVING 
    COUNT(DISTINCT GD.MALOP) >= 2
    AND SUM(MH.TCLT + MH.TCTH) > 30
--24. Danh sách học viên và điểm thi môn CSDL (chỉ lấy điểm của lần thi sau cùng), kèm theo số
--lần thi của mỗi học viên cho môn này
SELECT 
    HV.MAHV,
    HV.HO,
    HV.TEN,
    KQT.DIEM,
    COUNT(KQT.LANTHI) AS SO_LAN_THI
FROM 
    HOCVIEN HV
JOIN 
    KETQUATHI KQT ON HV.MAHV = KQT.MAHV
JOIN 
    MONHOC MH ON KQT.MAMH = MH.MAMH
WHERE 
    MH.TENMH = 'CSDL'
GROUP BY 
    HV.MAHV, HV.HO, HV.TEN, KQT.DIEM, MH.MAMH, KQT.LANTHI
HAVING 
    KQT.LANTHI = (
        SELECT MAX(LANTHI)c
        FROM KETQUATHI
        WHERE MAHV = HV.MAHV AND MAMH = MH.MAMH
    );
--25. Danh sách học viên và điểm trung bình tất cả các môn (chỉ lấy điểm của lần thi sau cùng), kèm
--theo số lần thi trung bình cho tất cả các môn mà mỗi học viên đã tham gia
WITH LastExam AS (
    SELECT 
        MAHV,
        MAMH,
        MAX(LANTHI) AS LastExamNumber
    FROM 
        KETQUATHI
    GROUP BY 
        MAHV, MAMH
)
SELECT 
    HV.MAHV,
    HV.HO,
    HV.TEN,
    AVG(KQT.DIEM) AS DIEM_TB,
    COUNT(KQT.LANTHI) AS SO_LAN_THI
FROM 
    HOCVIEN HV
JOIN 
    KETQUATHI KQT ON HV.MAHV = KQT.MAHV
JOIN 
    LastExam LE ON KQT.MAHV = LE.MAHV AND KQT.MAMH = LE.MAMH AND KQT.LANTHI = LE.LastExamNumber
GROUP BY 
    HV.MAHV, HV.HO, HV.TEN
ORDER BY 
    HV.MAHV;




