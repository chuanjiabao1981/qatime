require "grape-swagger"

module V1
  class Base < Grape::API
    include V1::Defaults
    include SessionsHelper

    mount V1::System
    mount V1::Sessions
    mount V1::LiveStudio::Courses

    add_swagger_documentation mount_path: "/api-doc", api_version: "v1", hide_documentation_path: true, hide_format: false,
                              info: { title: "答疑时间API接口", description: "v1.0" }
  end
end
