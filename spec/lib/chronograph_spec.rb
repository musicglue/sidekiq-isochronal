require 'spec_helper'

describe Sidekiq::Isochronal::Chronograph do
  
  before do
    rspec_reset
  end
  
  context "stores and triggers jobs for Worker classes" do
    subject(:chronograph) { Sidekiq::Isochronal::Chronograph.new }
    
    before :each do
      @worker = stub_class("Worker")
      Worker.stub(:perform_async)
      Sidekiq::Isochronal::Chronograph.reset_jobs
    end
    
    it { should respond_to(:jobs) }
    it { should_not be_running }

    it "#push jobs onto queue" do
      chronograph.push "Worker", 5
      chronograph.jobs.length.should eq(1)
    end

    it "#push-es only valid jobs" do
      chronograph.push("Worker", "name").should be_false
      chronograph.push(10, nil).should be_false
    end

    it "allows a single entry per Worker class" do
      chronograph.push "Worker", 5
      chronograph.push("Worker", 10).should be_false
      chronograph.jobs.length.should eq(1)
    end

    it "should not be startable without a valid job" do
      chronograph.execute.should be_false
    end
    
    it "should run if there are any valid jobs" do
      chronograph.push "Worker", 1
      chronograph.execute.should be_true
      chronograph.running?.should be_true
    end
    
    it "should #dispatch a job" do
      chronograph.push "Worker", 1
      Worker.should_receive(:perform_async)
      chronograph.dispatch      
    end
    
    it "should trigger requested workers" do
      chronograph.push "Worker", 1
      Worker.should_receive(:perform_async)
      chronograph.execute
      chronograph.running?.should be_true
      sleep 2
    end
    
    it "should continue to trigger the requested workers" do
      chronograph.push "Worker", 1
    end
    
    it "should trigger multiple workers" do
    end
  end
end