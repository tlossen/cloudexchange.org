require 'rubygems'
require 'sinatra'
require 'erb'

REGIONS = ['us-west-1', 'us-east-1', 'eu-west-1']
SYSTEMS = ['linux', 'windows']
INSTANCES = ['m1.small', 'm1.large', 'm1.xlarge', 'c1.medium', 'c1.xlarge', 'm2.2xlarge', 'm2.4xlarge']

get '/' do
  redirect '/charts/eu-west-1.linux.m1.small.html'
end

get '/check' do
  'ok'
end

get '/charts/:which.html' do
  @which = params[:which]
  erb :chart
end

