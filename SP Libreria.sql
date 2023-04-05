use LIBRERIA_2


/* 0 Crear un procedimiento almacenado que ingresa registros en la tabla
"articulos". Los parámetros correspondientes al pre_unitario DEBEN ingresarse con
un valor distinto de "null", los demás son opcionales. El procedimiento retorna "1" si
la inserción se realiza, es decir, si se ingresan valores para pre_unitario y "0", en
caso que pre_unitario sea nulo*/

create proc sp_insert_articulos
@descripcion varchar(80) null,
@stock_minimo int null,
@pre_unitario decimal(10,2) not null,
@observaciones varchar(80) null
as
if(@pre_unitario is null)
begin return 0
else
begin
insert into articulos(descripcion, stock_minimo, pre_unitario, observaciones) 
            values(@descripcion, @stock_minimo, @pre_unitario, @observaciones)
return 1
end;

create procedure pa_articulos_ingreso
@descripcion nvarchar (50) NULL ,
@stock_minimo smallint NULL ,
@pre_unitario decimal(10, 2) NOT NULL ,
@observaciones nvarchar (50)=null
as
if (@pre_unitario is null)
 return 0
else
begin
insert into articulos
values(@descripcion,@stock_minimo,@pre_unitario,@observaciones)
 return 1
end;


/* 1 Detalle_Ventas: liste la fecha, la factura, el vendedor, el cliente, el
artículo, cantidad e importe. Este SP recibirá como parámetros de E un
rango de fechas.*/

create proc Detalle_Ventas
@fecha1 datetime,
@fecha2 datetime 
as
select f.nro_factura, cod_vendedor, fecha, cod_articulo, cantidad, pre_unitario 
from facturas f join detalle_facturas d on f.nro_factura = d.nro_factura
where fecha between @fecha1 and @fecha2

/* 2 CantidadArt_Cli : este SP me debe devolver la cantidad de artículos o
clientes (según se pida) que existen en la empresa.*/

create proc CantidadArt_Cli
@Articulos varchar(100),
@Clientes varchar(100)
as
if(@Articulos is not null and @Clientes is null)
select count(cod_articulo) 
from articulos
else
if(@Clientes is not null and @Articulos is null)
select count(cod_cliente)
from clientes

/* 3 INS_Vendedor: Cree un SP que le permita insertar registros en la tabla
vendedores.*/

create proc INS_Vendedor -- Lod parametros not null solo se admite con SP  compilados de forma nativa.
@nom_vendedor varchar(100) not null,
@ape_vendedor varchar(100) not null,
@calle varchar(100) null, 
@altura int null,
@cod_barrio int not null,
@email varchar(50) null,
@fec_nac datetime null
as
if(@nom_vendedor is null and @ape_vendedor is null and @cod_barrio is null)
return 0
else
begin
insert into vendedores(nom_vendedor, ape_vendedor, calle, altura, cod_barrio, [e-mail], fec_nac)
values(@nom_vendedor, @ape_vendedor, @calle, @altura, @cod_barrio, @email, @fec_nac)
return 1
end;

/* 4 UPD_Vendedor: cree un SP que le permita modificar un vendedor
cargado.*/

create proc UPD_Vendedor
@cod_vendedor int,
@nom_vendedor varchar(100),
@ape_vendedor varchar(100),
@calle varchar(100), 
@altura int,
@cod_barrio int,
@email varchar(50),
@fec_nac datetime
as
if(@cod_vendedor is not null)
update vendedores
set nom_vendedor = @nom_vendedor,
    ape_vendedor = @ape_vendedor,
	calle = @calle,
	altura = @altura,
	cod_barrio = @cod_barrio,
	[e-mail] = @email,
	fec_nac = @fec_nac
where @cod_vendedor = cod_vendedor

/*DEL_Vendedor: cree un SP que le permita eliminar un vendedor
ingresado.*/
create proc DEL_Vendedor1
@cod_vendedor int
as
if(@cod_vendedor is not null)
delete vendedores
where @cod_vendedor = cod_vendedor

-----
create proc DEL_Vendedor2
@cod_vendedor int
as
if(@cod_vendedor is null)
print 'Debe ingresar el codigo del vendedor'
else
begin
delete vendedores
where @cod_vendedor = cod_vendedor
end

-- 2
/*Modifique el SP 1-a, permitiendo que los resultados del SP puedan filtrarse por
una fecha determinada, por un rango de fechas y por un rango de vendedores;
según se pida.*/

