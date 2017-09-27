module V1
  # 家庭作业接口
  module LiveStudio
    class Attachments < V1::Base
      namespace "live_studio" do
        before do
          authenticate!
        end
        resource :attachments do
          desc '上传附件' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :file, type: ::File
          end
          post do
            attachment = ::LiveStudio::Attachment.create(file: params[:file])
            present attachment, with: Entities::LiveStudio::Attachment
          end
        end
      end
    end
  end
end
