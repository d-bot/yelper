require 'nokogiri'
require 'open-uri'

module Yelper

	class Crawler

		attr_reader :doc, :url, :keyword, :location, :result
		UA = "mozilla/5.0 (macintosh; intel mac os x 10_9_2) applewebkit/537.75.14 (khtml, like gecko) version/7.0.3 safari/537.75.14"

		def initialize(keyword, location)
			@keyword = keyword
			@location = location
			@result = []
			@url = "http://www.yelp.com/search?find_desc=#{@keyword}&find_loc=#{@location}%2c+ca&ns=1"
			@doc = Nokogiri::HTML(open("#{@url}", "user-agent" => "#{UA}"))
		end

		def start

			total = @doc.xpath("//span[@class = 'pagination-results-window']").collect do |node|
				node.text.strip.split('of')[1].strip
			end

			tot = total[0].to_i if total.length == 1

			(tot / 10 + 1).times do |i|
			#3.times do |i|

				i *= 10
				url = @url + "&start=#{i}"
				#url = "http://www.yelp.com/search?find_desc=#{@keyword}&find_loc=#{@location}%2c+ca&ns=1&start=#{i}"
				@doc = Nokogiri::HTML(open("#{url}", "user-agent" => "#{UA}"))

				scrape
			end

			return @result
		end

		def scrape
			name = @doc.xpath("//div[@class = 'media-story']/h3[@class = 'search-result-title']/span[@class = 'indexed-biz-name']/a").collect do |node|
				node.text.strip
			end

			review = @doc.xpath("//span[@class = 'review-count rating-qualifier']").collect do |node|
				node.text.strip
			end

			star = @doc.xpath("//div[@class = 'rating-large']/i[@class]").collect { |node| node.attr("class") }
			star = star.map { |attr| attr.split[1] }
			price = @doc.xpath("//span[@class = 'business-attribute price-range']").collect do |node|
				node.text.strip
			end
			address = @doc.xpath("//address").collect { |node| node.text.strip }

			ret =  name.zip review, star, price, address
			@result << ret
		end

	end
end
