module Sidekiq
  module Isochronal
    class ChronoJob
      
      attr_accessor :id, :worker_class, :interval, :unique, :last_run
      
      def initialize worker_class, interval, unique=false
        @worker_class, @interval, @unique = worker_class, interval, unique
        @id = Digest::MD5.hexdigest(worker_class)
      end
            
      def register!
        Sidekiq.redis do |conn| 
          conn.sadd("chronojobs", id)
          conn.hmset("chronojob:#{id}", "worker_class", worker_class, "interval", interval, "unique", unique, "last_run", nil)
        end
      end
      
      def status
        Sidekiq.redis { |conn| conn.hgetall("chronojob:#{id}") }
      end
      
      def runnable?
        if unique
          
        else
          true
        end
      end
      
      
      class << self
        def create! worker_class, interval, unique=false
          item = new(worker_class, interval, unique)
          item.register!
          return item
        end
      end
      
    end
  end
end