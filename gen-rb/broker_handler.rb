require 'thrift'
require_relative 'pub_sub_consumer'
require_relative 'pub_sub_broker'
require_relative 'consumer_handler'
require_relative 'broker_handler'

class BrokerHandler
  # stores the hosts and ports that have registered for each topic
  @topic_hash
  def initialize()
    @topic_hash = Hash.new nil
  end
  # add host and port to a topic
  def subscribe(topic, host, port)
    @topic_hash[topic] = Set.new unless @topic_hash[topic]
    @topic_hash[topic] = @topic_hash[topic].add [host, port]

    puts "#{host}: #{port} subscribes to #{topic}"
  end
  # remove host and port from a topic
  def unsubscribe(topic, host, port)
    @topic_hash[topic] = @topic_hash[topic].delete [host, port]
    puts "#{host}: #{port} unsubscribes from #{topic}"
  end
  # sends the topic and message to each subscriber
  def publish(topic, message)
    unless @topic_hash[topic] == nil
      @topic_hash[topic].each do |arr|
        host = arr[0]
        port = arr[1]
        transport = Thrift::BufferedTransport.new(Thrift::Socket.new(host, port))
      	protocol = Thrift::BinaryProtocol.new(transport)
      	client = Concord::PubSub::PubSubConsumer::Client.new(protocol)
      	transport.open()
      	client.receive topic,message
      	transport.close()
        puts "publish to #{arr}"
      end
    else
      puts "No subscribers for #{topic}"
    end
  end
end
