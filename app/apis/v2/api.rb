require "grape-swagger"

module V2
  class API < Grape::API
    include V2::Defaults

    # 首页搜索
    mount V2::Home::Search
    mount V2::LiveStudio::Courses
    mount V2::LiveStudio::Lessons

    add_swagger_documentation mount_path: "/api-doc", api_version: "v2", hide_documentation_path: true, hide_format: false,
                              info: { title: "答疑时间API接口", description: "v2.0" }
  end
end
