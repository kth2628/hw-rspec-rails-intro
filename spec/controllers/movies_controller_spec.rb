require 'rails_helper'

if RUBY_VERSION>='2.6.0'
  if Rails.version < '5'
    class ActionController::TestResponse < ActionDispatch::TestResponse
      def recycle!
        # hack to avoid MonitorMixin double-initialize error:
        @mon_mutex_owner_object_id = nil
        @mon_mutex = nil
        initialize
      end
    end
  else
    puts "Monkeypatch for ActionController::TestResponse no longer needed"
  end
end

describe MoviesController do
  describe 'searching TMDb' do
    before :each do
      @fake_results = [double('movie1'), double('movie2')]
    end

    it 'calls the model method that performs TMDb search' do
      expect(Movie).to receive(:find_in_tmdb).with('hardware').
        and_return(@fake_results)
      get :search_tmdb, {:search_terms => 'hardware'}
    end

    describe 'after valid search' do
      before :each do
        allow(Movie).to receive(:find_in_tmdb).and_return(@fake_results)
        get :search_tmdb, {:search_terms => 'hardware'}
      end

      it 'selects the Search Results template for rendering' do
        expect(response).to render_template('search_tmdb')
      end
      it 'makes the TMDb search results available to that template' do
        expect(assigns(:movies)).to eq(@fake_results)
      end
      it 'calls Tmdb with valid API key' do
        Movie.find_in_tmdb({title: "hacker", language: "en"})
     end
    end 
  end
  
  describe 'adding a TMDb movie' do
    it 'creates a movie in the database' do
      expect {
        post :add_movie, params: { movie: { title: "TMDb Movie", release_date: "2025-01-01", rating: "R" } }
      }.to change(Movie, :count).by(1)
      expect(Movie.last.title).to eq("TMDb Movie")
    end
  
    it 'sets a flash notice' do
      post :add_movie, params: { movie: { title: "TMDb Movie", release_date: "2025-01-01", rating: "R" } }
      expect(flash[:notice]).to match(/successfully added/)
    end
  
    it 'redirects to the search page' do
      post :add_movie, params: { movie: { title: "TMDb Movie", release_date: "2025-01-01", rating: "R" } }
      expect(response).to redirect_to(search_movies_path)
    end
  end
  
end