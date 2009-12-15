require 'rubygems'
require 'sinatra'
require 'erb'

get '/' do
  redirect '/charts/eu-west-1.linux.m1.small.html'
end

get '/charts/:which.html' do
  @regions = ['eu-west-1', 'us-east-1', 'us-west-1']
  @systems = ['linux']
  @instances = ['m1.small', 'm1.large', 'm1.xlarge', 'c1.medium', 'c1.xlarge', 'm2.2xlarge', 'm2.4xlarge']
  @which = params[:which]
  erb :chart
end

get '/charts/:which.xml' do
  @which = params[:which]
  content_type 'application/xml', :charset => 'utf-8'
  erb :settings
end




