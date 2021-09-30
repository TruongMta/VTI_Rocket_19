/* Lenh xoa Database */
DROP DATABASE IF EXISTS `Testing_System_1`;
/* Lenh tao Database */
CREATE DATABASE IF NOT EXISTS `Testing_System_1`;
/* Lenh su dung Database */
USE `Testing_System_1`;


/*------------------- Create table ----------------------- */

/* Lenh xoa bang */
DROP TABLE IF EXISTS `Department`;
/* Len tao bang va cac cot du lieu cua bang--*/
CREATE TABLE `Department`
(   
    `DepartmentID`   TINYINT PRIMARY KEY AUTO_INCREMENT,
    `DepartmentName` VARCHAR(50)
);

DROP TABLE IF EXISTS `Position`;
CREATE TABLE IF NOT EXISTS `Position` (
    `PositionID` TINYINT UNSIGNED AUTO_INCREMENT,
    `PositionName` ENUM('Dev1', 'Dev2', 'Test', 'Scrum Master', 'PM'),
    CONSTRAINT pk_p PRIMARY KEY (`PositionID`)
);

## ALTER TABLE `position` CHANGE COLUMN `PositionName` `PositionName` VARCHAR(50);
## ALTER TABLE `position` MODIFY `PositionName` VARCHAR(50);

/* ALTER TABLE `position` DROP COLUMN `PositionName`,
	ADD COLUMN `PositionName` VARCHAR(50); */

DROP TABLE IF EXISTS `Account`;
CREATE TABLE IF NOT EXISTS `Account`
(
    `AccountID`    MEDIUMINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    `Email`        VARCHAR(100) UNIQUE,
    `Username`     VARCHAR(50) NOT NULL,
    `Fullname`     VARCHAR(50),
    `DepartmentID` TINYINT UNSIGNED DEFAULT 0,
    `PositionID`  TINYINT UNSIGNED,
    `CreateDate`   DATETIME 
    -- CONSTRAINT fk_dp_id FOREIGN KEY (`DepartmentID`) REFERENCES `Department` (`DepartmentID`) ON DELETE SET NULL ON UPDATE CASCADE,
    -- CONSTRAINT fk_ps_id FOREIGN KEY (`PositionID`) REFERENCES `Position` (`PositionID`) ON DELETE SET NULL ON UPDATE CASCADE
);

DROP TABLE IF EXISTS `Group`;
CREATE TABLE IF NOT EXISTS `Group`
(
    `GroupID`    MEDIUMINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    `GroupName`  VARCHAR(50) NOT NULL,
    `CreatorID`  MEDIUMINT UNSIGNED,
    `CreateDate` DATETIME
);

DROP TABLE IF EXISTS `GroupAccount`;
CREATE TABLE IF NOT EXISTS `GroupAccount`
(
    `GroupID`   MEDIUMINT,
    `AccountID` MEDIUMINT,
    `JoinDate`  DATETIME DEFAULT NOW()
);

DROP TABLE IF EXISTS `TypeQuestion`;
CREATE TABLE IF NOT EXISTS `TypeQuestion`
(
    `TypeID`   TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    `TypeName` VARCHAR(50)
);

DROP TABLE IF EXISTS `CategoryQuestion`;
CREATE TABLE IF NOT EXISTS `CategoryQuestion`
(
    `CategoryID`   TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    `CategoryName` ENUM ('Java', 'SQL', '.NET', 'Ruby', 'Python', 'NodeJS' , 'HTML', 'CSS', 'JavaScript')
);

DROP TABLE IF EXISTS `Question`;
CREATE TABLE IF NOT EXISTS `Question`
(
    `QuestionID` TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    `Content`    VARCHAR(50),
    `CategoryID` TINYINT UNSIGNED,
    `TypeID`     TINYINT UNSIGNED,
    `CreatorID`  MEDIUMINT UNSIGNED,
    `CreateDate` DATETIME 
    -- CONSTRAINT fk_q1 FOREIGN KEY (`CreatorID`) REFERENCES `Account` (`AccountID`) ON UPDATE CASCADE ON DELETE SET NULL,
    -- CONSTRAINT fk_q2 FOREIGN KEY (`CategoryID`) REFERENCES `CategoryQuestion` (`CategoryID`) ON UPDATE CASCADE ON DELETE SET NULL,
    -- CONSTRAINT fk_q3 FOREIGN KEY (`TypeID`) REFERENCES `TypeQuestion` (`TypeID`) ON UPDATE CASCADE ON DELETE SET NULL
);

