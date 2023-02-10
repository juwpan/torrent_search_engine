class Search < ApplicationRecord
  has_many :torrent_links, dependent: :delete_all

  before_save { query.downcase! }
  after_save :search_service

  validates :query, presence: true

  def search_service
    SearchService.new.login(query, id)
  end
end
