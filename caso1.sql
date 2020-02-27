--------------------------------------CHRISTIAN MONTOLIO------------------------------------------
-------------------------------------------2017-4934----------------------------------------------

-------------------------------------------TAREA FINAL--------------------------------------------
----------------------------------------------CASO 1----------------------------------------------

--------------------------------------------------------------------------------------------------
--------------------------------------------SQL SERVER--------------------------------------------

create database caso1_final
use caso1_final

create table vehiculo
	(idvehiculo int not null,
	 matricula char(7) not null,
	 marca varchar(20),
	 modelo varchar(30),
	 color varchar(20),
	 precio int not null,
	 garantia_duracion varchar(20),
	 porciento_garantia float,
	 constraint pk_vehiculo primary key(idvehiculo)
	)
create unique index idx_un_vehiculo on vehiculo(matricula)

create table propietario
	(
	idpropietario int not null,
	idvehiculo int not null,
	nombre_propietario varchar(30), 
	fecha_n_propietario varchar(30),
	sexo char(1),
	fecha_adquisicion date
	constraint pk_propietario primary key(idpropietario),
	constraint fk_propietario foreign key(idvehiculo) references vehiculo(idvehiculo),
	constraint ck_chofer_sex check(sexo in('f','m'))
	)
	
create table area
	(idarea int not null,
	 area varchar(40)
	 constraint pk_area primary key(idarea)
	)

create table mecanico
	(idmecanico int not null,
	 nombre_mecanico varchar(30),
	 cedula_mecanico varchar(13),
	 idarea int not null,
	 constraint pk_mecanico primary key(idmecanico),
	 constraint fk_mecanico foreign key(idarea) references area(idarea)
	)
create unique index idx_un_mecanico on mecanico(cedula_mecanico)

create table chequeo
	(idchequeo int not null,
	 descripcion varchar(100),
	 costo_chequeo int,
	 constraint pk_chequeo primary key(idchequeo)
	)

create table piezas
	(idpiezas int not null,
	 piezas_cambiadas varchar(100),
	 costo_piezas int,
	 constraint pk_piezas primary key(idpiezas)
	)

create table mantenimiento
	(idcita int not null,
	 idvehiculo int not null,
	 idmecanico int not null,
	 idchequeo int not null,
	 idpiezas int not null,
	 constraint pk_mantenimiento primary key(idcita),
	 constraint fk_mantenimiento1 foreign key(idvehiculo) references vehiculo(idvehiculo),
	 constraint fk_mantenimiento2 foreign key(idmecanico) references mecanico(idmecanico),
	 constraint fk_mantenimiento3 foreign key(idchequeo) references chequeo(idchequeo),
	 constraint fk_mantenimiento4 foreign key(idpiezas) references piezas(idpiezas)
	)

create table entrada
	(idcita int not null,
	 idmecanico int not null,
	 idpropietario int not null,
	 fecha_entrada date,
	 hora_entrada time,
	 constraint fk_entrada1 foreign key(idcita) references mantenimiento(idcita),
	 constraint fk_entrada2 foreign key(idmecanico) references mecanico(idmecanico),
	 constraint fk_entrada3 foreign key(idpropietario) references propietario(idpropietario)
	)
alter table entrada add constraint
pk_entrada primary key(idcita,idmecanico,idpropietario)

create table salida
	(idcita int not null,
	 idmecanico int not null,
	 idpropietario int not null,
	 fecha_salida date,
	 hora_salida time,
	 constraint fk_salida1 foreign key(idcita) references mantenimiento(idcita),
	 constraint fk_salida2 foreign key(idmecanico) references mecanico(idmecanico),
	 constraint fk_salida3 foreign key(idpropietario) references propietario(idpropietario)
	)
alter table salida add constraint
pk_salida primary key(idcita,idmecanico,idpropietario)


insert into vehiculo values
	(101,'A547834','Hyundai','Sonata Y20','Blanco', 650000,'2 años',0.20),
	(102,'Y453416','Toyota','Corolla 2010','Gris', 450000, '1 año', 0.10),
	(103,'G359714','Toyota','Hilux 2016','Gris',1200000,'3 años', 0.30),
	(104,'F549129','Hyndai','Sonata N20','Gris', 350000, '1 año', 0.10),
	(105,'Z146784','Kia','K5','Azul',750000,'3 años', 0.30)

