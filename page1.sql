
--דף פרויקט מספר 2
---1

---פונקצית זיכוי של 1
alter function ex1_Promotional (@id_accounts int) returns int
as
begin
declare @sum int=0
select @sum= sum([sum_accounts]) from [dbo].[move_accounts] where [id_accounts]=@id_accounts and  [sum_accounts]>0 and [date_move]=GETDATE()
group by [id_accounts]
return @sum
end
---פונקצית חיובים של 1

alter function ex1_debit (@id_accounts int) returns int
as
begin
declare @sum int=0
select @sum= sum([sum_accounts]) from [dbo].[move_accounts] where [id_accounts]=@id_accounts and  [sum_accounts]<0 and [date_move]=GETDATE()
group by [id_accounts]
return @sum
end

---פונקצית יתרה של1
go
create function ex1_balance (@id_accounts int) returns int
as
begin
declare @balance int
select @balance=[balance]  from [dbo].[move_accounts] where [id_accounts] = @id_accounts and [date_move]=GETDATE()
order by [id_move] desc
return @balance
end

---פונקצית חריגה של 1
create function ex1_overraft (@id_accounts int) returns varchar(5)
as
begin 
declare @frame_height int
declare @balance int
select @frame_height=[frame_height] from[dbo].[accounts] where [id_accounts]=@id_accounts
set @balance=[dbo].[ex1_balance](@id_accounts)
if @frame_height-@balance>0
return 'no'
return'yes'
end


create view daily_summary 
as
select  [id_accounts],[id_name], GETDATE()as dete, [dbo].[ex1_debit] ([id_accounts]) as debit, [dbo].[ex1_Promotional]([id_accounts]) as Promotional,[dbo].[ex1_balance]([id_accounts]) as balance,[dbo].[ex1_overraft]([id_accounts]) as overraft
from [dbo].[accounts]


---2
alter procedure ex2(@id_move int=null)
as
begin
if @id_move is null
begin
select* from [dbo].[move_accounts] m join [dbo].[accounts] a on m.id_accounts= a.id_accounts
end
else
begin
select m.id_move , a.fullName, a.num_accounts, a.num_branch, m.sum_accounts, m.description_word
from [dbo].[move_accounts] m join [dbo].[accounts] a on m.id_accounts= a.id_accounts
where m.[id_move] = @id_move
end
end

exec dbo.ex2  1


--3
create procedure ex3 (@id_move int, @id_accounts int, @description_word varchar(100), @sum_accounts money , @balance money)
as
begin
declare @select_id int
select  @select_id = [id_accounts] from [dbo].[accounts] a where id_accounts= @id_accounts
if @select_id is null
begin
raiserror('opss there is error acoount',10,2) 
end
else
begin
insert [dbo].[move_accounts]([date_move],[id_accounts],[description_word],[sum_accounts],[balance]) values(getdate(),@id_accounts,@description_word,@sum_accounts,@balance)
end
end

exec dbo.ex3  10, 1 , 'הפקדת שיקים' ,1000 , 4000
exec dbo.ex3  10, 20 , 'הפקדת שיקים' ,1000 , 4000


--4
create procedure ex4(@id_move int, @description_word VARCHAR(100), @sum_accounts money,@balance money)
as
begin
declare @date date
select @date = [date_move] from [dbo].[move_accounts] where @id_move = [id_move]
if year(@date) = year(GETDATE()) and  month(@date) = month(GETDATE()) and (day(@date) = day(GETDATE()) or ((datename(weekday,getdate())='monday'and 
(datename(weekday,@date))='sunday' or (datename(weekday,@date))='saturday'))) 
begin
UPDATE [dbo].[move_accounts] SET[description_word] = @description_word, [sum_accounts]=@sum_accounts,[balance] = @balance
WHERE  [id_move] = @id_move
end
end

EXEC dbo.ex4 10, 'משיכה מכספומט', 1000,1000


--5
create procedure ex5(@id_move int)
as
begin
declare @idmove int, @date_move date,  @id_accounts int, @description_word varchar(100), @sum_accounts money,  @balance money
select @idmove = [id_move],@date_move=[date_move],@id_accounts=[id_accounts],@description_word=[description_word],@sum_accounts=[sum_accounts],    @balance=[balance]
from [dbo].[move_accounts]where id_move=@id_move
insert [dbo].[history_move_accounts] values(@idmove, @date_move,  @id_accounts, @description_word, @sum_accounts,  @balance)
delete  from [dbo].[move_accounts]where id_move=@id_move
end

