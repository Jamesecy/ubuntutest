require 'rubygems'
require 'bundler'

Bundler.require(:default)
require './twilio_endpoint.rb'
run TwilioEndpoint
