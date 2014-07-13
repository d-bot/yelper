module Yelper

	class Pop

		attr_reader :restaurants, :stars, :reviews, :hot_venue

		def initialize(restaurants, stars, reviews)
			@restaurants = restaurants
			@stars = stars
			@reviews = reviews
			@hot_venue = []
		end

		def filter

			@restaurants.each do |page|
				page.each do |venue|
					review = venue[1].to_s.split(' ')[0].to_i
					star = venue[2].to_s.split('_')[1].to_i
					if review > @reviews and star > @stars
						@hot_venue << venue
					end
				end
			end

			return @hot_venue

		end
	end
end
