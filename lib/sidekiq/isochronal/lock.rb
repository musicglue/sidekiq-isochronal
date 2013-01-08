module Sidekiq
  module Isochronal
    class Lock
      
      attr_accessor :worker, :id, :timeout
      def initialize worker, timeout=nil
        @worker, @timeout = worker, timeout
        @id = worker.id
      end
      
      def lock!
        lock.first
      end
      
      def unlock!
        unlock.first
      end
      
      def locked?
        lock_status.first
      end
      
      def unlocked?
        !lock_status.first
      end
      
      def with_lock &block
        lock!
        yield
        unlock!
      end
      
     
      private
      def lock
        Sidekiq.redis do |conn|
          conn.pipelined do
            conn.setnx "chronojob:lock:#{id}", "locked"
            if timeout
              conn.expire "chronojob:lock:#{id}", timeout
            end
          end
        end 
      end
      
      def unlock
        Sidekiq.redis do |conn|
          conn.pipelined do
            conn.del "chronojob:lock:#{id}"
          end
        end
      end
      
      def lock_status
        Sidekiq.redis do |conn|
          conn.pipelined do
            conn.exists "chronojob:lock:#{id}"
          end
        end
      end
        
      
    end
  end
end