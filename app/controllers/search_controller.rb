class SearchController < ApplicationController
  def root
  end

  def search
    query = params[:query]
    @searches = SearchService.new.search_rutracker(query)
    @searches_nwm = SearchService.new.search_nwm(query)
  end
end
