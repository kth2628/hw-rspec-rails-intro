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
    it 'calls the model method that performs TMDb search' do
      fake_results = [double('movie1'), double('movie2')]
      expect(Movie).to receive(:find_in_tmdb).with('hardware').
        and_return(fake_results)
      get :search_tmdb, {:search_terms => 'hardware'}
    end
    it 'selects the Search Results template for rendering' do
    end
    it 'makes the TMDb search results available to that template' do
    end 
  end
end