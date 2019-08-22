# timer_api

#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'time'
require 'thwait'
require_relative 'lib/gif_timer'

$threads = []

get '/api/timer/:show_days/:year/:month/:day/:hour/:minute' do
  
  delete_cache

  show_days = params[:show_days] 
  y = params[:year] 
  m = params[:month] 
  d = params[:day] 
  hh = params[:hour] 
  mm = params[:minute] 

  end_time = Time.parse(y + "-" + m + "-" + d + " " + hh + ":" + mm).to_i

  create_timer(end_time, show_days)

end

get '/api/timer/:show_days/:day/:month/:year' do

  delete_cache

  show_days = params[:show_days] 
  y = params[:year] 
  m = params[:month] 
  d = params[:day] 

  end_time = DateTime.parse("#{d}/#{m}/#{y}" + " 00:00:00.0 -0400")
  puts "-- DateTime.parse: #{end_time}"
  end_time = end_time + 1 # plus one day
  end_time = end_time + (8/24.0) # plus 8 hours
  puts "-- end_time: #{end_time}"
  end_time = end_time.to_time.to_i
  
  create_timer(end_time, show_days)
  
end

def create_timer end_time, show_days

  if show_days == "0" then show_days = false else show_days = true end

  # generate file for timestamp and store local dir
  start_time = Time.now.to_i

  time_difference = end_time - start_time
  if start_time > end_time
    time_difference = 0 # handle finished timer case
  end

  # round to nearest minute for caching
  rounded_time_difference = ((time_difference/60) * 60)
  gif = GifTimer::Gif.find_or_create(rounded_time_difference, show_days)

  send_file(gif.path, filename: "timer.gif", type: 'image/gif', disposition: :inline)

end

def delete_cache
  # delete cache
  # Dir.glob("gifs/*.gif").select{ |file| File.delete file }
end
