module Cenit
  module Collection
    require File.expand_path(File.join(*%w[ twilio build ]), File.dirname(__FILE__))
    require "cenit/client"

    @twilio = Cenit::Collection::Twilio::Build.new

    # Include Collection Gem dependency
    # require "cenit/collection/[My Dependency Collection]/build"
    # Collection dependency
    # @twilio.register_dep(Cenit::Collection::[My Dependency Collection]::Build.new)

    def self.push_collection (config)
      Cenit::Client.push(@twilio.shared_collection.to_json, config)
    end

    def self.show_collection
      @twilio.shared_collection
    end

    def self.pull_collection (parameters,config)
      @twilio.shared_collection
    end

    def self.push_sample(model, config)
      Cenit::Client.push(@twilio.sample_model(model).to_json, config)
    end

    def self.import(data)
      @twilio.import_data(data)
    end
  end
end