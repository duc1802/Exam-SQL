CREATE DATABASE EmployeeDB
GO
USE EmployeeDB
GO
CREATE TABLE Department(
	DepartID INT PRIMARY KEY,
	DepartName VARCHAR(50) NOT NULL,
	Description VARCHAR(100) NOT NULL
);

CREATE TABLE Employee(
	Empcode CHAR(6) PRIMARY KEY,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	Birthday SMALLDATETIME NOT NULL,
	Gender BIT DEFAULT 1,
	Address VARCHAR(100),
	DepartID INT ,
	Salary MONEY,
	FOREIGN KEY (DepartID) REFERENCES Department(DepartID)
);

INSERT INTO Department (DepartID, DepartName, Description) VALUES
(101, 'IT', 'Information Technology') ,
(102, 'HR', 'Human Resources'),
(103, 'Finance', 'Finance and Accounting')
Go
INSERT INTO Employee(Empcode, FirstName, LastName, Birthday, Gender, Address, DepartID, Salary) VALUES
('A001', 'John', 'Doe', '1999-01-02', 1, '123 Main St', 101, 50000),
('A002', 'Jane', 'Smith', '1998-03-04', 0, '789 Park Ave', 102, 55000),
('A003', 'Bob', 'Johnson', '1995-05-06', 1, '456 Elm St', 103, 60000)
GO

--2.Increase the salary for all employees by 10% [1 mark].
UPDATE Employee SET Salary = Salary*1.1;
SELECT * FROM Employee ;
--3.Using ALTER TABLE statement to add constraint on Employee table to ensure that salary always greater than 0 [2 marks].
ALTER TABLE Employee ADD CHECK (Salary>0);
--4.Create a trigger named tg_chkBirthday to ensure value of birthday column on Employee table always greater than 23 [3 marks].
CREATE TRIGGER tg_chkBirthday
ON Employee
AFTER INSERT, UPDATE
AS
BEGIN
	IF EXISTS (SELECT 1 FROM inserted WHERE Birthday <= 23)
	BEGIN
		RAISERROR('value of birthday column must be greater than 23', 16, 1);
		ROLLBACK TRANSACTION;
	END
END
--5.Create an unique, none-clustered index named IX_DepartmentName on DepartName column on Department table
CREATE UNIQUE INDEX IX_DepartmentName
ON Department (DepartName)
--6.Create a view to display employee’s code, full name and department name of all employees [3 marks].
SELECT Department.DepartName, Employee.Empcode, Employee.FirstName, Employee.LastName FROM Department INNER JOIN Employee ON Department.DepartID = Employee.DepartID;
--7.Create a stored procedure named sp_getAllEmp that accepts Department ID as given input parameter and displays all employees in that Department
create procedure sp_getAllEmp(@departId int)
as
	begin
		select * 
		from employee
		where departId = @departId
	end
go
--8.Create a stored procedure named sp_delDept that accepts employee Id as given input parameter to delete an employee
create procedure sp_delDept(@empId char(6))
as
	begin
		delete from employee
		where empCode = @empId
	end
go