--PARCIAL #3
-- Obtener los nombres de los empleados (Employee) residentes de Calgary, Alberta, Canadá nunca hayan facturado.

SELECT e.first_name as Nombre, e.last_name as Apellido
FROM employee e 
WHERE e.city = 'Calgary' AND
e.state = 'AB' AND
e.country = 'Canada' AND
e.employee_id NOT IN
(SELECT e.employee_id
FROM employee e
join customer c on e.employee_id = c.support_rep_id 
JOIN invoice i on i.customer_id = c.customer_id);


--Calcular la suma de ventas por cliente para cada país. Ej. si Argentina tiene un cliente que tiene una factura con 100 y otra con 200 (gasto 300) y otro cliente con una factura de 1000, la suma para Argentina es 1300.

SELECT SUM(i.total) Total, c.country Pais
from invoice i
join customer c on i.customer_id = c.customer_id
group by(c.country) ;

--Todos los artistas que en por lo menos uno de sus álbumes tienen todos tracks de genero “Rock”
SELECT distinct ar.artist_id, ar.name, al.title 
from artist ar
join album al on al.artist_id = ar.artist_id
where al.album_id in ( 
    SELECT al.album_id
    from album al
    join track t2 on t2.album_id = al.album_id 
    join genre g2 on t2.genre_id = g2.genre_id 
    where (g2.name = 'Rock'));

--Las playlist para las cuales TODOS sus tracks han sido vendidos por lo menos una vez.

select distinct p.playlist_id
from playlist p
except
select p.playlist_id
from playlist p
join playlist_track pt on pt.playlist_id = p.playlist_id
join track t on t.track_id = pt.track_id
where t.track_id not in (
    select t.track_id
    from track t
    join invoice_line i on i.track_id = t.track_id
);

select distinct p.playlist_id
from playlist p
join playlist_track pt on p.playlist_id = pt.playlist_id
join track t on t.track_id = pt.track_id
where t.track_id not in (
    select t.track_id
    from track t
    except
    select t.track_id
    from track t
    join invoice_line il on il.track_id = t.track_id
)

--Listar los géneros de los tracks que están en la Invoice de mayor importe

select g.genre_id, g.name
from invoice i
join invoice_line il on il.invoice_id = i.invoice_id
join track t on t.track_id = il.track_id
join genre g on t.genre_id = g.genre_id
where i.total = (
    select max(i.total)
    from invoice i
    join invoice_line il on il.invoice_id = i.invoice_id
    join track t on t.track_id = il.track_id
    join genre g on t.genre_id = g.genre_id
);

--Listar los datos de los clientes que hayan comprando solamente tracks de canciones de álbumes de “Billy Cobham” después del 2010
--(lo interpreto como que, a partir del 2010, no compraron nada que no sean canciones de billy)

select c.*
from customer c
where not exists (
    select t.track_id
    from customer c
    join invoice i on i.customer_id = c.customer_id
    join invoice_line il on il.invoice_id = i.invoice_id
    join track t on t.track_id = il.track_id
    join album al on al.album_id = t.album_id
    join artist ar on ar.artist_id = al.artist_id
    where ar.name = 'Billy Coham' and i.invoice_date > '2010-01-01'
);

--PARCIAL #2
--A. Enumerar Nombre, Apellido, Dirección y Ciudad de los clientes que poseen facturas (invoice) con más de 3 items
SELECT distinct c.first_name, c.last_name, c.address, c.city
from customer c
join invoice i on i.customer_id = c.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
group by c.customer_id, i.invoice_id
having count(il.invoice_line_id) > 3


--B. Encontrar los media types que tengan tracks que nunca hayan sido vendidos
select distinct m.media_type_id
from media_type m
join track t on t.media_type_id = m.media_type_id
where t.track_id not in (
    select t2.track_id
    from track t2
    join invoice_line il on il.track_id = t2.track_id
)
-- me da todos, está bien?

--otra mas corta:
select distinct t.media_type_id
from track t 
where t.track_id not in (
    select t2.track_id
    from track t2
    join invoice_line il on il.track_id = t2.track_id
)

--C. Todos los artistas que en algunos de sus álbumes tiene un track de género “Classical”
--(interpreto "al menos un track")

select distinct ar.artist_id
from artist ar
join album al on al.artist_id = ar.artist_id
join track t on t.album_id = al.album_id
join genre g on g.genre_id = t.genre_id
where g.name = 'Classical';

--otra forma
select distinct ar.artist_id
from artist ar
join album al on al.artist_id = ar.artist_id
where exists (
    select t.track_id, t.name
    from track t
    join track  on t.album_id = al.album_id
    join genre g on g.genre_id = t.genre_id
    where g.name = 'Classical'
)


--D. Las playlist para las cuales TODOS sus tracks han sido vendidos al menos una vez.

--igual al D anterior

--E. Modifique la tabla ALBUM para que incluya el año del mismo (para fines prácticos se puede inventar el año) y
--luego realice una consulta SQL que muestre AlbumID, Title y Year.

ALTER TABLE album ADD Year Integer DEFAULT 1991;

SELECT al.album_id, al.title, al.year
from album al

--F. Listar los datos de los clientes que hayan comprando solamente tracks de canciones de álbumes de “Billy bham”

select c.* 
from customer c
except
SELECT c.*
from customer c
join invoice i on i.customer_id = c.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track t on t.track_id = il.track_id
join album al on al.album_id = t.album_id
join artist ar on al.artist_id = ar.artist_id
where not (ar.name = 'Billy Cobham')
-- me da vacío... está bien?
-- lo pensé como "todos los clientes excepto los que compraron canciones que no son de billy"

--otra solucion
select c.* 
from customer c
where not exists(
    SELECT t.track_id
    from customer c
    join invoice i on i.customer_id = c.customer_id
    join invoice_line il on il.invoice_id = i.invoice_id
    join track t on t.track_id = il.track_id
    join album al on al.album_id = t.album_id
    join artist ar on al.artist_id = ar.artist_id
    where not (ar.name = 'Billy Cobham')
)