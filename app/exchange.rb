class Exchange

  def regular_price(which)
    regular_price_map[which]
  end

  def spot_price(which)
    spot_price_map[which]
  end

private

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

  def data_dir
    "#{File.dirname(__FILE__)}/public/data"
  end

end