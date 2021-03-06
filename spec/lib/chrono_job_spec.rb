require 'spec_helper'

describe Sidekiq::Isochronal::ChronoJob, redis: true do
  let(:chrono) { Sidekiq::Isochronal::ChronoJob }
  before :each do
    @job = Sidekiq::Isochronal::ChronoJob.create!("Worker", 5)
  end
  
  context "basic operations" do
    
    it "should have an @id" do
      @job.id.should_not be_nil
    end
    
    it "should be registered with Redis" do
      Sidekiq.redis {|x| @set = x.smembers("chronojobs") }
      @set.include?(@job.id).should be_true
    end
    
    it "should maintain correct status metadata" do
      @job.status.should be_a(Hash)
      @job.status.should include(
        "worker_class" => "Worker",
        "interval" => "5",
        "unique" => "false",
        "last_run" => ""
      )
    end
    
  end
  
  context "locking operations" do
    it "should be able to run concurrently unless unique is set" do
      @job.runnable?.should be_true
    end
    
    context "with unique set" do
      before :each do
        @job = Sidekiq::Isochronal::ChronoJob.create!("Worker", 5, true)
      end
      
      it "should acquire a lock for a worker class" do
        lock = chrono.lock_for("Worker")
        lock.should be_a(Sidekiq::Isochronal::Lock)
      end
    end
  end
end














