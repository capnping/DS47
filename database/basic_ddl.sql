-- creating database
create database demonstration;

-- using Database
use demonstration;

-- Create Table
create table customers(
	ID int not null,
    NAME varchar(32) not null,
    DATE timestamp default current_timestamp,
    AGE int,
    ADDRESS varchar(32)
);

-- show rows of table
desc customers;

-- add primary key
alter table customers add constraint primary key(ID);

-- add column
alter table customers add column employer varchar(32);

-- drop the added column
alter table customers drop column employer;


-- dropping whole table, once table is dropped it can't be undone
drop table customers;

-- dropping database
drop database demonstration