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
      params do
        optional :scope, type: String, desc: '是否加盟: has_default_workstation;', values: %w[has_default_workstation]
      end
      get :provinces do
        if params[:scope] && params[:scope] == 'has_default_workstation'
          provinces = ::Province.has_default_workstation
        else
          provinces = ::Province.all
        end
        present provinces, with: Entities::Province
      end

      desc '获取城市列表'
      params do
        optional :scope, type: String, desc: '是否加盟: has_default_workstation;', values: %w[has_default_workstation]
      end
      get :cities do
        if params[:scope] && params[:scope] == 'has_default_workstation'
          cities = ::City.has_default_workstation
        else
          cities = ::City.all
        end
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
      params do
        optional :cates, type: String, desc: '标签分离,多个分类用都好分割 例如 高三,语文'
      end
      get :tags do
        present Tag.category_of(params[:cates].to_s.split(/[,-]/)).order('tag_group_id, id'), with: Entities::CourseTag
      end
    end
  end
end
