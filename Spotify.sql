USE spotify_data;

SHOW TABLES;
SELECT * FROM tracks_cleaned LIMIT 10;
SELECT * FROM artists LIMIT 10;


select *
from artists
order by followers desc
limit 1000

ALTER TABLE artists MODIFY genres VARCHAR(1024);
ALTER TABLE artists
MODIFY name VARCHAR(512);

   
DROP VIEW IF EXISTS tracks_cleaned;

CREATE VIEW tracks_cleaned AS
SELECT 
    *, 
    REPLACE(REPLACE(REPLACE(id_artists, '[', ''), ']', ''), "'", '') AS cleaned_id
FROM 
    tracks;

   
   SELECT 
    *
FROM 
    tracks_cleaned tc
JOIN 
    artists a 
ON 
    tc.cleaned_id = a.id;
   
   
  ALTER TABLE tracks MODIFY release_date VARCHAR(10);
 
 ALTER TABLE tracks MODIFY id_artists TEXT;


ALTER TABLE tracks MODIFY artists VARCHAR(1024);

ALTER TABLE tracks MODIFY name TEXT;


#-------------------------------------------------------------------------------------------------------------------------
  
select count(*)
from tracks

SELECT id, COUNT(*) AS duplicate_count
FROM tracks
GROUP BY id
HAVING duplicate_count > 1;

TRUNCATE TABLE tracks;

SELECT COUNT( id) AS unique_track_count
FROM tracks;

# From This point on the code should work
   
#What Factors Drive Track Popularity?
#Question: How do attributes like danceability, energy, and valence affect a track’s popularity?
#Dashboard Idea: Visualize this as a scatter plot or heatmap to show correlations between track attributes and popularity. You could highlight the top attributes that make a track popular.

   
select 
	case 
		when danceability  < 0.4 then 'LOW'
		when danceability  between 0.4 and 0.7 then 'Medium'
		else 'High'
	end as danceability_range,
	AVG(popularity) as avg_popularity
from tracks
group by danceability_range
order by avg_popularity
#the higher the dancability the more popular the track is


select 
	case 
		when energy  < 0.4 then 'LOW'
		when energy  between 0.4 and 0.7 then 'Medium'
		else 'High'
	end as energy_range,
	AVG(popularity) as avg_popularity
from tracks
group by energy_range
order by avg_popularity
#the higher the energy the more popular the track is


SELECT 
    CASE 
        WHEN valence < 0.4 THEN 'Low'
        WHEN valence BETWEEN 0.4 AND 0.7 THEN 'Medium'
        ELSE 'High'
    END AS valence_range,
    AVG(popularity) AS avg_popularity
FROM 
    tracks
GROUP BY 
    valence_range
ORDER BY 
    avg_popularity DESC;
#the valence of the track as little to no impact on how popular the song may be
   

SELECT 
    explicit,
    AVG(popularity) AS avg_popularity,
    COUNT(*) AS track_count
FROM 
    tracks
GROUP BY 
    explicit
ORDER BY 
    avg_popularity DESC;
#There are alot more non explicit tracks then explicit tracks. and the explicit tracks have almost twice more popularity
   
   
#How Does Popularity Vary by Release Date?
#Question: Are tracks released in certain years or seasons more popular on average?
#Analysis: Group by release_date (converted to year or quarter) and calculate the average popularity of tracks by release period. Look for trends over time.  
#Dashboard Idea: Use a line chart to show popularity over time and filter by year or season. This could help artists understand when releases are most successful.
   
SELECT 
    YEAR(release_date) AS release_year,
    AVG(popularity) AS avg_popularity
FROM 
    tracks
GROUP BY 
    release_year
ORDER BY 
    avg_popularity desc;
   
#Music is mostg popular in the year 2019. and it seems like music has just gotten more popular as time went on 
#because the most popular years are 2016-2020. 2020 being the most recent date in this DB
#Maybe because of the avalibility and how accessable music is now through media

