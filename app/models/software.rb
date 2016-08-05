class Software < ActiveRecord::Base
  mount_uploader :logo, SoftwareLogoUploader
  mount_uploader :qr_code, SoftwareQrCodeUploader
end
