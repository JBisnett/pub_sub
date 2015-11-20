# include thrift-generated code
$:.push('../gen-rb')

require 'thrift'
require_relative 'pub_sub_consumer'
require_relative 'pub_sub_broker'
require_relative 'consumer_handler'
require_relative 'broker_handler'

begin
	broker_host = 'localhost' || ARGV.shift
	broker_port = 9090 || ARGV.shift

	transport = Thrift::BufferedTransport.new(Thrift::Socket.new(broker_host, broker_port))
	protocol = Thrift::BinaryProtocol.new(transport)
	client = Concord::PubSub::PubSubBroker::Client.new(protocol)

	transport.open()

	ARGF.readlines.each do |line|
		if /sub,\s?(\w*),\s?(\w*),\s?(\d*)/ =~ line
			client.subscribe $~[1], $~[2], $~[3].to_i
		elsif /unsub,\s?(\w*),\s?(\w*),\s?(\d*)/ =~ line
			client.unsubscribe $~[1], $~[2], $~[3].to_i
		elsif /pub,\s?(\w*),\s?(\w*)/ =~ line
			client.publish $~[1], $~[2]
		else
			puts "Invalid Input"
		end
	end
	transport.close()

rescue
	puts $!, $!.message
end