#The time when the most popular tracks came out during the 90s was the year 1993 with a popularity of 32.3969 with popular songs like "I Will Always Love You" or "Whoomp! (There It Is)"

SELECT 
    quarter(release_date) AS release_quarter,
    AVG(popularity) AS avg_popularity
FROM 
    tracks
GROUP BY 
    release_quarter
ORDER BY 
    avg_popularity desc;

#The quarters of the don't have much impact on the popularity, but quarters like the 2nd(April 1 to June 30) and 3rd(July 1 to September 30) of the year are the times when music released is most popular
#Where the 3rd(July 1 to September 30) quarter has a popularity of 33.0382 compared to the 1st(January 1 to March 31) quarter of a popularity of 27.4148
   
   
SELECT 
    quarter(release_date) AS release_quarter,
    AVG(popularity) AS avg_popularity
FROM 
    tracks
where 
	year(release_date) between '2000' and '2020'
GROUP BY 
    release_quarter
ORDER BY 
    avg_popularity desc;
    
#In recent history from 2000 to 2020 the 3rd quarter of the year is still the most popular time for popular music with 2nd quarter closely behind
   

SELECT 
    YEAR(release_date) AS release_year,
    QUARTER(release_date) AS release_quarter,
    AVG(popularity) AS avg_popularity
FROM 
    tracks
GROUP BY 
    release_year, release_quarter
ORDER BY 
    avg_popularity desc;
   
#-------------------------

SELECT 
    name AS song_name,
    artists AS artist_name,
    popularity,
    release_date
FROM 
    tracks
WHERE 
    release_date BETWEEN '2019-04-01' AND '2019-06-30'
ORDER BY 
    popularity DESC
LIMIT 10;

#The time when the tracks that had the most popularity was during April 1 to June 30 2019. at this time songs like Someone You Loved by 'Lewis Capaldi'


SELECT 
    artists AS artist_name,
    AVG(popularity) AS avg_popularity,
    QUARTER(release_date) AS release_quarter
FROM 
    tracks
WHERE 
    QUARTER(release_date) IN (2, 3)
GROUP BY 
    artist_name, release_quarter
ORDER BY 
    avg_popularity DESC
LIMIT 10;

#The artist that have produced the highest popularity rating in the 2nd and 3rd quarter has been Tate McRae, Cardi B, PopSmoke
#These are quarters where music generally sees higher popularity, as identified in your previous analysis.
#This pattern suggests that these artists may strategically release music during these quarters, aligning with times when audiences are more engaged, such as summer months.
#This diversity is particularly visible in genres associated with hip-hop, reggaeton, and pop, which align well with summer vibes and party atmospheres typical of the 2nd and 3rd quarters.


SELECT 
    FLOOR(YEAR(release_date) / 10) * 10 AS release_decade,
    AVG(popularity) AS avg_popularity
FROM 
    tracks
GROUP BY 
    release_decade
ORDER BY 
    release_decade;
   
#The data shows a gradual, almost uninterrupted rise in average popularity across each decade, reaching a peak in the 2010s and 2020s. This trend suggests that music from recent decades tends to 
#resonate more widely or is more accessible, driving higher popularity scores.
   
#This analysis shows that popularity scores have steadily increased with each decade, largely due to technological advancements and shifts in how music is consumed. 
#Recent decades see record-high popularity, likely due to streaming and global accessibility. 
#This insight underscores the importance of distribution and technology in shaping music’s reach and success.

   
#Question: Who are the top artists based on follower count and track popularity?
#Analysis: Rank artists by their total number of followers and by their average track popularity. You can calculate the average popularity across all tracks for each artist.
#Dashboard Idea: Present this as a leaderboard with interactive filtering options for follower count vs. popularity. Highlight top artists to show metrics relevant to audience engagement.

   
select 
	name as artist_name, 
	followers,
	popularity
from 
	artists 
where 
	followers is not NULL
order by 
	followers desc;
	
select 
	name as artist_name, 
	followers,
	popularity
from 
	artists 
where 
	followers is not NULL
