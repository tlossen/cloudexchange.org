require 'time'
require 'rubygems'
require 'AWS'


class Exchange

  def regular_price(which)
    regular_price_map[which]
  end

  def spot_price(which)
    spot_price_map[which]
  end
  
  def update_prices
    current = {}
    ['us-east-1', 'us-west-1', 'eu-west-1'].each do |region|
      fetch_region(region)
      data = parse_region(region)
      store_region(region, data)

      data.keys.each do |type|
        which = "#{region}.#{type}"
        price = data[type].last[1]
        current[which] = price
      end
    end
    store_prices(current)
  end

private

  def fetch_region(region)
    puts "#{Time.now} - fetching #{region}"
    last = Time.parse(`tail -1 #{history_file(region)}`.split[2]).utc
    open(history_file(region), 'a') do |file|
      ticks = ec2(region).describe_spot_price_history(:start_time => last).spotPriceHistorySet.item
      ticks.each do |t|
        if Time.parse(t.timestamp).utc > last 
          line = "SPOTINSTANCEPRICE\t#{t.spotPrice}\t#{t.timestamp}\t#{t.instanceType}\t#{t.productDescription}"
          file.puts line
          puts line
        end
      end
    end
  end
  
  def ec2(region)
    id, key = *open('.amazon').read.split(':')
    server = "#{region}.ec2.amazonaws.com"
    AWS::EC2::Base.new(:access_key_id => id, :secret_access_key => key, :server => server)
  end

  def parse_region(region)
    data = {}
    open(history_file(region), 'r').each do |line|
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

  def store_region(region, data)
    data.keys.each do |type|
      which = "#{region}.#{type}"
      atomic_write("#{data_dir}/#{which}.csv") do |file|
        data[type].each do |stamp, price|
          file.puts "#{stamp.strftime('%Y-%m-%d %H:%M:%S')},#{price}"
        end
      end
    end
  end

  def store_prices(data)
    atomic_write("#{data_dir}/spot.csv") do |file|
      data.each do |type, price|
        file.puts "#{type},#{price}"
      end
    end
  end
  
  def regular_price_map
    @regular_price_map ||= price_map('regular')
  end

  def spot_price_map
    @spot_price_map ||= price_map('spot')
  end

  def price_map(name)
    result = {}
    open("#{data_dir}/#{name}.csv").each do |line|
      key, value = *line.split(',')
      result[key] = value.to_f
    end
    result
  end
  
  def history_file(region)
    "#{data_dir}/history.#{region}.txt"
  end

  def data_dir
    "#{File.dirname(__FILE__)}/public/data"
  end

  def atomic_write(path)
    tmpfile = "/tmp/ruby.#{rand}"
    open(tmpfile, 'w') do |file|
      yield file
    end
    `mv #{tmpfile} #{path}`
  end

end