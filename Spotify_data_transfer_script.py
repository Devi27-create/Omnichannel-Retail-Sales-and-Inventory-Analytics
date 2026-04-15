cursor.fast_executemany = True

sql = """
INSERT INTO dbo.Songs_Stg (
    id, name, album_name, artists, artist_ids,
    danceability, energy, [key], loudness, mode,
    speechiness, acousticness, instrumentalness,
    liveness, valence, tempo, duration_ms,
    lyrics, [year], genre, popularity
)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
"""

cursor.executemany(sql, song_rows)
conn.commit()