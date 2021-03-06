require 'modesty'

describe "bootstrap" do
  before :all do
    Modesty.root = File.join(
      Modesty::TEST,
      'myapp'
    )
    Modesty.metrics = {}
    Modesty.experiments = {}
    Modesty.load!

    unless defined? Rails
      class Rails
        def self.root
          File.join(
            File.expand_path(File.dirname(__FILE__)),
            '../test/myapp'
          )
        end

        def self.configuration
          self
        end

        def self.env
          'test'
        end

        def self.after_initialize
          yield
        end
      end
    end
  end

  it "can bootstrap" do
    lambda { require 'modesty/frameworks/rails.rb' }.should_not raise_error
  end

  it "bootstraps Redis" do
    Modesty.data.store.should be_an_instance_of Redis::Client
    Modesty.data.store.instance_variable_get("@port").should == 6379
    Modesty.data.store.instance_variable_get("@host").should == 'localhost'
  end

  it "loads metrics" do
    Modesty.metrics.keys.should include :baked_goods
  end

  it "loads experiments" do
    Modesty.experiments.keys.should include :cookbook
  end
end
