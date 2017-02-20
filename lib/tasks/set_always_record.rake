task :set_always_record => :environment do
  include LiveStudio::Channelable
  LiveStudio::Channel.all.each do |channel|
    p("#{channel.id}-未设置,频道ID为空") && next unless channel.remote_id.present?
    p("#{channel.id}-未设置,辅导班为空") && next unless channel.course.present?

    res = ::Typhoeus.post(
      "#{VCLOUD_HOST}/app/channel/setAlwaysRecord",
      headers: vcloud_headers,
      body: {
        cid: channel.remote_id,
        needRecord: 1,
        format: 0,
        duration: 90,   # minutes
        filename: "#{channel.course.name}-#{Time.now.to_i}"
      }.to_json
    )
    p("#{channel.id}-设置失败") && next unless res.success?
    channel.set_always_recorded = true
    channel.save
  end

end