order by 
	popularity desc;

#The data reveals a clear distinction between popularity scores and follower counts, showing that recent engagement often drives popularity more than long-term fan loyalty. 
#For instance, while Ed Sheeran has the highest follower count (78.9 million), his popularity score (92) is lower than Justin Bieber’s perfect score of 100, highlighting Bieber’s current trending status. 
#Emerging artists like Myke Towers, with a popularity of 95 but fewer followers, illustrate the impact of viral appeal, as his music resonates widely despite a smaller fanbase. 
#Collaboration also boosts popularity, as seen with Cardi B and Megan Thee Stallion, whose combined fan bases amplify reach. The data indicates that while follower counts reflect sustained fan loyalty, 
#high popularity scores reflect an artist’s recent appeal and trends, underscoring the importance of strategic releases and engagement for capturing audience interest.


SELECT 
    a.name AS artist_name,
    a.followers,
    AVG(t.popularity) AS avg_track_popularity
FROM 
    artists a
JOIN 
    tracks_cleaned t ON a.id = t.cleaned_id
GROUP BY 
    a.name, a.followers
ORDER BY 
    avg_track_popularity DESC
LIMIT 10;

#The artist that average the most popularity per song they have released. The data highlights emerging artists like Regard, ElyOtto, and Ritt Momney, 
#who have gained substantial popularity scores (around 87) despite having relatively moderate follower counts. 
#This indicates that these artists likely achieved viral or trending success, capturing audience engagement even without large, established fan bases.


SELECT 
    name AS artist_name,
    followers,
    popularity,
    popularity - (followers / 1000000) AS popularity_growth
FROM 
    artists
ORDER BY 
    popularity_growth DESC
LIMIT 10;

#This data shows the next upcoming artists or artists that are currently performing well considering there low follower count
#An example is Giveon with a follower count of 946 thousand but with a popularity rating of 91. giving him a score of 90.05345 in popularity growth


SELECT 
    a.name AS artist_name,
    COUNT(*) AS num_top_tracks,
    AVG(t.popularity) AS avg_track_popularity
FROM 
    artists a
JOIN 
    tracks_cleaned t ON a.id = t.cleaned_id
WHERE 
    t.popularity > 90
GROUP BY 
    a.name
ORDER BY 
    num_top_tracks DESC
LIMIT 10;

#Artist getting a song over the popularity of 90 is very rare and most popular artist have only done it once. But two artists that have done it twice is Ariana Grande and The Weeknd


SELECT 
    a.name AS artist_name,
    a.followers,
    AVG(t.popularity) AS avg_track_popularity
FROM 
    artists a
JOIN 
    tracks_cleaned t ON a.id = t.cleaned_id
GROUP BY 
    a.name, a.followers
HAVING 
    avg_track_popularity < 50
ORDER BY 
    followers DESC
LIMIT 10;

#This analysis highlights that while artists like Justin Bieber have high follower counts, their average track popularity score is relatively low (25.2162), suggesting that their entire catalog may not consistently engage listeners. 
#This pattern indicates that legacy or long-term popularity doesn’t always align with the current appeal of an artist’s overall discography.


#Question: What is the ideal track length (duration) for maximizing popularity?
#Analysis: Group tracks by duration ranges and calculate the average popularity for each range to determine whether shorter or longer tracks are more successful.
#Dashboard Idea: Use a histogram or box plot to display popularity across track durations, with filters to adjust the range and view results.


SELECT
    CASE
        WHEN duration_ms < 180000 THEN 'Short'  -- Less than 3 minutes
        WHEN duration_ms BETWEEN 180000 AND 240000 THEN 'Medium'  -- 3 to 4 minutes
        ELSE 'Long'  -- More than 4 minutes
    END AS duration_category,
    AVG(popularity) AS avg_popularity
FROM
    tracks
GROUP BY
    duration_category
ORDER BY
    avg_popularity DESC;
   
