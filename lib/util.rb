class Util
  def self.random_code(length = 4)
    code = format("%0#{length}d", rand(10**length))
    code = format("%04d", 1234) if ENV["RAILS_ENV"] == "test"
    code
  end

  def self.random_order_no(time=nil)
    time ||= Time.now
    num = '%04d' % rand(1000)
    time.to_s(:number) + num
  end
end
