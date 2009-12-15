#!/usr/bin/env ruby

require 'time'

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
    data[type] ||= []
    data[type] << [stamp, price]
  end
  data
end

['us-east-1', 'us-west-1', 'eu-west-1'].each do |region|
  data = fetch(region)
  data.keys.each do |type|
    open("public/data/#{region}.#{type}.csv", 'w') do |file|
      data[type].each do |stamp, price|
        file.puts "#{stamp.strftime('%Y-%m-%d %H:%M:%S')},#{price}"
      end
    end
  end
end