EXEC dbo.ex5 10


---6

alter function ex6 (@date date, @id_accounts int) 
returns int
as
begin
declare @new_date date
declare @credit_line int
declare @diff int=-1
select @credit_line = [frame_height] from [dbo].[accounts] where @id_accounts=[id_accounts]
select @new_date =[date_move] from[dbo].[move_accounts]where [id_accounts]=@id_accounts and [date_move]>@date and (@credit_line+[balance])>0
return datediff(m,@date,@new_date)
end

select dbo.ex6('2011-01-01',1)


--7
---לבדוק
alter function ex7(@id_move int)
returns int 
as
begin
declare @balance money
declare @date date
declare @id int
select @id=[id_accounts], @balance = [balance] ,@date=[date_move] from [dbo].[move_accounts] where [id_move]= @id_move
declare @frame money
select  @frame= [frame_height]  from[dbo].[accounts] a join [dbo].[move_accounts] m on a.id_accounts= m.id_accounts where m.[id_move]= @id_move
if @frame+@balance>0
begin
return 1
end
declare @diff int=dbo.ex6(@date,@id)
if @frame+@balance >-1000 and @diff<=6
begin
return 1
end
return 0
end

select dbo.ex7(1)


---8
--create trigger ex8 on [dbo].[move_accounts] for insert, update , delete
--as
--begin
--   if UPDATE()
--   begin
--   Update [balance]
--   set

--end

alter trigger trigger_move on [dbo].[move_accounts] for insert,delete
as 
begin
declare @insert money,@delete money,@num int,@x int
declare cursor_insert cursor for select m.id_move from [dbo].[move_accounts]m join inserted i on m.id_accounts=i.id_accounts where m.date_move> i.date_move
declare cursor_delete cursor for select m.id_move from [dbo].[move_accounts]m join deleted d on m.id_accounts=d.id_accounts where m.date_move> d.date_move
select @insert=[sum_accounts]from inserted
select @delete=[sum_accounts]from deleted
select @num=[id_move] from inserted
if @insert is not null
begin
	set @x= @insert
	open cursor_insert
while @@FETCH_STATUS=0
begin
fetch next from cursor_insert into @num
update [move_accounts] set [balance]=[balance]+@x where [id_move]=@num 
end
close cursor_insert
deallocate cursor_insert
end
else
begin
	set @x=-@delete
		open cursor_delete
while @@FETCH_STATUS=0
begin
fetch next from cursor_delete into @num
update [move_accounts] set [balance]=[balance]+@x where [id_move]=@num 
end
close cursor_delete
deallocate cursor_delete
end
end


---9
create function ex9_table (@date date, @days int) returns @t table(debit int, Promotional int,balance int )
as
begin
declare @balance int 
declare @debit int 
declare @Promotional int
select  @balance=  ([balance]) from  [dbo].[daily_summary]
where DATEDIFF(d,@date,[dete])<=@days and DATEDIFF(d,@date,[dete])>0
order by ([dete]) desc
select @debit=sum([debit]),@Promotional=sum([Promotional]) 
from [dbo].[daily_summary]
where DATEDIFF(d,@date,[dete])<=@days and DATEDIFF(d,@date,[dete])>0
group by [id_name]
insert into @t
values
(
@debit,@Promotional,@balance)
return 
end

--10
create procedure ex10
as 
begin 
declare cursor_id cursor for select[id_accounts] from[dbo].[move_accounts]
declare @sum_insert money=0 , @sum_out money=0,@id int 
fetch next from cursor_id into @id
open cursor_id
while @@FETCH_STATUS=0
begin 
select  @sum_insert+=[sum_accounts] from[dbo].[move_accounts] where [sum_accounts]>0 and [date_move]=GETDATE() and [id_accounts]=@id
select @sum_out+=[sum_accounts] from[dbo].[move_accounts] where [sum_accounts]<0 and DATEPART(WEEK,[date_move])=DATEPART(WEEK, GETDATE()) and DATEPART(year,[date_move])=DATEPART(YEAR, GETDATE()) and DATEPART(month,[date_move])=DATEPART(MONTH, GETDATE()) and [id_accounts]=@id
if @sum_insert>50000 and @sum_out<-50000
print 'Money laundering was found in the account of' +convert(varchar(10),@id)
fetch next from cursor_id into @id
end
close cursor_id
deallocate cursor_id
end
