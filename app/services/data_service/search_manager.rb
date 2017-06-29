module DataService
  class SearchManager
    def initialize(cate = 'course')
      @cate = cate
    end

    def search(k)
      @cate == 'teacher' ? search_teachers(k) : search_courses(k)
    end

    def search_teachers(k)
      ::Teacher.order(created_at: :desc).ransack(name_or_category_or_subject_cont: k, name_present: '1').result
    end

    def search_courses(k)
      courses = ::LiveStudio::Course.for_sell.includes(:lessons, :teacher).ransack(name_cont: k).result
      interactive_courses = ::LiveStudio::InteractiveCourse.for_sell.includes(:interactive_lessons, :teachers).ransack(name_cont: k).result
      video_courses = ::LiveStudio::VideoCourse.for_sell.includes(:video_lessons, :teacher).ransack(name_cont: k).result

      all_courses = courses.to_a + interactive_courses.to_a + video_courses.to_a
      all_courses.sort_by{ |x| x.published_at || Time.new(2000) }.reverse
    end

    def self.teachers_ransack(params = {})
      params = params.presence || {}
      ::Teacher.order(all_courses_count: :desc, created_at: :desc).ransack(params.merge(name_present: '1'))
    end

    def self.replays_ransack(params = {})
      params = params.presence || {}
      params['s'] ||= 'updated_at desc'
      ::Recommend::ReplayItem.default.items.ransack(params)
    end
  end
end
