class LockingWorker
  include Sidekiq::Worker
  periodicly unique: true
  def perform
    Sidekiq.redis { |x| 
      x.incr "locktest"
    }
  end
end