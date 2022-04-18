CREATE DATABASE AP203TasksDb

USE AP203TasksDb

CREATE TABLE Groups(
	Id INT PRIMARY KEY IDENTITY,
	No NVARCHAR(10)
)

CREATE TABLE Students(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(100),
	Surname NVARCHAR(120),
	GroupId INT FOREIGN KEY REFERENCES Groups(Id)
)

CREATE TABLE Subjects(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(100)
)

CREATE TABLE Exams(
	Id INT PRIMARY KEY IDENTITY,
	Date DATETIME2 DEFAULT GETDATE(),
	SubjectId INT FOREIGN KEY REFERENCES Subjects(Id)
)

CREATE TABLE StudentsExams(
	Id INT PRIMARY KEY IDENTITY,
	StudentId INT FOREIGN KEY REFERENCES Students(Id),
	ExamId INT FOREIGN KEY REFERENCES Exams(Id),
	Result TINYINT
)

SELECT S.Name + ' ' + S.Surname AS 'Fullname', G.No FROM Students AS S
JOIN Groups AS G
ON G.Id = S.GroupId

SELECT S.Name + ' ' + S.Surname AS 'Fullname', 
(SELECT COUNT(Id) FROM StudentsExams AS SE WHERE SE.StudentId = S.Id) AS 'ExamCount'
FROM Students AS S

SELECT * FROM Subjects AS S
WHERE (SELECT COUNT(Id) FROM Exams AS E WHERE E.SubjectId = S.Id) = 0

SELECT *,
(SELECT COUNT(Id) 
FROM StudentsExams AS SE WHERE SE.ExamId = E.Id) AS 'StudentCount', 
S.Name AS 'SubjectName' FROM Exams AS E
JOIN Subjects AS S
ON S.Id = E.SubjectId
WHERE CONVERT(varchar, E.Date, 5) = CONVERT(varchar, GETDATE() - 1, 5)
--SELECT DATEADD(day, -1, GETDATE())

SELECT S.Name + ' ' + S.Surname AS 'Fullname' FROM StudentsExams AS SE
JOIN Students AS S
ON S.Id = SE.StudentId

SELECT *, (SELECT AVG(Result) FROM StudentsExams AS SE WHERE SE.StudentId = S.Id) AS 'Avarage' FROM Students AS S

CREATE TABLE Authors(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(100),
	Surname NVARCHAR(120)
)

CREATE TABLE Books(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(100) CHECK(LEN(NAME) >= 2),
	PageCount INT CHECK(PageCount >= 10),
	AuthorId INT FOREIGN KEY REFERENCES Authors(Id)
)


CREATE VIEW v_GetBookInfo
AS
SELECT B.Id,
	   B.Name 'BookName',
	   B.PageCount,
	   A.Name + ' ' + a.Surname 'AuthorFullname'
FROM Books AS B
JOIN Authors AS A
ON A.Id = B.AuthorId

SELECT * FROM v_GetBookInfo

CREATE PROCEDURE usp_InsertAuthor @name NVARCHAR(100), @surname NVARCHAR(120)
AS
INSERT INTO Authors VALUES (@name,@surname)

CREATE PROCEDURE usp_UpdateAuthor @id INT, @name NVARCHAR(100), @surname NVARCHAR(120)
AS
UPDATE Authors SET Name = @name, Surname = @surname WHERE Id = @id

CREATE PROCEDURE usp_DeleteAuthor @id INT
AS
DELETE FROM Authors WHERE Id=@id

EXEC usp_SearchBooks 'a'

EXEC usp_InsertAuthor 'Seymur', 'Mustafayev'
EXEC usp_InsertAuthor 'Ibrahim', 'Huseynov'

EXEC usp_UpdateAuthor 4, 'Seymur', 'Mustafayev'
EXEC usp_UpdateAuthor 3, 'Sarvan', 'Naxcivanli'

CREATE VIEW v_GetAuthorInfo
AS
SELECT A.Id, A.Name + ' ' + A.Surname 'Fullname', COUNT(B.Id) AS 'BooksCount' , MAX(B.PageCount) AS 'MaxPageCount' FROM Authors AS A
JOIN Books AS B
ON B.AuthorId = A.Id
GROUP BY A.Name, A.Surname, A.Id

SELECT * FROM v_GetAuthorInfo


----EXEC usp_DeleteAuthor 2

--CREATE PROCEDURE usp_SearchBooks @search NVARCHAR(100)

CREATE TABLE Users(
	Id INT PRIMARY KEY IDENTITY,
	Email  NVARCHAR(100)
)

INSERT INTO Users
VALUES ('test@gmail.com')

SELECT Id, SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email)) AS 'EmailDomain' FROM Users