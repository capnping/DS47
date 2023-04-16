Create database CustomerDetails
Use CustomerDetails

Create table Customer
(
CustId int Primary Key,
CustName Varchar(30) not null,
City Varchar(30) not null,
CustStatus Varchar(20) Default 'NEW'
)

Create table Product
(
ProdID int Primary Key,
ProdName Varchar(30) not null,
QtyAvl int not null
)

Create table Orders
(
OrdId Int Primary Key,
CustId int not null,
ProdId int not null,
OrdUnits int not null,
UnitPrice decimal(18,2) not null
)

-------------------ALTER COMMAND----------------------

Alter table Customer add constraint PK_Customer Primary Key(CustID)

Alter table Orders add constraint FK_Orders_Customer Foreign Key(CustID) references Customer(CustID) 

Alter table Orders add constraint FK_Orders_Product Foreign Key(ProdID) references Product(prodId)

Create table Bonus
(
EmpId Int,
Year Int,
Amount decimal(18,2)
Constraint PK_Bonus Primary Key(EmpId,Year)
)

-------------------------INSERT------------------------
Insert into Customer values(1002,'Gretal','Mumbai',default),(1003,'Ron','New Delhi','Regular'),(1004,'Cathy','Bangalore','Regular')

Insert into Product values(11,'Shoes',11),(22,'Shirts',15),(33,'Watches',24),(44,'Laptops',0)

Insert into Orders values(101,1001,33,5,3000),(102,1003,11,13,4000),(103,1001,44,4,7000)

Select * from Customer
Select * from Product
Select * from Orders

Delete from product where ProdId=11
Truncate table product
---------------------SUBQUERIES---------------------

Select CustId as [Customers who placed an order] from Customer where CustId= ANY(Select CustId from Orders);
Select CustId as [Customers who not placed any order] from Customer where CustId<> ALL(Select CustId from Orders);

Select ProdId from Product where ProdId = ANY(Select ProdID from Orders)
Select ProdId from Product where ProdId <>ALL(Select ProdID from Orders)

Select CustId as [Customers who placed an order] from Customer where CustId IN(Select CustId from Orders);
Select CustId as [Customers who not placed any order] from Customer where CustId NOT IN(Select CustId from Orders);

----------IN replaces multiple ORs in queries-----------------

Select * from Customer where city='New Delhi' or city = 'Mumbai'

Select * from Customer where City IN ('New Delhi','Mumbai')

Select * from Customer where City NOT IN ('New Delhi','Mumbai')

Select * from Product
Select * from Orders

--Find the list of all the products for which an 
--order has been placed but the qtyavl is less than quantity ordered

Select ProdId from Product where ProdID IN (Select ProdId from Orders) 
AND QtyAvl<ANY(Select OrdUnits from Orders);

Select * from Customer
Select * from Orders

Select CustId from Customer where CustId IN (Select CustId from Orders)

Select * from Customer
Update Customer Set CustStatus='Current' where CustId IN (Select CustId from Orders)
Select * from Customer

-----------------------DCL--------------------------

Use Master;

Create Login Login123 with password='123'

Use CustomerDetails;
Create user user123 for login Login123
Create user user321 for login Login123 ---- Will not have access

Create database Test
Use Test
Create user user123 for login Login123

------------------------GRANT------------------

Grant SELECT on Customer to User123

Grant ALL on Customer to User123 ---- INSERT, UPDATE, DELETE, SELECT

Grant Alter on Customer to user123

Revoke INSERT on Customer from User123

Select * from Customer;
-----------------------TCL----------------------

Begin transaction --- transaction/tran both works

Insert into Customer values(1006,'Daniel','Pune', 'Regular')

Rollback
Commit
------------------------------
Begin tran

Insert into Customer values(1006,'Daniel','Pune', 'Regular')
Save tran I

Update Customer Set CustName='Richa' where CustId=1003
Save tran U

Delete from Customer where CustId=1004
Save tran D

Rollback tran U

-----------------------VARIABLES--------------------------
Go
Declare @a int, @b varchar(30)

----Assigning values to variables------------

--1.
Go
Declare @a int =10, @b varchar(30)='Ellie' --- We assign default values
Print @a
Print @b
--2.
Go
Declare @a int, @b varchar(30)
Set @a=20
Set @b='Jammie'    ---- Cannot assign multiple variable using a single set command
Print 'The number is '+ Cast(@a as varchar(20))
Print 'The name is '+ @b
--3.
GO
Declare @a int, @b varchar(30)
Select @a=30, @b='Rosie'	--- Can assign multiple variable with single select
Print @a
Print @b

-------Differences----------
--1. Cannot assign multiple variable using a single set command
--2. Fetch query value in a variable, set has to be used along with select

