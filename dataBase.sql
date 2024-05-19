
--������ ��� ����� ���� ���
---���� �������
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
kind_accounts varchar(5)default'����',check(kind_accounts in('����','����')),
frame_height  money ,
)
---���� ������
create table move_accounts
(
id_move int identity(1,1)primary key,
date_move date,
id_accounts int foreign key(id_accounts) references accounts(id_accounts) ,
description_word varchar(100),
sum_accounts money,
balance money,
)
---���� ������
create table bank_Branch(
id_bankBranch int identity(1,1)primary key,
num int,
name_bankBranch varchar(20),
)

---���� ��������� ������
create table history_move_accounts
(
id_move int primary key,
date_move date,
id_accounts int  foreign key(id_accounts) references accounts(id_accounts),
description_word varchar(100),
sum_accounts money,
balance money,
)




---����� ������ ���� �������
insert accounts values('���','�����',52626255,'032344555' ,35422,1,'����',0 ) 
insert accounts values('�����','����',65765787,'028876752' ,9876,2,'����',8000 ) 
insert accounts values('�������','����',325747889,'0528876752' ,90722,1,'����',3000 ) 
insert accounts values('����','���',09998882,'0559862455' ,8724,3,'����',10000 ) 

---����� ������ ���� ������
insert [dbo].[move_accounts]([date_move],[id_accounts],[description_word],[sum_accounts],[balance]) values('01/01/2011',1,'����� �����', 200, 200)
insert [dbo].[move_accounts]([date_move],[id_accounts],[description_word],[sum_accounts],[balance]) values('2011-01-01',1,'����� �������', -1000, -800)
insert [dbo].[move_accounts]([date_move],[id_accounts],[description_word],[sum_accounts],[balance])values('03/01/2011',4,'����� ����', 75000, 75000)
insert [dbo].[move_accounts]([date_move],[id_accounts],[description_word],[sum_accounts],[balance]) values('03/01/2011',1,'����� ������ ���', 1700, 900)
insert [dbo].[move_accounts]([date_move],[id_accounts],[description_word],[sum_accounts],[balance]) values('04/01/2011',4,'����� ������ ���', -60000, 15000)
insert [dbo].[move_accounts]([date_move],[id_accounts],[description_word],[sum_accounts],[balance]) values('10/01/2011',2,'����� ����', 100004.50, 100004.50)
insert [dbo].[move_accounts]([date_move],[id_accounts],[description_word],[sum_accounts],[balance]) values('10/02/2011',3,'����� ����', 60900, 60900)
insert [dbo].[move_accounts]([date_move],[id_accounts],[description_word],[sum_accounts],[balance]) values('10/03/2011',2,'����� ����', 12000, 112004.50)
insert [dbo].[move_accounts]([date_move],[id_accounts],[description_word],[sum_accounts],[balance]) values('10/03/2011',2,'����� ����', 40000, 152004.50)

---����� ������ ���� ������
insert[dbo].[bank_Branch]values (20,'���-���')
insert[dbo].[bank_Branch]values (12,'�������-����')
insert[dbo].[bank_Branch]values (13,'�������-����')