#!/urs/bin/env ruby

lib = File.expand_path(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift(lib) if File.directory?(lib) && !$LOAD_PATH.include?(lib)

require 'yelper'
require 'optparse'

options = {}

OptionParser.new do |opts|
	opts.banner = "Usage: yelper [options]"

	opts.on('-c', '--crawler', 'Display Crawler') do
		Yelper::Crawler.test
	end

	opts.on('-v', '--version', 'Display version') do
		puts Yelper::VERSION
	end

	opts.on('-h', '--help', 'Display this screen') do
		puts opts
		exit
	end

end.parse!
