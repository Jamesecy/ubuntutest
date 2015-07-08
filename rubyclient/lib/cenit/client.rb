require "cenit/client/version"
require 'openssl'
require 'httparty'
require 'active_model/array_serializer'

module Cenit
  module Client

    require "cenit"

    def self.push(json_payload, options=self.configuration)

      res = HTTParty.post(
          options[:push_url],
          {
              body: json_payload,
              headers: {
                  'Content-Type'        => 'application/json',
                  'X-Hub-Store'         => options[:connection_id]||'',
                  'X-Hub-Access-Token'  => options[:connection_token]||'',
                  'X-User-Access-Key'   => options[:user_id]||'',
                  'X-User-Access-Token' => options[:user_token]||'',
                  'X-Hub-Timestamp'    => Time.now.utc.to_i.to_s
              }
          }
      )
      validate(res)
      res
    end

    def self.destroy(resource,id, options=self.configuration)

      res = HTTParty.delete(
          options[:push_url] + "/#{resource}/#{id}",
          {
              headers: {
                  'Content-Type'       => 'application/json',
                  'X-Hub-Store'        => options[:connection_id],
                  'X-Hub-Access-Token' => options[:connection_token],
                  'X-Hub-Timestamp'    => Time.now.utc.to_i.to_s
              }
          }
      )
      validate(res)
      res
    end

    def self.show(resource,id, options=self.configuration)

      res = HTTParty.get(
          options[:push_url] + "/#{resource}/#{id}",
          {
              headers: {
                  'Content-Type'       => 'application/json',
                  'X-Hub-Store'        => options[:connection_id],
                  'X-Hub-Access-Token' => options[:connection_token],
                  'X-Hub-Timestamp'    => Time.now.utc.to_i.to_s
              }
          }
      )
      validate(res)
      res.body
    end

    def self.index(resource, options=self.configuration)

      res = HTTParty.get(
          options[:push_url] + "/#{resource}",
          {
              headers: {
                  'Content-Type'       => 'application/json',
                  'X-Hub-Store'        => options[:connection_id],
                  'X-Hub-Access-Token' => options[:connection_token],
                  'X-Hub-Timestamp'    => Time.now.utc.to_i.to_s
              }
          }
      )
      validate(res)
      res.body
    end

    private

    def self.configuration
      {
          push_url: Cenithub.configuration.push_url,
          connection_id: Cenithub.configuration.connection_id,
          connection_token: Cenithub.configuration.connection_token
      }
    end

    def self.validate(res)
      raise PushApiError, "Push not successful. CENIT returned response code #{res.code} and message: #{res.body}" if res.code != 200
    end

    class PushApiError < StandardError; end
  end
end
