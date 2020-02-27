--------------------------------------CHRISTIAN MONTOLIO------------------------------------------
-------------------------------------------2017-4934----------------------------------------------

-------------------------------------------TAREA FINAL--------------------------------------------
----------------------------------------------CASO 2----------------------------------------------

--------------------------------------------------------------------------------------------------
--------------------------------------------SQL SERVER--------------------------------------------

create database caso2_final
use caso2_final

create table socio
	(idsocio int not null,
	 nombre varchar(30),
	 apellido varchar(30),
	 sexo char(1),
	 cedula varchar(13),
	 telefono varchar(12),
	 fecha_ingreso date
	 constraint pk_socio primary key(idsocio),
	 constraint ck_socio_sex check(sexo in('f','m'))
	 )
create unique index idx_un_socio on socio(cedula)

create table patron
	(idpatron int not null,
	 nombre varchar(30),
	 apellido varchar(30),
	 sexo char(1),
	 cedula varchar(13),
	 telefono varchar(12)
	 constraint pk_patron primary key(idpatron),
	 constraint ck_patron_sex check(sexo in('f','m'))
	 )
create unique index idx_un_patron on patron(cedula)

create table barco
	(idbarco int not null,
	 idsocio int not null,
	 idpatron int not null,
	 matricula char(11),
	 nombre varchar(25),
	 n_amarre int,
	 cuota int,
	 constraint pk_barco primary key(idbarco),
	 constraint fk_barco1 foreign key(idsocio) references socio(idsocio),
	 constraint fk_barco2 foreign key(idpatron) references patron(idpatron)
	 )
create unique index idx_un_barco on barco(matricula)

create table salida
	(idsalida int not null,
	 idbarco int not null,
	 fecha_salida date,
	 hora_salida time,
	 destino varchar(30),
	 constraint pk_salida primary key(idsalida),
	 constraint fk_salida foreign key(idbarco) references barco(idbarco)
	)

insert into socio values
	(101, 'Christian','Montolio','M','402-7865149-8','809-485-9431','2018-04-15'),
	(102, 'Laura','Montolio','F','402-8764121-3','849-964-7834','2017-12-01'),
	(103, 'Inmaculada','Perensejo','F','001-1452578-5','829-487-9421','2018-01-20'),
	(104, 'Pedro','Navaja','M','001-1445278-4','849-945-7892','2018-04-30'),
	(105, 'George','Delaselva','F','049-6415956-1','829-954-7843','2018-01-30')

insert into patron values
	(1001, 'Jose','Lopez','M','053-7894216-3','809-954-9104'),
	(1002, 'Adrian','Jimenez','M','001-9914778-1','849-610-2015'),
	(1003, 'Gabriel','Perez','M','402-8549479-6','809-614-2020'),
	(1004, 'Federico','Almonte','M','100-8616191-9','829-145-9734'),
	(1005, 'John','Salchichon','M','000-2647964-6','809-794-6458')

insert into barco values
	(945,102,1005,'VA-3-919-92','linda I',10,15000),
	(919,101,1003,'OK-6-432-01','La Bellaca',3,27900),
	(920,101,1003,'YA-9-543-00','Tommy',4,24560),
	(961,105,1004,'DOM-7-99-87','Nino Lindo',15,12400),
	(968,104,1001,'VE-2-647-05','El dolor',5,34120),
	(964,103,1002,'YE-8-147-12','Yaqueline',9,67948)

insert into salida values
	(1,968,'2018-11-30','9:00','La Romana'),
	(2,920,'2018-11-29','15:00','Isla Saona'),
	(3,945,GETDATE(),'12:00','Pedernales')


--JOIN PARA VERIFICAR RESULTADOS
select s.nombre+' '+s.apellido as 'SOCIO', s.cedula as 'CEDULA', s.fecha_ingreso as 'FECHA DE INGRESO',
 b.nombre as 'BARCO', b.matricula as 'MATRICULA'
from socio s join barco b on(s.idsocio=b.idsocio)

--JOIN PARA VER LA SALIDA
select b.nombre as 'BARCO', b.matricula as 'MATRICULA', s.nombre+' '+s.apellido as 'PROPIETARIO',
sa.fecha_salida as 'SALIDA', sa.hora_salida as 'HORA',
sa.destino as 'DESTINO', p.nombre+' '+p.apellido as 'PATRON'
from salida sa join barco b on(b.idbarco=sa.idbarco) join patron p on(p.idpatron=b.idpatron) 
join socio s on(s.idsocio=b.idsocio)

