module LiveService
  class ScheduleDirector
    def initialize(user)
      @user = user
    end

    def month

    end

    def week
    end

    def day
    end
  end

  class TeacherSchedule > ScheduleDirector
    def initialize(user)
      @user = user
    end
  end

  class StudentSchedule > ScheduleDirector
  end

end
