--Listar los nombre completos de los empleados que dieron soporte a clientes que compraron tracks de audio. 
SELECT DISTINCT e.first_name, e.last_name 
from employee e 
join customer c on c.support_rep_id = e.employee_id
join invoice i on i.customer_id = c.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track t on t.track_id = il.track_id 
join media_type m on t.media_type_id = m.media_type_id 
where m.name LIKE '%audio%';


--Obtener la cantidad de ventas de tracks de género “Rock”. Aclaración: si en una línea de facturación figura una venta de 5 unidades de un track, entonces ese track se considera vendido 5 veces. 
SELECT SUM(il.quantity)
from genre g
join track t on t.genre_id = g.genre_id
join invoice_line il on t.track_id = il.track_id
where g.name = 'Rock';


--Listar el id, título, y cantidad de minutos de todos los álbumes que duren más de 90 minutos
-- 90 minutos = 5400000 milisegundos

SELECT al.album_id, al.Title, (sum(t.milliseconds)/60000) Minutos
from album al 
join track t on t.album_id = al.album_id 
GROUP BY al.album_id 
having (sum(t.milliseconds)/60000) > 90;


--Listar un ranking los artistas según la cantidad de playlists en las cuales aparecen. El artista que aparece en más playlists debe estar primero en el resultado.
SELECT ar.artist_id , ar.name, COUNT(pt.playlist_id) 
from artist ar 
join album al on ar.artist_id = al.album_id
join track t on t.album_id = al.album_id 
join playlist_track pt on pt.track_id = t.track_id 
join playlist p on p.playlist_id = pt.playlist_id
GROUP BY ar.artist_id
ORDER BY COUNT(pt.playlist_id) DESC;

--Obtener el máximo precio promedio de las invoices . El precio promedio de una invoice es el promedio de los precios de los ítems de esa invoice.. Se quiere el máximo. El resultado es 1 único número. 
--SELECT MAX( AVG(il.unit_price) )
--from invoice i   
--join invoice_line il on i.invoice_id = il.invoice_id 
--GROUP BY i.invoice_id
