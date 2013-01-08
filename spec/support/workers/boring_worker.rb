class BoringWorker
  include Sidekiq::Worker
  def perform
    Sidekiq.redis { |x| 
      x.set "testing", "set"
    }
  end
end