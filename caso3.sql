--------------------------------------CHRISTIAN MONTOLIO------------------------------------------
-------------------------------------------2017-4934----------------------------------------------

-------------------------------------------TAREA FINAL--------------------------------------------
----------------------------------------------CASO 3----------------------------------------------

--------------------------------------------------------------------------------------------------
--------------------------------------------SQL SERVER--------------------------------------------

create database caso3_final
use caso3_final

-- 1: CREACION DE TABLAS Y SUS CONSTRAINTS

create table pais
	(idpais int not null,
	 nombre varchar(30),
	 constraint pk_pais primary key(idpais)
	)

create table cliente
	(idcliente int not null,
	 nombre varchar(30),
	 idpais int not null,
	 constraint pk_cliente primary key(idcliente),
	 constraint fk_cliente foreign key(idpais) references pais(idpais)
	)

create table cuenta
	(idcuenta int not null,
	 idcliente int not null,
	 tipo varchar(25),
	 nombre varchar(30),
	 constraint pk_cuenta primary key(idcuenta),
	 constraint fk_cuenta foreign key(idcliente) references cliente(idcliente)
	 )

create table ahorro
	(idcuenta int not null,
	 monto_apertura int,
	 balance decimal(12,2)
	 constraint fk_ahorro foreign key(idcuenta) references cuenta(idcuenta)
	 )

create table prestamo
	(idprestamo int not null,
	 idcuenta int not null,
	 cantidad_cuotas int,
	 monto decimal(12,2),
	 saldo decimal(12,2),
	 constraint pk_prestamo primary key(idprestamo),
	 constraint fk_prestamo foreign key(idcuenta) references cuenta(idcuenta)
	 )

create table pagoprestamo
	(idpago int not null,
	 idprestamo int not null,
	 monto decimal(12,2),
	 fecha date,
	 constraint pk_pagoprestamo primary key(idpago),
	 constraint fk_pagoprestamo foreign key(idprestamo) references prestamo(idprestamo)
	 )

insert into pais values
	(1,'Republica Dominicana'),
	(2,'Puerto Rico'),
	(3,'Estados Unidos'),
	(4,'Haiti')

insert into cliente values
	(101,'Matthew Trump',3),
	(102,'Jean Jules',4),
	(103,'Pedro Navaja',2),
	(104,'Christian Montolio',1),
	(105, 'James Bazil',4),
	(106,'Laura Montolio',1)

insert into cuenta values
	(1,101,'AHO','cuenta 1'),
	(2,101,'PRE','cuenta 2'),
	(3,102,'AHO','cuenta 3'),
	(4,103,'PRE','cuenta 4'),
	(5,104,'AHO','cuenta 5'),
	(6,104,'PRE','cuenta 6'),
	(7,105,'AHO','cuenta 7'),
	(8,106,'PRE','cuenta 8')

insert into ahorro values
	(1,500,125000),
	(3,1500,8500),
	(5,700,6500),
	(7,1200,100)

insert into prestamo values
	(970,2,12, 30000, 9000), --3 pagos (paga 3000)
	(971,4,10, 20000, 8000), --4 pagos (paga 2000)
	(972,6,24,12000, 10000), --2 pagos (paga 5000)
	(973,8,6,24000, 12000) --- 3 pagos (paga 4000)

insert into pagoprestamo values
	(4501,970,3000,'2018-9-25'),
	(4502,971,2000,'2018-9-25'),
	(4512,972,5000,'2018-9-26'),
	(4599,973,4000,'2018-9-28'),
	(4754,970,3000,'2018-10-26'),
	(4758,971,2000,'2018-10-26'),
	(4760,972,5000,'2018-10-27'),
	(4804,973,4000,'2018-10-30'),
	(5009,971,1900,'2018-12-01')

-- 2: PROCEDIMIENTO ALMACENADO QUE MUESTRE LO PAGADO POR MES

create procedure pagos_mensuales (@prestamo int, @ano int)
as
	begin

		select datename(month,fecha) as 'MES', sum(monto) as 'TOTAL PAGADO'
		from pagoprestamo where idprestamo =@prestamo and year(fecha) = @ano
		group by datepart(month, Fecha),datename(month,fecha)
		order by datepart(month, Fecha) asc
	end

