1. Hiển thị tên và cấp độ của tất cả các kỹ năng của chuyên gia có MaChuyenGia là 1, đồng thời lọc ra những kỹ năng có cấp độ thấp hơn 3.
select KN.TenKyNang, CGKN.CapDo
from ChuyenGia_KyNang CGKN
join KyNang KN on KN.MaKyNang=CGKN.MaKyNang
where CGKN.CapDo>=3 and CGKN.MaChuyenGia=1
2. Liệt kê tên các chuyên gia tham gia dự án có MaDuAn là 2 và có ít nhất 2 kỹ năng khác nhau.
 select CG.HoTen
 from ChuyenGia CG
 join ChuyenGia_DuAn CGDA on CG.MaChuyenGia=CGDA.MaChuyenGia
 join ChuyenGia_KyNang CGKN on CGDA.MaChuyenGia=CGKN.MaChuyenGia
 where CGDA.MaDuAn=2
 group by CGKN.MaChuyenGia,CG.HoTen
 having count(distinct CGKN.MaKyNang)>=2
3. Hiển thị tên công ty và tên dự án của tất cả các dự án, sắp xếp theo tên công ty và số lượng chuyên gia tham gia dự án.
select CT.TenCongTy,DA.TenDuAn,count(CGDA.MaChuyenGia) as SoLuongCG
from CongTy CT
join DuAn DA on CT.MaCongTy=DA.MaCongTy
left join ChuyenGia_DuAn CGDA on DA.MaDuAn=CGDA.MaDuAn
group by CT.TenCongTy,DA.TenDuAn
order by CT.TenCongTy, SoLuongCG desc

4. Đếm số lượng chuyên gia trong mỗi chuyên ngành và hiển thị chỉ những chuyên ngành có hơn 5 chuyên gia.


5. Tìm chuyên gia có số năm kinh nghiệm cao nhất và hiển thị cả danh sách kỹ năng của họ.
select CG.HoTen, KN.TenKyNang
from ChuyenGia CG
join ChuyenGia_KyNang CGKN on CGKN.MaChuyenGia = CG.MaChuyenGia
join KyNang KN on KN.MaKyNang=CGKN.MaKyNang
where CG.NamKinhNghiem >= all(select NamKinhNghiem from ChuyenGia)
6. Liệt kê tên các chuyên gia và số lượng dự án họ tham gia, đồng thời tính toán tỷ lệ phần trăm so với tổng số dự án trong hệ thống.
select CG.Hoten, count(CGDA.MaDuAn) as SoLuongDuAn, (count(CGDA.MaDuAn)*100/(select count(*)from DuAn))as TiLePhanTram
from ChuyenGia CG
join ChuyenGia_DuAn CGDA on CG.MaChuyenGia = CGDA.MaChuyenGia
group by CG.Hoten
7. Hiển thị tên công ty và số lượng dự án của mỗi công ty, bao gồm cả những công ty không có dự án nào.
select CT.TenCongTy, count(DA.MaDuAn)as SoLuongDuAn
from CongTy CT
left join DuAN DA on CT.MaCongTy=DA.MaCongTy
group by CT.TenCongTy
8. Tìm kỹ năng được sở hữu bởi nhiều chuyên gia nhất, đồng thời hiển thị số lượng chuyên gia sở hữu kỹ năng đó.
select top 1 KN.TenKyNang, count(CGKN.MaChuyenGia)as SoLuongChuyenGia
from KyNang KN
join ChuyenGia_KyNang CGKN on KN.MaKyNang = CGKN.MaKyNang
group by KN.TenKyNang
order by SoLuongChuyenGia desc

