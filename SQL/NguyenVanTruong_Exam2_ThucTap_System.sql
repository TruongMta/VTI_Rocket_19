-- Tao Database
DROP DATABASE IF EXISTS THUC_TAP_MANAGENMENT ;
CREATE DATABASE THUC_TAP_MANAGENMENT ;
USE THUC_TAP_MANAGENMENT;

-- Tao Table Giang Vien
DROP TABLE IF EXISTS GiangVien;
CREATE TABLE GiangVien
(
	MaGV  	TINYINT AUTO_iNCREMENT PRIMARY KEY,
	Hoten 	VARCHAR(100) NOT NULL,
	Luong	INT 
);

-- Tao Table Sinh Vien
DROP TABLE IF EXISTS Student;
CREATE TABLE Student
(
	MaSV  	TINYINT AUTO_iNCREMENT PRIMARY KEY,
	Hoten 	VARCHAR(100) NOT NULL,
	Namsinh DATETIME,
	QueQuan	VARCHAR(100)
);

-- Tao Table Detai
DROP TABLE IF EXISTS Detai;
CREATE TABLE Detai
(
	MaDT  		TINYINT AUTO_iNCREMENT PRIMARY KEY,
	TenDT 		VARCHAR(100) NOT NULL,
	Kinhphi		INT,
	NoiThucTap	VARCHAR(100)
);

-- Tao Table HuongDan
DROP TABLE IF EXISTS HuongDan;
CREATE TABLE HuongDan
(
	ID		TINYINT AUTO_iNCREMENT PRIMARY KEY,
	MaSV 	TINYINT,
	MaDT	TINYINT,
	MaGV	TINYINT,
	Ketqua	TINYINT
);

-- 1. Tạo table với các ràng buộc và kiểu dữ liệu
-- Thêm ít nhất 3 bản ghi vào table
/* Data Table GiangVien */

INSERT INTO `thuc_tap_managenment`.`giangvien` (`MaGV`, `Hoten`, `Luong`) VALUES ('1', 'Nguyen Van Truong', '10000000');
INSERT INTO `thuc_tap_managenment`.`giangvien` (`MaGV`, `Hoten`, `Luong`) VALUES ('2', 'Nguyen Thi Thuy', '12000000');
INSERT INTO `thuc_tap_managenment`.`giangvien` (`MaGV`, `Hoten`, `Luong`) VALUES ('3', 'Tran Xuan Kien', '9000000');

/* Data Table SinhVien */

INSERT INTO `thuc_tap_managenment`.`student` (`MaSV`, `Hoten`, `Namsinh`, `QueQuan`) VALUES ('1', 'Nguyen Van A', '1900-00-00', 'Ha Noi');
INSERT INTO `thuc_tap_managenment`.`student` (`MaSV`, `Hoten`, `Namsinh`, `QueQuan`) VALUES ('2', 'Tran Van C', '1985-00-00', 'Ha Nam');
INSERT INTO `thuc_tap_managenment`.`student` (`MaSV`, `Hoten`, `Namsinh`, `QueQuan`) VALUES ('3', 'Nguyen Thi C', '2000-00-00', 'Nam Dinh');


/* Data Table DeTai */

INSERT INTO `thuc_tap_managenment`.`detai` (`MaDT`, `TenDT`, `Kinhphi`, `NoiThucTap`) VALUES ('1', 'CONG NGHE SINH HOC', '1000000', 'Ha Noi');
INSERT INTO `thuc_tap_managenment`.`detai` (`MaDT`, `TenDT`, `Kinhphi`, `NoiThucTap`) VALUES ('2', 'CONG NGHE HOA HOC', '20000000', 'Ha Nam');
INSERT INTO `thuc_tap_managenment`.`detai` (`MaDT`, `TenDT`, `Kinhphi`, `NoiThucTap`) VALUES ('3', 'CONG NGHE THONG TIN', '15000000', 'Ho Chi Minh');

/* Data Table HuongDan */
INSERT INTO `thuc_tap_managenment`.`huongdan` (`ID`, `MaSV`, `MaDT`, `MaGV`, `Ketqua`) VALUES ('1', '1', '1', '1', '8');
INSERT INTO `thuc_tap_managenment`.`huongdan` (`ID`, `MaSV`, `MaDT`, `MaGV`, `Ketqua`) VALUES ('2', '2', '2', '3', '9');
INSERT INTO `thuc_tap_managenment`.`huongdan` (`ID`, `MaSV`, `MaDT`, `MaGV`, `Ketqua`) VALUES ('3', '3', '3', '2', '10');

-- 2. Viết lệnh để
-- a) Lấy tất cả các sinh viên chưa có đề tài hướng dẫn
SELECT SV.*
FROM Student SV LEFT JOIN HuongDan HD USING(MaSV)
WHERE HD.MaDT IS NULL;

-- b) Lấy ra số sinh viên làm đề tài ‘CONG NGHE SINH HOC’
SELECT Count(MaDT) As SL_SV_Detai_CongNgheSinhHoc
FROM Student SV JOIN HuongDan HD USING(MaSV) 
		JOIN DeTai DT USING(MaDT)
WHERE DT.TenDT LIKE '%CONG NGHE SINH HOC%';

-- 3. Tạo view có tên là "SinhVienInfo" lấy các thông tin về học sinh bao gồm:mã số, họ tên và tên đề tài
-- (Nếu sinh viên chưa có đề tài thì column tên đề tài sẽ in ra "Chưa có"

DROP VIEW IF EXISTS SinhVienInfo;
CREATE OR REPLACE VIEW SinhVienInfo AS(
	SELECT SV.MaSV As Ma_so, SV.Hoten As Ho_Ten, CASE 
		WHEN TenDT IS NULL THEN 'Chua_co'
        ELSE TenDT
        END AS Ten_De_Tai
	FROM Student SV LEFT JOIN HuongDan HD USING(MaSV)
					LEFT JOIN DeTai DT USING(MaDT)
    );
SELECT * FROM SinhVienInfo;
        
-- 4. Tạo trigger cho table SinhVien khi insert sinh viên có năm sinh <= 1900 thì hiện ra thông báo "năm sinh phải > 1900"

DROP TRIGGER IF EXISTS trg_Inset_SinhVien;
DELIMITER $$
	CREATE TRIGGER trg_Inset_SinhVien
	BEFORE INSERT ON `Student`
    FOR EACH ROW 
    BEGIN
		IF (NEW.Namsinh <= '1900-00-00') THEN
		SIGNAL SQLSTATE '12345'
		SET MESSAGE_TEXT = 'năm sinh phải > 1900';
		END IF;
    END $$;
DELIMITER ;

Begin work;
INSERT `Student` VALUE ('7','Nguyen Van B','1899-00-00','Ha Noi');
SELECT * FROM `Student`;
Rollback;

-- 5. Hãy cấu hình table sao cho khi xóa 1 sinh viên nào đó thì sẽ 
-- tất cả thông tin trong table HuongDan liên quan tới sinh viên đó sẽ bị xóa đi

DROP TRIGGER IF EXISTS Tg_Delete_SinhVien;
DELIMITER $$
	CREATE TRIGGER Tg_Delete_SinhVien
	BEFORE DELETE ON Student
    FOR EACH ROW
    BEGIN
		DELETE FROM HuongDan WHERE MaSV = Old.MaSV;
    END $$;
DELIMITER ;

Begin work;
	DELETE FROM Student WHERE `MaSV` = '3' ;
Rollback;

SELECT * FROM Student;
SELECT * FROM HuongDan;