insert into propietario values
	(001,104,'Juan Perez', '5-8-65', 'm','2018-04-02'),
	(005,101,'Beatriz Disla', '25-7-70','f','2017-01-26'),
	(008,103,'Emilio Peralta', '4-9-98','m','2018-05-31'),
	(009,105,'Eustacia Jimenez','4-12-89','f','2018-09-28'),
	(010,102,'Ramiro Adames','7-9-95','m','2017-12-15')

insert into area values
	(1,'Mecanica General'),
	(2,'Electricidad'),
	(3,'Pintura')

insert into mecanico values
	(991,'Juan Pichardo','409-1465725-9',3),
	(992,'Casimiro Bonificacio','001-1452578-5',1),
	(993,'Pedro Navaja','001-1445278-4',2),
	(994,'Justin Severino','049-6415956-1',1)

insert into chequeo values
	(0,'ninguno',0),
	(1,'Chequeo de motor',1200),
	(2,'Chequeos de bateria',400)

insert into piezas values
	(0,'ninguna',0),
	(1,'Cambio de aceite',800),
	(2,'Cambio de faroles',6400)

insert into mantenimiento values
	(9878,101,994,0,1),
	(9885,102,993,2,0),
	(9882,104,993,1,2),
	(9892,103,992,1,0)

insert into entrada values
	(9878,992,005,GETDATE(),'9:00'),
	(9885,992,010,GETDATE(),'9:29'),
	(9882,994,001,GETDATE(),'10:40'),
	(9892,993,008,GETDATE(),'3:21')

insert into salida values
	(9878,994,005,GETDATE(),'9:25'),
	(9885,993,010,GETDATE(),'10:56'),
	(9882,993,001,GETDATE(),'1:10'),
	(9892,993,008,GETDATE(),'4:12')

--POR CUESTION DE NO HACER UN JOIN DEMASIADO COMPLEJO QUE LLENASE LA PANTALLA... LOS DIVIDE EN TRES

--ESTE JOIN MUESTRA POR QUIEN FUE RECIBIDO EL VEHICULO
select e.idcita as 'Cita no.',e.fecha_entrada as 'Recibido el',e.hora_entrada as 'Hora', m.nombre_mecanico as 'Recibido por', 
p.nombre_propietario as 'Propietario', v.marca + ' '+v.modelo as 'Vehiculo'
from entrada e join mecanico m on(e.idmecanico=m.idmecanico) join propietario p on(e.idpropietario=p.idpropietario)
join vehiculo v on (p.idvehiculo=v.idvehiculo) 

--ESTE JOIN MUESTRA POR QUIEN FUE TRABAJADO EL VEHICULO Y LO QUE SE LE HIZO AL VEHICULO
select e.idcita as 'Cita no.', p.nombre_propietario as 'Propietario', v.marca + ' '+v.modelo as 'Vehiculo', 
m.nombre_mecanico as 'Trabajado por', a.area as'Area',c.descripcion as 'Chequeo', c.costo_chequeo as 'Costo', 
pie.piezas_cambiadas as 'Piezas cambiadas', pie.costo_piezas as 'Costo', (c.costo_chequeo+pie.costo_piezas) as 'Subtotal',
(c.costo_chequeo+pie.costo_piezas)*v.porciento_garantia as 'Garantia', 
(c.costo_chequeo+pie.costo_piezas)-((c.costo_chequeo+pie.costo_piezas)*v.porciento_garantia) as 'Total'
from entrada e join mantenimiento ma on(e.idcita=ma.idcita) join mecanico m on(ma.idmecanico=m.idmecanico) 
join propietario p on(e.idpropietario=p.idpropietario) join vehiculo v on (p.idvehiculo=v.idvehiculo) 
join area a on(a.idarea=m.idarea) join chequeo c on (ma.idchequeo=c.idchequeo) 
join piezas pie on(pie.idpiezas=ma.idpiezas)

--ESTE JOIN MUESTRA POR QUIEN FUE ENTREGADO EL VEHICULO A SU DUEÑO
select s.idcita as 'Cita no.',s.fecha_salida as 'Entregado el',s.hora_salida as 'Hora', m.nombre_mecanico as 'Entregado por', 
p.nombre_propietario as 'Propietario', v.marca + ' '+v.modelo as 'Vehiculo'
from salida s join mecanico m on(s.idmecanico=m.idmecanico) join propietario p on(s.idpropietario=p.idpropietario)
join vehiculo v on (p.idvehiculo=v.idvehiculo) 

