module StudentsHelper

  # 生成注册二维码
  # 如果注册类型已经存在则直接放回链接, 否则生成注册二维码再返回链接
  def regsiter_qr_code_url(register_type)
    return nil if register_type.blank?
    register_type = "Register#{register_type}"
    register_code = QrCode.find_by(qr_codeable_type: register_type)
    return register_code.code_url unless register_code.blank?
    relative_path = QrCode.generate_tmp(UserService::WechatApi.wechat_url(register_type))
    tmp_path = Rails.root.join(relative_path)
    File.open(tmp_path) do |file|
      register_code = QrCode.create(code: file, qr_codeable_type: register_type)
    end
    File.delete(tmp_path)
    register_code.code_url
  end
end
