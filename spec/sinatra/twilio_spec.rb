require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Sinatra do
  subject { app }

  context "classic apps" do
    let(:app) { Sinatra::Application }
    it { should respond_to(:respond) }
  end

  describe "modular apps" do
    let(:app) { Class.new(Sinatra::Base) { register Sinatra::Twilio } }
    it { should respond_to(:respond) }

    describe "#respond" do
      context "defining routes" do
        let(:route) { "/foo" }
        let(:action) { Proc.new {} }

        before { app.respond(route, &action) }

        it "defines a GET route" do
          app.routes["GET"].should have(1).item
        end

        it "defines a POST route" do
          app.routes["POST"].should have(1).item
        end

        it "should have identical GET and POST routes" do
          t = Proc.new {|res| [res.status, res.headers, res.body] }

          get_response  = get(route)
          post_response = post(route)
          t[get_response].should == t[post_response]
        end
      end
    end

  end
end
