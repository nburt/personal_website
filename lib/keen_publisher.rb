class KeenPublisher

  def initialize(event, data)
    @event = event
    @data = data
  end

  def delete(event)
    Keen.delete(event)
  end

  def count(event)
    Keen.count(event)
  end

  def publish
    Keen.publish(@event, @data)
  end

end