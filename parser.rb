require 'sinatra'
require 'bundler'
require 'json'
require 'open-uri'

Bundler.require
COMMON_URL="http://www.google.com"
URL="http://www.google.com/movies?near=pune&sort=1&start="
MOVIES_URL = "http://www.google.com/movies?near="

not_found do
  error_hash = {:error => "No such method found.Please refer documentation"}
  return error_hash.to_hash
end

get '/movies?' do
 error_hash = {}
 start = params[:start]
 near = params[:near]
 showtimings = params[:showtimings]
 
 if(near == nil)
  error_hash = {:error => "Near attribute is compulsory"}
  return error_hash.to_hash
 end


 if (start == nil)
   start = 0
 end

 if( start.to_i < 0 || start.to_i % 10 != 0 )
  error_hash = {:error => "start attribute cannot be negative and has to be a multiple of 10"}
  return error_hash.to_hash
 end

 if( showtimings == nil )
   showtimings = 0
 end

 if (showtimings == "false" || (showtimings !="true" && showtimings.to_i == 0))
   showtimings = false
 elsif (showtimings =="true" || showtimings.to_i == 1)
   showtimings = true
 else
   error_hash = {:error => "only 0 and 1 are allowed for showtimings"}
   return error_hash.to_json
 end

 if (start == 0)
   search_url = MOVIES_URL + near + "&sort=1"
 else
   search_url = MOVIES_URL + near + "&sort=1" +"&start="+start.to_s
 end 

 movie_links = Array.new
 doc = Nokogiri::HTML(open(search_url))
 movies_hash={:movies => []}

 movies = doc.css(".movie")  
 if movies.size == 0 
   error_hash = {:error => "Data not available for specified location"}
   return error_hash.to_json
 end
 movies.each do |movie|
   movie_hash = {
     :movie_name =>"",
     :actors => [],
     :theaters => {:theater => []}
   }
   parse_movie_result(movie,movie_hash , showtimings)
   movies_hash[:movies] << movie_hash
 end
 
 movies_hash.to_json

end

def parse_movie_result(movie_result, movie_hash , showtimings)
  movie_name = movie_result.css("h2[itemprop=name]").text
  movie_hash[:movie_name] = movie_name
   
  actors_array = Array.new 
  actors = movie_result.css("span[itemprop=actors]")
  actors.each do |actor|
    actors_array << actor.text 
  end
  movie_hash[:actors] = actors_array
  
  return movie_hash if showtimings == false
  
  
  theaters = movie_result.css(".theater")

  theaters.each do |theater|    
    theater_hash = {}
    name_of_theater = theater.css('a').text
    theater_hash[:theater_name] = name_of_theater

    show_times = theater.css('.times').css("span")    
    show_times_array = Array.new
    show_times.each do |show_time|
      spaces_removed = show_time.text.rstrip
      spaces_removed = spaces_removed.lstrip
      
      if (spaces_removed["&nbsp"] != nil  && spaces_removed.length!=6)
        spaces_removed = spaces_removed[5..-1]
        show_times_array << spaces_removed  
      else
        if(spaces_removed["&nbsp"] == nil && spaces_removed.length != 1)
          show_times_array << spaces_removed  
        end
      end
      
    end
    theater_hash[:showtimes] = show_times_array
    movie_hash[:theaters][:theater] << theater_hash 
  end
end
