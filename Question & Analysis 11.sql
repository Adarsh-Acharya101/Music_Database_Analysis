/*Q1: Who is the senior most employee based on job title?*/

select* from employee
order by levels desc

/*A1: Madan Mohan L7*/

/*Q2: Which countries have the most Invoices?*/

select count(*),billing_country as c
from invoice
group by billing_country
order by c desc

/*A2: USA*/

/*Q3: What are top 3 values of total invoice?*/

select* from invoice
order by total desc
limit 3

/*A3: 23.75, 19.8, 19.8*/

/*Q4: one city that has the highest sum of invoice totals. Return city name & sum of all invoice*/

select billing_city, sum(total) as revenue
from invoice
group by billing_city
order by revenue desc
limit 1

/*A4: Prague - 273.240*/

/*Q5: Best customer?*/

select customer.customer_id,first_name,last_name, sum(total) as t
from customer
join invoice on customer.customer_id=invoice.customer_id
group by customer.customer_id
order by t desc
limit 1

/*A5: R Madav - 144.54*/

/*Q6: Write query to return the email, first name, last name, & Genre of all Rock Music listeners.*/

select distinct customer.first_name,last_name
from customer
join invoice on invoice.customer_id=customer.customer_id
join invoice_line on invoice.invoice_id=invoice_line.invoice_id
WHERE track_id in(
select track_id from track
	join genre on track.genre_id = genre.genre_id
where genre.name = 'Rock')
order by first_name asc

/*A6: Aaron Mitchell,..........*/

/*Q7: Write a query that returns the Artist name and total track count of the top 10 rock bands*/

select artist.artist_id,artist.name, COUNT(artist.artist_id) as songs
from artist
join album on artist.artist_id = album.artist_id
join track on album.album_id=track.album_id
join genre on track.genre_id=genre.genre_id
where genre.name = 'Rock'
group by artist.artist_id
order by songs desc
limit 10

/*A7: Led Zepplin...........*/

/*Q8: Return all the track names & Ms that have song length > than the avg length.*/ 

select name,milliseconds from track
where milliseconds > (
select avg(milliseconds) as avglength
from track)
order by milliseconds desc

/*A8: "Occupation / Precipice".......*/

/*Q9: Write a query to return customer name, artist name and total spent for best artist*/

with bsa as(
	select artist.artist_id as aid, artist.name as aname,
	SUM(invoice_line.unit_price*invoice_line.quantity) as sales
	from invoice_line
	join track on invoice_line.track_id = track.track_id
	join album on track.album_id = album.album_id
	join artist on album.artist_id = artist.artist_id
	group by aid
	order by sales desc
	limit 1
)

select customer.customer_id, customer.first_name, customer.last_name, bsa.aname,
SUM(invoice_line.unit_price*invoice_line.quantity) as spent
from invoice
join customer on invoice.customer_id = customer.customer_id
join invoice_line on invoice_line.invoice_id = invoice.invoice_id
join track on invoice_line.track_id = track.track_id
join album on track.album_id = album.album_id
join bsa on album.artist_id = bsa.aid
group by 1,2,3,4
order by spent desc

/*A9: Hugh O'Rielly...Queen...27.719*/

/*Q10: Find out the most popular music Genre for each country wrt purchase quantity*/

WITH popular_genre AS 
(
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity)desc) AS RowNo 
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre WHERE RowNo <= 1

/*A10: 17...Argentina....Alt & Punk*/

/*Q11: Write a query that determines the customer that has spent the most on music for each country.*/

WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1

/*A11: Diego Gutierrez...Argentina...39.6*/


















































