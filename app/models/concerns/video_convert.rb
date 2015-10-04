module VideoConvert
  extend ActiveSupport::Concern

  CONVERT_POSTFIX='-converted'

  included do
    mount_uploader :name, VideoUploader
    mount_uploader :convert_name,VideoUploader

    state_machine :initial => :not_convert do
      transition :in_queue                  => :converting,     :on => [:convert_process_begin]
      transition :converting                => :convert_success,:on => [:convert_process_finish]
      transition :convert_fail              => :converting,     :on => [:convert_process_begin]
      event :in_queue do
        transition all => :in_queue
      end
      event :convert_process_exec_error do
        transition all => :convert_fail
      end

      after_transition :on => :in_queue do |video,transition|
        VideoConvertWorker.perform_async(video.id,0,video.class.to_s)
      end
    end

    def build_convert_file_name
      return "#{File.basename(self.name_identifier,File.extname(name_identifier))}#{CONVERT_POSTFIX}.mp4"
    end
    def update_video_file(params)
      params[:state] = :not_convert
      self.update_attributes(params)
      add_to_convert_queue
    end

    def add_to_convert_queue
      self.with_lock do
        self.fire_events!(:in_queue)
        self.save!
      end
    end
  end
end
