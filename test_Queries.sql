use test_db;
-- --------------------------------------------------
-- Total expenses
-- --------------------------------------------------

select round(sum(charge),2) as sum 
from (select call_id, ceiling((timestamp_end - timestamp_start)/ 60)*(select money from rates where id= 3) as charge 
	from call_logs cl left join numbers n on cl.from = n.phone_number
	where cl.call_dir = 'out' and n.phone_number is null) as tabel;

-- ----------------------------------------------------
-- Top 10 active users
-- ----------------------------------------------------

select n.UID, sum(t2.total) as total1 
from numbers as n join 
(select number, count(number) as total from (select call_logs.from as number from call_logs 
union all
select call_logs.to from call_logs
union all
select call_forwarding.from from call_forwarding
union all
select call_forwarding.to from call_forwarding) as t1
group by number
order by total desc) as t2  on n.Phone_number = t2.number  
group by n.UID
order by total1 desc
limit 10;

-- ---------------------------------------------------------------------------
-- Top 10: Users with highest charges, and daily distribution for each of them
-- ---------------------------------------------------------------------------

select cl.UID, sum(ceiling((timestamp_end - timestamp_start)/ 60)*(select money from rates where id= 3) ) as period 
from call_logs cl left join numbers n on cl.from = n.phone_number
where cl.call_dir = 'out' and n.phone_number is null
group by cl.UID
order by period desc;

