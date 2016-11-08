class RechargeCode < ApplicationRecord
  validates :money, numericality: { only_integer: true,greater_than: 0 }
  validates_presence_of :admin
  belongs_to :admin
  belongs_to :student
  has_one    :recharge_record

  def self.get_code(money)
    money = "#{RechargeCode.get_random_letter}#{money.to_s}#{RechargeCode.get_random_letter}"
    des = OpenSSL::Cipher::Cipher.new("des-ede3-cbc")
    des.encrypt
    iv = des.random_iv
    des.key = APP_CONFIG[:recharge_key]
    data = des.update(money) + des.final
    data = iv + data
    data = Base64.strict_encode64(data)
    #data = URI.escape(data, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))

    data
  end

  def self.get_money(code)
    des = OpenSSL::Cipher::Cipher.new("des-ede3-cbc")
    des.decrypt
    des.key =  APP_CONFIG[:recharge_key]
    #encrypted_data = URI.unescape(code)
    encrypted_data = Base64.decode64(encrypted_data)
    des.iv =  encrypted_data.slice!(0,8)
    decrypted = des.update(encrypted_data) + des.final
    decrypted.delete("a-zA-Z").to_i
  end

  def self.build_with_code(param=nil,admin=nil)
    a = RechargeCode.new(param)
    a.code = RechargeCode.get_code(a.money) if a.money
    a.admin = admin
    a
  end
  def self.get_random_letter
    (0...5).map { ('a'..'z').to_a[rand(26)] }.join
  end
end