#Songs which have a "short"(less than 3 minutes) duration tend to be a lot less popular then songs which of the length of "Medium"(3 to 4 minutes) or "Long"(over 3 minutes).
#Long and Medium songs have an average of 29 in terms of popularity while Short songs have the average of 22 popularity

SELECT
    CASE
        WHEN duration_ms < 180000 THEN 'Short'
        WHEN duration_ms BETWEEN 180000 AND 240000 THEN 'Medium'
        ELSE 'Long'
    END AS duration_category,
    explicit,
    AVG(popularity) AS avg_popularity
FROM
    tracks
GROUP BY
    duration_category, explicit
ORDER BY
    duration_category, avg_popularity DESC;
   
#The analysis reveals a clear distinction in popularity based on track duration and whether the track is explicit. Medium-duration tracks (3-4 minutes) have the highest average popularity when they are explicit (46.61), 
#followed closely by explicit short tracks (<3 minutes, 45.65) and explicit long tracks (>4 minutes, 44.38). 
#In contrast, non-explicit tracks show significantly lower average popularity across all durations, with short non-explicit tracks being the least popular (21.39). 
#This suggests that explicit content and typical track lengths (short and medium) are associated with higher listener engagement and popularity.

SELECT
    name AS track_name,
    duration_ms,
    popularity
FROM
    tracks
WHERE
    (duration_ms BETWEEN 180000 AND 240000)  -- Adjust based on findings
ORDER BY
    popularity DESC
LIMIT 10;

#The analysis shows that the most popular tracks fall within the typical duration range of 3 to 4 minutes (180,000 to 240,000 milliseconds), with "Peaches" achieving a perfect popularity score of 100. 
#Tracks like "Save Your Tears" and "Blinding Lights" also demonstrate high popularity (97 and 96), suggesting that listeners prefer tracks of conventional length with strong engagement and wide appeal. 
#This supports the notion that optimal track duration significantly contributes to popularity.

SELECT
    CASE
        WHEN duration_ms < 180000 THEN 'Short'
        WHEN duration_ms BETWEEN 180000 AND 240000 THEN 'Medium'
        ELSE 'Long'
    END AS duration_category,
    AVG(danceability) AS avg_danceability,
    AVG(energy) AS avg_energy,
    AVG(popularity) AS avg_popularity
FROM
    tracks
GROUP BY
    duration_category
ORDER BY
    avg_popularity DESC;

#varibles like dance or energy have little to no impact on how long or short songs are.
   
#The analysis concludes that track duration significantly influences popularity, with medium-duration tracks (3-4 minutes) consistently outperforming both shorter and longer tracks in terms of average popularity. 
#Explicit content further boosts engagement, particularly for medium and long tracks, while attributes like danceability and energy show minimal correlation with track length, 
#emphasizing that duration and explicit content are the primary drivers of listener preference and engagement.
   
   
#Question: Are there artists with low follower counts but high average track popularity who might be “hidden gems”?
#Analysis: Identify artists with below-average follower counts but above-average track popularity to highlight emerging artists.
#Dashboard Idea: Create a scatter plot with follower count on one axis and average track popularity on the other. Highlight “hidden gem” artists for potential growth opportunities.

WITH Averages AS (
    SELECT 
        AVG(a.followers) AS avg_followers,
        AVG(t.popularity) AS avg_track_popularity
    FROM 
        artists a
    JOIN 
        tracks_cleaned t ON a.id = t.cleaned_id
)
SELECT 
    a.name AS artist_name,
    a.followers,
    AVG(t.popularity) AS avg_track_popularity
FROM 
    artists a
JOIN 
    tracks_cleaned t ON a.id = t.cleaned_id,
    Averages
WHERE 
    a.followers < (SELECT avg_followers FROM Averages)
GROUP BY 
    a.name, a.followers
HAVING 
    avg_track_popularity > (SELECT avg_track_popularity FROM Averages)
ORDER BY 
    avg_track_popularity DESC
LIMIT 10;

