require "grape-swagger"

module V1
  class API < Grape::API
    include V1::Defaults

    mount V1::System
    mount V1::Sessions
    mount V1::Students
    mount V1::Teachers
    mount V1::AppConstants
    mount V1::Register
    mount V1::Captcha
    mount V1::Users
    mount V1::Password
    mount V1::Notifications

    mount V1::LiveStudio::Students::Courses
    mount V1::LiveStudio::Courses
    mount V1::LiveStudio::Lessons
    mount V1::LiveStudio::Channels

    # 互动直播
    mount V1::LiveStudio::InteractiveCourses
    mount V1::LiveStudio::InteractiveLessons
    mount V1::LiveStudio::Students::InteractiveCourses
    mount V1::LiveStudio::Teachers::InteractiveCourses

    # 视频课
    mount V1::LiveStudio::VideoCourses
    mount V1::LiveStudio::VideoLessons
    mount V1::LiveStudio::Students::VideoCourses
    mount V1::LiveStudio::Students::Schedule
    mount V1::LiveStudio::Teachers::VideoCourses

    # 专属课 start
    mount V1::LiveStudio::CustomizedGroups
    mount V1::LiveStudio::Students::CustomizedGroups
    mount V1::LiveStudio::Teachers::CustomizedGroups
    mount V1::LiveStudio::Events
    mount V1::LiveStudio::InstantLessons
    mount V1::LiveStudio::ScheduledLessons
    # 专属课 end

    mount V1::LiveStudio::Teachers::Schedule

    mount V1::Payment::Orders
    mount V1::Payment::Recharges
    mount V1::Payment::Users
    mount V1::Payment::Withdraws
    mount V1::Payment::CashAccounts
    mount V1::Payment::Refunds
    mount V1::Recommend::Positions
    mount V1::Payment::Coupons
    mount V1::Payment::ItunesProducts

    # 首页搜索
    mount V1::Home::Search

    add_swagger_documentation mount_path: "/api-doc", api_version: "v1", hide_documentation_path: true, hide_format: false,
                              info: { title: "答疑时间API接口", description: "v1.0" }
  end
end
