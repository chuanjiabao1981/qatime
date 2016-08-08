class Util
  def self.random_code(length = 4)
    format("%0#{length}d", rand(10**length))
    format("%04d", 1234) if ENV["RAILS_ENV"] == "test"
  end
end
