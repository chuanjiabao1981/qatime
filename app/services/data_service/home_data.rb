module DataService
  class HomeData
    class << self
      # home data
      def home_data_by_city(city_id)
        courses = model_query(Recommend::LiveStudioCourseItem, city_id).order(index: :asc).limit(6)
        teachers = model_query(Recommend::TeacherItem, city_id).order(index: :asc).limit(5)
        banners = model_query(Recommend::BannerItem, city_id).order(index: :asc).limit(3)
        [courses, teachers, banners]
      end

      # 如果查询不到数据的话
      # 就拿city_id未设置的数据(代指全国数据)
      def model_query(model, city_id)
        model.where(city_id: city_id)
      end

      def position_query(position, city_name)
        city = City.find_by(name: city_name)
        return position.items unless city.present?
        position.items.where(city_id: city.id)
      end
    end
  end
end
