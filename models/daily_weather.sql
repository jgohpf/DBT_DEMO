{{
    config(
        materialized='table'
    )
}}

WITH daily_weather AS(

select 
DATE(TIME) as DAILY_WEATHER,
WEATHER,
TEMP,
PRESSURE,
HUMIDITY,
CLOUDS
from {{ source('demo', 'weather') }}

),

daily_weather_agg AS(

select
DAILY_WEATHER,
WEATHER, 
ROUND(AVG(TEMP),2) AS AVG_TEMP,
ROUND(AVG(PRESSURE),2) AS AVG_PRESSURE,
ROUND(AVG(HUMIDITY),2) AS AVG_HUMIDITY,
ROUND(AVG(CLOUDS),2) AS AVG_CLOUDS
from 
daily_weather
group by 1,2
qualify ROW_NUMBER() OVER (PARTITION BY DAILY_WEATHER ORDER BY COUNT(WEATHER) DESC) = 1

)

select 
*
from daily_weather_agg