--------------------------------------------------------------------------------------------------
----------------------------------------------ORACLE----------------------------------------------

create table vehiculo
	(idvehiculo int not null,
	 matricula char(7) not null,
	 marca varchar(20),
	 modelo varchar(30),
	 color varchar(20),
	 precio int not null,
	 garantia_duracion varchar(20),
	 porciento_garantia float,
	 constraint pk_vehiculo primary key(idvehiculo)
	)
create unique index idx_un_vehiculo on vehiculo(matricula);

create table propietario
	(
	idpropietario int not null,
	idvehiculo int not null,
	nombre_propietario varchar(30), 
	fecha_n_propietario varchar(30),
	sexo char(1),
	fecha_adquisicion date,
	constraint pk_propietario primary key(idpropietario),
	constraint fk_propietario foreign key(idvehiculo) references vehiculo(idvehiculo),
	constraint ck_chofer_sex check(sexo in('f','m'))
	)
	
create table area
	(idarea int not null,
	 area varchar(40),
	 constraint pk_area primary key(idarea)
	)

create table mecanico
	(idmecanico int not null,
	 nombre_mecanico varchar(30),
	 cedula_mecanico varchar(13),
	 idarea int not null,
	 constraint pk_mecanico primary key(idmecanico),
	 constraint fk_mecanico foreign key(idarea) references area(idarea)
	)
create unique index idx_un_mecanico on mecanico(cedula_mecanico);

create table chequeo
	(idchequeo int not null,
	 descripcion varchar(100),
	 costo_chequeo int,
	 constraint pk_chequeo primary key(idchequeo)
	)

create table piezas
	(idpiezas int not null,
	 piezas_cambiadas varchar(100),
	 costo_piezas int,
	 constraint pk_piezas primary key(idpiezas)
	)

create table mantenimiento
	(idcita int not null,
	 idvehiculo int not null,
	 idmecanico int not null,
	 idchequeo int not null,
	 idpiezas int not null,
	 constraint pk_mantenimiento primary key(idcita),
	 constraint fk_mantenimiento1 foreign key(idvehiculo) references vehiculo(idvehiculo),
	 constraint fk_mantenimiento2 foreign key(idmecanico) references mecanico(idmecanico),
	 constraint fk_mantenimiento3 foreign key(idchequeo) references chequeo(idchequeo),
	 constraint fk_mantenimiento4 foreign key(idpiezas) references piezas(idpiezas)
	)

create table entrada
	(idcita int not null,
	 idmecanico int not null,
	 idpropietario int not null,
	 fecha_entrada date,
	 constraint fk_entrada1 foreign key(idcita) references mantenimiento(idcita),
	 constraint fk_entrada2 foreign key(idmecanico) references mecanico(idmecanico),
	 constraint fk_entrada3 foreign key(idpropietario) references propietario(idpropietario)
	)
alter table entrada add constraint
pk_entrada primary key(idcita,idmecanico,idpropietario);

create table salida
	(idcita int not null,
	 idmecanico int not null,
	 idpropietario int not null,
	 fecha_salida date,
	 constraint fk_salida1 foreign key(idcita) references mantenimiento(idcita),
	 constraint fk_salida2 foreign key(idmecanico) references mecanico(idmecanico),
	 constraint fk_salida3 foreign key(idpropietario) references propietario(idpropietario)
	)
alter table salida add constraint
pk_salida primary key(idcita,idmecanico,idpropietario);


insert into vehiculo values
	(101,'A547834','Hyundai','Sonata Y20','Blanco', 650000,'2 años',0.20);
insert into vehiculo values
	(102,'Y453416','Toyota','Corolla 2010','Gris', 450000, '1 año', 0.10);
insert into vehiculo values
	(103,'G359714','Toyota','Hilux 2016','Gris',1200000,'3 años', 0.30);
insert into vehiculo values    
	(104,'F549129','Hyndai','Sonata N20','Gris', 350000, '1 año', 0.10);
insert into vehiculo values
	(105,'Z146784','Kia','K5','Azul',750000,'3 años', 0.30);


-- AQUI ME QUEDE
insert into propietario values
	(001,104,'Juan Perez', '5-8-65', 'm',TO_DATE('2018-04-02','YYYY-MM-DD'));
insert into propietario values    
	(005,101,'Beatriz Disla', '25-7-70','f',TO_DATE('2017-01-26','YYYY-MM-DD'));
