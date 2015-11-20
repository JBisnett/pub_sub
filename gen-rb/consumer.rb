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
		if /\Abroker:\s?(\w*),\s?(\d*)/ =~ line
			transport.close if transport
			$broker_host = $~[1]
			$broker_port = $~[2].to_i
			transport = Thrift::BufferedTransport.new(Thrift::Socket.new($broker_host, $broker_port))
			protocol = Thrift::BinaryProtocol.new(transport)
			$client = Concord::PubSub::PubSubBroker::Client.new(protocol)
			transport.open()
		elsif /\Alocal:\s?(\w*),\s?(\d*)/ =~ line
			$local_host = $~[1]
			$local_port = $~[2].to_i
		elsif /\Asub,\s?(\w*)/ =~ line
			$client.subscribe $~[1], $local_host, $local_port
		elsif /\Aunsub,\s?(\w*)/ =~ line
			$client.unsubscribe $~[1], $local_host, $local_port
		elsif /\Apub,\s?(\w*),\s?(\w*)/ =~ line
			$client.publish $~[1], $~[2]
		else
			puts "Invalid Input"
		end
	end
	transport.close if transport

rescue
	puts $!, $!.message
end
