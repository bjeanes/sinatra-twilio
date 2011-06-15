require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Sinatra::Application do
  # Create a new sub-class each time to avoid bleeding routes between
  # tests
  let(:app) { Class.new(Sinatra::Application) }

  describe "#respond" do
    context "defining routes" do
      let(:route) { "/foo" }
      let(:action) { Proc.new {} }

      before(:all) { app.respond(route, &action) }

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

    context "returning TwiML response" do
      it "allows empty block" do
        lambda {
          app.respond "/"
        }.should_not raise_error
      end

      it "always returns a <Response> object" do
        app.respond "/"
        get("/").body.should =~ /^<Response>.*<\/Response>$/
      end

      it "doesn't return the response of the block" do
        app.respond("/") { "foobar123" }
        get("/").body.should_not =~ /foobar123/
      end

      it "creates a new Twilio::Response for each route" do
        app.respond("/1") { addSay "1" }
        app.respond("/2") { addSay "2" }

        get("/1").body.should_not =~ /2/
        get("/2").body.should_not =~ /1/
      end
    end

    context "action block has access to normal Sinatra helpers" do
      %w[params request response].each do |helper|
        it "can access #{helper.inspect} method" do
          app.respond("/") { eval(helper) }
          get("/").status.should == 200
        end
      end
    end

    context "building Twilio::Response" do
      it "can access instance methods on Twilio::Response transparently" do
        app.respond("/") { addSay "1" }

        get "/"

        last_response.status.should == 200
        last_response.body.should == "<Response><Say>1</Say></Response>"
      end
    end
  end
end
