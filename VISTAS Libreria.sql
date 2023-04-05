-- El c�digo y nombre completo de los clientes, la direcci�n (calle y n�mero) y
--barrio.
solo tome el mes pasado (mes anterior al actual) y que tambi�n muestre la
direcci�n del vendedor.*/
as
select distinct ape_cliente+' '+nom_cliente, barrio,
calle, altura
from clientes c
join barrios b
on c.cod_barrio=b.cod_barrio
join facturas f
on c.cod_cliente=f.cod_cliente
Where year(fecha)>=year(getdate())-1
a. Llame a la vista creada en el punto anterior pero filtrando por importes
inferiores a $120.
b. Llame a la vista creada en el punto anterior filtrando para el vendedor
Miranda.
c. Llama a la vista creada en el punto 4 filtrando para los importes
menores a 10.000. */