#!/usr/bin/env ruby

## run this from Procfile to push data to wombat periodically

require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

period = ENV['PUSH_IT_PERIOD'] || '30s'

scheduler.every period, :overlap => false do
  system 'rake wombat:push_it'
end

scheduler.join
