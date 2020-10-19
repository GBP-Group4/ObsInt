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
