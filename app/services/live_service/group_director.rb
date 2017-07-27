module LiveService
  class GroupDirector
    def initialize(group)
      @course = course
    end

    def self.search(search_params)
      chain = LiveStudio::CustomizedGroup.for_sell.includes(:teacher)
      chain.ransack(search_params[:q])
    end
  end
end