exec pagos_mensuales 971,2018

-- 3: CONSTRAINT QUE SOLO PERMITA CUENTAS TIPO AHO y PRE

alter table cuenta add constraint ck_tipo check(tipo in('AHO','PRE'))

-- 4: FUNCION QUE DEVUELVA EL VALOR DEL TIPO DE CUENTA

create function dbo.descripcioncuenta(@tipo varchar(3))
returns varchar(20)
	
	begin
		return (case when @tipo = 'AHO' then 'Cuenta tipo ahorro' 
				when @tipo = 'PRE' then 'Cuenda tipo prestamo' end)
	end

select dbo.descripcioncuenta(tipo) as descripcion from cuenta;

-- 5: PROCEDIMIENTO ALMACENADO EL SALDO DE LOS PRESTAMOS

create procedure actualizar_saldo
as
	begin
		declare @idprestamo int
		declare @monto decimal(12,2)
		declare @pagado decimal(12,2)
		declare @prestamoid int

		declare c_datos cursor 
		for select p.idprestamo,p.monto,/*(select sum(pp.monto) from pagoprestamo pp where p.idprestamo = pp.idprestamo) as "total pagado",*/
			(p.monto-sum(pagoprestamo.monto)) as 'nuevo saldo' from prestamo p
			join pagoprestamo on p.idprestamo=pagoprestamo.idprestamo
			group by p.idprestamo, p.monto, p.saldo

		open c_datos

		while 1=1
		begin
			fetch next from c_datos into @idprestamo, @monto, @pagado
			if @@FETCH_STATUS <> 0
			begin 
				break
			end
				update prestamo set saldo = @pagado where idprestamo = @idprestamo
		end
		close c_datos
		deallocate c_datos
    end 
	
    exec actualizar_saldo
	
	select * from prestamo

-- 6: CONSULTA QUE MUESTRA LISTADO DE LOS CLIENTES Y SUS PRESTAMOS

select c.idCliente as 'ID', c.nombre as 'NOMBRE', p.idprestamo as 'ID P', p.monto as 'MONTO PRESTADO', 
p.saldo as 'RESTANTE',
(select sum(pp.monto) from pagoprestamo pp where p.idPrestamo = pp.idprestamo) as 'PAGADO'
from cliente c join cuenta cu on cu.idcliente=c.idcliente
  join prestamo p on p.idcuenta = cu.idcuenta
left outer join pagoprestamo pp on p.idprestamo = pp.idprestamo 
group by c.idcliente, c.nombre, p.idPrestamo, p.monto, p.saldo
order by c.idcliente	


--------------------------------------------------------------------------------------------------
----------------------------------------------ORACLE----------------------------------------------


-- 1: CREACION DE TABLAS Y SUS CONSTRAINTS

create table pais
	(idpais int not null,
	 nombre varchar(30),
	 constraint pk_pais primary key(idpais)
	)

create table cliente
	(idcliente int not null,
	 nombre varchar(30),
	 idpais int not null,
	 constraint pk_cliente primary key(idcliente),
	 constraint fk_cliente foreign key(idpais) references pais(idpais)
	)

create table cuenta
	(idcuenta int not null,
	 idcliente int not null,
	 tipo varchar(25),
	 nombre varchar(30),
	 constraint pk_cuenta primary key(idcuenta),
	 constraint fk_cuenta foreign key(idcliente) references cliente(idcliente)
	 )

create table ahorro
	(idcuenta int not null,
	 monto_apertura int,
	 balance decimal(12,2),
	 constraint fk_ahorro foreign key(idcuenta) references cuenta(idcuenta)
	 )

create table prestamo
	(idprestamo int not null,
	 idcuenta int not null,
	 cantidad_cuotas int,
	 monto decimal(12,2),
	 saldo decimal(12,2),
	 constraint pk_prestamo primary key(idprestamo),
	 constraint fk_prestamo foreign key(idcuenta) references cuenta(idcuenta)
	 )