#This analysis highlights "hidden gem" artists like Regard, Ritt Momney, and ElyOtto, who, despite having relatively low follower counts (under 210,000), achieve high average track popularity scores (84-87). 
#Their ability to rival the popularity of major artists with millions of followers demonstrates their emerging appeal and potential for significant growth, as seen with Regard now reaching 11 million followers on Spotify.

SELECT 
    CASE 
        WHEN a.followers < 500000 THEN 'Low Follower'
        ELSE 'High Follower'
    END AS follower_category,
    AVG(t.popularity) AS avg_track_popularity
FROM 
    artists a
JOIN 
    tracks_cleaned t ON a.id = t.cleaned_id
GROUP BY 
    follower_category
ORDER BY 
    avg_track_popularity DESC;

#Artists with a high follower count have an average track popularity score of 38.96, 
#significantly outperforming those with a low follower count, who average 24.46, highlighting the strong correlation between an artist's established fan base and their track's overall popularity.

WITH ArtistAverages AS (
    SELECT 
        a.id AS artist_id,
        AVG(t.popularity) AS artist_avg_popularity
    FROM 
        artists a
    JOIN 
        tracks_cleaned t ON a.id = t.cleaned_id
    GROUP BY 
        a.id
)
SELECT 
    a.name AS artist_name,
    t.name AS track_name,
    t.popularity AS track_popularity,
    aa.artist_avg_popularity
FROM 
    artists a
JOIN 
    tracks_cleaned t ON a.id = t.cleaned_id
JOIN 
    ArtistAverages aa ON a.id = aa.artist_id
WHERE 
    t.popularity > aa.artist_avg_popularity + 10  -- Outlier threshold
ORDER BY 
    t.popularity DESC
LIMIT 10;

#Tracks like "drivers license" by Olivia Rodrigo and "Astronaut In The Ocean" by Masked Wolf significantly outperform their respective artist's average popularity, 
#highlighting their role as breakout hits that drive audience engagement and solidify the artist's presence in the industry.

SELECT 
    a.name AS artist_name,
    a.followers,
    AVG(t.popularity) AS recent_avg_popularity
FROM 
    artists a
JOIN 
    tracks_cleaned t ON a.id = t.cleaned_id
WHERE 
    YEAR(t.release_date) >= 2018
GROUP BY 
    a.name, a.followers
HAVING 
    a.followers < 1000000
    AND AVG(t.popularity) > 80
ORDER BY 
    recent_avg_popularity DESC
LIMIT 10;

#This analysis highlights emerging artists like Regard, ElyOtto, and Ritt Momney, who maintain high track popularity scores (84-87) despite having relatively low follower counts under 210,000, 
#showcasing their strong audience engagement and potential for future growth in the music industry.

#This analysis uncovers key insights into hidden gem artists and the relationship between follower counts and track popularity. 
#Artists like Regard, Ritt Momney, and ElyOtto demonstrate high average track popularity despite low follower counts, showcasing their potential for growth and their ability to rival major artists. 
#While artists with high follower counts generally maintain higher track popularity (38.96 vs. 24.46 for low-followers), standout tracks like Olivia Rodrigo’s "drivers license" and 
#Masked Wolf’s "Astronaut In The Ocean" significantly exceed their respective artist's averages, solidifying their role as breakout hits. 
#This emphasizes the importance of viral success and strategic engagement in elevating artists, even with a smaller fanbase.

#Overall analysis
#This comprehensive analysis highlights how factors such as track attributes, release timing, and artist dynamics influence music popularity. Danceability and energy positively correlate with track popularity, 
#while explicit content and medium-duration tracks (3-4 minutes) achieve the highest engagement. Recent years, particularly 2016-2020, saw record-breaking popularity driven by streaming accessibility 
#and strategic releases during high-engagement periods like summer. Additionally, 
#"hidden gem" artists like Regard and ElyOtto showcase significant audience appeal despite lower follower counts, 
#emphasizing the impact of viral hits and audience trends. Overall, this analysis underscores the importance of data-driven strategies in maximizing an artist's reach and success.
   
   