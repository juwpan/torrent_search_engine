class SearchController < ApplicationController
  before_action :set_search, only: [:show]
  before_action :set_search_params, only: [:create]

  def new
    @search = Search.new(params[:query])
  end
  
  def create
    if @search_value.present?
      redirect_to search_path(@search_value.first.id)
    else
      @search = Search.create_or_find_by(params_search)
      if @search.save
        redirect_to search_path(@search)
      else
        render :new
      end
    end
  end

  def show
    @searches = @search.torrent_links.paginate(page: params[:page], per_page: 30)
  end

  def index
    # @searches = Search.joins(:torrent_links).select("torrent_links.*").paginate(page: params[:page], per_page: 30)
  end

  private

  def set_search_params
    @search_value = Search.where("query = ?", (params[:search][:query]).downcase)
  end

  def set_search
    @search = Search.find(params[:id])
  end

  def params_search
    params.require(:search).permit(:query)
  end
end