create table pagoprestamo
	(idpago int not null,
	 idprestamo int not null,
	 monto decimal(12,2),
	 fecha date,
	 constraint pk_pagoprestamo primary key(idpago),
	 constraint fk_pagoprestamo foreign key(idprestamo) references prestamo(idprestamo)
	 )
     
insert into pais values
	(1,'Republica Dominicana');
insert into pais values
	(2,'Puerto Rico');
insert into pais values
	(3,'Estados Unidos');
insert into pais values
	(4,'Haiti');

insert into cliente values
	(101,'Matthew Trump',3);
insert into cliente values    
	(102,'Jean Jules',4);
insert into cliente values
	(103,'Pedro Navaja',2);
insert into cliente values
	(104,'Christian Montolio',1);
insert into cliente values
	(105, 'James Bazil',4);
insert into cliente values
	(106,'Laura Montolio',1);

insert into cuenta values
	(1,101,'AHO','cuenta 1');
insert into cuenta values
	(2,101,'PRE','cuenta 2');
insert into cuenta values
	(3,102,'AHO','cuenta 3');
insert into cuenta values
	(4,103,'PRE','cuenta 4');
insert into cuenta values
	(5,104,'AHO','cuenta 5');
insert into cuenta values
	(6,104,'PRE','cuenta 6');
insert into cuenta values
	(7,105,'AHO','cuenta 7');
insert into cuenta values
	(8,106,'PRE','cuenta 8');

insert into ahorro values
	(1,500,125000);
insert into ahorro values
	(3,1500,8500);
insert into ahorro values
	(5,700,6500);
insert into ahorro values
	(7,1200,100);

insert into prestamo values
	(970,2,12, 30000, 9000);
insert into prestamo values
	(971,4,10, 20000, 8000);
insert into prestamo values
	(972,6,24,12000, 10000);
insert into prestamo values
	(973,8,6,24000, 12000);

insert into pagoprestamo values
	(4501,970,3000,TO_DATE('2018-9-25','YYYY-MM-DD'));
insert into pagoprestamo values
	(4502,971,2000,TO_DATE('2018-9-25','YYYY-MM-DD'));
insert into pagoprestamo values
	(4512,972,5000,TO_DATE('2018-9-26','YYYY-MM-DD'));
insert into pagoprestamo values    
	(4599,973,4000,TO_DATE('2018-9-28','YYYY-MM-DD'));
insert into pagoprestamo values
	(4754,970,3000,TO_DATE('2018-10-26','YYYY-MM-DD'));
insert into pagoprestamo values
	(4758,971,2000,TO_DATE('2018-10-26','YYYY-MM-DD'));
insert into pagoprestamo values
	(4760,972,5000,TO_DATE('2018-10-27','YYYY-MM-DD'));
insert into pagoprestamo values
	(4804,973,4000,TO_DATE('2018-10-30','YYYY-MM-DD'));
insert into pagoprestamo values
	(5009,971,1900,TO_DATE('2018-12-01','YYYY-MM-DD'));    
     
-- 2: PROCEDIMIENTO ALMACENADO QUE MUESTRE LO PAGADO POR MES     


create or replace procedure pagos_mensuales (p_prestamo number, p_ano number, cur out sys_refcursor)
as
	begin

		open cur for select to_char(fecha, 'month') as "MES", sum(monto) as "TOTAL PAGADO"
		from pagoprestamo where idprestamo =p_prestamo and extract(year from fecha) = p_ano
		group by to_number(to_char(Fecha, 'month')),to_char(fecha, 'month')
		order by to_number(to_char(Fecha, 'month')) asc;
	end;
	/

execute IMMEDIATEpagos_mensuales 971,2018


-- 3: CONSTRAINT QUE SOLO PERMITA CUENTAS TIPO AHO y PRE

ALTER TABLE cuenta ADD CONSTRAINT CHK_tipo CHECK (tipo in('AHO','PRE'));

-- 4: FUNCION QUE DEVUELVA EL VALOR DEL TIPO DE CUENTA

create or replace function descripcioncuenta(tipo varchar2)
return varchar2
	
	is
	begin
		return (case when tipo = 'AHO' then 'Cuenta tipo ahorro' 
				when tipo = 'PRE' then 'Cuenda tipo prestamo' end);
	end;


