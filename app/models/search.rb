class Search < ApplicationRecord
  has_many :torrent_links, dependent: :delete_all

  before_save { query.downcase! }
  after_save :search_service

  validates :query, presence: true

  def search_service
    search = SearchService.new
    # search.save_test(self.id)
    search.login(self.query, self.id)
  end
end
