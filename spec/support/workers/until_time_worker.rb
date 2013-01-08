class UntilTimeWorker
  include Sidekiq::Worker

  def perform
    puts "[TIME] #{Time.now}"
  end
end