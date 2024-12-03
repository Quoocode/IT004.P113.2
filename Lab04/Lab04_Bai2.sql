--19. Khoa nào (mã khoa, tên khoa) ???c thành l?p s?m nh?t.
SELECT MAKHOA, TENKHOA
FROM KHOA
WHERE NGTLAP = (SELECT MIN(NGTLAP) FROM KHOA);
--20. Có bao nhiêu giáo viên có h?c hàm là “GS” ho?c “PGS”.
SELECT COUNT(*) as SoLuongGiaoVien
FROM GIAOVIEN
WHERE HOCHAM IN ('GS', 'PGS');
--21. Th?ng kê có bao nhiêu giáo viên có h?c v? là “CN”, “KS”, “Ths”, “TS”, “PTS” trong m?i khoa.
SELECT K.MAKHOA, K.TENKHOA, 
       COUNT(CASE WHEN G.HOCVI = 'CN' THEN 1 END) AS SoLuong_CN,
       COUNT(CASE WHEN G.HOCVI = 'KS' THEN 1 END) AS SoLuong_KS,
       COUNT(CASE WHEN G.HOCVI = 'Ths' THEN 1 END) AS SoLuong_Ths,
       COUNT(CASE WHEN G.HOCVI = 'TS' THEN 1 END) AS SoLuong_TS,
       COUNT(CASE WHEN G.HOCVI = 'PTS' THEN 1 END) AS SoLuong_PTS
FROM GIAOVIEN G
JOIN KHOA K ON G.MAKHOA = K.MAKHOA
GROUP BY K.MAKHOA, K.TENKHOA;
--22. M?i môn h?c th?ng kê s? l??ng h?c viên theo k?t qu? (??t và không ??t).
SELECT MH.MAMH, MH.TENMH,
       COUNT(CASE WHEN KQ.DIEM >= 5 THEN 1 END) AS SoLuongDat,
       COUNT(CASE WHEN KQ.DIEM < 5 THEN 1 END) AS SoLuongKhongDat
FROM MONHOC MH
LEFT JOIN KETQUATHI KQ ON MH.MAMH = KQ.MAMH
GROUP BY MH.MAMH, MH.TENMH;
--23. Tìm giáo viên (mã giáo viên, h? tên) là giáo viên ch? nhi?m c?a m?t l?p, ??ng th?i d?y cho l?p ?ó ít nh?t m?t môn h?c.
SELECT G.MAGV, G.HOTEN
FROM GIAOVIEN G
JOIN LOP L ON G.MAGV = L.MAGVCN
JOIN GIANGDAY GD ON L.MALOP = GD.MALOP AND G.MAGV = GD.MAGV
GROUP BY G.MAGV, G.HOTEN;
--24. Tìm h? tên l?p tr??ng c?a l?p có s? s? cao nh?t.
SELECT HV.HO, HV.TEN
FROM HOCVIEN HV
JOIN LOP L ON HV.MAHV = L.TRGLOP
WHERE L.SISO = (SELECT MAX(SISO) FROM LOP);
--25. * Tìm h? tên nh?ng LOPTRG thi không ??t quá 3 môn (m?i môn ??u thi không ??t ? t?t c? các l?n thi)
SELECT hv.HO, hv.TEN
FROM HOCVIEN hv
JOIN LOP lp ON hv.MAHV = lp.TRGLOP
JOIN (
    SELECT MAHV, COUNT(DISTINCT MAMH) AS So_Mon_Thi_Khong_Dat
    FROM KETQUATHI
    WHERE KQUA = 'Không ??t'
    GROUP BY MAHV
    HAVING COUNT(DISTINCT MAMH) <= 3
) AS kq ON hv.MAHV = kq.MAHV;