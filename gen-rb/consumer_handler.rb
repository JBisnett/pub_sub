class ConsumerHandler
  def initialize()
    # unused
  end
  def receive topic, message
		puts "#{topic}: #{message}"
  end
end
