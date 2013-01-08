class SayTimeWorker
  include Sidekiq::Worker
  periodicly each: 5.seconds, unique: true

  def perform
    puts "[TIME] #{Time.now}"
  end
end