require "sinatra/base"
require "twiliolib"

module Sinatra
  module Twilio
    module Helpers
      def method_missing(method, *args, &block)
        @twilio.send(method, *args, &block)
      rescue
        super(method, *args, &block)
      end

    end

    def respond(route, conditions = {}, &block)
      action = Proc.new do
        @twilio = ::Twilio::Response.new
        instance_eval(&block) if block_given?
        @twilio.respond
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
