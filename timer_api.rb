# timer_api

#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require_relative 'lib/gif_timer'

get '/api/timer.gif' do
  y = request.env["rack.request.query_hash"]["year"]
  m = request.env["rack.request.query_hash"]["month"]
  d = request.env["rack.request.query_hash"]["day"]
  hh = request.env["rack.request.query_hash"]["hour"]
  mm = request.env["rack.request.query_hash"]["minute"]

  # generate file for timestamp and store local dir
  start_time = Time.now.to_i
  # end_time = end_time_ms_since_epoch / 1000
  end_time = Time.parse(y + "-" + m + "-" + d + " " + hh + ":" + mm).to_i
  time_difference = end_time - start_time
  if start_time > end_time
    time_difference = 0
    # handle finished timer case
  end
  # round to nearest minute for caching
  rounded_time_difference = ((time_difference/60) * 60)
  gif = GifTimer::Gif.find_or_create(rounded_time_difference)

  send_file(gif.path, filename: "timer.gif", type: 'image/gif', disposition: :inline)
end

