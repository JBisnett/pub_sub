# include thrift-generated code
$:.push('../gen-rb')

require 'thrift'
require_relative 'pub_sub_consumer'
require_relative 'pub_sub_broker'
require_relative 'consumer_handler'
require_relative 'broker_handler'

begin
	#read possible input
	transport = nil
	$client = nil
	$broker_host = nil
	$broker_port = nil
	$local_host = nil
	$local_port = nil
	ARGF.readlines.each do |line|
		case line
		when /\Abroker:\s?(\w*),\s?(\d*)/
			transport.close if transport
			$broker_host = $~[1]
			$broker_port = $~[2].to_i
			transport = Thrift::BufferedTransport.new(Thrift::Socket.new($broker_host, $broker_port))
			protocol = Thrift::BinaryProtocol.new(transport)
			$client = Concord::PubSub::PubSubBroker::Client.new(protocol)
			transport.open()
		when /\Alocal:\s?(\w*),\s?(\d*)/
			$local_host = $~[1]
			$local_port = $~[2].to_i
		when /\Asub,\s?(\w*)/
			$client.subscribe $~[1], $local_host, $local_port
		when /\Aunsub,\s?(\w*)/
			$client.unsubscribe $~[1], $local_host, $local_port
		when /\Apub,\s?(\w*),\s?(\w*)/
			$client.publish $~[1], $~[2]
		when /\A\s*\Z/
			next
		else
			puts "Invalid input: #{line}" 
		end
	end
	transport.close if transport

rescue
	puts $!, $!.message
end
