require 'rails_helper'
require 'spec_helper'

describe Movie do
  describe 'searching Tmdb by keyword' do
    it 'calls Faraday gem' do
      fake_json = {
        "results" => [
          { "title" => "Hardware", "release_date" => "1990-01-01" },
          { "title" => "Hardware 2", "release_date" => "1995-05-05" }
        ]
      }
    
      fake_response = double('response', body: JSON.generate(fake_json))
      expect(Faraday).to receive(:get).and_return(fake_response)
    
      movies = Movie.find_in_tmdb(title: 'hardware', language: 'en')
      expect(movies.length).to eq(2)
      expect(movies.first.title).to eq('Hardware')
    end    
  end
end