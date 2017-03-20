module DataService
  class HomeData

    def initialize(city_id)
      @city_id = city_id
    end

    def banners
      Recommend::BannerItem.default.items.by_city(@city_id)
    end

    def today_lives
      LiveStudio::Course.by_city(@city_id).order(id: :desc).limit(12)
    end

    def teachers
      Recommend::TeacherItem.default.items.by_city(@city_id)
    end

    def choiceness
      Recommend::ChoicenessItem.default.items.by_city(@city_id)
    end

    def recent_courses
      LiveStudio::Course.by_city(@city_id).order(id: :desc).limit(4)
    end

    def newest_courses
      LiveStudio::Course.by_city(@city_id).order(id: :desc).limit(4)
    end

    class << self
      def position_query(position, city_name)
        city = City.find_by(name: city_name)
        return position.items unless city.present?
        position.items.where(city_id: city.id)
      end
    end
  end
end
