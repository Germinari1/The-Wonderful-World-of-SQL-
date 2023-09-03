select
    avg(energy)
from
    artists join songs on artists.id = songs.artist_id
where
    artists.name = 'Drake'