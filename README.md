nowPlaying
==========

nowPlaying API was conceived to provide currently playing movies along with showtimings and theatres for 
a specified location.I could achieve this by screen scraping the Google Movies page. But I have to stall
work on this because I learnt that this is against Google's Policies.Nevertheless,you can find a minimalistic
working version of this api on Heroku.

Below are the usage examples

1)nowPlaying.herokuapp.com/movies?near=Pune&start=10&showtimings=1
  - This will return json response containing movie names, casts, and the nearby theaters playing them
  - near attribute is compulsory
  - start attribute can either be 0 or any multiples of 10.
  - start=0 signifies the first page containing 10 results.start=10 will mean that you requested for the second page
    of results containing 10 entries
  - showtimings can be 0 or 1. '0' indicates "dont include theatre and showtimings" whereas '1' indicates 'include theatres and showtimings'
  - The list of theatres returned isnt exhaustive. It contains only the major theatres in the city.
  
2)nowPlaying.herokuapp.com/movies?near=Pune&showtimings=1
  - This will return the first page of results containing 10 entries 
  - If data is not available for the movies, a hash with key as error and values as "Data not available for specified location" is returned


