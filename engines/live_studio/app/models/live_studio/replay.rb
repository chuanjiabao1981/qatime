module LiveStudio
  class Replay < ActiveRecord::Base
    belongs_to :lesson
    belongs_to :target, polymorphic: true
    belongs_to :channel
    serialize :vids, Array
    serialize :pending_vids, Array

    enum video_for: { board: 0, camera: 1 }
    enum status: {
      merging: 0,
      merged: 1
    }

    # 音视频回放
    def self.create_from(channel_video)
      replay = find_or_initialize_by(target: channel_video.target, vid: channel_video.vid)
      attrs = channel_video.attributes.symbolize_keys.slice(:orig_url, :sd_mp4_url, :hd_mp4_url, :shd_mp4_url)
      replay.assign_attributes(attrs.merge(name: channel_video.name, video_for: 0))
      replay.save
      replay.merged! unless replay.merged?
      replay.target.merged! unless replay.target.merged?
    end

    def merge_video
      return single_merge unless vids.count > 1 # 单个视频不需要合并
      async_merge_replays
    end

    def async_merge_video
      VideoMergeJob.set(wait: 1.minutes).perform_later(id)
    end

    def video_get
      return unless vid.present?
      res = VCloud::Service.app_vod_video_get(vid: vid)
      result = JSON.parse(res.body).symbolize_keys[:ret].symbolize_keys
      update(
        duration: result[:duration],
        type_id: result[:typeId],
        snapshot_url: result[:snapshotUrl],
        orig_url: result[:origUrl],
        download_orig_url: result[:downloadOrigUrl],
        initial_size: result[:initialSize],
        sd_mp4_url: result[:sdMp4Url],
        download_sd_mp4_url: result[:downloadSdMp4Url],
        sd_mp4_size: result[:sdMp4Size],
        hd_mp4_url: result[:hdMp4Url],
        download_hd_mp4_url: result[:downloadHdMp4Url],
        hd_mp4_size: result[:hdMp4Size],
        shd_mp4_url: result[:shdMp4Url],
        download_shd_mp4_url: result[:downloadShdMp4Url],
        shd_mp4_size: result[:shdMp4Size],
        create_time: result[:createTime]
      )
      target.merged! unless target.merged?
      merged! unless merged?
    end

    # 返回下一次合并视频ID
    def current_pending_vids!
      pending_vids.unshift(vid) if vid && pending_vids.exclude?(vid)
      pending_vids.first(4)
    end

    # 异步合并视频片段
    def async_merge_replays
      ReplaysMergeJob.set(wait: 1.minutes).perform_later(id)
    end

    # 合并视频片段
    def merge_replays
      return if pending_vids.blank?
      vid_list = current_pending_vids!
      self.name = merging_name(vid_list)
      save!
      VCloud::Service.app_video_merge(outputName: name, vidList: vid_list)
    end

    # 合并回调
    def merge_callback(params)
      return unless params[:video_name] == name
      with_lock do
        # 删除已经合并的视频ID
        self.vid = params['vid']
        self.pending_vids -= merged_vids(params[:video_name])
        self.orig_video_key = params['orig_video_key']
        self.uid = params['uid']
        self.n_id = params['nID']
        save!
      end
      video_get
      async_merge_replays unless pending_vids.blank? # 如果有未合并视频继续合并
    end

    def instance_resource
      return if download_orig_url.blank?
      attach = ::Resource::Attach.create!(remote_file_url: download_orig_url)
      target.teacher.files.create(
        name: "#{target.name}.mp4",
        user: target.teacher,
        attach: attach,
        ext_name: attach.ext_name,
        origin: self,
        file_size: attach.file_size,
        type: attach.resource_type
      )
    end

    after_create :async_instance_resource
    def async_instance_resource
      ReplayResourceJob.set(wait: 1.days).perform_later(id)
    end

    private

    # 合并文件名称
    def merging_name(vid_list)
      return name if vid_list.blank?
      name.gsub(/board_replay_?[\w-]*$/, "board_replay_#{vid_list.join('-')}")
    end

    def merged_vids(video_name)
      return [] unless video_name =~ /board_replay_\d+/
      video_name.split('board_replay_').last.split('-')
    end

    def single_merge
      video = ChannelVideo.find_by(vid: vids.first)
      with_lock do
        self.vid = video.vid
        self.orig_video_key = video.orig_video_key
        self.uid = video.uid
        self.pending_vids.delete(video.vid.to_s)
        save!
      end
      video_get
    end
  end
end
