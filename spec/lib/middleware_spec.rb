require 'spec_helper'
require 'support/workers/boring_worker'
require 'support/workers/locking_worker'

describe Sidekiq::Middleware::Server::Chronograph, redis: true do
  before :each do
    Sidekiq.server_middleware do |chain|
      chain.add Sidekiq::Middleware::Server::Chronograph
    end
    @chain = Sidekiq::Middleware::Chain.new
    @chain.add Sidekiq::Middleware::Server::Chronograph
  end
  
  it "should be registerable in the middleware chain" do
    match = false
    @chain.entries.each do |mware|
      match = true if mware.klass == Sidekiq::Middleware::Server::Chronograph
    end
    match.should be_true
  end
  
  it "should be registered in the god damn middleware" do
    entries = Sidekiq.server_middleware.entries
    entries.select{|m| m.klass == Sidekiq::Middleware::Server::Chronograph }.size.should eq(1)
  end
  
  context "should do nothing unless the job is unique" do
    it "does nothing when given a non-unique worker" do
      BoringWorker.perform_async
      BoringWorker.drain
      
      redis_result("get", "testing").should eq("set")
    end
    
    it "should acquire a lock with a unique worker" do
      3.times do
        LockingWorker.perform_async
      end
      LockingWorker.drain
      
      redis_result("get", "locktest").should eq("1")
    end
    
  end
end