USE Property

set IMPLICIT_TRANSACTIONS ON;

--View to store only the Houses from Our Table for Data Analysis
create view HouseProperty
as
select
     [Listing Number], Prices, Province, City, Cast(Bedrooms as int) as Bedrooms, Cast(Bathrooms as int) as Bathrooms, [Type of Property], [Listing Date], [new Erf Size] 
from lists
where [Type of Property] = 'House'  
       and Bathrooms is not null
	   and Bedrooms is not null
	   and [new Erf Size] is not null
	   and Prices is not null
	   


select bedrooms, count(*), AVG(Prices)
from HouseProperty
group by Bedrooms;

--Outlier Detection
with cte as(
   select
        *,( (Prices -avg(Prices) over(Partition by Bedrooms)) / STDEV(Prices) over(Partition by Bedrooms)) as z_score
   from HouseProperty)
Delete  H
from HouseProperty H
join cte c
on H.[Listing Number] = c.[Listing Number]
where z_score > 3 or z_score <-3

with cte as(
   select
        *,( (Prices -avg(Prices) over(Partition by Province, City)) / STDEV(Prices) over(Partition by Province, City)) as z_score
   from HouseProperty)
 Delete  H
from HouseProperty H
join cte c
on H.[Listing Number] = c.[Listing Number]
where z_score > 3 or z_score <-3

with cte as(
   select
        *, case when 
		 (stdev(Prices) over(Partition by [new erf size])) > 0 
		 then(Prices - avg(Prices) over(Partition by [new erf size])) / STDEV(Prices) over(Partition by [new erf size]) else 0  end as z_score
   from HouseProperty)
   Delete  H
from HouseProperty H
join cte c
on H.[Listing Number] = c.[Listing Number]
where z_score > 3 or z_score <-3


--The Data we used to export to excel for analysis
select b.[listing number], b.Province, b.Bathrooms, b.Bedrooms, b.City, b.Prices, a.[Listing Date]
from HousePropeerty b
join lists a 
on  b.[Listing Number] = a.[listing Number]