select descripcioncuenta(tipo) as descripcion from cuenta;

-- 5: PROCEDIMIENTO ALMACENADO EL SALDO DE LOS PRESTAMOS

create or replace procedure actualizar_saldo
as
	 v_idprestamo number(10);
	 v_monto number(12,2);
	 v_pagado number(12,2);
	 v_prestamoid number(10);

		cursor c_datos 
		is select p.idprestamo,p.monto,
			(p.monto-sum(pagoprestamo.monto)) as "nuevo saldo" from prestamo p
			join pagoprestamo on p.idprestamo=pagoprestamo.idprestamo
			group by p.idprestamo, p.monto, p.saldo;begin


		open c_datos;

		while 1=1
		loop
			fetch next from; c_datos into v_idprestamo, v_monto, v_pagado
			if @@FETCH_STATUS <> 0
			then 
				break
			end if;
				update prestamo set saldo = v_pagado where idprestamo = v_idprestamo;
		end loop;
		close c_datos;
    end;
    / 
	
    execute immediate  actualizar_saldo
    
-- 6: CONSULTA QUE MUESTRA LISTADO DE LOS CLIENTES Y SUS PRESTAMOS

select c.idCliente as "ID", c.nombre as "NOMBRE", p.idprestamo as "ID P", p.monto as "MONTO PRESTADO", 
p.saldo as "RESTANTE",
(select sum(pp.monto) from pagoprestamo pp where p.idPrestamo = pp.idprestamo) as "PAGADO"
from cliente c join cuenta cu on cu.idcliente=c.idcliente
  join prestamo p on p.idcuenta = cu.idcuenta
left outer join pagoprestamo pp on p.idprestamo = pp.idprestamo 
group by c.idcliente, c.nombre, p.idPrestamo, p.monto, p.saldo
order by c.idcliente	
    

--------------------------------------------------------------------------------------------------
----------------------------------------------MY SQL----------------------------------------------

-- 1: CREACION DE TABLAS Y SUS CONSTRAINTS

create table pais
	(idpais int not null,
	 nombre varchar(30),
	 constraint pk_pais primary key(idpais)
	);

create table cliente
	(idcliente int not null,
	 nombre varchar(30),
	 idpais int not null,
	 constraint pk_cliente primary key(idcliente),
	 constraint fk_cliente foreign key(idpais) references pais(idpais)
	);

create table cuenta
	(idcuenta int not null,
	 idcliente int not null,
	 tipo varchar(25),
	 nombre varchar(30),
	 constraint pk_cuenta primary key(idcuenta),
	 constraint fk_cuenta foreign key(idcliente) references cliente(idcliente)
	 );

create table ahorro
	(idcuenta int not null,
	 monto_apertura int,
	 balance decimal(12,2),
	 constraint fk_ahorro foreign key(idcuenta) references cuenta(idcuenta)
	 );

create table prestamo
	(idprestamo int not null,
	 idcuenta int not null,
	 cantidad_cuotas int,
	 monto decimal(12,2),
	 saldo decimal(12,2),
	 constraint pk_prestamo primary key(idprestamo),
	 constraint fk_prestamo foreign key(idcuenta) references cuenta(idcuenta)
	 );

create table pagoprestamo
	(idpago int not null,
	 idprestamo int not null,
	 monto decimal(12,2),
	 fecha date,
	 constraint pk_pagoprestamo primary key(idpago),
	 constraint fk_pagoprestamo foreign key(idprestamo) references prestamo(idprestamo)
	 );

insert into pais values
	(1,'Republica Dominicana'),
	(2,'Puerto Rico'),
	(3,'Estados Unidos'),
	(4,'Haiti');

insert into cliente values
	(101,'Matthew Trump',3),
	(102,'Jean Jules',4),
	(103,'Pedro Navaja',2),
	(104,'Christian Montolio',1),
	(105, 'James Bazil',4),
	(106,'Laura Montolio',1);

insert into cuenta values
	(1,101,'AHO','cuenta 1'),
	(2,101,'PRE','cuenta 2'),
	(3,102,'AHO','cuenta 3'),
	(4,103,'PRE','cuenta 4'),
	(5,104,'AHO','cuenta 5'),
	(6,104,'PRE','cuenta 6'),
	(7,105,'AHO','cuenta 7'),
	(8,106,'PRE','cuenta 8');

