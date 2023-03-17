class SearchController < ApplicationController
  def root
  end

  def search
    query = params[:query]
    sort = params[:sort]

    @searches = SearchService.new.search_rutracker(query, sort)
    @searches_nwm = SearchService.new.search_nwm(query, sort)

    @results = (@searches + @searches_nwm).paginate(page: params[:page], per_page: 100)
  end
end
