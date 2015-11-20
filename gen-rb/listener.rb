require 'thrift'
require_relative 'pub_sub_consumer'
require_relative 'consumer_handler'

port = 9091 || ARGV[0]

listen_handler = ConsumerHandler.new
listen_processor = Concord::PubSub::PubSubConsumer::Processor.new listen_handler
listen_transport = Thrift::ServerSocket.new(port)
listen_transportFactory = Thrift::BufferedTransportFactory.new()
server = Thrift::SimpleServer.new(listen_processor, listen_transport, listen_transportFactory)
puts "Starting the server..."
server.serve()
