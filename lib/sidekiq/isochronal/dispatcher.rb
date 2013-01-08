module Sidekiq
  module Isochronal
    class Dispatcher
      
      attr_accessor :worker_class
      def initialize worker_class
        @worker_class = worker_class
      end
      
      def run
        worker_class.constantize.send(:perform_async)
      rescue NameError
        ""
      end
      
      class << self
      
        def run! class_name
          new(class_name).run
        end
      
      end
      
    end
  end
end