DROP TABLE IF EXISTS `Answer`;
CREATE TABLE IF NOT EXISTS `Answer`
(
    `AnswerID`   TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    `Content`    VARCHAR(50),
    `QuestionID` TINYINT UNSIGNED,
    `isCorrect`  BIT
	-- CONSTRAINT fk_qid FOREIGN KEY (`QuestionID`) REFERENCES `Question` (`QuestionID`) ON UPDATE CASCADE ON DELETE SET NULL
);

DROP TABLE IF EXISTS `Exam`;
CREATE TABLE IF NOT EXISTS `Exam`
(
    `ExamID`     TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    `Code`       VARCHAR(20) NOT NULL,
    `Title`      VARCHAR(50) NOT NULL,
    `CategoryID` TINYINT UNSIGNED,
    `Duration`   TINYINT,
    `CreatorID`  MEDIUMINT UNSIGNED,
    `CreateDate` DATETIME 
	-- CONSTRAINT fk_ex_1 FOREIGN KEY (CreatorID) REFERENCES Account (AccountID) ON UPDATE CASCADE ON DELETE NO ACTION,
    -- CONSTRAINT fk_ex_2 FOREIGN KEY (CategoryID) REFERENCES CategoryQuestion (CategoryID) ON UPDATE CASCADE ON DELETE SET NULL
);


DROP TABLE IF EXISTS `ExamQuestion`;
CREATE TABLE IF NOT EXISTS `ExamQuestion`
(
    `ExamID`     TINYINT UNSIGNED,
    `QuestionID` TINYINT UNSIGNED
   --  CONSTRAINT fk_eq1 FOREIGN KEY (ExamID) REFERENCES Exam (ExamID),
   --  CONSTRAINT fk_eq2 FOREIGN KEY (QuestionID) REFERENCES Question (QuestionID)
);


/* ---------------------- INSERT DATA ---------------------------- */
/* INSERT DATA bang Department */
INSERT INTO `Department`(`DepartmentName`)
VALUES ('Phong Ky Thuat 1'),
       ('Phong Ky Thuat 2'),
       ('Phong Dev 1'),
       ('Phong Dev 2'),
       ('Phong Sale'),
       ('Phong Marketing'),
       ('Phong Giam Doc'),
       ('Phong Tai Chinh');

/* Lenh sua bang `Position` sua kieu du lieu cot `PositionName` */
ALTER TABLE `Position`
    MODIFY COLUMN `PositionName` ENUM ('Dev1', 'Dev2', 'PM', 'Leader', 'Scrum Master' , 'Test');
/* INSERT DATA bang Position */
INSERT INTO `Position`(`PositionName`)
VALUES ('Dev1'),
       ('Dev2'),
       ('Test'),
       ('PM'),
       ('Leader'),
       ('Scrum Master');

/* lenh sua bang xoa khoa ngoai foreign key*/
-- ALTER TABLE `Account`
--     DROP CONSTRAINT `fk_dp_id`,
--     DROP CONSTRAINT `fk_ps_id`;
/* INSERT DATA bang Account */
INSERT INTO `Account`(`Email`, `Username`, `Fullname`, `DepartmentID`, `PositionID`, `CreateDate`)
VALUES ('vti_account1@vtiacademy.com', 'vti1', 'Nguyen Van Tinh', 1, 1, '2019-12-01'),
       ('vti_account2@vtiacademy.com', 'vti2', 'Trinh Hoai Linh', 1, 2, '2020-12-01'),
       ('vti_account3@vtiacademy.com', 'vti3', 'Nguyen Van Test', 1, 1, '2020-07-01'),
       ('vti_account4@vtiacademy.com', 'vti4', 'Tran Van Tinh', 1, 2, '2019-09-01'),
       ('vti_account5@vtiacademy.com', 'account5', 'Ho Van Tinh', 3, 2, '2021-07-01'),
       ('vti_account6@vtiacademy.com', 'account_vti6', 'Cao Thai Son', 3, 1, NOW()),
       ('vti_7@vtiacademy.com', 'account_vti7', 'Tam Thất Tùng', 3, 3, '2020-10-01'),
       ('vti_8@vtiacademy.com', 'account_vti8', 'Nguyen Quynh Thu', 3, 4, '2019-04-01'),
       ('vti_9@vtiacademy.com', 'account_vti9', 'Tran Kim Tuyen', 2, 1, NOW()),
       ('vti_account10@vtiacademy.com', 'account_vti10', 'Nguyen Ba Dao', 1, 5, '2019-10-01'),
       ('vti_account11@vtiacademy.com', 'account_vti11', 'Nguyen Van Binh', 1, 3, '2020-12-01');

