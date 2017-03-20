module V1
  # 基础数据获取接口
  class AppConstants < Base
    namespace :app_constant do
      desc '获取基础信息'
      get do
        provinces = ::Province.all
        cities = ::City.all
        schools = ::School.all

        present :grades, APP_CONSTANT["grades_in_menu"]
        present :cities, cities, with: Entities::City
        present :provinces, provinces, with: Entities::Province
        present :schools, schools, with: Entities::School
        present :im_app_key, Chat::IM.app_key
      end

      desc '获取年级列表'
      get :grades do
        { grades: APP_CONSTANT["grades_in_menu"] }
      end

      desc '获取省份列表'
      get :provinces do
        provinces = ::Province.all
        present provinces, with: Entities::Province
      end

      desc '获取城市列表'
      get :cities do
        cities = ::City.all
        present cities, with: Entities::City
      end

      desc '获取学校列表'
      get :schools do
        schools = ::School.all
        present schools, with: Entities::School
      end

      desc '获取云信信息'
      get :im_app_key do
        present :im_app_key, Chat::IM.app_key
      end

      desc '获取所有标签'
      get :tags do
        present ActsAsTaggableOn::Tag.all, with: Entities::CourseTag
      end
    end
  end
end
