module DataService
  class HomeData
    class << self

      # home data
      def home_data_by_city city_id
        courses = query_data(Recommend::LiveStudioCourseItem, city_id).order(index: :asc).limit(6)
        teachers = query_data(Recommend::TeacherItem, city_id).order(index: :asc).limit(5)
        banners = query_data(Recommend::BannerItem, city_id).order(index: :asc).limit(3)
        [courses, teachers, banners]
      end


      private
      # 如果查询不到数据的话
      # 就拿city_id未设置的数据(代指全国数据)
      def query_data(model,city_id)
        model.where(city_id: city_id).presence || model.where(city_id: nil)
      end
    end
  end
end