/* INSERT DATA bang Group */
INSERT INTO `Group`(`GroupName`, `CreatorID`, CreateDate)
VALUES ('Nhom 1', '3', '2021-04-03'),
       ('Nhom 2', '3', '2019-01-03'),
       ('Nhom 3', '2', '2020-04-03'),
       ('Nhom 4', '1', NOW()),
       ('Nhom 5', '3', '2021-06-03'),
       ('Nhom 6', '1', '2020-04-03'),
       ('Nhom 7', '5', '2021-04-03'),
       ('Nhom 8', '5', '2019-05-03'),
       ('Nhom 9', '3', '2019-01-03'),
       ('Nhom 10', '1', NOW());

/* INSERT DATA bang GroupAccount */
INSERT INTO `GroupAccount`(`GroupID`, `AccountID`, `JoinDate`)
VALUES ('1', '1', '2021-06-01'),
       ('1', '3', '2020-01-01'),
       ('1', '2', NOW()),
       ('1', '4', '2021-06-01'),
       ('2', '1', '2021-06-01'),
       ('2', '10', '2019-05-01'),
       ('5', '1', '2021-06-01'),
       ('5', '3', '2020-01-01'),
       ('5', '4', '2021-07-01'),
       ('3', '1', '2021-06-01'),
       ('9', '2', '2021-06-01'),
       ('10', '1', NOW());

/* INSERT DATA bang TypeQuestion */
INSERT INTO `TypeQuestion`(`TypeName`)
VALUES ('Trac nghiem'),
       ('Tu Luan');

/* INSERT DATA bang CategoryQuestion */
/*`CategoryName` ENUM ('Java', 'SQL', '.NET', 'Ruby', 'Python', 'NodeJS' , 'HTML', 'CSS', 'JavaScript')*/
INSERT INTO `CategoryQuestion` (`CategoryName`)
VALUES ('Java'),
       ('SQL'),
       ('HTML'),
       ('CSS '),
       ('.NET'),
       ('Python'),
       ('Ruby'),
       ('JavaScript');

/* Lenh sua bang `Question` Xoa rang buoc khoa ngoai Foreign Key */
-- ALTER TABLE `Question`
--     DROP CONSTRAINT `fk_q1`,
--     DROP CONSTRAINT `fk_q2`,
--     DROP CONSTRAINT `fk_q3`;
/* INSERT DATA bang Question */
INSERT INTO `Question`(`Content`, CategoryID, TypeID, CreatorID, CreateDate)
VALUES ('Câu hỏi SQL 1', 2, 2, 1, '2021-04-01'),
       ('Câu hỏi SQL 2', 2, 2, 2, '2020-01-01'),
       ('Câu hỏi JAVA 1', 1, 1, 10, '2021-07-01'),
       ('Câu hỏi JAVA 2', 1, 2, 5, '2021-06-01'),
       ('Câu hỏi HTML 1', 3, 1, 2, NOW()),
       ('Câu hỏi HTML 2', 3, 2, 2, NOW());

/* lenh sua bang xoa khoa ngoai foreign key*/
-- ALTER TABLE `Answer`
--     DROP CONSTRAINT `fk_qid`;
/* INSERT DATA bang Answer */
INSERT INTO `Answer` (`Content`, `QuestionID`, `isCorrect`)
VALUES ('Câu trả lời 1 - question SQL 1', 1, 1),
       ('Câu trả lời 2 - question SQL 1', 1, 0),
       ('Câu trả lời 3 - question SQL 1', 1, 0),
       ('Câu trả lời 4 - question SQL 1', 1, 1),
       ('Câu trả lời 1 - question SQL 2', 2, 0),
       ('Câu trả lời 2 - question SQL 2', 2, 0),
       ('Câu trả lời 3 - question SQL 2', 2, 0),
       ('Câu trả lời 4 - question SQL 2', 2, 1),
       ('Câu trả lời 1 - question JAVA 1', 3, 0),
       ('Câu trả lời 2 - question JAVA 1', 3, 1),
       ('Câu trả lời 1 - question JAVA 2', 4, 0),
       ('Câu trả lời 2 - question JAVA 2', 4, 0),
       ('Câu trả lời 3 - question JAVA 2', 4, 0),
       ('Câu trả lời 4 - question JAVA 2', 4, 1),
       ('Câu trả lời 1 - question HTML 1', 5, 1),
       ('Câu trả lời 2 - question HTML 2', 5, 0);

