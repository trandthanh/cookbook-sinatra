require 'open-uri'
require 'nokogiri'
require_relative('recipe')

class ScrapingService
  def initialize(keyword)
    @keyword = keyword
  end

  def search(url)
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)
    return html_doc
  end

  def call
    url = "https://www.marmiton.org/recettes/recherche.aspx?aqt=#{@keyword}"

    results = []

    search(url).search('.recipe-card-link').first(5).each do |element|
      name = element.search('h4').text.strip
      description = element.search('.recipe-card__description').text.strip
      prep_time = element.search('.recipe-card__duration__value').text.strip

      link = "https://www.marmiton.org#{element.attribute('href').value}"
      difficulty = search(link).search('.recipe-infos__level .recipe-infos__item-title').first.text.strip

      results << Recipe.new(name: name, description: description, prep_time: prep_time, difficulty: difficulty)
    end

    return results
  end
end

# ScrapingService.new("fraise").call
