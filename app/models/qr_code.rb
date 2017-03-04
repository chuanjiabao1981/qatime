class QrCode < ApplicationRecord

  belongs_to :qr_codeable, :polymorphic => true
  belongs_to :coupon, class_name: "::Payment::Coupon"
  mount_uploader :code, QrCodeUploader
  # 属于哪个优惠券的二维码
  scope :by_coupon, ->(coupon_id) { where(coupon_id: coupon_id) }

  class << self
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