/* lenh sua bang xoa khoa ngoai foreign key*/
-- ALTER TABLE `Exam`
--     DROP CONSTRAINT `fk_ex_1`;
-- ALTER TABLE `Exam`
--     DROP CONSTRAINT `fk_ex_2`;
/* INSERT DATA bang Exam */
INSERT INTO `Exam`(`Code`, `Title`, `CategoryID`, `Duration`, `CreatorID`, `CreateDate`)
VALUES ('MS_01', 'De thi 01', 1, 90, 1, NOW()),
       ('MS_02', 'De thi 02', 1, 60, 5, NOW()),
       ('MS_03', 'De thi 03', 2, 60, 9, NOW()),
       ('MS_04', 'De thi 04', 2, 90, 1, NOW()),
       ('MS_05', 'De thi 05', 1, 60, 2, NOW()),
       ('MS_06', 'De thi 06', 2, 90, 2, NOW()),
       ('MS_07', 'De thi 07', 1, 60, 1, NOW());

/* lenh sua bang xoa khoa ngoai foreign key*/
-- ALTER TABLE `ExamQuestion`
--     DROP CONSTRAINT `fk_eq1`,
--     DROP CONSTRAINT `fk_eq2`;
/* INSERT DATA bang Examquestion */
INSERT INTO `ExamQuestion`
VALUES (1, 1),
       (2, 1),
       (3, 1),
       (4, 1),
       (5, 2),
       (6, 2),
       (7, 2),
       (8, 2),
       (9, 3),
       (10, 3),
       (11, 4),
       (12, 4),
       (13, 4),
       (14, 4),
       (15, 5),
       (16, 5);

/* TESTING_SYSTEM_3 */
-- Question 2: lay ra tat ca cac phong ban--
SELECT * FROM Department;

-- Question 3: lay ra ID cua phong ban Sale
SELECT DepartmentID FROM Department Where DepartmentName = `Phong Sale`;

-- Question 4: acount co fullname dai nhat
SELECT * FROM `Account` 
Where Character_length(Fullname) = 
(SELECT Character_length(Fullname) As length_FullName 
FROM `Account` ORDER BY length DESC LIMIT 1);
SELECT * FROM `Account` 
Where Character_length(Fullname) = 
(SELECT MAX(character_length(Fullname)) FROM `Account`As length_FullName);

-- Question 5: lay ra account co full name dai nhat va thuoc phong ban co id = 3
SELECT * FROM `Account` 
Where character_length(Fullname) = 
(Select MAX(character_length(Fullname)) FROM `Account` As length_Name WHERE DepartmentID = 3) AND DepartmentID = 3; 

-- Question 6: lay ra ten group da tham gia truoc ngay 20/12/2019
SELECT GroupName FROM `GROUP`
WHERE CreateDate < `2019-12-20`;

-- Question 7: lay ra ID cua Question co >= 4 cau tra loi
SELECT QuestionID, COUNT(QuestionID) AS SL_QuestionID
FROM Answer
GROUP BY QuestionID
HAVING SL_QuestionID >= 4;

-- Question 8: Lay ra Ma de thi co thoi gian >= 60 phut va duoc tao truoc ngay 20/12/2019
SELECT `Code`, Duration, Createdate FROM Exam
WHERE Duration > 60 AND Createdate < '2021-12-20';

-- Question 9: Lay ra 5 group duoc tao gan nhat
SELECT * FROM `Group`
ORDER BY Createdate DESC
LIMIT 5;

-- Question 10: Dem so nhan vien thuoc department co id = 2
SELECT DepartmentID, COUNT(DepartmentId) As SL_nhan_vien
FROM `Account`
WHERE DepartmentID = 2;

-- Question 11: Lay ra ten nhan vien bat dau bang chu "D" va ket thuc bang chu "O"
SELECT FullName FROM `Account`
WHERE Fullname LIKE "D%o";

-- Question 12: Xoa tat ca cac exam duoc tao truoc ngay 20/12/2019
/* Begin work;
DELETE FROM `exam` WHERE Create Date < `2019-12-20`;
Role back; */

-- Question 13: Xoa tat ca cac question co noi dung bat dau bang tu "cau hoi"
SET SQL_SAFE_UPDATE =0;
DELETE FROM `Question` WHERE Content LIKE 'cau hoi%';

-- Question 14: Update thong tin cua account co id = 5 thanh vien "Nguyen Ba Loc" va 
-- email thanh "loc.nguyen@vti.com.vn"

SET SQL_SAFE_UPDATE =0;
UPDATE `Account` SET Fullname = `Nguyen Ba Loc`, Email =`loc.nguyen@vti.com.vn` 
WHERE AccountID = 5;

