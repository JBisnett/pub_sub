class ConsumerHandler
  def initialize()
    # nothing
  end
  def receive topic, message
		puts "#{topic}: #{message}"
  end
end
