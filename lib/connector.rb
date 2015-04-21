require 'json'
require 'bunny'

module Connector

  def self.broadcast(queue, key, msg)
      begin
        payload = "{function: '#{msg[:function]}', args: '#{msg.to_s}'}"
        pubconn = Bunny.new(:host => Continuous::Application.config.queuehost, :vhost => Continuous::Application.config.queuevhost, :user => Continuous::Application.config.queueuser, :password => Continuous::Application.config.queuepassword)
        pubconn.start
        pubch = pubconn.create_channel
        pubx = pubch.fanout(key)
        pubx.publish(payload)
        pubconn.close
        output = "Broadcasting to #{queue}"
      rescue => e
        output = "Error while sending message to queue #{queue} #{e.inspect}"
        pubconn.close
      end
    return output
  end


  def self.publish(queue, key, msg)
      begin
        payload = "{function: '#{msg[:function]}', args: '#{msg.to_s}'}"
        pubconn = Bunny.new(:host => Continuous::Application.config.queuehost, :vhost => Continuous::Application.config.queuevhost, :user => Continuous::Application.config.queueuser, :password => Continuous::Application.config.queuepassword)
        pubconn.start
        pubch = pubconn.create_channel
        pubx = pubch.topic("civ", :durable => true, :auto_delete => true)
        pubqueue = pubch.queue(queue, :auto_delete => true, :durable => true).bind(pubx, :routing_key => key)
        pubx.publish(payload, :routing_key => key)
        pubconn.close
        msgoutput = "Sending to queue #{queue}"
      rescue => e
        msgoutput = "Error while sending to queue #{queue} #{e.inspect}"
      end
    return msgoutput
  end

end

