WITH CTE AS(

select 
t.*,
d.*
from {{ ref('trip_fact') }} t
left join {{ ref('daily_weather') }} d
on t.TRIP_DATE = d.DAILY_WEATHER

)

select 
*
from CTE