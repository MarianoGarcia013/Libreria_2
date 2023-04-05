-- El código y nombre completo de los clientes, la dirección (calle y número) y
--barrio.use LIBRERIA_2create view vista_clientesasselect c.cod_cliente, nom_cliente +' '+ape_cliente 'Nombre completo', c.altura Altura, c.calle Calle,        b.barrio Barriofrom clientes c join barrios b on c.cod_barrio = b.cod_barrioselect [Nombre completo] from vista_clienteswhere [Nombre completo] like 'A%'create view vista2asselect f.fecha Fecha, f.nro_factura, v.cod_vendedor, v.nom_vendedor, a.descripcion,       d.cantidad, d.pre_unitariofrom facturas f join vendedores v on f.cod_vendedor = v.cod_vendedor     join detalle_facturas d on f.nro_factura = d.nro_factura 	 join articulos a on a.cod_articulo = d.cod_articulowhere year(fecha) = year(getdate())/*3. Modifique la vista creada en el punto anterior, agréguele la condición de que
solo tome el mes pasado (mes anterior al actual) y que también muestre la
dirección del vendedor.*/alter view vista2asselect f.fecha Fecha, f.nro_factura, v.cod_vendedor, v.nom_vendedor, a.descripcion,       d.cantidad, d.pre_unitario, v.altura + ' '+ v.calle + ' '+ v.cod_barrio 'Direccion'from facturas f join vendedores v on f.cod_vendedor = v.cod_vendedor     join detalle_facturas d on f.nro_factura = d.nro_factura 	 join articulos a on a.cod_articulo = d.cod_articulowhere datediff(month, fecha, getdate()) = 1/* Modificar vista */alter view vis_clientes_activos (nombre,barrio,calle,altura)
as
select distinct ape_cliente+' '+nom_cliente, barrio,
calle, altura
from clientes c
join barrios b
on c.cod_barrio=b.cod_barrio
join facturas f
on c.cod_cliente=f.cod_cliente
Where year(fecha)>=year(getdate())-1/*4. Consulta las vistas según el siguiente detalle:
a. Llame a la vista creada en el punto anterior pero filtrando por importes
inferiores a $120.
b. Llame a la vista creada en el punto anterior filtrando para el vendedor
Miranda.
c. Llama a la vista creada en el punto 4 filtrando para los importes
menores a 10.000. */select  * from vista2where pre_unitario < 120select * from vista2where nom_vendedor = 'Miranda'select * from vista2where pre_unitario < 10000--5. Elimine las vistas creadas en el punto 3  drop view vista2