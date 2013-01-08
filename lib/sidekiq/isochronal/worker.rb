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
        end

      end
    end
  end
  Worker::ClassMethods.send(:include, Isochronal::Worker::ClassMethods)  
end