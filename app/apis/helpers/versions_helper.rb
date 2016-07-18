module VersionsHelper
  # 强制更新APP
  def force_update!(bool = verify_version?)
    #return unless Rails.env.production?
    raise APIErrors::VersionOldError unless bool
  end

  def verify_version?(ios_version = nil, android_version = nil)
    bool = true

    bool = false unless client_version.present?
    bool = false if ios_version.present? && ios? && device_version < ios_version
    bool = false if android_version.present? && android? && device_version < android_version

    bool
  end

  def client_version
    @client_version ||= headers["X-Client-Version"].to_s
  end

  def device
    @device ||= client_version.split("-").try(:first)
  end

  def device_version
    @device_version ||= client_version.split("-").try(:last)
  end

  def ios?
    device == "iOS"
  end

  def android?
    device == "Android"
  end

  def setup_user_source(user)
    user.source =
      if ios?
        "ios"
      elsif android?
        "android"
      end
    user.register_ip = ip
    user.device = client_version
  end

  def sim_version?
    verify_version?("3.0", (Rails.env.production? ? "3.0" : "2.0"))
  end

  def p2p_update_version?
    (Rails.env.production? || Rails.env.testing?) ? true : verify_version?("3.1", "3.1")
  end
end

