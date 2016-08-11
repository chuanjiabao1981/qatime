module V1
  # 基础数据获取接口
  class AppConstants < Base
    namespace :app_constant do
      before do
        authenticate!
      end

      desc '获取基础信息' do
        headers 'Remember-Token' => {
          description: 'RememberToken',
          required: true
        }
      end
      get do
        provinces = ::Province.all
        cities = ::City.all
        schools = ::School.all

        # grades = APP_CONSTANT["grades_in_menu"].to_json
        provinces = present provinces, with: Entities::Province
        cities = present cities, with: Entities::City
        schools = present schools, with: Entities::School
        {
          grades: provinces
        }

      end

      desc '获取年级列表' do
        headers 'Remember-Token' => {
          description: 'RememberToken',
          required: true
        }
      end
      get :grades do
        { grades: APP_CONSTANT["grades_in_menu"] }
      end

      desc '获取省份列表' do
        headers 'Remember-Token' => {
          description: 'RememberToken',
          required: true
        }
      end
      get :provinces do
        provinces = ::Province.all
        present provinces, with: Entities::Province
      end

      desc '获取城市列表' do
        headers 'Remember-Token' => {
          description: 'RememberToken',
          required: true
        }
      end
      get :cities do
        cities = ::City.all
        present cities, with: Entities::City
      end

      desc '获取学校列表' do
        headers 'Remember-Token' => {
          description: 'RememberToken',
          required: true
        }
      end
      get :schools do
        schools = ::School.all
        present schools, with: Entities::School
      end
    end
  end
end
