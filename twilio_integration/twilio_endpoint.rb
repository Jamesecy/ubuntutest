require 'sinatra'
require 'endpoint_base'

Dir['./lib/**/*.rb'].each &method(:require)

class TwilioEndpoint < EndpointBase::Sinatra::Base
  set :logging, true
  set :show_exceptions, false
  #EndpointBase::Concerns::SinatraResponder::Helpers.result(nil,nil)
  error do
    result 500, env['sinatra.error'].message
  end

  Honeybadger.configure do |config|
   config.api_key = ENV['HONEYBADGER_KEY']
    config.environment_name = ENV['RACK_ENV']
  end

  post '/send_sms/' do
    body    = @payload['Message']['body']
    phone   = @payload['Message']['to']
    from    = @payload['Message']['from']
   #body    = @payload['body']
    #phone   = @payload['to']
    #from    = @payload['from']

    message = Message.new(@config, body, phone, from)
    message.deliver

    result 200, %{SMS "#{body}" sent to #{phone}}

  end
  

  post '/send_smss/' do


    result 200, %{SMS  sent to }
  end

end
