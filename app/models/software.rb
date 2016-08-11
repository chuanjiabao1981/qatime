class Software < ActiveRecord::Base
  extend Enumerize

  mount_uploader :logo, SoftwareLogoUploader
  mount_uploader :qr_code, SoftwareQrCodeUploader

  PLATFORM_HASH = {
    windows: 1,
    android: 2,
    ios: 3
  }

  enumerize :platform, in: PLATFORM_HASH,
                        i18n_scope: "enums.software.platform",
                        scope: true,
                        predicates: { prefix: true }

end
