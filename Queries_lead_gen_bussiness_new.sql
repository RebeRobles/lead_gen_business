select * from billing;
select * from clients;
select * from leads;
select * from sites;

/*1. ¿Qué consulta ejecutaría para obtener los ingresos totales para marzo de 2012?*/
select sum(amount) as 'Total montos de Marzo' from billing
where charged_datetime between '2012-03-01 00:00:01' and '2012-03-31 23:59:59';

/*2. ¿Qué consulta ejecutaría para obtener los ingresos totales recaudados del cliente con una identificación de 2?*/
select sum(amount) as 'Total montos de cliente' from billing
where client_id=2;

/*3. ¿Qué consulta ejecutaría para obtener todos los sitios que posee client = 10?*/
select domain_name as 'Sitios que posee' from sites
where client_id=10;

/*4. ¿Qué consulta ejecutaría para obtener el número total de sitios creados por mes por año para el cliente con una identificación de 1? ¿Qué pasa con el cliente = 20?*/
select
count(domain_name) as 'Cantidad', 
monthname(created_datetime) as 'Mes', 
year(created_datetime) as 'Año' from sites
where client_id=1
group by created_datetime;

select
count(domain_name) as 'Cantidad', 
monthname(created_datetime) as 'Mes', 
year(created_datetime) as 'Año' from sites
where client_id=20
group by created_datetime;

/*5. ¿Qué consulta ejecutaría para obtener el número total de clientes potenciales generados para cada uno de los sitios entre el 1 de enero de 2011 y el 15 de febrero de 2011?*/
select
count(l.leads_id) as 'Cantidad', 
s.domain_name as 'Nombre Sitio',
date(l.registered_datetime) as 'Fecha'
from leads l inner join sites s on s.site_id = l.site_id 
where registered_datetime between '2011-01-01 00:00:01' and '2011-02-15 23:59:59'
group by s.site_id;

/*6. ¿Qué consulta ejecutaría para obtener una lista de nombres de clientes y el número total de clientes potenciales que hemos generado para cada uno de nuestros clientes entre el 1 de enero de 2011 y el 31 de diciembre de 2011?*/
select
	concat(c.first_name, ' ', c.last_name) as 'Nombre Cliente',
    count(l.leads_id) as 'Cantidad de Prospectos'
from clients c inner join sites s on c.client_id = s.client_id 
inner join leads l on s.site_id = l.site_id
where registered_datetime between '2011-01-01 00:00:01' and '2011-12-31 23:59:59'
group by concat(c.first_name, ' ', c.last_name)
order by c.client_id;
    
/*7. ¿Qué consulta ejecutaría para obtener una lista de nombres de clientes y el número total de clientes potenciales que hemos generado para cada cliente cada mes entre los meses 1 y 6 del año 2011?*/
select
	concat(c.first_name, ' ', c.last_name) as 'Nombre Cliente',
    count(l.leads_id) as 'Cantidad de Prospectos',
    monthname(l.registered_datetime) as 'Mes'
from clients c inner join sites s on c.client_id = s.client_id 
inner join leads l on s.site_id = l.site_id
where l.registered_datetime between '2011-01-01 00:00:01' and '2011-06-30 23:59:59'
group by monthname(s.created_datetime), concat(c.first_name, ' ', c.last_name);

/*8. ¿Qué consulta ejecutaría para obtener una lista de nombres de clientes y el número total de clientes potenciales que hemos generado para cada uno de los sitios de nuestros clientes entre el 1 de enero de 2011 y el 31 de diciembre de 2011? */
/*Solicite esta consulta por ID de cliente.*/ 
select
	concat(c.first_name, ' ', c.last_name) as 'Nombre Cliente',
    s.domain_name as 'Nombre Sitio',
    count(l.leads_id) as 'Cantidad de Prospectos',
    l.registered_datetime as 'Fecha creación'
from clients c inner join sites s on  c.client_id = s.client_id  
inner join leads l on l.site_id = s.site_id 
where l.registered_datetime between '2011-01-01 00:00:01' and '2011-12-31 23:59:59'
group by s.domain_name
order by c.client_id;

/*Presente una segunda consulta que muestre todos los clientes, los nombres del sitio y el número total de clientes potenciales generados en cada sitio en todo momento.*/
select
	concat(c.first_name, ' ', c.last_name) as 'Nombre Cliente',
    s.domain_name as 'Nombre Sitio',
    count(l.leads_id) as 'Cantidad de Prospectos'
from clients c inner join sites s on  c.client_id = s.client_id  
inner join leads l on l.site_id = s.site_id 
group by s.domain_name
order by c.client_id;

/*9. Escriba una sola consulta que recupere los ingresos totales recaudados de cada cliente para cada mes del año. Pídalo por ID de cliente.*/
select
	concat(c.first_name, ' ', c.last_name) as 'Nombre Cliente',
    sum(b.amount) as 'Total',
    monthname(b.charged_datetime) as 'Mes',
    year(b.charged_datetime) as 'Año'
from billing b inner join clients c on c.client_id = b.client_id
group by c.client_id, year(b.charged_datetime), month(b.charged_datetime)
order by c.client_id, year(b.charged_datetime), month(b.charged_datetime);

/*10. Escriba una sola consulta que recupere todos los sitios que posee cada cliente. 
Agrupe los resultados para que cada fila muestre un nuevo cliente. 
Se volverá más claro cuando agregue un nuevo campo llamado 'sitios' que tiene todos los sitios que posee el cliente. (SUGERENCIA: use GROUP_CONCAT)*/
select
	concat(c.first_name, ' ', c.last_name) as 'Nombre Cliente',
    group_concat(distinct s.domain_name
		order by s.site_id
		separator ' ; ') as 'Sitios'
    from clients c inner join sites s on  c.client_id = s.client_id
    group by c.client_id
    order by c.client_id;