9. Liệt kê tên các chuyên gia có kỹ năng 'Python' với cấp độ từ 4 trở lên, đồng thời tìm kiếm những người cũng có kỹ năng 'Java'.
SELECT DISTINCT CG.HoTen
FROM ChuyenGia CG
JOIN ChuyenGia_KyNang CGKN_Python ON CG.MaChuyenGia = CGKN_Python.MaChuyenGia
JOIN KyNang KN_Python ON CGKN_Python.MaKyNang = KN_Python.MaKyNang
JOIN ChuyenGia_KyNang CGKN_Java ON CG.MaChuyenGia = CGKN_Java.MaChuyenGia
JOIN KyNang KN_Java ON CGKN_Java.MaKyNang = KN_Java.MaKyNang
WHERE KN_Python.TenKyNang = 'Python' AND CGKN_Python.CapDo >= 4
AND KN_Java.TenKyNang = 'Java';

10. Tìm dự án có nhiều chuyên gia tham gia nhất và hiển thị danh sách tên các chuyên gia tham gia vào dự án đó.
select CG.HoTen, DA.TenDuAn
from ChuyenGia CG
join ChuyenGia_DuAn CGDA on CG.MaChuyenGia = CGDA.MaChuyenGia
join DuAn DA on DA.MaDuAn = CGDA.MaDuAn
where DA.MaDuAn = (select top 1 MaDuAn from ChuyenGia_DuAn group by MaDuAn order by count(MaChuyenGia) desc)
11. Hiển thị tên và số lượng kỹ năng của mỗi chuyên gia, đồng thời lọc ra những người có ít nhất 5 kỹ năng.
select CG.HoTen, count(CGKN.MaKyNang) as SoLuongKyNang
from ChuyenGia CG
join ChuyenGia_KyNang CGKN on CG.MaChuyenGia = CGKN.MaChuyenGia
group by CG.HoTen
having count(CGKN.MaKyNang)>=5
12. Tìm các cặp chuyên gia làm việc cùng dự án và hiển thị thông tin về số năm kinh nghiệm của từng cặp.
select CG1.HoTen as ChuyenGia1, CG1.NamKinhNghiem as NamKinhNghiem1,
       CG2.HoTen as ChuyenGia2, CG2.NamKinhNghiem as NamKinhNghiem2
from ChuyenGia_DuAn CGDA1
JOIN ChuyenGia_DuAn CGDA2 on CGDA1.MaDuAn = CGDA2.MaDuAn AND CGDA1.MaChuyenGia < CGDA2.MaChuyenGia
JOIN ChuyenGia CG1 on CGDA1.MaChuyenGia = CG1.MaChuyenGia
JOIN ChuyenGia CG2 on CGDA2.MaChuyenGia = CG2.MaChuyenGia;

13. Liệt kê tên các chuyên gia và số lượng kỹ năng cấp độ 5 của họ, đồng thời tính toán tỷ lệ phần trăm so với tổng số kỹ năng mà họ sở hữu.
SELECT CG.HoTen,
       COUNT(CASE WHEN CGKN.CapDo = 5 THEN 1 END) AS SoKyNangCapDo5,
       ROUND((COUNT(CASE WHEN CGKN.CapDo = 5 THEN 1 END) * 100.0) / COUNT(CGKN.MaKyNang), 2) AS TiLePhanTram
FROM ChuyenGia CG
JOIN ChuyenGia_KyNang CGKN ON CG.MaChuyenGia = CGKN.MaChuyenGia
GROUP BY CG.HoTen;
14. Tìm các công ty không có dự án nào và hiển thị cả thông tin về số lượng nhân viên trong mỗi công ty đó.
SELECT CT.TenCongTy, CT.SoNhanVien
FROM CongTy CT
LEFT JOIN DuAn DA ON CT.MaCongTy = DA.MaCongTy
WHERE DA.MaDuAn IS NULL;

15. Hiển thị tên chuyên gia và tên dự án họ tham gia, bao gồm cả những chuyên gia không tham gia dự án nào, sắp xếp theo tên chuyên gia.
SELECT CG.HoTen AS TenChuyenGia, DA.TenDuAn AS TenDuAn
FROM ChuyenGia CG
LEFT JOIN ChuyenGia_DuAn CGDA ON CG.MaChuyenGia = CGDA.MaChuyenGia
LEFT JOIN DuAn DA ON CGDA.MaDuAn = DA.MaDuAn
ORDER BY CG.HoTen;

