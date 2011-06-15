require "sinatra/base"
require "sinatra/twilio/response"

module Sinatra
  module Twilio
    module Helpers
    end

    def respond(route, conditions = {}, &block)
      action = Proc.new do
        twilio = Response.new(self)
        twilio.instance_eval &block if block_given?
        twilio.respond
      end

      get  route, conditions, &action
      post route, conditions, &action
    end

    def self.registered(app)
      app.helpers Helpers
    end
  end

  register Twilio
end