-- Question 15: Update account co id = 5 se thuoc group co id = 4
 SET SQL_SAFE_UPDATE =0;
 UPDATE GroupAccount SET Groupid = 4 WHERE AccountID = 5;
 
 /* TESTING_SYSTEM_4 */
 -- Question 1: Lay ra danh sach nhan vien va thong tin phong ban cua ho

(SELECT Username, A.DepartmentID, DepartmentName
FROM `Account` A LEFT JOIN Department D ON A.DepartmentID = D.DEPARTMENTID)
UNION
(
SELECT Username, DepartmentID, "Khong co phong ban"
FROM `Account`
WHERE DepartmentID NOT IN (SELECT DepartmentID FROM Department)
);

SELECT Username, A.DepartmentID, IF(DepartmentName IS NULL, "Khong co phong ban",DepartmentName)
FROM `Account` A LEFT JOIN Department D ON A.DepartmentID = D.DEPARTMENTID;

 -- Question 2: Lay ra thong tin cac account duoc tao sau ngay 20/12/2010
 SELECT *
 FROM `Account`
 WHERE CreateDate > '2010-12-20';
 
 -- Question 3: Lay ra tat ca cac developer
 Select Ac.*, DepartmentName
 FROM `Account` Ac JOIN Department D USING (DepartmentID)
 WHERE DepartmentName LIKE '%DEV%';
 
 -- Question 4:	Lay ra danh sach cac phong ban co > 3 nhan vien
 SELECT D.*, COUNT(DepartmentID) As SL_Nhanvien 
 FROM Department D LEFT JOIN `Account` AC USING (DepartmentID)
 GROUP BY DepartmentID
 HAVING  COUNT(DepartmentID) > 3;
 
 -- Question 5: Lay ra danh sach cau hoi duoc su dung trong de thi nhieu nhat
-- 1. Đếm số lượng câu hỏi trong bảng examquestion & group theo cau hỏi (QuestionID)
    SELECT QuestionID, Content, COUNT(QuestionID) As SL_Question_use_to_Exam
			FROM Question Q JOIN ExamQuestion EQ USING (QuestionID)
			GROUP BY QuestionID;
            
-- 2. Lấy Max trong (1)
SELECT MAX(SL_Question_use_to_Exam) 
		FROM (SELECT QuestionID, Content, COUNT(QuestionID) As SL_Question_use_to_Exam
			FROM Question Q JOIN ExamQuestion EQ USING (QuestionID)
			GROUP BY QuestionID ) As New_Table; 
			
-- 3. Tìm danh sách câu hỏi với đk số lượng bằng = max

SELECT QuestionID, Content, COUNT(QuestionID) As Max_SL_Question_use_Max_to_Exam
FROM Question Q JOIN ExamQuestion EQ USING (QuestionID)
GROUP BY QuestionID
HAVING COUNT(QuestionID) = 
		( SELECT MAX(SL_Question_use_to_Exam) 
		FROM (SELECT COUNT(QuestionID) As SL_Question_use_to_Exam
			FROM Question Q JOIN ExamQuestion EQ USING (QuestionID)
			GROUP BY QuestionID 
            ) AS New_Table 
		);
            
/* TESTING_SYSTEM_6 */
 -- Question 4: Lay ra Type Question co nhieu cau hoi nhat
 
 -- 1. Tao view Dem SL Question trong TypeQuestion
 DROP VIEW IF EXISTS v_type_questions;
CREATE OR REPLACE VIEW v_type_questions AS(
			SELECT typeID, Count(*) AS total 
            FROM question q JOIN TypeQuestion tq USING(TypeID) 
            GROUP BY TypeID
		);
SELECT * FROM v_questions;

-- Tao thu tuc tra gia tri Typeid = max trong bang view
DROP PROCEDURE IF EXISTS pr_id_maxCQ;
DELIMITER $$
CREATE PROCEDURE pr_id_maxCQ(OUT IDQ INT)
BEGIN
		
	   SELECT `TypeID` INTO IDQ
       FROM	v_type_questions WHERE total = (SELECT MAX(total) FROM v_type_questions);

END $$
DELIMITER ;

CALL pr_id_maxCQ(@FF);
SELECT @FF;

-- Sql LOI 1418: CHAY CAU LENH PHIA DUOI
-- SET GLOBAL log_bin_trust_function_creators = 1;

CREATE OR REPLACE VIEW v_type_questions AS(
			SELECT typeID, Count(*) AS total 
            FROM question q JOIN TypeQuestion tq USING(TypeID) 
            GROUP BY TypeID
		);

 DROP FUNCTION IF EXISTS pr_id_maxCQ;       
