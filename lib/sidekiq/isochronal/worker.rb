require 'sidekiq/worker'
require 'active_support/core_ext'

module Sidekiq
  module Isochronal
    module Worker
      module ClassMethods
        
        def periodicly opts={}
          if opts[:each]
            ::Sidekiq::Isochronal.chronograph.push self.to_s, opts[:each]
          end
          if opts[:unique]
            Sidekiq::Isochronal::ChronoJob.create! self.to_s, 10, true
            @@chronojob_unique = true
          else
            @@chronojob_unique = false
          end
        end
        
        def chronojob_unique
          @@chronojob_unique ||= false
        end

      end
    end
  end
  Worker::ClassMethods.send(:include, Isochronal::Worker::ClassMethods)  
end