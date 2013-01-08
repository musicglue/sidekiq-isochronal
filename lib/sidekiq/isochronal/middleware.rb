module Sidekiq
  module Middleware
    module Server
      class Chronograph
        def call(worker, msg, queue)
          yield
        end
      end
    end
  end
end