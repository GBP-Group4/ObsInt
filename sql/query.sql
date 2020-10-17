-- get count of blocks in block table that are not in observation
select count(distinct b.block)
from public.block as b
where b.block not in (select block from public.observation)
