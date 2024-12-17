--11. Ngày mua hàng (NGHD) của một khách hàng thành viên sẽ lớn hơn hoặc bằng ngày khách hàng đó đăng ký thành viên (NGDK).
create trigger trg_ins_hd on HOADON
for insert
as
begin
if exists (select*
		from INSERTED, KHACHHANG
		where INSERTED.MAKH=KHACHHANG.MAKH
		and NGHD<NGDK)
		begin
			RAISERROR('LOI: NGAY HOA DON KHONG HOP LE!',16,1);
			ROLLBACK TRANSACTION
		end
		else
		begin
		PRINT'THEM MOI HOA DON THANH CONG'
		end
end
select *from HOADON
select* from NHANVIEN
INSERT INTO HOADON (SOHD, NGHD, MAKH, MANV, TRIGIA)
VALUES (1024, '2006-01-01', 'KH01', 'NV01', 500000.00);
-- Dự kiến kết quả: "LOI: NGAY HOA DON KHONG HOP LE!"


--12. Ngày bán hàng (NGHD) của một nhân viên phải lớn hơn hoặc bằng ngày nhân viên đó vào làm.
create trigger trg_upd_hd on HOADON
for insert, update
as
begin 
	if exists(select*
		from inserted,NHANVIEN
		where inserted.MANV = NHANVIEN.MANV
		and NGHD<NGVL)
		begin
			RAISERROR('LOI: NGAY HOA DON KHONG HOP LE!',16,1);
			ROLLBACK TRANSACTION
		end
		else
		begin
		PRINT'THEM MOI HOA DON THANH CONG'
		end
end

--13. Trị giá của một hóa đơn là tổng thành tiền (số lượng*đơn giá) của các chi tiết thuộc hóa đơn đó.
create trigger trg_upd_tghd on CTHD
for update
as
begin
	update HOADON
	set TRIGIA=TRIGIA-(select sum(SL*GIA)
						from DELETED D join SANPHAM S on D.MASP=S.MASP
						where HOADON.SOHD=D.SOHD)
	from deleted D
	where D.SOHD=HOADON.SOHD

	update HOADON
	set TRIGIA=TRIGIA+(select sum(SL*GIA)
						from inserted I join SANPHAM S on I.MASP=S.MASP
						where I.SOHD=HOADON.SOHD)
	from inserted I
	where HOADON.SOHD=I.SOHD
	PRINT'TRI GIA CUA CAC HOA DON DA DUOC CAP NHAT'
end

select* from KHACHHANG
--14. Doanh số của một khách hàng là tổng trị giá các hóa đơn mà khách hàng thành viên đó đã mua
CREATE TRIGGER trg_dskh on HOADON
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	UPDATE KHACHHANG
	SET DOANHSO=(SELECT SUM(TRIGIA)
				FROM HOADON H 
				WHERE H.MAKH=KHACHHANG.MAKH
				)
	WHERE KHACHHANG.MAKH in (
	SELECT MAKH FROM inserted
	UNION
	SELECT MAKH FROM deleted
	)
END
	