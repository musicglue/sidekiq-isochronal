require 'spec_helper'

describe Sidekiq::Isochronal::Dispatcher do

  context "should invoke workers" do
    
    subject(:dispatcher) { Sidekiq::Isochronal::Dispatcher }
    before :each do
      stub_class("Worker")
      Worker.stubs(:perform_async)
    end
    
    it "with .run!" do
      Worker.expects(:perform_async)
      dispatcher.run!("Worker")
    end
    
    it "and elegantly handle workers that don't exist" do
      expect{ dispatcher.run!("NotAWorker") }.not_to raise_error(NameError)
    end
  end

end