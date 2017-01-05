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

    mount V1::LiveStudio::Courses
    mount V1::LiveStudio::Lessons

    mount V1::Payment::Orders
    mount V1::Payment::Recharges
    mount V1::Payment::Users
    mount V1::Payment::Withdraws
    mount V1::Payment::CashAccounts
    mount V1::Payment::Refunds
    mount V1::Recommend::Positions

    add_swagger_documentation mount_path: "/api-doc", api_version: "v1", hide_documentation_path: true, hide_format: false,
                              info: { title: "答疑时间API接口", description: "v1.0" }
  end
end
