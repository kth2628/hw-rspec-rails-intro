class Movie < ActiveRecord::Base
  def self.all_ratings
    %w[G PG PG-13 R]
  end

  def self.with_ratings(ratings, sort_by)
    if ratings.nil?
      all.order sort_by
    else
      where(rating: ratings.map(&:upcase)).order sort_by
    end
  end

  def self.find_in_tmdb(search_terms)
    url = "https://api.themoviedb.org/3/search/movie?query=#{search_terms}&api_key=FAKE_KEY"
    response = Faraday.get(url)
    json = JSON.parse(response.body)
    movies = json["results"].map do |result|
      Movie.new(title: result["title"], release_date: result["release_date"] || nil, rating: "R")
    end
    movies
  end
end