--------------------------------------------------------------------------------------------------
----------------------------------------------ORACLE----------------------------------------------

create table socio
	(idsocio number(10) not null,
	 nombre varchar2(30),
	 apellido varchar2(30),
	 sexo char(1),
	 cedula varchar2(13),
	 telefono varchar2(12),
	 fecha_ingreso date,
	 constraint pk_socio primary key(idsocio),
	 constraint ck_socio_sex check(sexo in('f','m'))
	 )
create unique index idx_un_socio on socio(cedula);

create table patron
	(idpatron number(10) not null,
	 nombre varchar2(30),
	 apellido varchar2(30),
	 sexo char(1),
	 cedula varchar2(13),
	 telefono varchar2(12),
	 constraint pk_patron primary key(idpatron),
	 constraint ck_patron_sex check(sexo in('f','m'))
	 );
create unique index idx_un_patron on patron(cedula);

create table barco
	(idbarco number(10) not null,
	 idsocio number(10) not null,
	 idpatron number(10) not null,
	 matricula char(11),
	 nombre varchar2(25),
	 n_amarre number(10),
	 cuota number(10),
	 constraint pk_barco primary key(idbarco),
	 constraint fk_barco1 foreign key(idsocio) references socio(idsocio),
	 constraint fk_barco2 foreign key(idpatron) references patron(idpatron)
	 );
create unique index idx_un_barco on barco(matricula);

create table salida_barco
	(idsalida number(10) not null,
	 idbarco number(10) not null,
	 fecha_salida date,
	 destino varchar2(30),
	 constraint pk_salidabarco primary key(idsalida),
	 constraint fk_salidabarco foreign key(idbarco) references barco(idbarco)
	);
 
insert into socio values
	(101, 'Christian','Montolio','m','402-7865149-8','809-485-9431',TO_DATE('2018-04-15','YYYY-MM-DD'));
insert into socio values    
	(102, 'Laura','Montolio','f','402-8764121-3','849-964-7834',TO_DATE('2017-12-01','YYYY-MM-DD'));
insert into socio values
	(103, 'Inmaculada','Perensejo','f','001-1452578-5','829-487-9421',TO_DATE('2018-01-20','YYYY-MM-DD'));
insert into socio values    
	(104, 'Pedro','Navaja','m','001-1445278-4','849-945-7892',TO_DATE('2018-04-30','YYYY-MM-DD'));
insert into socio values    
	(105, 'George','Delaselva','m','049-6415956-1','829-954-7843',TO_DATE('2018-01-30','YYYY-MM-DD'));

insert into patron values
	(1001, 'Jose','Lopez','m','053-7894216-3','809-954-9104');
insert into patron values
	(1002, 'Adrian','Jimenez','m','001-9914778-1','849-610-2015');
insert into patron values    
	(1003, 'Gabriel','Perez','m','402-8549479-6','809-614-2020');
insert into patron values    
	(1004, 'Federico','Almonte','m','100-8616191-9','829-145-9734');
insert into patron values    
	(1005, 'John','Salchichon','m','000-2647964-6','809-794-6458');

insert into barco values
	(945,102,1005,'VA-3-919-92','linda I',10,15000);
insert into barco values
	(919,101,1003,'OK-6-432-01','La Bellaca',3,27900);
insert into barco values
	(920,101,1003,'YA-9-543-00','Tommy',4,24560);
insert into barco values    
	(961,105,1004,'DOM-7-99-87','Nino Lindo',15,12400);
insert into barco values
	(968,104,1001,'VE-2-647-05','El dolor',5,34120);
insert into barco values    
	(964,103,1002,'YE-8-147-12','Yaqueline',9,67948);

insert into salida_barco values
	(1,968,TO_DATE('2018-11-30 9:00','YYYY-MM-DD HH:MI'),'La Romana');
insert into salida_barco values    
	(2,920,TO_DATE('2018-11-29 03:00','YYYY-MM-DD HH:MI'),'Isla Saona');
insert into salida_barco values
	(3,945,TO_DATE('2018-12-01 12:00','YYYY-MM-DD HH:MI'),'Pedernales');
    
--JOIN PARA VERIFICAR RESULTADOS
select s.nombre||' '||s.apellido as "SOCIO", s.cedula as "CEDULA", s.fecha_ingreso as "FECHA DE INGRES",
 b.nombre as "BARCO", b.matricula as "MATRICULA"
from socio s join barco b on(s.idsocio=b.idsocio);

