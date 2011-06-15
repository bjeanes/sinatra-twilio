require "sinatra/base"

module Sinatra
  module Twilio
    def respond(route, conditions = {}, &block)
      get  route, conditions, &block
      post route, conditions, &block
    end
  end

  register Twilio
end
