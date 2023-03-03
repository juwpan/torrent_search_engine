class Search < ApplicationRecord
  has_many :torrent_links, dependent: :delete_all

  before_save { query.downcase! }
  after_save :search_service_rutracker
  after_save :search_service_nwm

  validates :query, presence: true


  def search_service_rutracker
    SearchService.new.login_rutracker(query, id)
  end
  
  def search_service_nwm
    SearchService.new.login_nwm(query, id)
  end
end
