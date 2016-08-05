class Util
  def self.random_code(length = 4)
    format("%0#{length}d", rand(10**length))
  end
end