insert into propietario values    
	(008,103,'Emilio Peralta', '4-9-98','m',TO_DATE('2018-05-31','YYYY-MM-DD'));
insert into propietario values    
	(009,105,'Eustacia Jimenez','4-12-89','f',TO_DATE('2018-09-28','YYYY-MM-DD'));
insert into propietario values    
	(010,102,'Ramiro Adames','7-9-95','m',TO_DATE('2017-12-15','YYYY-MM-DD'));

insert into area values
	(1,'Mecanica General');
insert into area values    
	(2,'Electricidad');
insert into area values    
	(3,'Pintura');

insert into mecanico values
	(991,'Juan Pichardo','409-1465725-9',3);
insert into mecanico values
	(992,'Casimiro Bonificacio','001-1452578-5',1);
insert into mecanico values    
	(993,'Pedro Navaja','001-1445278-4',2);
insert into mecanico values
	(994,'Justin Severino','049-6415956-1',1);

insert into chequeo values
	(0,'ninguno',0);
insert into chequeo values    
	(1,'Chequeo de motor',1200);
insert into chequeo values
	(2,'Chequeos de bateria',400);

insert into piezas values
	(0,'ninguna',0);
insert into piezas values
	(1,'Cambio de aceite',800);
insert into piezas values
	(2,'Cambio de faroles',6400);

insert into mantenimiento values
	(9878,101,994,0,1);
insert into mantenimiento values
	(9885,102,993,2,0);
insert into mantenimiento values    
	(9882,104,993,1,2);
insert into mantenimiento values 
	(9892,103,992,1,0);

insert into entrada values
	(9878,992,005,SYSDATE);
insert into entrada values    
	(9885,992,010,SYSDATE);
insert into entrada values    
	(9882,994,001,SYSDATE);
insert into entrada values
	(9892,993,008,SYSDATE);

insert into salida values
	(9878,994,005,SYSDATE);
insert into salida values    
	(9885,993,010,SYSDATE);
insert into salida values
	(9882,993,001,SYSDATE);
insert into salida values
	(9892,993,008,SYSDATE);

--POR CUESTION DE NO HACER UN JOIN DEMASIADO COMPLEJO QUE LLENASE LA PANTALLA... LOS DIVIDE EN TRES

--ESTE JOIN MUESTRA POR QUIEN FUE RECIBIDO EL VEHICULO
select e.idcita as "Cita no.",e.fecha_entrada as "Recibido e", m.nombre_mecanico as "Recibido por", 
p.nombre_propietario as "Propietario", v.marca || ' '||v.modelo as "Vehiculo"
from entrada e join mecanico m on(e.idmecanico=m.idmecanico) join propietario p on(e.idpropietario=p.idpropietario)
join vehiculo v on (p.idvehiculo=v.idvehiculo);

--ESTE JOIN MUESTRA POR QUIEN FUE TRABAJADO EL VEHICULO Y LO QUE SE LE HIZO AL VEHICULO
select e.idcita as "Cita no", p.nombre_propietario as "Propietario", v.marca || ' '||v.modelo as "Vehiculo", 
m.nombre_mecanico as "Trabajado por", a.area as "Area",c.descripcion as "Chequeo", c.costo_chequeo as "Costo", 
pie.piezas_cambiadas as "Piezas cambiadas", pie.costo_piezas as "Costo", (c.costo_chequeo+pie.costo_piezas) as "Subtotal",
(c.costo_chequeo+pie.costo_piezas)*v.porciento_garantia as "Garantia", 
(c.costo_chequeo+pie.costo_piezas)-((c.costo_chequeo+pie.costo_piezas)*v.porciento_garantia) as "Total"
from entrada e join mantenimiento ma on(e.idcita=ma.idcita) join mecanico m on(ma.idmecanico=m.idmecanico) 
join propietario p on(e.idpropietario=p.idpropietario) join vehiculo v on (p.idvehiculo=v.idvehiculo) 
join area a on(a.idarea=m.idarea) join chequeo c on (ma.idchequeo=c.idchequeo) 
join piezas pie on(pie.idpiezas=ma.idpiezas);

