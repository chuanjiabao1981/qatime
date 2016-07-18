module V1
  # 系统环境
  module LiveStudio 
    class Courses < Grape::API
      namespace :live_studio do
        resource :courses do
          desc '辅导班列表.'
          params do
          end
          get do
          end
        end
      end
    end
  end
end