DELIMITER $$
CREATE FUNCTION f_id_maxCQ() RETURNS INT
BEGIN
	   DECLARE IDQ INT;
	   SELECT `TypeID` INTO IDQ
       FROM	v_type_questions WHERE total = (SELECT MAX(total) FROM v_type_questions) ;
       RETURN IDQ;
END $$
DELIMITER ;

SELECT * FROM TypeQuestion WHERE TypeID = (SELECT f_id_maxCQ());

/* TESTING_SYSTEM_7 */
-- Question 1: Tao trigger khong cho phep nguoi dung nhap vao GROUP co ngay tao truoc 1 nam truoc
DROP TRIGGER IF EXISTS Trigger_Insert_Group;
DELIMITER $$

Create TRIGGER Trigger_Insert_Group
BEFORE INSERT ON `GROUP` 
FOR EACH ROW
BEGIN
	IF (YEAR(NOW()) - YEAR(NEW.Createdate)) > 0 THEN  
	SIGNAL SQLSTATE '12345' -- Disallow Insert Record
	SET MESSAGE_TEXT = 'Cant Create this Group';
End IF;  
END $$
DELIMITER ; 
-- Cach 2: Dung ham DATE_SUB trong MySQL la: DATE_SUB(date, INTERVAL Values Unit)
DROP TRIGGER IF EXISTS Trg_Insert_Group;
DELIMITER $$

Create TRIGGER Trg_Insert_Group
BEFORE INSERT ON `GROUP` 
FOR EACH ROW
BEGIN
	DECLARE v_CreateDate DATETIME;
    Set V_CreateDate = DATE_SUB(NOW(),INTERVAL 1 Year);
	IF (NEW.Createdate < V_CreateDate) THEN  
	SIGNAL SQLSTATE '12345' -- Disallow Insert Record
	SET MESSAGE_TEXT = 'Cant Create this Group';
End IF;  
END $$
DELIMITER ; 

INSERT INTO `group` (`GroupName`, `CreatorID`, `CreateDate`) VALUES ('Nhom 12', '6', '2019-01-01');

-- QUESTION 2: Tao trigger khong cho phep nguoi dung them bat ky user nao vao Department "Sale" nua, 
-- khi them thi hien ra thong bao "Departmnent Sale cannot add more user"

DROP TRIGGER IF EXISTS Tg_NOT_ADD_USER_TO_SALE;
DELIMITER $$
CREATE TRIGGER Tg_NOT_ADD_USER_TO_SALE
BEFORE INSERT ON `Account`
FOR EACH ROW
BEGIN
	DECLARE D_ID TINYINT;
	SELECT D.DepartmentID INTO D_ID FROM Department D WHERE D.DepartmentName = 'Phong Sale'; 
	IF (NEW.DepartmentID = D_ID) THEN
    SIGNAL SQLSTATE "12345"
    SET MESSAGE_TEXT = 'Departmnent Sale cannot add more user';
    END IF;
END $$;
DELIMITER ;

INSERT INTO `testing_system_1`.`account` (`AccountID`, `Email`, `Username`, `Fullname`, `DepartmentID`, `PositionID`, `CreateDate`) VALUES ('14', 'vti_account14@vtiacademy.com', 'account_vti14', 'Nguyen Van Truong', '5', '3', '2021-09-26 00:00:00');

-- Question 3: Cấu hình 1 group có nhiều nhất là 5 user
DROP TRIGGER IF EXISTS Tg_Check_ADD_USER_TO_GROUP;
DELIMITER $$
CREATE TRIGGER  Tg_Check_ADD_User_TO_GROUP
BEFORE INSERT ON `GroupAccount` 
FOR EACH ROW 
BEGIN
	DECLARE Max_GroupID TINYINT;
	SELECT COUNT(GroupID) INTO Max_GroupID FROM `GroupAccount` GA
    WHERE GA.GroupID = NEW.GroupID
	GROUP BY GA.GroupID;   
    IF (Max_GroupID > 5) THEN
    SIGNAL SQLSTATE '12345'
    SET MESSAGE_TEXT = 'Not Add User - GROUP DA QUA 5 USER';
    END IF;
END $$;
DELIMITER ;

-- Question 4: Cấu hình 1 bài thi có nhiều nhất là 10 Question

DROP TRIGGER IF EXISTS Trg_Check_Add_Question_To_Exam;
DELIMITER $$
CREATE TRIGGER Trg_Check_Add_Question_To_Exam
BEFORE INSERT ON Examquestion
FOR EACH ROW
BEGIN
DECLARE Max_ExamID TINYINT;
SELECT Count(ExamID) INTO SL_ExamID FROM Examquestion EQ
WHERE EQ.ExamID = NEW.ExamID;
IF (Max_ExamID > 10 ) THEN
SIGNAL SQLSTATE '12345'
SET MESSAGE_TEXT = 'Not ADD Question - DE THI DA QUA 10 CAU HOI';
END IF;
END $$;
DELIMITER ; 

