
$:.push('../gen-rb')

require 'thrift'
require_relative 'pub_sub_broker'
require_relative 'broker_handler'

if ARGV[0]
  port = ARGV[0].to_i
else
  port = 9090
end

handler = BrokerHandler.new
processor = Concord::PubSub::PubSubBroker::Processor.new handler
transport = Thrift::ServerSocket.new(port)
transportFactory = Thrift::BufferedTransportFactory.new()
server = Thrift::SimpleServer.new(processor, transport, transportFactory)

puts "Broker on port #{port}"

server.serve()

puts "done."
