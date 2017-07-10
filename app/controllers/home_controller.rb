class HomeController < ApplicationController
  before_action :set_user
  layout 'v1/application'

  def index
    # if signed_in?
    redirect_to action: :new_index
    # else
    #   render layout: 'application_home'
    # end
  end

  def new_index
    home_data = DataService::HomeData.new(@location_city.try(:id))
    @recommend_banners = home_data.banners.order(:index)
    @recommend_teachers = home_data.teachers.order(:index).limit(6)
    @today_lives = home_data.today_lives.limit(12)
    @choiceness = home_data.choiceness.order(:index).paginate(page: 1, per_page: 8)
    @topic_items = home_data.topic_items.order(:index).paginate(page: 1, per_page: 3)
    @recent_courses = home_data.recent_courses.limit(4)
    @newest_courses = home_data.newest_courses
    @free_courses = home_data.free_courses(limit: 4)
    replay_limit = @topic_items.count > 0 ? 3 : 4
    @replay_items = home_data.replay_items.top.order(updated_at: :desc).limit(replay_limit)
  end

  def switch_city
    @hash_cities = City.all.to_a.group_by {|city| Spinying.parse(word: city.name).first }.sort.to_h
    @selected_cities = cookies[:selected_cities].try(:split, '-')
  end

  def search
    params[:search_cate] ||= 'course'
    if params[:search_cate] == 'teacher'
      redirect_to main_app.search_teachers_home_index_path(search_key: params[:search_key])
    else
      redirect_to main_app.search_courses_home_index_path(search_key: params[:search_key])
    end
  end

  def search_teachers
    params[:search_cate] = 'teacher'
    search_data = DataService::SearchManager.new(params[:search_cate])
    @teachers = search_data.search(params[:search_key]).paginate(page: params[:page], per_page: 8)
  end

  def search_courses
    params[:search_cate] = 'course'
    search_data = DataService::SearchManager.new(params[:search_cate])
    @courses = search_data.search(params[:search_key]).paginate(page: params[:page], per_page: 12)
  end

  def teachers
    @query = DataService::SearchManager.teachers_ransack(params[:q])
    @teachers = @query.result.paginate(page: params[:page], per_page: 8)
  end

  def replays
    @replay_items = Recommend::ReplayItem.default.items.order(updated_at: :desc).paginate(page: params[:page], per_page: 5)
  end

  def replay
    @replay_item = Recommend::ReplayItem.default.items.find(params[:id])
    @lesson = @replay_item.target
    @teacher = @replay_item.target.try(:teacher)
    @replay_item.increment_replay_times
    render layout: 'v1/live'
  end

  private

  def set_user
    @user = current_user
  end
end
