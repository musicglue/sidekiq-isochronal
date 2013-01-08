require 'spec_helper'
require 'support/workers/boring_worker'
describe Sidekiq::Isochronal::Lock, redis: true do
  
  let(:job) { Sidekiq::Isochronal::ChronoJob.new("BoringWorker", 10, true) }
  subject(:lock) { Sidekiq::Isochronal::Lock.new(job) }
  
  it { should respond_to(:lock!) }
  it { should respond_to(:unlock!) }
  
  it "should mirror its job id" do
    lock.id.should eq(job.id)
  end
  
  it "#lock! should set a lock in redis" do
    lock.lock!
    redis_result("get", "chronojob:lock:#{lock.id}").should eq("locked")
  end
  
  it "should not lock twice without being unlocked" do
    lock.lock!
    lock.lock!.should be_false
  end
  
  it "should be able to reacquire the lock if unlocked" do
    lock.lock!
    lock.unlock!
    lock.lock!.should be_true
  end
  
  it "should not allow separate locks to exist simultaneously" do
    lock2 = Sidekiq::Isochronal::Lock.new(job)
    lock.lock!
    lock2.lock!.should be_false
  end
  
  it "should wrap a block in a lock" do
    @a = 1
    lock.with_lock do
      @a += 1
    end
    lock.should_not be_locked
    @a.should eq(2)
  end
  
  it "should not yield the lock during a #with_lock" do
    lock.with_lock do
      lock.lock!.should be_false
    end
  end
  
  it "should not acquire a lock if the resource is locked" do
    lock.lock!
    @var = nil
    lock.with_lock do
      @var = "broken"
    end
    @var.should be_nil
  end
  
  context "timeouts" do
    subject(:lock) { Sidekiq::Isochronal::Lock.new(job, 1) }
    
    it "should automatically release the lock" do
      lock.lock!
      sleep 1
      lock.lock!.should be_true
    end
    
    xit "#with_lock should allow retries of the lock" do
      lock.lock!
      @var = "broken"
      lock.with_lock(retries: 3) do
        @var = "working"
      end
      @var.should eq("working")
    end
  end
  
end