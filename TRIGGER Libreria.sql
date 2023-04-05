use LIBRERIA_2

select * from articulos

create trigger dis_ventas_insertar
on detalle_facturas
for insert -- para que es (insert/update/delete)
as 
select top 5 * from detalle_facturas -- los ultimos 5 detalles insertados
order by nro_factura desc
select * from inserted -- esta es una tabla temporal que se hace por cada insert


create trigger dis_venta_eliminar
on detalle_facturas
for delete
as
update articulos set a.stock = a.stock + d.cantidad
from articulos a join deteled d on a.cod_ariculo = d.cod_articulo

select * from detalle_facturas order by nro_factura desc
select * from articulos

delete from detalle_facturas
where nro_factura = 571 and cod_articulo = 4


create trigger dis_clie_actualizar
on clientes
instead of update 
as 
if update (cod_cliente)
begin 
raiserror('Los codigos no pueden modificarse', 10, 1) -- el 10 es el numero de la gravedad del error
rollback transaction
end 
else
begin
update clientes
set clientes.nom_cliente = inserted.nom_cliente,
    clientes.ape_cliente = inserted.ape_cliente
from clientes join inserted on clientes.cod_cliente = inserted.cod_cliente
end;

