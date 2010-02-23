require 'rubygems'
require 'sinatra'
require 'erb'
require File.join(File.dirname(__FILE__), 'exchange')


REGIONS = ['us-west-1', 'us-east-1', 'eu-west-1']
SYSTEMS = ['linux', 'windows']
INSTANCES = ['m1.small', 'm1.large', 'm1.xlarge', 'c1.medium', 'c1.xlarge', 'm2.xlarge', 'm2.2xlarge', 'm2.4xlarge']

get '/' do
  @which = 'eu-west-1.linux.m1.small'
  erb :chart
end

get '/charts/:which.html' do
  @which = params[:which]
  erb :chart
end

get '/check' do
  'ok'
end

helpers do

  def display(which)
    (['ec2'] + which.split('.', 3)).join(' | ')
  end

  def percent(which)
    (exchange.spot_price(which) / exchange.regular_price(which) * 100).round
  end

  def spot_price(which)
    '%.3f' % exchange.spot_price(which)
  end

  def exchange
    @exchange ||= Exchange.new
  end

end



