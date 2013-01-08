require 'sidekiq/processor'

module Sidekiq
  module Middleware
    module Server
      class Chronograph
        def call(worker, msg, queue)
          if worker.class.respond_to?(:chronojob_unique) && worker.class.chronojob_unique
            if lock = Sidekiq::Isochronal::ChronoJob.lock_for(worker.to_s)
              lock.with_lock do
                yield 
              end
            else
              nil
            end
          else
            puts "[CHRONO] Haha, you still ain't got this right!"
            yield
          end
        end
      end
    end
  end
end