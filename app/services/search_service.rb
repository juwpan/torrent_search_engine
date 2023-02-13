class SearchService
  require 'nokogiri'
  require 'open-uri'
  require 'rubygems'
  require 'mechanize'
  require 'json'

  LOGIN_PAGE = 'https://rutracker.org/forum/login.php'.freeze
  SEARCH_PAGE = 'https://rutracker.org/forum/tracker.php'.freeze

  def initialize
    @agent = Mechanize.new
  end

  def login(value, id)
    @agent.post(LOGIN_PAGE, login_username: 'test_forg',
                            login_password: 'dedede', login: 'Вход')

    url ||= @agent.get(SEARCH_PAGE, nm: value)

    return_url_pages(url, value)
    save_bd(return_url_pages(url, value), id)
  end

  private

  def return_url_pages(url, value)
    url_search = url.parser
    doc = Nokogiri::HTML(url_search.to_s)
    links = doc.css('a.pg')

    if links.empty?
      url = ["#{SEARCH_PAGE}?nm=#{value}"]
    else
      search_ids = links.map { |link| link.attribute('href').value.match(/search_id=([^&]+)/)[1] }

      search_ids.map.with_index do |id, index|
        start = index * 50
        "#{SEARCH_PAGE}?search_id=#{id}&start=#{start}&nm=#{value}"
      end
    end
  end

  def save_bd(url_search, id)
    url_search.each do |parse|
      url ||= @agent.get(parse)
      url_search = url.parser
      doc = Nokogiri::HTML(url_search.to_s)

      doc.css('tr.tCenter.hl-tr').each do |td|
        name = td.at_css('div.t-title').text
        link_forum = td.at_css('div.t-title').at_css('a').attributes['href'].value
        link_present = td.at_css('td.tor-size a')
        link = link_present.attributes['href'].value if link_present.present?
        lychees = td.at_css('td.row4.leechmed.bold').text || 0
        seeds = td.at_css('td b.seedmed') ? td.at_css('td b.seedmed').text : 0
        hd_present = td.at_css('td.tor-size a')
        hd = hd_present.text || "0" if hd_present.present?

        TorrentLink.find_or_create_by(search_id: id,
                                      name:,
                                      link_forum: "https://rutracker.org/forum/#{link_forum}",
                                      link: "https://rutracker.org/forum/#{link}",
                                      seeds:,
                                      lychee: lychees,
                                      hd:)
      end
    end
  end
end
