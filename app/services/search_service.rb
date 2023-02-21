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

  def initialize
    @agent_rutracker = Mechanize.new
    @agent_rustorka = Mechanize.new
    @agent_nwm = Mechanize.new
  end
  
  def login(value, id)
    @agent_rutracker.post(LOGIN_PAGE_RUTRACKER, login_username: ENV['LOGIN'],
                            login_password: ENV['PASSWORD'], login: 'Вход')

    # @agent_rustorka.post(LOGIN_PAGE_RUSTORKA, login_username: ENV['LOGIN'],
    #                           login_password: ENV['PASSWORD'], login: 'Вход')

    url_rutracker ||= @agent_rutracker.get(SEARCH_PAGE_RUTRACKER, nm: value)

    @agent_nwm.post(LOGIN_NWM_CLUB, username: ENV['LOGIN'],
                            password: ENV['PASSWORD'], login: 'Вход')

    # url_rustorka ||= @agent_rustorka.get(SEARCH_PAGE_RUSTORKA, nm: value)
    url_nwm ||= @agent_nwm.get(SEARCH_NWM_CLUB, nm: value)

    # return_url_pages(url_rutracker, value)
    # save_bd(return_url_pages(url, value), id)
    # save_local(url_nwm)
    # save_local(url_rutracker)
    # file = File.open("data.html", "r")
    # url = file.read
    # file.close

    save_bd_nwm(url_nwm, id)
    save_bd_rutracker(url_rutracker, id)
  end

  private

  # def save_local(url)
  #   file_name = 'data.html'
  #   url_search = url.parser
  #   doc = Nokogiri::HTML(url_search.to_s)

  #   file = File.open(file_name, 'w') do |file|
  #     file.write(doc)
  #   end
  # end

  def return_url_pages(url, value)
    url_search = url.parser
    doc = Nokogiri::HTML(url_search.to_s)
    links = doc.css('a.pg')

    if links.empty?
      url = ["#{SEARCH_PAGE_RUTRACKER}?nm=#{value}"]
    else
      search_ids = links.map { |link| link.attribute('href').value.match(/search_id=([^&]+)/)[1] }

      search_ids.map.with_index do |id, index|
        start = index * 50
        "#{SEARCH_PAGE_RUTRACKER}?search_id=#{id}&start=#{start}&nm=#{value}"
      end
    end
  end

  def save_bd_rutracker(url_search, id)
    # url_search.each do |parse|
    #   url ||= @agent_rutracker.get(parse)
      url = url_search.parser
      doc = Nokogiri::HTML(url.to_s)

      doc.css('tr.tCenter.hl-tr').each do |td|
        name = td.at_css('div.t-title').text
        link_forum = td.at_css('div.t-title').at_css('a').attributes['href'].value
        link_present = td.at_css('td.tor-size a')
        link = link_present.attributes['href'].value if link_present.present?
        lychee = td.at_css('td.row4.leechmed.bold').text || 0
        seeds = td.at_css('td b.seedmed') ? td.at_css('td b.seedmed').text : 0
        hd_present = td.at_css('td.tor-size a')
        hd = hd_present.text || "0" if hd_present.present?

        TorrentLink.find_or_create_by(search_id: id,
                                      name:,
                                      link_forum: "https://rutracker.org/forum/#{link_forum}",
                                      link: "https://rutracker.org/forum/#{link}",
                                      seeds:,
                                      lychee:,
                                      hd:)
      end
    # end
  end

  def save_bd_nwm(url_search, id)
      url = url_search.parser
      doc = Nokogiri::HTML(url.to_s)

      doc.css('tr.prow1, tr.prow2').each do |td|
        name =  td.at_css("a.genmed").text
        link_forum = td.at_css("a.genmed").attributes["href"].value
        link = td.css("a")[3].attributes["href"].value

        seed = td.at_css("td.seedmed").text

        lychee = td.at_css("td.leechmed").children.text
        hd = td.at_css("td.gensmall").children[2].text.strip

        TorrentLink.find_or_create_by(search_id: id,
          name:,
          link_forum: "https://nnmclub.to/forum/#{link_forum}",
          link: "https://nnmclub.to/forum/#{link}",
          seeds: seed,
          lychee: lychee,
          hd:)
      end
  end
end
