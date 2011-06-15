require "twiliolib"

module Sinatra
  module Twilio
    class Response < ::Twilio::Response
      attr_accessor :target

      def initialize(target)
        super(nil)
        self.target = target
      end

      def method_missing(method, *args, &block)
        target.send(method, *args, &block)
      rescue NoMethodError
        super(method, *args, &block)
      end

      def self.allowed_verbs
        superclass.allowed_verbs
      end
    end
  end
end
