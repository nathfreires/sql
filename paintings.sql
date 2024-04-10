select * from artist; -- 421
select * from canvas_size; -- 200
select * from image_link; -- 14,775
select * from museum; -- 57
select * from product_size; -- 110,347
select * from subject; -- 6771
select * from work; -- 14776

-- Identify the museums which are open on both Sunday and Monday. Display museum name, city.
select distinct m.name as museum_name, m.city, m.state,m.country
	from museum_hours mh 
	join museum m on m.museum_id=mh.museum_id
	where day='Sunday'
	and exists (select 1 from museum_hours mh2 
				where mh2.museum_id=mh.museum_id 
			    and mh2.day='Monday');
                
-- How many museums are open every single day?
select count(1)
	from (select museum_id, count(1)
		  from museum_hours
		  group by museum_id
		  having count(1) = 7) x;
  
  
-- 16) Which museum has the most no of most popular painting style?
	with pop_style as 
			(select style
			,rank() over(order by count(1) desc) as rnk
			from work
			group by style),
		cte as
			(select w.museum_id,m.name as museum_name,ps.style, count(1) as no_of_paintings
			,rank() over(order by count(1) desc) as rnk
			from work w
			join museum m on m.museum_id=w.museum_id
			join pop_style ps on ps.style = w.style
			where w.museum_id is not null
			and ps.rnk=1
			group by w.museum_id, m.name,ps.style)
	select museum_name,style,no_of_paintings
	from cte 
	where rnk=1;

