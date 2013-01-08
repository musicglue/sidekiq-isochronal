require 'rubygems'
require 'bundler/setup'
require 'spork'
require 'guard/rspec'
require 'rspec'

Spork.prefork do
  require 'factory_girl'
  require 'faker'
  require 'celluloid'
  require 'sidekiq'
  require 'sidekiq/testing/inline'
  Dir['./spec/support/helpers/*.rb'].each{ |file| require file }

  RSpec.configure do |config|
    config.include FactoryGirl::Syntax::Methods
    
    config.around(:each, redis: true) do |spec|
      Sidekiq.redis { |x| x.flushdb }
      spec.run
    end
  end
end

Spork.each_run do
  load File.expand_path('../../lib/sidekiq/isochronal.rb', __FILE__)
  Dir[File.expand_path('../../lib/sidekiq/isochronal', __FILE__)+'/*.rb'].each{ |file| load file }
  FactoryGirl.find_definitions
end