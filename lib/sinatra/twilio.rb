require "sinatra/base"
require "twiliolib"

module Sinatra
  module Twilio
    def respond(route, conditions = {}, &block)
      action = Proc.new do
        @twilio = ::Twilio::Response.new
        instance_eval(&block) if block_given?
        @twilio.respond
      end

      get  route, conditions, &action
      post route, conditions, &action
    end
  end

  register Twilio
end
