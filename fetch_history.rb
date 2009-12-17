#!/usr/bin/env ruby

require 'time'

#DATA_DIR = "/home/ubuntu/cloudexchange.org/www/data"
DATA_DIR = "/Users/tlossen/Code/cloudexchange.org/public/data"


def store(region, data)
  # open("#{DATA_DIR}/#{region}.csv", 'w') do |file|
  #   data.each do |type, values|
  #     file.puts "#{type},#{values.last[1]}"
  #   end
  # end

  data.keys.each do |type|
    open("#{DATA_DIR}/#{region}.#{type}.csv", 'w') do |file|
      data[type].each do |stamp, price|
        file.puts "#{stamp.strftime('%Y-%m-%d %H:%M:%S')},#{price}"
      end
    end
  end
end


def fetch(region)
  puts "#{Time.now} - fetching #{region}"

  data = {}
  ENV['EC2_URL'] = "https://#{region}.ec2.amazonaws.com"
  `ec2-describe-spot-price-history`.each do |line|
    col = line.split
    price = col[1].to_f
    stamp = Time.parse(col[2]).utc
    inst = col[3]
    os = col[4].split('/')[0].downcase
    type = "#{os}.#{inst}"
    values = data[type] ||= []
    values << [stamp - 1, values.last[1]] unless values.empty?
    values << [stamp, price]
  end

  data.each do |type, values|
    values << [Time.now.utc, values.last[1]]
  end

  data
end


['us-east-1', 'us-west-1', 'eu-west-1'].each do |region|   
  store(region, fetch(region))
end
