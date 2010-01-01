require 'rubygems'
require 'sinatra'
require 'erb'

REGIONS = ['us-west-1', 'us-east-1', 'eu-west-1']
SYSTEMS = ['linux', 'windows']
INSTANCES = ['m1.small', 'm1.large', 'm1.xlarge', 'c1.medium', 'c1.xlarge', 'm2.2xlarge', 'm2.4xlarge']

get '/' do
  @which = 'eu-west-1.linux.m1.small'
  @spot_price = spot_price_map
  erb :chart
end

get '/charts/:which.html' do
  @which = params[:which]
  @spot_price = spot_price_map
  erb :chart
end

get '/check' do
  'ok'
end

def spot_price_map
  result = {}
  open("#{File.dirname(__FILE__)}/public/data/spot.csv").each do |line|
    key, value = *line.split(',')
    result[key] = value.to_f
  end
  result
end

