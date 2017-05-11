module DataService
  class HomeData
    def initialize(city_id)
      @city_id = city_id
    end

    # 首页banner
    def banners
      position_query(Recommend::BannerItem.default, @city_id)
    end

    # 今日直播
    def today_lives
      LiveStudio::Lesson.includes(:course).today.readied.order(:start_time)
    end

    # 教师推荐
    def teachers
      position_query(Recommend::TeacherItem.default, @city_id)
    end

    # 精选内容
    def choiceness
      position_query(Recommend::ChoicenessItem.default, @city_id)
    end

    # 近期开课
    def recent_courses
      LiveService::RankManager.rank_of('start_rank', {city_id: @city_id})
    end

    # 新课发布
    def newest_courses
      LiveService::RankManager.rank_of('all_published_rank', {city_id: @city_id})
    end

    class << self
      def position_query(position, city_name)
        city = City.find_by(name: city_name)
        return position.items.by_city(nil) unless city.present?
        position.items.by_city(city.id)
      end
    end

    private

    def position_query(position, city_id)
      return position.none if position.blank?
      position.items.by_city(city_id)
    end
  end
end