16. Tìm các chuyên gia có ít nhất 3 kỹ năng, đồng thời lọc ra những người không có bất kỳ kỹ năng nào ở cấp độ cao hơn 3.
SELECT CG.HoTen
FROM ChuyenGia CG
JOIN ChuyenGia_KyNang CGKN ON CG.MaChuyenGia = CGKN.MaChuyenGia
GROUP BY CG.MaChuyenGia,CG.HoTen
HAVING COUNT(CGKN.MaKyNang) >= 3
AND MAX(CGKN.CapDo) <= 3;

17. Hiển thị tên công ty và tổng số năm kinh nghiệm của tất cả chuyên gia trong các dự án của công ty đó, chỉ hiển thị những công ty có tổng số năm kinh nghiệm lớn hơn 10 năm.
SELECT CT.TenCongTy, SUM(CG.NamKinhNghiem) AS TongKinhNghiem
FROM CongTy CT
JOIN DuAn DA ON CT.MaCongTy = DA.MaCongTy
JOIN ChuyenGia_DuAn CGDA ON DA.MaDuAn = CGDA.MaDuAn
JOIN ChuyenGia CG ON CGDA.MaChuyenGia = CG.MaChuyenGia
GROUP BY CT.TenCongTy
HAVING SUM(CG.NamKinhNghiem) > 10;

18. Tìm các chuyên gia có kỹ năng 'Java' nhưng không có kỹ năng 'Python', đồng thời hiển thị danh sách các dự án mà họ đã tham gia.
SELECT CG.HoTen AS TenChuyenGia, DA.TenDuAn AS TenDuAn
FROM ChuyenGia CG
JOIN ChuyenGia_KyNang CGK ON CG.MaChuyenGia = CGK.MaChuyenGia
JOIN KyNang KN ON CGK.MaKyNang = KN.MaKyNang
JOIN ChuyenGia_DuAn CGDA ON CG.MaChuyenGia = CGDA.MaChuyenGia
JOIN DuAn DA ON CGDA.MaDuAn = DA.MaDuAn
WHERE KN.TenKyNang = 'Java'
AND CG.MaChuyenGia NOT IN (
    SELECT MaChuyenGia
    FROM ChuyenGia_KyNang
    JOIN KyNang ON ChuyenGia_KyNang.MaKyNang = KyNang.MaKyNang
    WHERE KyNang.TenKyNang = 'Python'
)
ORDER BY CG.HoTen;

19. Tìm chuyên gia có số lượng kỹ năng nhiều nhất và hiển thị cả danh sách các dự án mà họ đã tham gia.
WITH SkillCounts AS (
    SELECT MaChuyenGia, COUNT(*) AS SkillCount
    FROM ChuyenGia_KyNang
    GROUP BY MaChuyenGia
)
SELECT CG.HoTen AS TenChuyenGia, DA.TenDuAn AS TenDuAn
FROM ChuyenGia CG
JOIN ChuyenGia_KyNang CGK ON CG.MaChuyenGia = CGK.MaChuyenGia
JOIN ChuyenGia_DuAn CGDA ON CG.MaChuyenGia = CGDA.MaChuyenGia
JOIN DuAn DA ON CGDA.MaDuAn = DA.MaDuAn
JOIN SkillCounts SC ON CG.MaChuyenGia = SC.MaChuyenGia
WHERE SC.SkillCount = (SELECT MAX(SkillCount) FROM SkillCounts)
group by CG.HoTen,DA.TenDuAn
ORDER BY CG.HoTen;

