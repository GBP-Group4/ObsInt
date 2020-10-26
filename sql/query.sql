-- get count of blocks in block table that are not in observation
select count(distinct b.block)
from public.block as b
where b.block not in (select block from public.observation)
-- select blocks inside NL
WITH blks AS ( SELECT b.* FROM public.block as b WHERE b.latit <>0) SELECT block, longit, latit, geom FROM (SELECT block, longit, latit, geom, ROW_NUMBER() OVER (PARTITION BY (longit, latit) ORDER BY block DESC) rn FROM blks ) tmp WHERE rn = 1

/*
Curation of the block table
*/
-- Find duplicate blocks
create view dupblocks as (
  select b1.block, b1.longit, b1.latit, b1.geom
  from public.block b1, public.block b2
  where st_equals(b1.geom, b2.geom) and b1.block <> b2.block
)

-- Create block table without duplicates
create table s2218216.block as (
  select *
  from public.block
  where block not in 
      (select distinct on (longit, latit) block from s2218216.dupblocks)
)

/*
Curation of the road_access table
*/
select block, count(block)from block_road_access 
group by block having count(block)>1;

select block,count(block),sum(roadlength)
from block_road_access group by block;

create table s2218216.cured_road 
as select block,count(block),sum(roadlength) as roadlength
from public.block_road_access group by block;

--observer intensity and weather table
create table s2333902.obsint as
(select i.obsint,i.block,i.obsdate
from (select count(species) as obsint,o.block,o.obsdate
            from observation as o
			where o.obsdate between '2017-01-01' and '2017-06-30'
            group by o.obsdate,o.block ) as i
where i.block in (select block from block where block not in (select block from s2333902.dupblocks))
order by i.obsdate,i.block asc)

create table s2333902.weather as
(select w.to_date,w.block,w.temper,w.precip
from (select t.block,t.temper,p.precip,to_date(t.dtime::text,'YYYYMMDD')
      from temperature as t
      inner join precipitation as p on t.dtime = p.dtime and p.block = t.block 
	  where t.dtime between 20170101 and 20170630) as w
where w.block in (select block from block where block not in (select block from s2333902.dupblocks))
order by w.block,w.to_date asc)

create table s2333902.obsint_weather as 
(select o.obsdate,o.block,o.obsint,w.temper,w.precip
from s2333902.obsint as o
inner join s2333902.weather as w on o.block = w.block and o.obsdate = w.to_date
order by o.obsdate,o.block asc)
