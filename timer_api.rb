# timer_api

#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'time'
require_relative 'lib/gif_timer'

get '/api/timer.gif' do
  type = request.env["rack.request.query_hash"]["type"]
  show_days = request.env["rack.request.query_hash"]["show_days"]
  date = request.env["rack.request.query_hash"]["date"]
  plus = request.env["rack.request.query_hash"]["plus"]
  y = request.env["rack.request.query_hash"]["year"]
  m = request.env["rack.request.query_hash"]["month"]
  d = request.env["rack.request.query_hash"]["day"]
  hh = request.env["rack.request.query_hash"]["hour"]
  mm = request.env["rack.request.query_hash"]["minute"]

  if show_days == "0" then show_days = false else show_days = true end

  if type == "dolar" then
    end_time = DateTime.parse(date + " 00:00:00.0 -0400")
    puts "-- DateTime.parse: #{end_time}"
    end_time = end_time + 1 # plus one day
    end_time = end_time + (8/24.0) # plus 8 hours
    puts "-- end_time: #{end_time}"
    end_time = end_time.to_time.to_i
  elsif type.nil? then 
    end_time = Time.parse(y + "-" + m + "-" + d + " " + hh + ":" + mm).to_i
  end

  # generate file for timestamp and store local dir
  start_time = Time.now.to_i
  puts "-- start_time: #{Time.now}"

  time_difference = end_time - start_time
  if start_time > end_time
    time_difference = 0 # handle finished timer case
  end

  # round to nearest minute for caching
  rounded_time_difference = ((time_difference/60) * 60)
  gif = GifTimer::Gif.find_or_create(rounded_time_difference, show_days)

  send_file(gif.path, filename: "timer.gif", type: 'image/gif', disposition: :inline)

end

