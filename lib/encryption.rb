require 'digest'
require "openssl"
require 'base64'

# 加密
class Encryption
  ENC_SALT = 'rG1-tZZ$'.freeze
  class << self
    # 对明文做salt二次加密
    def encrypt(plain)
      md5(ENC_SALT + md5(plain))
    end

    # 使用md5算法把明文转为密文
    def md5(plain)
      plain = plain.nil? ? '' : plain.to_s
      Digest::MD5.hexdigest(plain)
    end

    # des 加密
    def des_encrypt(plaintext)
      c = OpenSSL::Cipher::Cipher.new("DES-CBC")
      c.encrypt
      c.key = des_key
      c.iv = des_iv
      ret = c.update(plaintext)
      ret << c.final
      # ret.to_a.pack("m").strip
      [ret].pack("m").strip
    end

    # des 解密
    def des_decrypt(encrypt_value)
      c = OpenSSL::Cipher::Cipher.new("DES-CBC")
      c.decrypt
      c.key = des_key
      c.iv = des_iv
      ret = c.update(encrypt_value.unpack('m').first)
      ret << c.final
    end

    def des_iv
      @des_iv ||= TradingServer::Application.config.des_iv
    end

    def des_key
      @des_key ||= TradingServer::Application.config.des_key
    end
  end
end
