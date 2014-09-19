# encoding: utf-8
#
require 'sinatra'
require "sinatra/json"
require 'bitcoin-client'
require './bitcoin_client_extensions.rb'
require './command.rb'
set :bind, '0.0.0.0'

raise "Please set SLACK_API_TOKEN" if ENV['SLACK_API_TOKEN'].nil?

post "/tip" do
  puts params
  raise "NOP" unless params['token'] == ENV['SLACK_API_TOKEN']

  begin
    command = Command.new(params)
    command.perform
    json command.result
  rescue Exception => ex
    puts "#{ex.message}: #{ex.backtrace.join("\n")}"
    json text: "so error: #{ex.message}"
  end
end

get "/" do
  "it works!"
end
