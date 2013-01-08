class SayTimeWorker
  include Sidekiq::Worker
  periodicly each: 5.seconds

  def perform
    puts "[TIME] #{Time.now}"
  end
end