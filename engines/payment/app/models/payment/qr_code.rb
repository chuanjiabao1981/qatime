module Payment
  class Qr_Code

    class << self
      def generate_payment(id,code_url)
        require 'rqrcode'

        qrcode = RQRCode::QRCode.new(code_url)
        # With default options specified explicitly
        png = qrcode.as_png(
            resize_gte_to: false,
            resize_exactly_to: false,
            fill: 'white',
            color: 'black',
            size: 220,
            border_modules: 0,
            module_px_size: 0,
            file: nil # path to write
        )
        qrcode_url = "/qrcode/#{id.to_s}_#{Time.now.to_i.to_s}.png"
        IO.write("public#{qrcode_url}", png.to_s.force_encoding('UTF-8'))
        qrcode_url
      end

      def generate_tmp(code_url)
        require 'rqrcode'
        qrcode = RQRCode::QRCode.new(code_url)
        # With default options specified explicitly
        png = qrcode.as_png(
          resize_gte_to: false,
          resize_exactly_to: false,
          fill: 'white',
          color: 'black',
          size: 220,
          border_modules: 0,
          module_px_size: 0,
          file: nil # path to write
        )
        qrcode_url = "tmp/#{rand(10000)}_#{Time.now.to_i}.png"
        IO.write("#{qrcode_url}", png.to_s.force_encoding('UTF-8'))
        qrcode_url
      end
    end
  end
end