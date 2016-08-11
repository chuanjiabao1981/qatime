module V1
  # 基础数据获取接口
  class AppConstants < Base
    namespace :app_constant do
      before do
        authenticate!
      end

      desc '获取年级列表' do
        headers 'Remember-Token' => {
          description: 'RememberToken',
          required: true
        }
      end
      get :grade_list do
        { grade_list: APP_CONSTANT["grades_in_menu"] }
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

      desc '获取省包含城市列表' do
        headers 'Remember-Token' => {
          description: 'RememberToken',
          required: true
        }
      end
      get :provinces_full do
        provinces = ::Province.all
        present provinces, with: Entities::Province, type: :full
      end

      desc '获取省详细信息' do
        headers 'Remember-Token' => {
          description: 'RememberToken',
          required: true
        }
      end
      params do
        requires :id, type: Integer, desc: '省份ID'
      end
      get :province do
        province = ::Province.find(params[:id])
        present province, with: Entities::Province, type: :full
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

      desc '获取城市学校列表' do
        headers 'Remember-Token' => {
          description: 'RememberToken',
          required: true
        }
      end
      params do
        requires :id, type: Integer, desc: '城市ID'
      end
      get :city_schools do
        city = ::City.find(params[:id])
        present city, with: Entities::City, type: :schools
      end
    end
  end
end