-- Question 5: Tạo trigger không cho phép người dùng xóa tài khoản có email là
-- 				admin@gmail.com (đây là tài khoản admin, không cho phép user xóa),
-- 				còn lại các tài khoản khác thì sẽ cho phép xóa và sẽ xóa tất cả các thông
-- 				tin liên quan tới user đó

DELETE
FROM `Account`
WHERE Email ='admin@gmail.com';

DROP TRIGGER IF EXISTS Trg_Check_DELETE_USER_Admin;
DELIMITER $$
CREATE TRIGGER Trg_Check_DELETE_USER_Admin
BEFORE DELETE ON `Account`
FOR EACH ROW
BEGIN
DECLARE Email_Admin VARCHAR(50);
SET Email_Admin = 'admin@gmail.com';
IF (OLD.Email = Email_Admin) THEN
SIGNAL SQLSTATE '12345'
SET MESSAGE_TEXT = 'Not Delete User - DAY LA TAI KHOAN ADMIN';
END IF;
END $$;
DELIMITER ; 

-- Question 6: Không sử dụng cấu hình default cho field DepartmentID của table
-- 				Account, hãy tạo trigger cho phép người dùng khi tạo account không điền
-- vào departmentID thì sẽ được phân vào phòng ban "waiting Department"

DROP TRIGGER IF EXISTS Trg_Add_User_Not_DepartmentID;
DELIMITER $$
CREATE TRIGGER Trg_Add_User_Not_DepartmentID
BEFORE INSERT ON `Account`
FOR EACH ROW
BEGIN
DECLARE Waiting_DepartmentID VARCHAR(50);
SELECT D.DepartmentID INTO Waiting_DepartmentID
FROM Department D
WHERE DepartmentName = 'waiting Department';
IF (NEW.DepartmentID IS NULL) THEN
SET NEW.DepartmentID = Waiting_DepartmentID;
SET MESSAGE_TEXT = 'Not DepartmentID - Auto DepartmentID is Waiting DepartmentID';
END IF;
END $$;
DELIMITER ; 

-- Question 7: Cấu hình 1 bài thi chỉ cho phép user tạo tối đa 4 answers cho mỗi
-- question, trong đó có tối đa 2 đáp án đúng.

DROP TRIGGER IF EXISTS Trg_Add_Max_Answers_To_Question;
DELIMITER $$
CREATE TRIGGER Trg_Add_Max_Answer_To_Question
BEFORE INSERT ON `Answer`
FOR EACH ROW
BEGIN
DECLARE Max_QuestionID TINYINT;
DECLARE Max_isCorrect_True TINYINT;
SELECT COUNT(QuestionID) INTO Max_QuestionID
FROM Answer
WHERE QuestionID = NEW.QuestionID ;
SELECT COUNT(1) INTO Max_isCorrect_True
FROM Answer
WHERE QuestionID = NEW.QuestionID AND IsCorrect = NEW.IsCorrect;
IF (Max_QuestionID > 4) OR (Max_isCorrect_True > 2) THEN
SIGNAL SQLSTATE '12345'
SET MESSAGE_TEXT = 'Not Add Answer - Da qua 4 cau hoi';
END IF;
END $$;
DELIMITER ; 

-- Question 8: Viết trigger sửa lại dữ liệu cho đúng:
-- 				Nếu người dùng nhập vào gender của account là nam, nữ, chưa xác định
-- Thì sẽ đổi lại thành M, F, U cho giống với cấu hình ở database

DROP TRIGGER IF EXISTS Trg_Check_Gender_User;
DELIMITER $$
CREATE TRIGGER Trg_Check_Gender_User
BEFORE INSERT ON `Account`
FOR EACH ROW
BEGIN
IF (NEW.GENDER = 'Nam') THEN
SET NEW.GENDER = 'M';
ELSEIF (NEW.GENDER = 'NU') THEN
SET NEW.GENDER = 'N';
ELSEIF (NEW.GENDER = 'chua xac dinh') THEN
SET NEW.GENDER = 'U';
END IF;
END $$;
DELIMITER ; 
-- chua co truong du lieu gender cua bang Account

-- Question 9: Viết trigger không cho phép người dùng xóa bài thi mới tạo được 2 ngày
Delete 
FROM EXAM
WHERE Createdate < 2;