--ESTE JOIN MUESTRA POR QUIEN FUE ENTREGADO EL VEHICULO A SU DUEÑO
select s.idcita as "Cita no.",s.fecha_salida as "Entregado el", m.nombre_mecanico as "Entregado por", 
p.nombre_propietario as "Propietario", v.marca || ' '||v.modelo as "Vehiculo"
from salida s join mecanico m on(s.idmecanico=m.idmecanico) join propietario p on(s.idpropietario=p.idpropietario)
join vehiculo v on (p.idvehiculo=v.idvehiculo);

--------------------------------------------------------------------------------------------------
----------------------------------------------MY SQL----------------------------------------------

create table vehiculo
	(idvehiculo int not null,
	 matricula varchar(7) not null,
	 marca varchar(20),
	 modelo varchar(30),
	 color varchar(20),
	 precio int not null,
	 garantia_duracion varchar(20),
	 porciento_garantia double,
	 constraint pk_vehiculo primary key(idvehiculo)
	);
create unique index idx_un_vehiculo on vehiculo(matricula);

create table propietario
	(
	idpropietario int not null,
	idvehiculo int not null,
	nombre_propietario varchar(30), 
	fecha_n_propietario varchar(30),
	sexo char(1),
	fecha_adquisicion date,
	constraint pk_propietario primary key(idpropietario),
	constraint fk_propietario foreign key(idvehiculo) references vehiculo(idvehiculo)
	);
	
create table area
	(idarea int not null,
	 area varchar(40),
	 constraint pk_area primary key(idarea)
    );

create table mecanico
	(idmecanico int not null,
	 nombre_mecanico varchar(30),
	 cedula_mecanico varchar(13),
	 idarea int not null,
	 constraint pk_mecanico primary key(idmecanico),
	 constraint fk_mecanico foreign key(idarea) references area(idarea)
	);
create unique index idx_un_mecanico on mecanico(cedula_mecanico);

create table chequeo
	(idchequeo int not null,
	 descripcion varchar(100),
	 costo_chequeo int,
	 constraint pk_chequeo primary key(idchequeo)
	);

create table piezas
	(idpiezas int not null,
	 piezas_cambiadas varchar(100),
	 costo_piezas int,
	 constraint pk_piezas primary key(idpiezas)
	);

create table mantenimiento
	(idcita int not null,
	 idvehiculo int not null,
	 idmecanico int not null,
	 idchequeo int not null,
	 idpiezas int not null,
	 constraint pk_mantenimiento primary key(idcita),
	 constraint fk_mantenimiento1 foreign key(idvehiculo) references vehiculo(idvehiculo),
	 constraint fk_mantenimiento2 foreign key(idmecanico) references mecanico(idmecanico),
	 constraint fk_mantenimiento3 foreign key(idchequeo) references chequeo(idchequeo),
	 constraint fk_mantenimiento4 foreign key(idpiezas) references piezas(idpiezas)
	);

create table entrada
	(idcita int not null,
	 idmecanico int not null,
	 idpropietario int not null,
	 fecha_entrada date,
	 hora_entrada time(6),
	 constraint fk_entrada1 foreign key(idcita) references mantenimiento(idcita),
	 constraint fk_entrada2 foreign key(idmecanico) references mecanico(idmecanico),
	 constraint fk_entrada3 foreign key(idpropietario) references propietario(idpropietario)
	);
alter table entrada add constraint
pk_entrada primary key(idcita,idmecanico,idpropietario);

create table salida
	(idcita int not null,
	 idmecanico int not null,
	 idpropietario int not null,
	 fecha_salida date,
	 hora_salida time(6),
	 constraint fk_salida1 foreign key(idcita) references mantenimiento(idcita),
	 constraint fk_salida2 foreign key(idmecanico) references mecanico(idmecanico),
	 constraint fk_salida3 foreign key(idpropietario) references propietario(idpropietario)
	);
alter table salida add constraint
pk_salida primary key(idcita,idmecanico,idpropietario);

insert into vehiculo values
	(101,'A547834','Hyundai','Sonata Y20','Blanco', 650000,'2 años',0.20),
	(102,'Y453416','Toyota','Corolla 2010','Gris', 450000, '1 año', 0.10),
	(103,'G359714','Toyota','Hilux 2016','Gris',1200000,'3 años', 0.30),
	(104,'F549129','Hyndai','Sonata N20','Gris', 350000, '1 año', 0.10),
	(105,'Z146784','Kia','K5','Azul',750000,'3 años', 0.30);