use CustomerDetails
Go
Declare @City varchar(30)
Select @city=city from customer where custid=1003

Set @City=(Select city from Customer where custid=1003)

--3. Assigning a value to a variable(default) from a query which returns NULL values:
--SET: Return a NULL
--Select : Return the default value

Go
Declare @City varchar(30)='New York'
Select @city=city from customer where custid=1033
Print @City

Go
Declare @City varchar(30)='Seattle'
Set @City=(Select city from Customer where custid=1033)
Print @City

--4. Assigning a value to a variable from a query which returns multiple values:
--SET: return an error
--SELECT: return the last executed value

Go
Declare @Name varchar(30)
Select @Name=CustName from customer where City='New Delhi'
Print @Name

Go
Declare @Name varchar(30)
Set @Name=(Select CustName from Customer where City='New Delhi')
Print @Name

Select * from Customer

-------------------TESTING CONDITIONS----------------
------------- IF-ELSE Conditions-----------

/*IF Condition1
Statement/expression
ElSE IF Condition2
Statement/expression
....
ELSE IF Condition N
Statement/expression
ELSE
Statement/expression*/

Go
Declare @a int=30, @b int=30

Begin
IF(@a>@b)
Print 'A is greater than B'

ElSE IF(@b>@a)
print 'B is greater than A'

ELSE
Print 'Both are equal'
End

---

Select * from Orders

Go
Declare @TotalPrice as decimal(18,2),@units int, @unitprice decimal(18,2) 

Set @TotalPrice=(Select Ordunits*unitprice from orders where OrdId=102)
Select @units=ordunits, @unitprice=UnitPrice from orders where ordId=102
Print 'Total Units= '+Cast(@units as varchar(20))
Print 'Total unit price= '+Cast(@unitprice as varchar(20))
Print 'Total Price= '+ Cast(@totalprice as varchar(20))

Begin
IF (@TotalPrice>=30000)
Print '10 % Discount'

ELSE IF(@TotalPrice<30000 and @TotalPrice>=20000)
print '5% Discount'

ELSE
print 'No discount'

End

---
Select * from product

--- IF QtyAvl =0 , then out of stock
--IF QtyAvl<20, then Limited
--IF QtyAvl>20, then In Stock

Go
Declare @qty int
Set @qty=(Select QtyAvl from Product where ProdID=33)
print @qty
Begin
If(@qty=0)
print 'Out of Stock'
Else If(@qty>0 and @qty<=20)
print 'Limited'
Else
print 'Available'
End

------------CASE----------------
go
Declare @mem varchar(10)='Gold'

Select Case
When @mem='Gold' then '3 yrs warranty'
When @mem='Silver' then '2 yrs warranty'
When @mem='Broze' then '1 yr warranty'
Else 'No memebership'
End as Membership

--------

go
Select *,Case
When QtyAvl=0 then 'No stock'
When QtyAvl>0 and QtyAvl<=20 then 'Limited'
When QtyAvl>20 then 'In Stock'
End as Availibilty from Product

go
Select *,ordunits*unitprice as TotalPrice,
Case
When Ordunits*UnitPrice>=30000 then '30%'
When Ordunits*UnitPrice<30000 and Ordunits*UnitPrice>=10000 then '20%'
When Ordunits*UnitPrice<10000 then 'No'
End as Discount from orders

--------------WHILE LOOP---------------
Go
Declare @a int = 1
While (@a<=10)
begin
print 'Number: '+cast(@a as varchar(30))
Set @a = @a+1
End

Select prodid,prodname from product

go
Declare @prodname as varchar(30), @min as int, @max int

Select @min=min(prodid), @max=max(prodid) from Product
Print 'List of products'
While(@min<=@max)
Begin
Set @prodname=(Select ProdName from Product where ProdID=@min)

print @prodname

Set @min=@min+11

End

Select * from product

---------
Begin tran
While((Select Qtyavl from product where ProdID=11)<=30)
begin
Update product set QtyAvl=QtyAvl+5
end
Rollback

---------------------- STORED PROCEDURES----------------

----- Code(s) that can be saved and reused again and again
Go
Create procedure Proc1
As
begin
Select * from Customer
Select * from Product
Select * from Orders
end

Exec Proc1

----With Parameters
Go
Create or Alter proc Proc1(@city varchar(20), @status varchar(30))
As
Begin
Select * from Customer where City=@city and CustStatus=@status
End

Exec Proc1 'New Delhi','Current'

-----With Default parameters
Go
Create or Alter proc Proc1(@city varchar(20)='New Delhi', @status varchar(30)='Current')
As
Begin
Select * from Customer where City=@city and CustStatus=@status
End

Exec Proc1 'Mumbai','New'

