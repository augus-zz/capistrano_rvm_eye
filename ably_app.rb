require 'ably'
require './boot'

EventMachine.run do
  ably = Ably::Realtime.new(key: $setting['ably_api_key'])
  channel = ably.channels.get("#{$setting['ably_channel']}")
  channel.subscribe do |msg|
    MiddlewareLogger.log("Received #{msg.name}: #{msg.data}")
    if msg.name == "test"
      entity = JSON.parse(msg.data)
      puts entity
    end
  end
end
