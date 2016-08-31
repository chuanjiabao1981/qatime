class WelcomeController < ApplicationController
  layout "application"
  def download
    render && return unless current_user
    @softwares = Software.auto_sort(current_user)
    flag_hash = {}
    # 以title分组的数据 只取第一条进行展示
    @softwares.each do |soft|
      flag_hash[soft.title] || flag_hash[soft.title] = soft
    end
    @softwares = flag_hash.values
  end
end