----------SYSTEM DEFINED PROCEDURE-------

Exec sp_help
Exec sp_help Customer
Exec sp_rename 'Cust','Customer' --- Exec sp_rename 'Old','new'
Exec sp_rename 'Customer.CId','CustId'

--------------RULES------------------
Go
create rule StatusRule as @rule  IN ('Current','New','Regular')
go
drop rule statusrule
Go
Create type StatusType from varchar(20) not null

Exec sp_bindrule statusrule,statustype

Select * from Customer
Insert into Customer values(1008,'Greg','Pune','Old')

-------------Create a rule UnitRule>1000 & unitrule<=7000
--- Create type as decimal(18,2)
--- Bind the rule with the type

Go
Create rule UnitRule as @unit>=1000 and @unit<=7000

Go
Create type UnitType from decimal(18,2) not null

Exec sp_bindrule UnitRule,UnitType

insert into orders values(104,1003,11,6,8000)

----------------Functions---------------
------System Defined functions------

----------Numerical functions---------

Select abs(-255) as [Absolute Value],SQRT(25),CEILING(28.778),FLOOR(28.778)

----------Date Functions-------------

Select GETDATE(),DATEADD(day,10,getdate()),DATEDIFF(month,'01-10-2022','10-10-2022'),DATEPART(Month,'20-Mar-2022')

---------STRING Functions------------

Select CustName,Upper(CustName),LOWER(CustName),Left(CustName,3),Right(CustName,2),SUBSTRING(CustName,2,3),
Stuff(CustName,1,0,'Customer'), REPLACE(CustName,'Harry','Jack'),REPLACE(CustName,Custname,'Jack') from Customer

---------------SCALAR FUNCTIONS---------
Go
Create function fullname(@FN varchar(20),@LN varchar(30))
returns varchar(30)
As
Begin
Return (@FN + ' '+@LN)
End
Go
Select dbo.fullname('Sucheta','Mukherjee')

-----TABLE Functions-------
Go
create function TotalPrice()
Returns table
As
return(Select *, ordunits*unitprice as[TotalPrice] from Orders)

go
Select * from TotalPrice()

------------------TRIGGERS----------------
Create table CustomerAction
(
CustId int,
CustName varchar(20),
ActionTaken varchar(30),
ActionDate datetime
)

go
Create trigger TRG1 on Customer
for Insert as
Declare @ID as int,@Name as varchar(20), @Action as varchar(30)
Select @ID=CustId, @Name=CustName from inserted
Set @Action='New record Inserted'

Insert into CustomerAction values(@ID,@Name,@Action,GETDATE())

Select * from CustomerAction

Select * from Customer

Insert into Customer values(1008,'Carrie','Pune','New')

drop trigger TRG1

-----------------------CURSORS-----------------
Go
-------DECLARE CURSOR-----------
Print '----Customer Details---'
Declare CustCursor Cursor for
Select CustId,CustName from Customer

-------OPEN CURSOR--------------
Open CustCursor

------FETCH CURSOR---------
Declare @ID int, @Name varchar(20)
Print @@Fetch_Status
Fetch Next from CustCursor into @Id,@Name
Print @@Fetch_Status
Print 'Customer Id Customer Name'
While(@@FETCH_STATUS=0)
Begin
Print Cast(@ID as Varchar(20)) + '			'+@Name
Fetch Next from CustCursor into @ID,@Name
End
Print @@Fetch_Status
-----CLOSE CURSOR------
Close CustCursor

-----Deallocating Cursor----
Deallocate CustCursor

----------------------TEMPORARY TABLES-------------
------------LOCAL-------------
Select * into #LocalTemp from Customer

Select * from #LocalTemp

----------GLOBAL -------
Create table ##GlobalTable
(
Sl int not null,
CustName Varchar(30)
)

Insert into ##GlobalTable select ROW_NUMBER() over (Order by Custname), CustName from Customer

Select * from ##GlobalTable

---------------------TABLE VARIABLES----

Declare @Days table(DayNames Varchar(20),Shifting Varchar(20))
Insert into @Days values('Mon','Evening'),('Tue','Morning')

Select * from @Days

--------------ERROR HANDLING---------
--Begin try
---- Statements that may cause exceptions 
--End try
--Begin catch
----- Statements that handle the exceptions
--End Catch

Select * from Customer

Begin

Begin Try
Print 'Try block started'
Insert into Customer values(1009,'ABC','XYZ',Default)
Insert into Customer values(1006,'PQR','LMN',default)
End Try

Begin Catch
print 'Catch block started'
Select ERROR_LINE() as [Error Line], ERROR_MESSAGE() as[Error Message], ERROR_NUMBER() as[Error Number]
End Catch

End




















