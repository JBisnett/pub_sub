
$:.push('../gen-rb')

require 'thrift'
require_relative 'pub_sub_broker'
require_relative 'broker_handler'

port = 9090 || ARGV[0]

handler = BrokerHandler.new
processor = Concord::PubSub::PubSubBroker::Processor.new handler
transport = Thrift::ServerSocket.new(port)
transportFactory = Thrift::BufferedTransportFactory.new()
server = Thrift::SimpleServer.new(processor, transport, transportFactory)

puts "Starting the server..."

server.serve()

puts "done."