DROP TRIGGER IF EXISTS Trg_Check_Delete_Exam;
DELIMITER $$
CREATE TRIGGER Trg_Check_Delete_Exam
BEFORE DELETE ON `Exam`
FOR EACH ROW
BEGIN
DECLARE Dk_Createdate DATETIME;
SET DK_Createdate = DATE_SUB(NOW(),INTERVAL 2 DAY);
IF (OLD.Createdate < Dk_CreateDate ) THEN
SIGNAL SQLSTATE '12345' -- Disallow Delete Exam
SET MESSAGE_TEXT = 'Not Delete Exam - CreateDate < 2';
END IF;
END $$;
DELIMITER ; 

-- Question 10: Viết trigger chỉ cho phép người dùng chỉ được update, delete các
-- question khi question đó 'chưa' nằm trong exam nào

DROP TRIGGER IF EXISTS Trg_Check_Update_Question_Not_Exam;
DELIMITER $$
CREATE TRIGGER Trg_Check_Update_Question_Not_Exam
BEFORE INSERT ON `Question`
FOR EACH ROW
BEGIN
DECLARE SL_QuestionID TINYINT ;
SET SL_QuestionID = -1 ;
SELECT COUNT(EX.QuestionID) INTO SL_QuestionID
FROM EXAMQUESTION EX
WHERE EX.QuestionID = NEW.QuestionID;
IF (SL_QuestionID != - 1) THEN
SIGNAL SQLSTATE '12345'
SET MESSAGE_TEXT = 'Not Update Question - Question chua co trong Exam';
END IF;
END $$;
DELIMITER ; 

-- Delete lam tuong tu

DROP TRIGGER IF EXISTS Trg_Check_Delete_Question_Not_Exam;
DELIMITER $$
CREATE TRIGGER Trg_Check_Delete_Question_Not_Exam
BEFORE DELETE ON `Question`
FOR EACH ROW
BEGIN
DECLARE SL_QuestionID TINYINT ;
SET SL_QuestionID = -1 ;
SELECT COUNT(EX.QuestionID) INTO SL_QuestionID
FROM EXAMQUESTION EX
WHERE EX.QuestionID = OLD.QuestionID;
IF (SL_QuestionID != - 1) THEN
SIGNAL SQLSTATE '12345'
SET MESSAGE_TEXT = 'Not Update Question - Question chua co trong Exam';
END IF;
END $$;
DELIMITER ; 

-- QUESTION 12: Lấy ra thông tin exam trong đó:
-- 				Duration <= 30 thì sẽ đổi thành giá trị "Short time"
-- 				30 < Duration <= 60 thì sẽ đổi thành giá trị "Medium time"
-- Duration > 60 thì sẽ đổi thành giá trị "Long time"

SELECT * FROM Exam;
SELECT E.ExamID, E.CodeID, E.Title, CASE
WHEN (Duration <= 30) THEN 'Sort time'
WHEN (30 < Duration <= 60) THEN 'Medium time'
    ELSE 'Long time'
    END AS Duration, E.Createdate, E.Duration
FROM Exam E;

-- QUESTION 13: Thống kê số account trong mỗi group và in ra thêm 1 column nữa có tên
-- 				là the_number_user_amount và mang giá trị được quy định như sau:
-- 				Nếu số lượng user trong group <= 5 thì sẽ có giá trị là few
-- 				Nếu số lượng user trong group <= 20 và > 5 thì sẽ có giá trị là normal
-- Nếu số lượng user trong group > 20 thì sẽ có giá trị là higher
WITH CTE_Total_Account_to_Group AS (
SELECT GR.GroupID, GroupName, Count(GroupID) As SL_Acc, CASE
	WHEN (Count(GroupID) <= 5) THEN 'FEW'
    WHEN (Count(GroupID) > 5) AND (Count(GroupID) <= 20) THEN 'NORMAL'
    ELSE 'Higher'
    END AS the_number_user_amount
FROM `GROUP` GR LEFT JOIN GROUPAccount GA USING (GroupID)
JOIN `Account` Ac USING (AccountID)
GROUP BY GroupID
)
Select * FROM CTE_Total_Account_to_Group;

-- QUESTION 14: Thống kê số mỗi phòng ban có bao nhiêu user, nếu phòng ban nào
-- không có user thì sẽ thay đổi giá trị 0 thành "Không có User"

SELECT D.DepartmentID, DepartmentName, CASE 
	WHEN COUNT(DepartmentID) ='0' THEN 'Không có User'
    ELSE COUNT(DepartmentID)
    END AS SL_User
FROM Department D LEFT JOIN `Account` Ac USING (DepartmentID)
GROUP BY DepartmentID;
