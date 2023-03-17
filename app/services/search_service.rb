class SearchService
  require 'nokogiri'
  require 'open-uri'
  require 'rubygems'
  require 'mechanize'
  require 'json'

  LOGIN_PAGE_RUTRACKER = 'https://rutracker.org/forum/login.php'.freeze
  LOGIN_PAGE_RUSTORKA = 'http://rustorka.com/forum/login.php'.freeze
  LOGIN_NWM_CLUB = 'https://nnmclub.to/forum/login.php'.freeze

  SEARCH_PAGE_RUTRACKER = 'https://rutracker.org/forum/tracker.php'.freeze
  SEARCH_PAGE_RUSTORKA = 'http://rustorka.com/forum/tracker.php'.freeze
  SEARCH_NWM_CLUB = 'https://nnmclub.to/forum/tracker.php'.freeze

  def initialize(agent = Mechanize.new)
    @agent = agent
  end

  def search_rutracker(value, sort)
    results ||= Rails.cache.fetch("rutracker_search_#{value}", expires_in: 5.hour) do
      login_rutracker(value, sort)
    end
  end

  def search_nwm(value, sort)
    results ||= Rails.cache.fetch("nwm_search_#{value}", expires_in: 1.hour) do
      login_nwm(value, sort)
    end
  end

  private

  def login_rutracker(value, sort)
    @agent.post(LOGIN_PAGE_RUTRACKER, login_username: Rails.application.credentials.dig(:tracker, :LOGIN),
                                      login_password: Rails.application.credentials.dig(:tracker, :PASSWORD), login: 'Вход')
    url_rutracker ||= @agent.get(SEARCH_PAGE_RUTRACKER, nm: value)

    result_rutracker(url_rutracker, sort)
  end

  def login_nwm(value, sort)
    begin
      @agent.post(LOGIN_NWM_CLUB, username: Rails.application.credentials.dig(:tracker, :LOGIN),
                                password: Rails.application.credentials.dig(:tracker, :PASSWORD), login: 'Вход')

      url_nwm ||= @agent.get(SEARCH_NWM_CLUB, nm: value)
      result_nwm(url_nwm, sort)
    rescue StandardError => e
      puts "Unknown error: #{e.message}"
    end
  end

  def result_rutracker(url_search, sort)
    url = url_search.parser
    doc = Nokogiri::HTML(url.to_s)

    results = []
    
    doc.css('tr.tCenter.hl-tr').each do |td|
      name = td.at_css('div.t-title').text
      link_forum = td.at_css('div.t-title').at_css('a').attributes['href'].value
      link_present = td.at_css('td.tor-size a')
      link = link_present.attributes['href'].value if link_present.present?
      lychee = td.at_css('td.row4.leechmed.bold').text || 0
      seeds = td.at_css('td b.seedmed') ? td.at_css('td b.seedmed').text : 0
      hd_present = td.at_css('td.tor-size a')
      hd = hd_present.text || '0' if hd_present.present?

      results << {
        name: name,
        link_forum: "https://rutracker.org/forum/#{link_forum}",
        link: "https://rutracker.org/forum/#{link}",
        seeds: seeds,
        lychee: lychee,
        hd: hd
      }
    end

    if sort == "seeds"
      results.sort_by! { |result| -result[:seeds].to_i }
    else
      results.shuffle
    end
  end

  def result_nwm(url_search, sort)
    url = url_search.parser
    doc = Nokogiri::HTML(url.to_s)

    results = []

    doc.css('tr.prow1, tr.prow2').each do |td|
      name = td.at_css('a.genmed').text
      link_forum = td.at_css('a.genmed').attributes['href'].value
      link = td.css('a')[3].attributes['href'].value
      seed = td.at_css('td.seedmed').text
      lychee = td.at_css('td.leechmed').children.text
      hd = td.at_css('td.gensmall').children[2].text.strip

      results << {
        name: name,
        link_forum: "https://nnmclub.to/forum/#{link_forum}",
        link: "https://nnmclub.to/forum/#{link}",
        seeds: seed,
        lychee: lychee,
        hd: hd
      }
    end

    if sort == "seeds"
      results.sort_by! { |result| -result[:seeds].to_i }
    else
      results.shuffle
    end
  end
end
