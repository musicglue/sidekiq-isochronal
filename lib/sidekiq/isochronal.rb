require 'active_support/concern'
require 'sidekiq/isochronal/lock'
require 'sidekiq/isochronal/worker'
require 'sidekiq/isochronal/chrono_job'
require 'sidekiq/isochronal/chronograph'
require 'sidekiq/isochronal/dispatcher'
require 'sidekiq/isochronal/middleware'

module Sidekiq
  module Isochronal
    class << self
      attr_accessor :supervisor
      def chronograph
        @chronograph ||= begin
          @supervisor = Chronograph.supervise_as :chronograph
          Celluloid::Actor[:chronograph]
        end
      end
    end
  end
end