--JOIN PARA VER LA SALIDA
select b.nombre as "BARCO", b.matricula as "MATRICULA", s.nombre||' '||s.apellido as "PROPIETARIO",
sa.fecha_salida as "SALIDA", sa.destino as "DESTINO", p.nombre||' '||p.apellido as "PATRON"
from salida_barco sa join barco b on(b.idbarco=sa.idbarco) join patron p on(p.idpatron=b.idpatron) 
join socio s on(s.idsocio=b.idsocio);


--------------------------------------------------------------------------------------------------
----------------------------------------------MY SQL----------------------------------------------

create table socio
	(idsocio int not null,
	 nombre varchar(30),
	 apellido varchar(30),
	 sexo char(1),
	 cedula varchar(13),
	 telefono varchar(12),
	 fecha_ingreso date,
	 constraint pk_socio primary key(idsocio)
	 );
create unique index idx_un_socio on socio(cedula);

create table patron
	(idpatron int not null,
	 nombre varchar(30),
	 apellido varchar(30),
	 sexo char(1),
	 cedula varchar(13),
	 telefono varchar(12),
	 constraint pk_patron primary key(idpatron)
	 );
create unique index idx_un_patron on patron(cedula);

create table barco
	(idbarco int not null,
	 idsocio int not null,
	 idpatron int not null,
	 matricula char(11),
	 nombre varchar(25),
	 n_amarre int,
	 cuota int,
	 constraint pk_barco primary key(idbarco),
	 constraint fk_barco1 foreign key(idsocio) references socio(idsocio),
	 constraint fk_barco2 foreign key(idpatron) references patron(idpatron)
	 );
create unique index idx_un_barco on barco(matricula);

create table salida
	(idsalida int not null,
	 idbarco int not null,
	 fecha_salida date,
	 hora_salida time(6),
	 destino varchar(30),
	 constraint pk_salida primary key(idsalida),
	 constraint fk_salida foreign key(idbarco) references barco(idbarco)
	);

insert into socio values
	(101, 'Christian','Montolio','M','402-7865149-8','809-485-9431','2018-04-15'),
	(102, 'Laura','Montolio','F','402-8764121-3','849-964-7834','2017-12-01'),
	(103, 'Inmaculada','Perensejo','F','001-1452578-5','829-487-9421','2018-01-20'),
	(104, 'Pedro','Navaja','M','001-1445278-4','849-945-7892','2018-04-30'),
	(105, 'George','Delaselva','F','049-6415956-1','829-954-7843','2018-01-30');

insert into patron values
	(1001, 'Jose','Lopez','M','053-7894216-3','809-954-9104'),
	(1002, 'Adrian','Jimenez','M','001-9914778-1','849-610-2015'),
	(1003, 'Gabriel','Perez','M','402-8549479-6','809-614-2020'),
	(1004, 'Federico','Almonte','M','100-8616191-9','829-145-9734'),
	(1005, 'John','Salchichon','M','000-2647964-6','809-794-6458');

insert into barco values
	(945,102,1005,'VA-3-919-92','linda I',10,15000),
	(919,101,1003,'OK-6-432-01','La Bellaca',3,27900),
	(920,101,1003,'YA-9-543-00','Tommy',4,24560),
	(961,105,1004,'DOM-7-99-87','Nino Lindo',15,12400),
	(968,104,1001,'VE-2-647-05','El dolor',5,34120),
	(964,103,1002,'YE-8-147-12','Yaqueline',9,67948);

insert into salida values
	(1,968,'2018-11-30','9:00','La Romana'),
	(2,920,'2018-11-29','15:00','Isla Saona'),
	(3,945,NOW(),'12:00','Pedernales');

-- JOIN PARA VERIFICAR RESULTADOS
select concat(s.nombre,' ',s.apellido) as 'SOCIO', s.cedula as 'CEDULA', s.fecha_ingreso as 'FECHA DE INGRESO',
 b.nombre as 'BARCO', b.matricula as 'MATRICULA'
from socio s join barco b on(s.idsocio=b.idsocio);

-- JOIN PARA VER LA SALIDA
select b.nombre as 'BARCO', b.matricula as 'MATRICULA', concat(s.nombre,' ',s.apellido) as 'PROPIETARIO',
sa.fecha_salida as 'SALIDA', sa.hora_salida as 'HORA',
sa.destino as 'DESTINO', concat(p.nombre,' ',p.apellido) as 'PATRON'
from salida sa join barco b on(b.idbarco=sa.idbarco) join patron p on(p.idpatron=b.idpatron) 
join socio s on(s.idsocio=b.idsocio)