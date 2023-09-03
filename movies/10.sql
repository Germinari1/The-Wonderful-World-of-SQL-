select distinct(people.name)
from people join directors on people.id = directors.person_id
where directors.movie_id in (select movies.id from movies join ratings on movies.id=ratings.movie_id where ratings.rating >=9.0)