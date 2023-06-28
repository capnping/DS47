-- DML

create database demonstration;
use demonstration;

create table transportation(
	ship_mode varchar(25),
    vehicle_company varchar(25),
    toll_required boolean
) ;

-- inserting the records

insert into  transportation value('Delivery Truck', 'Ashok Leyland', false) ;
insert into  transportation value('Regular Air', 'Air India', false) ;

select * from transportation ;

update transportation set toll_required = true
where ship_mode = 'Delivery Truck';

-- ddl query to add a new column
alter table transportation add column vehicle_number varchar(32) ;
desc transportation ;

update transportation set vehicle_number = 'MH-05-81234';

-- deleting particular record from the table
delete from transportation where vehicle_company='Air India';

