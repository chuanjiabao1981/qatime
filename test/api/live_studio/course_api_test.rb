class Qatime::CoursesAPITest < ActiveSupport::TestCase
  include Rack::Test::Methods

  def app
    Rails.application
  end

  test "GET /api/v1/live_studio/teacher/courses returns teacher's courses list" do
    get '/api/v1/live_studio/teacher/courses'
    assert last_response.ok?
    assert_equal [], JSON.parse(last_response.body)
  end
end
