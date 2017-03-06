require 'HTTParty'
require 'Nokogiri'
require 'csv'

class Scraper
  attr_accessor :parse_page

  def initialize
    doc = HTTParty.get("http://store.nike.com/us/en_us/pw/womens-nikeid-basketball-shoes/7ptZoolZ8r1Zoi3")
    @parse_page ||= Nokogiri::HTML(doc)
  end

  def get_names
    item_container.css(".product-display-name").css("p").children.map { |name| name.text }.compact
  end

  def get_prices
    item_container.css(".product-price").css("span.local").children.map { |price| price.text }.compact
  end

  private

  def item_container
    parse_page.css(".grid-item-info")
  end

  shoes = []
  scraper = Scraper.new
  names = scraper.get_names
  prices = scraper.get_prices

  (0...prices.size).each do |index|
    puts "- - - Shoe: #{index + 1} - - - "
    puts "Name: #{names[index]} | Price: #{prices[index]}"
    shoes.push("Name: #{names[index]} | Price: #{prices[index]}")
  end

  CSV.open('shoes.csv', 'w') do |csv|
    csv << shoes
  end
end
