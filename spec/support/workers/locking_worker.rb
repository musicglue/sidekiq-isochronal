class LockingWorker
  include Sidekiq::Worker
  periodicly unique: true
  def perform
    count = 0
    Sidekiq.redis { |x| 
      count = x.incr "locktest"
    }
    Sidekiq.redis { |x|
      x.set "locktest#{count}", Time.now.to_f
    }
    sleep 0.2 if count == 1
  end
end