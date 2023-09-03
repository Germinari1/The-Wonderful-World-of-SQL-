select distinct(name)
from people join stars on people.id = stars.person_id
where stars.movie_id in(select id
from movies
where year = 2004)
order by people.birth
