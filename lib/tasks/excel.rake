require 'roo'

namespace :excel do
  desc "迁移用户充值记录"
  task import_cities: :environment do
    file_name = ENV['file'] || './cities.xlsx'
    puts "删除旧的数据..."
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE cities")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE provinces")
    ActiveRecord::Base.connection.execute("ALTER SEQUENCE cities_id_seq RESTART WITH 1")
    ActiveRecord::Base.connection.execute("ALTER SEQUENCE provinces_id_seq RESTART WITH 1")

    xlsx = Roo::Spreadsheet.open(file_name)

    Province.create(name: '山西省')
    City.create(name: '阳泉市', province_id: 1)
    Province.create(name: '浙江省')
    City.create(name: '诸暨市', province_id: 2)
    City.create(name: '太原市', province_id: 1)

    xlsx.each_with_pagename do |name, sheet|
      next unless sheet.first_row
      province_name = sheet.column(1)[1]
      city_column = 3
      if province_name.blank?
        province_name = sheet.column(2)[1]
        city_column = 4
        city_column = 2 if %w(天津市 重庆市).include?(province_name)
      end
      if "澳门各区" == province_name
        province_name = "澳门特别行政区"
        city_column = 1
      end
      if "新疆" == name
        province_name = "新疆维吾尔族自治区"
        city_column = 3
      end
      province = Province.find_or_create_by(name: province_name.strip)

      p "开始导入 #{province.name}....."

      sheet.column(city_column).each do |c|
        next if c.nil? || c == '' || %w(城区 市 省市 澳门各区).include?(c) || c == province.name
        province.cities.find_or_create_by(name: c.to_s.strip)
      end
      p "#{province.name} 导入完成"
      p province.cities.map(&:name)
    end
  end
end
