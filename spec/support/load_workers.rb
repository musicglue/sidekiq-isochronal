require 'sidekiq'
require 'sidekiq-isochronal'

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Sidekiq::Middleware::Server::Chronograph
  end
end

Dir[File.expand_path('../workers', __FILE__)+'/*.rb'].each{ |file| require file }