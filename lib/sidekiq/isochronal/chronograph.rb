require 'celluloid'

module Sidekiq
  module Isochronal
    class Chronograph
      include Celluloid

      def execute
        if !running? && jobs.length > 0
          every(0.1.seconds) do
            dispatch
          end
          @running = true
        else
          @running = false
        end
      end
      
      def dispatch
        if jobs.any?
          jobs.each do |key, val|
            Dispatcher.run!(key)
          end
        end
      end

      def running?
        @running || false
      end

      def jobs
        self.class.jobs
      end
      
      def self.jobs
        @jobs ||= {}
      end
      
      def self.reset_jobs
        @jobs = {}
      end

      def push class_name, increment
        return false unless (increment.is_a? Fixnum) || (increment.is_a? Float)
        return false if jobs.has_key? class_name
        jobs[class_name.to_s] = increment
        true
      end
    
    end
  end
end