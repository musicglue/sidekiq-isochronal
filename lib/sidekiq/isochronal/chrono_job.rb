module Sidekiq
  module Isochronal
    class ChronoJob
      
      class << self
        def create! worker_class, interval, unique=false
          item = new(worker_class, interval, unique)
          item.register!
          return item
        end
        
        def load_job worker_class
          id, hash = Digest::MD5.hexdigest(worker_class), {}
          Sidekiq.redis { |conn| hash = conn.hgetall "chronojob:#{id}" }
          return hash
        end
        
        def runnable
        end
        
        def lock_for worker_class
          args = load_job(worker_class)
          worker = new(args["worker_class"], args["interval"], args["unique"]).tap{|obj| obj.last_run = args["last_run"]}
          Lock.new(worker)
        end
      end
      
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
      
      def run
        lock if unique
      end
      
      def finish
        unlock if unique
      end
      
      def locked?
        Sidekiq.redis { |conn| conn.exists "chronojob:lock:#{id}" }
      end
      
      def unlocked?
        !locked?
      end
      
      def runnable?
        if unique
          locked?
        else
          true
        end
      end

    end
  end
end