20. Liệt kê các cặp chuyên gia có cùng chuyên ngành và hiển thị thông tin về số năm kinh nghiệm của từng người trong cặp đó.
SELECT cg1.HoTen AS ChuyenGia1, cg2.HoTen AS ChuyenGia2, cg1.NamKinhNghiem AS KinhNghiem1, cg2.NamKinhNghiem AS KinhNghiem2
FROM ChuyenGia cg1
JOIN ChuyenGia cg2 ON cg1.ChuyenNganh = cg2.ChuyenNganh AND cg1.MaChuyenGia < cg2.MaChuyenGia;

21. Tìm công ty có tổng số năm kinh nghiệm của các chuyên gia trong dự án cao nhất và hiển thị danh sách tất cả các dự án mà công ty đó đã thực hiện.
WITH CompanyExperience AS (
    SELECT CT.MaCongTy, SUM(CG.NamKinhNghiem) AS TotalExperience
    FROM CongTy CT
    JOIN DuAn DA ON CT.MaCongTy = DA.MaCongTy
    JOIN ChuyenGia_DuAn CGDA ON DA.MaDuAn = CGDA.MaDuAn
    JOIN ChuyenGia CG ON CGDA.MaChuyenGia = CG.MaChuyenGia
    GROUP BY CT.MaCongTy
)
SELECT CT.TenCongTy, DA.TenDuAn
FROM CongTy CT
JOIN DuAn DA ON CT.MaCongTy = DA.MaCongTy
JOIN CompanyExperience CE ON CT.MaCongTy = CE.MaCongTy
WHERE CE.TotalExperience = (SELECT MAX(TotalExperience) FROM CompanyExperience)
ORDER BY DA.TenDuAn;

22. Tìm kỹ năng được sở hữu bởi tất cả các chuyên gia và hiển thị danh sách chi tiết về từng chuyên gia sở hữu kỹ năng đó cùng với cấp độ của họ.
SELECT KN.TenKyNang, CG.HoTen, CGKN.CapDo
FROM KyNang KN
JOIN ChuyenGia_KyNang CGKN ON KN.MaKyNang = CGKN.MaKyNang
JOIN ChuyenGia CG ON CGKN.MaChuyenGia = CG.MaChuyenGia
WHERE NOT EXISTS (
    SELECT 1
    FROM ChuyenGia C
    WHERE NOT EXISTS (
        SELECT 1
        FROM ChuyenGia_KyNang CGKN2
        WHERE CGKN2.MaChuyenGia = C.MaChuyenGia
        AND CGKN2.MaKyNang = KN.MaKyNang
    )
)
ORDER BY KN.TenKyNang, CG.HoTen;


23. Tìm tất cả các chuyên gia có ít nhất 2 kỹ năng thuộc cùng một lĩnh vực và hiển thị tên chuyên gia cùng với tên lĩnh vực đó.
SELECT CG.HoTen AS TenChuyenGia, KN.LoaiKyNang AS TenLinhVuc
FROM ChuyenGia CG
JOIN ChuyenGia_KyNang CGKN ON CG.MaChuyenGia = CGKN.MaChuyenGia
JOIN KyNang KN ON CGKN.MaKyNang = KN.MaKyNang
GROUP BY CG.HoTen, KN.LoaiKyNang
HAVING COUNT(DISTINCT KN.MaKyNang) >= 2;


24. Hiển thị tên các dự án và số lượng chuyên gia tham gia cho mỗi dự án, chỉ hiển thị những dự án có hơn 3 chuyên gia tham gia.
SELECT DA.TenDuAn AS TenDuAn, COUNT(DISTINCT CG.MaChuyenGia) AS SoLuongChuyenGia
FROM DuAn DA
JOIN ChuyenGia_DuAn CGDA ON DA.MaDuAn = CGDA.MaDuAn
JOIN ChuyenGia CG ON CGDA.MaChuyenGia = CG.MaChuyenGia
GROUP BY DA.TenDuAn
HAVING COUNT(DISTINCT CG.MaChuyenGia) > 3;

  
25.Tìm công ty có số lượng dự án lớn nhất và hiển thị tên công ty cùng với số lượng dự án.
SELECT top 1 with ties CT.TenCongTy, COUNT(DA.MaDuAn) AS SoLuongDuAn
FROM CongTy CT
JOIN DuAn DA ON CT.MaCongTy = DA.MaCongTy
GROUP BY CT.TenCongTy
ORDER BY SoLuongDuAn DESC

