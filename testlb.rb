require "net/http"
require "uri"
require 'optparse'
require 'pp'


hash_options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: your_app [options]"
  opts.on('-u', '--hostname', "Specify the name of the host") do |v|
    hash_options[:hostname] = v
  end
  opts.on('-n', '--requests', "Specify the numbeer of requests") do |v|
    hash_options[:numberOfRequests] = v
  end
  opts.on('-v', '--version', 'Display the version') do
    puts "VERSION 1"
    exit
  end
  opts.on('-h', '--help', 'Display this help') do
    puts opts
    exit
  end
end.parse!


_uri = hash_options[:argument_a]


#obvious pitfall that first argument should always be hostname
if hash_options[:hostname]
  _uri = ARGV[0]
  uri = URI.parse("http://"+_uri)
end

if hash_options[:numberOfRequests]
  numberOfRequests = Integer(ARGV[1])
end

@response_hash = Hash.new(0)
(0..numberOfRequests-1).each do |i|
# Full
  http = Net::HTTP.new(uri.host, uri.port)
  response = http.request(Net::HTTP::Get.new(uri.request_uri))
  #Read the response header and update the response_hash
  @response_hash[response["X-Backend-Server"]] += 1
end

@response_hash.each do |key, value|
  puts "#{key}  #{value}"

end
