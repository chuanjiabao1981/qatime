class Util
  def self.random_code(length = 4)
    code = format("%0#{length}d", rand(10**length))
    code = format("%04d", 1234) if ENV["RAILS_ENV"] == "test"
    code = format('%04d', 0000) if ENV['RAILS_ENV'] == 'testing'
    code
  end

  def self.random_order_no(time=nil)
    time ||= Time.now
    num = '%04d' % rand(1000)
    time.to_s(:number) + num
  end

  def self.group_cities
    cities = City.all
    result = {}
    cities.each do |city|
      result[Spinying.parse(word: city.name).first] ||= []
      result[Spinying.parse(word: city.name).first] << city.name
    end
    result
  end

  def self.img_url_save_to_tmp(img_url)
    req = Typhoeus::Request.new(
      img_url,
      method: :get,
    )
    img_stream = req.run.body
    path = "tmp/#{rand(10000)}_#{Time.now.to_i}.png"
    IO.write("#{path}", img_stream.to_s.force_encoding('UTF-8'))
    path
  end

  def self.duration_in_words(seconds_diff)
    hours = seconds_diff / 3600
    seconds_diff -= hours * 3600
    minutes = seconds_diff / 60
    seconds_diff -= minutes * 60
    seconds = seconds_diff
    word = ''
    word += "#{hours}时" if hours > 0
    word += "#{minutes}分" if minutes > 0
    word += "#{seconds}秒" if seconds > 0
    word
  end

end
