require 'cenit/client'

module Cenit
    class << self
      attr_accessor :configuration
    end

    def self.configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    class Configuration
      attr_accessor :connection_id, :connection_token, :user_id, :user_token, :push_url

      def initialize
        @push_url = 'https://www.cenithub.com/api/v1/push'
      end
    end
end
