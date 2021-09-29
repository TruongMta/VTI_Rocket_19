DROP DATABASE IF EXISTS QuanLyDiem;
CREATE DATABASE QuanLyDiem;
USE QUANLYDIEM;

DROP TABLE IF EXISTS Student;
CREATE TABLE Student
(
StudentID  	TINYINT UNSIGNED PRIMARY KEY AUTO_iNCREMENT,
StudentName Varchar(50) NOT NULL,
Age 		TINYINT,
Gender 		Varchar(50)
);

DROP TABLE IF EXISTS `Subject`;
CREATE TABLE `Subject`
(
SubjectID	TINYINT UNSIGNED PRIMARY KEY AUTO_iNCREMENT,
SubjectName	Varchar(50) NOT NULL
);

DROP TABLE IF EXISTS StudentSubject;
CREATE TABLE `StudentSubject`
(
StudentID 	TINYINT,
SubjectID 	TINYINT,
Mark 		Varchar(50),
Date 		DATETIME,
PRIMARY KEY (StudentID, SubjectID)
);

-- 1. Tạo table với các ràng buộc và kiểu dữ liệu
-- Thêm ít nhất 3 bản ghi vào table
/* Data Student */
INSERT INTO `quanlydiem`.`student` (`StudentID`, `StudentName`, `Age`, `Gender`) VALUES ('1', 'Truong', '29', '');
INSERT INTO `quanlydiem`.`student` (`StudentID`, `StudentName`, `Age`, `Gender`) VALUES ('2', 'Huy', '30', '1');
INSERT INTO `quanlydiem`.`student` (`StudentID`, `StudentName`, `Age`, `Gender`) VALUES ('3', 'Dat', '25', '0');
INSERT INTO `quanlydiem`.`student` (`StudentID`, `StudentName`, `Age`, `Gender`) VALUES ('4', 'Nghia', '23', '1');

/* Data Subject */
INSERT INTO `quanlydiem`.`subject` (`SubjectID`, `SubjectName`) VALUES ('1', 'Van');
INSERT INTO `quanlydiem`.`subject` (`SubjectID`, `SubjectName`) VALUES ('2', 'Toan');
INSERT INTO `quanlydiem`.`subject` (`SubjectID`, `SubjectName`) VALUES ('3', 'Ly');

/* Data StudentSubject */
INSERT INTO `quanlydiem`.`studentsubject` (`StudentID`, `SubjectID`, `Mark`, `Date`) VALUES ('1', '1', '3', '2021-09-25');
INSERT INTO `quanlydiem`.`studentsubject` (`StudentID`, `SubjectID`, `Mark`, `Date`) VALUES ('1', '2', '4', '2021-09-25');
INSERT INTO `quanlydiem`.`studentsubject` (`StudentID`, `SubjectID`, `Mark`, `Date`) VALUES ('1', '3', '5', '2021-09-20');
INSERT INTO `quanlydiem`.`studentsubject` (`StudentID`, `SubjectID`, `Mark`, `Date`) VALUES ('2', '1', '6', '2021-09-22');
INSERT INTO `quanlydiem`.`studentsubject` (`StudentID`, `SubjectID`, `Mark`, `Date`) VALUES ('2', '2', '7', '2021-09-25');
INSERT INTO `quanlydiem`.`studentsubject` (`StudentID`, `SubjectID`, `Mark`, `Date`) VALUES ('2', '3', '8', '2021-09-20');
INSERT INTO `quanlydiem`.`studentsubject` (`StudentID`, `SubjectID`, `Mark`, `Date`) VALUES ('3', '1', '6', '2021-09-22');
INSERT INTO `quanlydiem`.`studentsubject` (`StudentID`, `SubjectID`, `Mark`, `Date`) VALUES ('3', '2', '10', '2021-09-25');
INSERT INTO `quanlydiem`.`studentsubject` (`StudentID`, `SubjectID`, `Mark`, `Date`) VALUES ('3', '3', '9', '2021-09-20');

-- 2. Viết lệnh để
-- a) Lấy tất cả các môn học không có bất kì điểm nào
SELECT *
FROM `Subject` SJ LEFT JOIN `StudentSubject` SS USING (SubjectID);

SELECT SJ.SubjectID, SubjectName
FROM `Subject` SJ LEFT JOIN `StudentSubject` SS USING (SubjectID)
WHERE SS.MARK IS NULL;

-- b) Lấy danh sách các môn học có ít nhất 2 điểm
SELECT *
FROM `Subject` SJ JOIN `StudentSubject` SS USING (SubjectID)
GROUP BY MARK;

