module Cenit
  module Collection
    require File.expand_path(File.join(*%w[ twilio_api build ]), File.dirname(__FILE__))
    require "cenit/client"

    @twilio_api = Cenit::Collection::TwilioApi::Build.new

    # Include Collection Gem dependency
    # require "cenit/collection/[My Dependency Collection]/build"
    # Collection dependency
    # @twilio_api.register_dep(Cenit::Collection::[My Dependency Collection]::Build.new)

    def self.push_collection (config)
      Cenit::Client.push(@twilio_api.shared_collection.to_json, config)
    end

    def self.show_collection
      @twilio_api.shared_collection
    end

    def self.pull_collection (parameters,config)
      @twilio_api.shared_collection
    end

    def self.push_sample(model, config)
      Cenit::Client.push(@twilio_api.sample_model(model).to_json, config)
    end

    def self.import(data)
      @twilio_api.import_data(data)
    end
  end
end