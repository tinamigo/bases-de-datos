SELECT g.name , t.name, m.name 
FROM genre g, track t, media_type m
WHERE t.genre_id = g.genre_id AND t.media_type_id = m.media_type_id

SELECT COUNT(t.track_id) as Total , g.name as Genre  
FROM track t
    RIGHT JOIN genre g on g.genre_id = t.genre_id
GROUP BY g.name

SELECT g. name , COUNT (t. track_id )
FROM genre g
LEFT JOIN track t ON g. genre_id = t. genre_id
GROUP BY g. genre_id , g. name

SELECT DISTINCT ar.name 
FROM artist ar 
    LEFT OUTER JOIN album al ON ar.artist_id = al.artist_id 
    WHERE  al.album_id IS NULL

SELECT ar.name
FROM artist ar 
EXCEPT
select ar.name
from artist ar JOIN album al on ar.artist_id = al.artist_id

SELECT ar.name, count(*) as cantidad
from artist ar 
    inner join album al on ar.artist_id = al.artist_id
    inner JOIN track t on t.album_id = al.album_id
GROUP BY ar.artist_id, ar.name    
having COUNT(*) > 50
ORDER BY COUNT(*) 

SELECT COUNT(e.employee_id) , c.customer_id
FROM employee e 
    right outer join customer c on e.country = c.country AND
    e.state = c.state AND
    e.city = c.city
GROUP BY c.customer_id
ORDER BY COUNT(e.employee_id) DESC

SELECT c. customer_id , COUNT ( e. employee_id )
FROM customer c
LEFT OUTER JOIN employee e ON
c. country = e. country AND
c. state = e. state AND
c. city = e. city
GROUP BY c. customer_id
ORDER BY COUNT (e . employee_id ) DESC

--Obtener el dinero recaudado por cada empleado durante cada año.

SELECT e.first_name , e.last_name , date_part('year', i.invoice_date) , sum(i.total)
FROM employee e 
    LEFT OUTER JOIN customer c ON e.employee_id = c.support_rep_id
    LEFT OUTER JOIN invoice i ON i.customer_id = c.customer_id
GROUP BY e.first_name, e.last_name , date_part('year', i.invoice_date)  

--Obtener la cantidad de pistas de audio que tengan una duraci ́on superior a
--la duraci ́on promedio de todas las pistas de audio. Adem ́as, obtener la
--sumatoria de la duraci ́on de todas esas pistas en minutos.

SELECT count(t.*), sum(t.milliseconds / 60000)
from track t 
    JOIN media_type m on t.media_type_id = m.media_type_id
WHERE m.name like '%audio%' AND t.milliseconds > (
    SELECT avg(t2.milliseconds)
    from track t2 
        JOIN media_type m on t2.media_type_id = m.media_type_id
        WHERE m.name like '%audio%')

CREATE OR REPLACE VIEW rock_tracks AS
SELECT (p.*)
FROM playlist p
    JOIN playlist_track pt on p.playlist_id = pt.playlist_id
    JOIN track t ON pt.track_id = t.track_id
    JOIN genre g ON g.genre_id = t.genre_id
WHERE g.name = 'Rock'
GROUP BY p.playlist_id 

SELECT count(p.playlist_id)
FROM playlist p 
WHERE p.playlist_id NOT IN 
    (select p.playlist_id FROM rock_tracks)

CREATE OR REPLACE VIEW rocky_playlists AS
SELECT DISTINCT p.playlist_id , p.name 
FROM playlist p
WHERE p.playlist_id = ANY (
SELECT pt.playlist_id FROM playlist_track pt
INNER JOIN track t ON pt.track_id = t.track_id
INNER JOIN genre g ON t.genre_id = g.genre_id
WHERE g.name = 'Rock' )


SELECT COUNT ( playlist_id ) FROM playlist
WHERE playlist_id NOT IN (
SELECT playlist_id FROM rocky_playlists )   


CREATE OR REPLACE VIEW precios_playlists AS
SELECT (p.*) , SUM(t.unit_price)
FROM playlist p 
    JOIN playlist_track as pt on p.playlist_id = pt.playlist_id
    JOIN track t on pt.track_id = t.track_id
GROUP BY p.playlist_id

SELECT pp.playlist_id, pp.name, pp.sum
from precios_playlists pp 
where pp.sum = (SELECT MAX(pp.sum)
from precios_playlists pp) 


