-- get count of blocks in block table that are not in observation
select count(distinct b.block)
from public.block as b
where b.block not in (select block from public.observation)


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

--observer intensity table
select i.block, i.obsdate, i.obsint,w.precip,w.temper
from (select t.block,t.temper,p.precip,to_date(t.dtime::text,'YYYYMMDD')
      from temperature as t
      left join precipitation as p on t.dtime = p.dtime and p.block = t.block 
	  where t.dtime between 20170101 and 20170630
	  order by t.block,to_date asc) as w
right join (select count(species) as obsint,o.block,o.obsdate
            from observation as o
			where o.obsdate between '2017-01-01' and '2017-06-30'
            group by o.obsdate,o.block 
			order by o.obsdate,o.block asc ) as i on w.to_date = i.obsdate and w.block = i.block
where i.block in (select block from block where block not in (select block from s2333902.dupblocks))
order by i.block,i.obsdate asc