insert into ahorro values
	(1,500,125000),
	(3,1500,8500),
	(5,700,6500),
	(7,1200,100);

insert into prestamo values
	(970,2,12, 30000, 9000), -- 3 pagos (paga 3000)
	(971,4,10, 20000, 8000), -- 4 pagos (paga 2000)
	(972,6,24,12000, 10000), -- 2 pagos (paga 5000)
	(973,8,6,24000, 12000); -- 3 pagos (paga 4000)

insert into pagoprestamo values
	(4501,970,3000,'2018-9-25'),
	(4502,971,2000,'2018-9-25'),
	(4512,972,5000,'2018-9-26'),
	(4599,973,4000,'2018-9-28'),
	(4754,970,3000,'2018-10-26'),
	(4758,971,2000,'2018-10-26'),
	(4760,972,5000,'2018-10-27'),
	(4804,973,4000,'2018-10-30'),
	(5009,971,1900,'2018-12-01');


-- 2: PROCEDIMIENTO ALMACENADO QUE MUESTRE LO PAGADO POR MES

delimiter //
create procedure pagos_mensuales (p_prestamo int, p_ano int)


		select MONTHNAME(fecha) as 'MES', sum(monto) as 'TOTAL PAGADO'
		from pagoprestamo where idprestamo =p_prestamo and year(fecha) = p_ano
		group by MONTH(fecha),MONTHNAME(fecha)
		order by MONTH(fecha) asc;
	
//
delimiter ;

call pagos_mensuales(971,2018);


-- 3: CONSTRAINT QUE SOLO PERMITA CUENTAS TIPO AHO y PRE 

alter table cuenta add constraint ck_tipo check (tipo in('AHO','PRE'));


-- 4: FUNCION QUE DEVUELVA EL VALOR DEL TIPO DE CUENTA

delimiter //

create function descripcioncuenta(p_tipo varchar(3))
returns varchar(20)
	
	begin
		return (case when p_tipo = 'AHO' then 'Cuenta tipo ahorro' 
				when p_tipo = 'PRE' then 'Cuenda tipo prestamo' end);
	end;
//

delimiter ;

select dbo.descripcioncuenta(tipo) as descripcion from cuenta;


-- 5: PROCEDIMIENTO ALMACENADO EL SALDO DE LOS PRESTAMOS

reate procedure actualizar_saldo()
	BEGIN
		declare idprestamo int;
		declare monto decimal(12,2);
		declare pagado decimal(12,2);
		declare prestamoid int;

		declare c_datos cursor 
		for select p.idprestamo,p.monto,/*(select sum(pp.monto) from pagoprestamo pp where p.idprestamo = pp.idprestamo) as "total pagado",*/
			(p.monto-sum(pagoprestamo.monto)) as 'nuevo saldo' from prestamo p
			join pagoprestamo on p.idprestamo=pagoprestamo.idprestamo
			group by p.idprestamo, p.monto, p.saldo

		open c_datos;

		while 1=1
		do
			fetch next from; c_datos into v_idprestamo, v_monto, v_pagado
			if @@FETCH_STATUS <> 0
			then 
				break
			end if;
				update prestamo set saldo = v_pagado where idprestamo = v_idprestamo;
		end while;
		close c_datos;
	END;


-- 6: CONSULTA QUE MUESTRA LISTADO DE LOS CLIENTES Y SUS PRESTAMOS

select c.idCliente as 'ID', c.nombre as 'NOMBRE', p.idprestamo as 'ID P', p.monto as 'MONTO PRESTADO', 
p.saldo as 'RESTANTE',
(select sum(pp.monto) from pagoprestamo pp where p.idPrestamo = pp.idprestamo) as 'PAGADO'
from cliente c join cuenta cu on cu.idcliente=c.idcliente
  join prestamo p on p.idcuenta = cu.idcuenta
left outer join pagoprestamo pp on p.idprestamo = pp.idprestamo 
group by c.idcliente, c.nombre, p.idPrestamo, p.monto, p.saldo
order by c.idcliente	