SELECT SJ.SubjectID, SubjectName, Count(SubjectID) As SL
FROM `Subject` SJ JOIN `StudentSubject` SS USING (SubjectID)
GROUP BY SJ.SubjectID
HAVING SL > 1;

-- Cach 2 Dung CTE
WITH CTE_SL_Mon_hoc AS (
SELECT SJ.SubjectID, SubjectName, Count(SubjectID) As SL
FROM `Subject` SJ JOIN `StudentSubject` SS USING (SubjectID)
GROUP BY SJ.SubjectID
)
Select * FROM CTE_SL_Mon_hoc WHERE SL > 1;

-- 3. Tạo view có tên là "StudentInfo" lấy các thông tin về học sinh bao gồm:
-- Student ID,Subject ID, Student Name, Student Age, Student Gender, Subject Name, Mark, Date
-- (Với cột Gender show 'Male' để thay thế cho 0, 'Female' thay thế cho 1 và 'Unknow' thay thế cho null)

DROP VIEW IF EXISTS v_StudentInfo;
CREATE OR REPLACE VIEW v_StudentInfo AS(
	Select ST.StudentID, SB.SubjectID, StudentName, ST.Age AS SStudentAge, CASE 
		WHEN '0' THEN 'MALE'
        WHEN '1' THEN 'FEMALE'
        ELSE 'UNKNOWM'
        END AS StudentGender, SubjectName, Mark, `Date`
	FROM Student ST LEFT JOIN StudentSubject SS USING (StudentId) 
		JOIN `Subject` SB USING (SubjectID)
    );
SELECT * FROM v_StudentInfo;

-- a) Tạo trigger cho table Subject có tên là SubjectUpdateID:
-- Khi thay đổi data của cột ID của table Subject, thì giá trị tương ứng với cột SubjectID của table StudentSubject cũng thay đổi theo

DROP TRIGGER IF EXISTS SubjectUpdateID;
DELIMITER $$
	CREATE TRIGGER SubjectUpdateID
	BEFORE UPDATE ON `Subject`
    FOR EACH ROW
    BEGIN
    UPDATE `Studentsubject` SET SubjectID = New.SubjectID WHERE `SubjectID` = OLD.SubjectID;
    END $$;
DELIMITER ;

SELECT * FROM `Subject`;
SELECT * FROM StudentSubject;
Begin work;
UPDATE `Subject` SET SubjectID = '20' WHERE `SubjectID` = '3' ;
Rollback;

-- b) Tạo trigger cho table Student có tên là StudentDeleteID:
-- Khi xóa data của cột ID của table Student, thì giá trị tương ứng với cột SubjectID của table StudentSubject cũng bị xóa theo

DROP TRIGGER IF EXISTS StudentDeleteID;
DELIMITER $$
	CREATE TRIGGER StudentDeleteID
	BEFORE DELETE ON Student
    FOR EACH ROW
    BEGIN
		DELETE FROM StudentSubject WHERE StudentID = Old.StudentID;
    END $$;
DELIMITER ;

SELECT * FROM Student;
SELECT * FROM StudentSubject;
Begin work;
	DELETE FROM Student WHERE `StudentID` = '3' ;
Rollback;

-- 5. Viết 1 store procedure (có 2 parameters: student name) sẽ xóa tất cả các thông tin liên quan tới học sinh có cùng tên như parameter
-- Trong trường hợp nhập vào student name = "*" thì procedure sẽ xóa tất cả các học sinh

DROP PROCEDURE IF EXISTS P_Delete_Student;
DELIMITER $$
CREATE PROCEDURE P_Delete_Student(IN Std Varchar(50))
BEGIN
	   IF (Std != '*') THEN
       DELETE FROM Student WHERE `Studentname` = std;
       ELSE DELETE FROM STUDENT;
       END IF;
END $$
DELIMITER ;
-- Dem va in SL ban ghi da xoa

DROP PROCEDURE IF EXISTS p_delete_STU;
DELIMITER $$
	CREATE PROCEDURE p_delete_STU(IN stuName varchar(100))
    BEGIN
		DECLARE x int DEFAULT 0;
        IF (stuName != '*' ) THEN
			SELECT COUNT(ID) INTO x FROM student WHERE `Name` = stuName; --  ĐẾM SỐ STUDENT ĐÃ XÓA
			DELETE  FROM student WHERE `Name` = stuName; 
            
        ELSE 
			SELECT COUNT(*) INTO x FROM student;
			DELETE  FROM student; 
        END IF
        ;
		SELECT x AS 'So luong da xoa';
    END $$
DELIMITER ;

SELECT * FROM Student;
BEGIN WORK;
CALL P_Delete_Student('Truong');
ROLLBACK;