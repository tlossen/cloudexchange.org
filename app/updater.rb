#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), 'exchange')

exchange = Exchange.new
exchange.update_prices