26. Liệt kê tên các chuyên gia có kinh nghiệm từ 5 năm trở lên và có ít nhất 4 kỹ năng khác nhau.
SELECT CG.HoTen
FROM ChuyenGia CG
JOIN ChuyenGia_KyNang CGKN ON CG.MaChuyenGia = CGKN.MaChuyenGia
GROUP BY CG.MaChuyenGia, CG.HoTen,CG.NamKinhNghiem
HAVING CG.NamKinhNghiem >= 5 AND COUNT(DISTINCT CGKN.MaKyNang) >= 4;


27. Tìm tất cả các kỹ năng mà không có chuyên gia nào sở hữu.
SELECT KN.TenKyNang
FROM KyNang KN
LEFT JOIN ChuyenGia_KyNang CGKN ON KN.MaKyNang = CGKN.MaKyNang
WHERE CGKN.MaChuyenGia IS NULL;


28. Hiển thị tên chuyên gia và số năm kinh nghiệm của họ, sắp xếp theo số năm kinh nghiệm giảm dần.
SELECT HoTen, NamKinhNghiem
FROM ChuyenGia
ORDER BY NamKinhNghiem DESC;


29. Tìm tất cả các cặp chuyên gia có ít nhất 2 kỹ năng giống nhau.
SELECT cg1.HoTen AS ChuyenGia1, cg2.HoTen AS ChuyenGia2
FROM ChuyenGia_KyNang cg1
JOIN ChuyenGia_KyNang cg2 ON cg1.MaKyNang = cg2.MaKyNang
AND cg1.MaChuyenGia < cg2.MaChuyenGia
GROUP BY cg1.MaChuyenGia, cg2.MaChuyenGia
HAVING COUNT(cg1.MaKyNang) >= 2;


30. Tìm các công ty có ít nhất một chuyên gia nhưng không có dự án nào.
SELECT CT.TenCongTy
FROM CongTy CT
LEFT JOIN DuAn DA ON CT.MaCongTy = DA.MaCongTy
LEFT JOIN ChuyenGia_DuAn CGDA ON DA.MaDuAn = CGDA.MaDuAn
WHERE CGDA.MaChuyenGia IS NOT NULL
GROUP BY CT.MaCongTy, CT.TenCongTy
HAVING COUNT(DA.MaDuAn) = 0;


31. Liệt kê tên các chuyên gia cùng với số lượng kỹ năng cấp độ cao nhất mà họ sở hữu.
SELECT CG.HoTen AS TenChuyenGia, COUNT(CGK.MaKyNang) AS SoLuongKyNangCaoNhat
FROM ChuyenGia CG
JOIN ChuyenGia_KyNang CGK ON CG.MaChuyenGia = CGK.MaChuyenGia
WHERE CGK.CapDo = (
    SELECT MAX(CapDo)
    FROM ChuyenGia_KyNang
    WHERE MaChuyenGia = CG.MaChuyenGia
)
GROUP BY CG.MaChuyenGia, CG.HoTen;


32. Tìm dự án mà tất cả các chuyên gia đều tham gia và hiển thị tên dự án cùng với danh sách tên chuyên gia tham gia.



33. Tìm tất cả các kỹ năng mà ít nhất một chuyên gia sở hữu nhưng không thuộc về nhóm kỹ năng 'Python' hoặc 'Java'.
SELECT KN.TenKyNang
FROM KyNang KN
WHERE KN.MaKyNang NOT IN (SELECT MaKyNang FROM KyNang WHERE TenKyNang IN ('Python', 'Java'))
AND KN.MaKyNang IN (SELECT DISTINCT MaKyNang FROM ChuyenGia_KyNang);

   