insert into propietario values
	(001,104,'Juan Perez', '5-8-65', 'm','2018-04-02'),
	(005,101,'Beatriz Disla', '25-7-70','f','2017-01-26'),
	(008,103,'Emilio Peralta', '4-9-98','m','2018-05-31'),
	(009,105,'Eustacia Jimenez','4-12-89','f','2018-09-28'),
	(010,102,'Ramiro Adames','7-9-95','m','2017-12-15');

insert into area values
	(1,'Mecanica General'),
	(2,'Electricidad'),
	(3,'Pintura');

insert into mecanico values
	(991,'Juan Pichardo','409-1465725-9',3),
	(992,'Casimiro Bonificacio','001-1452578-5',1),
	(993,'Pedro Navaja','001-1445278-4',2),
	(994,'Justin Severino','049-6415956-1',1);

insert into chequeo values
	(0,'ninguno',0),
	(1,'Chequeo de motor',1200),
	(2,'Chequeos de bateria',400);

insert into piezas values
	(0,'ninguna',0),
	(1,'Cambio de aceite',800),
	(2,'Cambio de faroles',6400);

insert mantenimiento values
	(9878,101,994,0,1),
	(9885,102,993,2,0),
	(9882,104,993,1,2),
	(9892,103,992,1,0);

insert into entrada values
	(9878,992,005,NOW(),'9:00'),
	(9885,992,010,NOW(),'9:29'),
	(9882,994,001,NOW(),'10:40'),
	(9892,993,008,NOW(),'3:21');

insert into salida values
	(9878,994,005,NOW(),'9:25'),
	(9885,993,010,NOW(),'10:56'),
	(9882,993,001,NOW(),'1:10'),
	(9892,993,008,NOW(),'4:12');

--POR CUESTION DE NO HACER UN JOIN DEMASIADO COMPLEJO QUE LLENASE LA PANTALLA... LOS DIVIDE EN TRES

--ESTE JOIN MUESTRA POR QUIEN FUE RECIBIDO EL VEHICULO
select e.idcita as 'Cita no.',e.fecha_entrada as 'Recibido el',e.hora_entrada as 'Hora', m.nombre_mecanico as 'Recibido por', 
p.nombre_propietario as 'Propietario', concat(v.marca , ' ',v.modelo) as 'Vehiculo'
from entrada e join mecanico m on(e.idmecanico=m.idmecanico) join propietario p on(e.idpropietario=p.idpropietario)
join vehiculo v on (p.idvehiculo=v.idvehiculo);

-- ESTE JOIN MUESTRA POR QUIEN FUE TRABAJADO EL VEHICULO Y LO QUE SE LE HIZO AL VEHICULO
select e.idcita as 'Cita no.', p.nombre_propietario as 'Propietario', concat(v.marca , ' ',v.modelo) as 'Vehiculo', 
m.nombre_mecanico as 'Trabajado por', a.area as'Area',c.descripcion as 'Chequeo', c.costo_chequeo as 'Costo', 
pie.piezas_cambiadas as 'Piezas cambiadas', pie.costo_piezas as 'Costo', (c.costo_chequeo+pie.costo_piezas) as 'Subtotal',
(c.costo_chequeo+pie.costo_piezas)*v.porciento_garantia as 'Garantia', 
(c.costo_chequeo+pie.costo_piezas)-((c.costo_chequeo+pie.costo_piezas)*v.porciento_garantia) as 'Total'
from entrada e join mantenimiento ma on(e.idcita=ma.idcita) join mecanico m on(ma.idmecanico=m.idmecanico) 
join propietario p on(e.idpropietario=p.idpropietario) join vehiculo v on (p.idvehiculo=v.idvehiculo) 
join area a on(a.idarea=m.idarea) join chequeo c on (ma.idchequeo=c.idchequeo) 
join piezas pie on(pie.idpiezas=ma.idpiezas);

-- ESTE JOIN MUESTRA POR QUIEN FUE ENTREGADO EL VEHICULO A SU DUEÑO
select s.idcita as 'Cita no.',s.fecha_salida as 'Entregado el',s.hora_salida as 'Hora', m.nombre_mecanico as 'Entregado por', 
p.nombre_propietario as 'Propietario', concat(v.marca , ' ',v.modelo) as 'Vehiculo'
from salida s join mecanico m on(s.idmecanico=m.idmecanico) join propietario p on(s.idpropietario=p.idpropietario)
join vehiculo v on (p.idvehiculo=v.idvehiculo)