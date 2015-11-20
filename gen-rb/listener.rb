$:.push('../gen-rb')
require 'thrift'
require_relative 'pub_sub_consumer'
require_relative 'pub_sub_broker'
require_relative 'consumer_handler'
require_relative 'broker_handler'
$listen_host = ARGV.shift
$listen_port = ARGV.shift.to_i
$broker_host = ARGV.shift
$broker_port = ARGV.shift.to_i
puts "Listening on port #{$listen_port}, hosting from #{$listen_host}"
puts "starting server"
Thread.new do
  listen_handler = ConsumerHandler.new
  listen_processor = Concord::PubSub::PubSubConsumer::Processor.new listen_handler
  listen_transport = Thrift::ServerSocket.new($listen_port)
  listen_transportFactory = Thrift::BufferedTransportFactory.new()
  server = Thrift::SimpleServer.new(listen_processor, listen_transport, listen_transportFactory)
  server.serve()
  puts "ending server"
end

# begin
	#read possible input
puts "Writing to host #{$broker_host} at port #{$broker_port}"
transport = Thrift::BufferedTransport.new(Thrift::Socket.new($broker_host, $broker_port))
protocol = Thrift::BinaryProtocol.new(transport)
$client = Concord::PubSub::PubSubBroker::Client.new(protocol)


STDIN.each_line do |line|
  transport.open
	case line
	when /\Asubscribe\s(\w*)/
		$client.subscribe $~[1], $listen_host, $listen_port
	when /\Aunsubscribe\s(\w*)/
		$client.unsubscribe $~[1], $listen_host, $listen_port
	when /\Apublish\s(\w*),\s?(\w*)/
		$client.publish $~[1], $~[2]
	else
		puts "Invalid input: #{line}"
	end
  transport.close
end


puts "over"
