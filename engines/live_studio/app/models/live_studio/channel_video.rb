module LiveStudio
  class ChannelVideo < ActiveRecord::Base
    include LiveStudio::Channelable

    belongs_to :channel

    def update_video_info
      res = ::Typhoeus.post(
        "#{VCLOUD_HOST}/app/vod/video/get",
        headers: vcloud_headers,
        body: {
          vid: vid
        }.to_json
      )
      return unless res.success?
      result = JSON.parse(res.body).symbolize_keys[:ret]
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
    end
  end
end
