require 'nokogiri'
require 'open-uri'

module Yelper

keyword = ARGV[0].gsub(' ', '+')
location = ARGV[1].gsub(' ', '+')

	class Crawler

		attr_reader :doc
		UA = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.75.14 (KHTML, like Gecko) Version/7.0.3 Safari/537.75.14"

		def initialize(keyworld, location)
			url = "http://www.yelp.com/search?find_desc=#{keyword}&find_loc=#{location}%2C+CA&ns=1"
			@doc = Nokogiri::HTML(open("#{url}", "User-Agent" => "#{UA}"))
		end

		def build_data
			total = @doc.xpath("//span[@class = 'pagination-results-window']").collect do |node|
				node.text.strip.split('of')[1].strip
			end
			total = total[0].to_str if total.length == 1

			name = @doc.xpath("//div[@class = 'media-story']/h3[@class = 'search-result-title']/span[@class = 'indexed-biz-name']/a").collect do |node|
				node.text.strip
			end

			review = @doc.xpath("//span[@class = 'review-count rating-qualifier']").collect do |node|
				node.text.strip
			end

			star = @doc.xpath("//div[@class = 'rating-large']/i[@class]").collect do |node|
				node.attr("class")
			end

			star = star.map { |attr| attr.split[1] }

			price = @doc.xpath("//span[@class = 'business-attribute price-range']").collect do |node|
				node.text.strip
			end

			address = @doc.xpath("//address").collect do |node|
				node.text.strip
			end

			ret = name.zip review, star, price, address

			return ret
		end

	end

end
