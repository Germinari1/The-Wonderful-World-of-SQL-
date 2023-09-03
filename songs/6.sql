select
    songs.name
from
    artists join songs on artists.id = songs.artist_id
where
    artists.name = 'Post Malone'