alter proc Detalle_Ventas
@fecha1 datetime,
@fecha2 datetime,
@cod_vendedor1 int,
@cod_vendedor2 int
as
if(@fecha1 is not null and @fecha2 is not null and @cod_vendedor1 is null and @cod_vendedor2 is null)
select f.nro_factura, cod_vendedor, fecha, cod_articulo, cantidad, pre_unitario 
from facturas f join detalle_facturas d on f.nro_factura = d.nro_factura
where fecha between @fecha1 and @fecha2
else
if(@fecha1 is not null and @fecha2 is null and @cod_vendedor1 is null and @cod_vendedor2 is null)
select f.nro_factura, cod_vendedor, fecha, cod_articulo, cantidad, pre_unitario 
from facturas f join detalle_facturas d on f.nro_factura = d.nro_factura
where fecha = @fecha1
else 
if(@fecha1 is null and @fecha2 is null and @cod_vendedor1 is not null and @cod_vendedor2 is not null)
select f.nro_factura, cod_vendedor, fecha, cod_articulo, cantidad, pre_unitario 
from facturas f join detalle_facturas d on f.nro_factura = d.nro_factura
where cod_vendedor between @cod_vendedor1 and @cod_vendedor2
end

------------------- FUNCIONES DEFINIDAS POR EL USUARIO ------------------

/*Fecha: una función que devuelva la fecha en el formato AAAMMDD (en
carácter de 8), a partir de una fecha que le ingresa como parámetro
(ingresa como tipo fecha)*/

create function F_Fecha
(@Fechaing datetime)
returns datetime
as
begin
declare @Resultado datetime
select @Resultado = format(@Fechaing ,'yyyy/mm/dd')-- as [yyy/mm/dd]
return @Resultado
end

/*Dia_Habil: función que devuelve si un día es o no hábil (considere
como días no hábiles los sábados y domingos). Debe devolver 1
(hábil), 0 (no hábil)*/

/*create function Dia_Habil
(@diaingresado varchar(50)
returns varchar(50))
as
begin 
 select day(@diaingresado) when
end*/

------------------------- U4 SP --------------------------------------
USE LIBRERIA_2

/* a. Mostrar los artículos cuyo precio sea mayor o igual que un valor que se
envía por parámetro.*/

create proc PA_mayor_iguales
@precio1 decimal (10,2)
as
select * from articulos where pre_unitario >= @precio1 

/* b. Ingresar un artículo nuevo, verificando que la cantidad de stock que se
pasa por parámetro sea un valor mayor a 30 unidades y menor que 100.
Informar un error caso contrario.*/

create proc nvo_articulo
@descripcion varchar(100),
@stock_minimo int,
@stock int,
@pre_unitario decimal(10,2),
@observaciones varchar(100)
as
if( @stock between 30 and 100)
begin
insert into articulos(descripcion, stock_minimo, stock, pre_unitario, observaciones)
values (@descripcion, @stock_minimo, @stock, @pre_unitario, @observaciones)
print 'El artiuclo fue ingresado con exito'
end
else
begin
print 'La cantidad de stock no es la permitida'
end;

execute nvo_articulo 

/* c. Mostrar un mensaje informativo acerca de si hay que reponer o no
stock de un artículo cuyo código sea enviado por parámetro */

create proc Reponer_stock
@cod_articulo int
as
declare @stock int
select @stock = stock - stock_minimo from articulos where cod_articulo = @cod_articulo -- para reponer stock se restan los stock y se los compara con 0
if(@stock <= 0)
select @cod_articulo as Codigo, 'Stock insuficiente' as Mensaje -- Puede ser con print
else
select @cod_articulo as Codigo, 'Stock ok' as Mensaje -- puede ser con print
declare @a int;
execute Reponer_stock 




/* d. Actualizar el precio de los productos que tengan un precio menor a uno
ingresado por parámetro en un porcentaje que también se envíe por
parámetro. Si no se modifica ningún elemento informar dicha situación*/

create proc precios_xporcetaje -- nose si estara bien
@cod_articulo int,
@porcentaje decimal(4,2)
as
declare @precio decimal(10,2)
select @precio = pre_unitario from articulos where cod_articulo like @cod_articulo
if(@precio < 1)
update articulos set pre_unitario = (@porcentaje * 100)/ pre_unitario
from articulos where cod_articulo = @cod_articulo -- Esta linea va?
else
begin 
raiserror('No se puede modificar el precio', 16, 2)
rollback transaction 
end;

/*e. Mostrar el nombre del cliente al que se le realizó la primer venta en un
parámetro de salida.*/

alter proc cliente_1venta
@nom_cliente varchar(100) output
as
select top 1 @nom_cliente = nom_cliente from facturas f join clientes c on f.cod_cliente = c.cod_cliente
      
declare @nom varchar(100)
execute cliente_1venta @nom;
select @nom as Primero;



        
































