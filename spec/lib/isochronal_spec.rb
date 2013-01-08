require 'spec_helper'

describe Sidekiq::Isochronal do

  context "it has a chronograph" do
    subject { Sidekiq::Isochronal }
    it { should respond_to(:chronograph) }
  end

end