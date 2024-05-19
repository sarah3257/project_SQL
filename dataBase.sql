
--פרויקט תמר וילנר ושרה ראם
---טבלת חשבונות
create table accounts
(
id_accounts int identity(1,1)primary key,
lastName varchar(20),
firstName varchar (20),
fullName as firstName+ ' ' + lastName,
id_name int unique,
tel varchar(10),
num_accounts  varchar (20),
num_branch int foreign key(num_branch) references bank_Branch(id_bankBranch) ,
kind_accounts varchar(5)default'פרטי',check(kind_accounts in('פרטי','עסקי')),
frame_height  money ,
)
---טבלת תנועות
create table move_accounts
(
id_move int identity(1,1)primary key,
date_move date,
id_accounts int foreign key(id_accounts) references accounts(id_accounts) ,
description_word varchar(100),
sum_accounts money,
balance money,
)
---טבלת סניפים
create table bank_Branch(
id_bankBranch int identity(1,1)primary key,
num int,
name_bankBranch varchar(20),
)

---טבלת היסטוריית תנועות
create table history_move_accounts
(
id_move int primary key,
date_move date,
id_accounts int  foreign key(id_accounts) references accounts(id_accounts),
description_word varchar(100),
sum_accounts money,
balance money,
)




---הכנסת נתונים טבלת חשבונות
insert accounts values('כהן','אברהם',52626255,'032344555' ,35422,1,'פרטי',0 ) 
insert accounts values('קליין','יוסף',65765787,'028876752' ,9876,2,'פרטי',8000 ) 
insert accounts values('קלינציק','מנחם',325747889,'0528876752' ,90722,1,'פרטי',3000 ) 
insert accounts values('חיים','ישי',09998882,'0559862455' ,8724,3,'עסקי',10000 ) 

---הכנסת נתונים טבלת תנועות
insert [dbo].[move_accounts]([date_move],[id_accounts],[description_word],[sum_accounts],[balance]) values('01/01/2011',1,'הפקדת מזומן', 200, 200)
insert [dbo].[move_accounts]([date_move],[id_accounts],[description_word],[sum_accounts],[balance]) values('2011-01-01',1,'משיכה מכספומט', -1000, -800)
insert [dbo].[move_accounts]([date_move],[id_accounts],[description_word],[sum_accounts],[balance])values('03/01/2011',4,'הפקדת שקים', 75000, 75000)
insert [dbo].[move_accounts]([date_move],[id_accounts],[description_word],[sum_accounts],[balance]) values('03/01/2011',1,'העברה מחשבון אחר', 1700, 900)
insert [dbo].[move_accounts]([date_move],[id_accounts],[description_word],[sum_accounts],[balance]) values('04/01/2011',4,'העברה מחשבון אחר', -60000, 15000)
insert [dbo].[move_accounts]([date_move],[id_accounts],[description_word],[sum_accounts],[balance]) values('10/01/2011',2,'הפקדת שקים', 100004.50, 100004.50)
insert [dbo].[move_accounts]([date_move],[id_accounts],[description_word],[sum_accounts],[balance]) values('10/02/2011',3,'הפקדת שקים', 60900, 60900)
insert [dbo].[move_accounts]([date_move],[id_accounts],[description_word],[sum_accounts],[balance]) values('10/03/2011',2,'הפקדת שקים', 12000, 112004.50)
insert [dbo].[move_accounts]([date_move],[id_accounts],[description_word],[sum_accounts],[balance]) values('10/03/2011',2,'הפקדת שקים', 40000, 152004.50)

---הכנסת נתונים טבלת סניפים
insert[dbo].[bank_Branch]values (20,'בני-ברק')
insert[dbo].[bank_Branch]values (12,'ירושלים-מרכז')
insert[dbo].[bank_Branch]values (13,'ירושלים-צפון')