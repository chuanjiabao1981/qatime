module RepliesHelper
  def get_reply_form_url(topic,reply)
    if reply.new_record?
      # topic_replies_path(topic,anchor:  "new_reply")

      send("#{topic.model_name.singular_route_key}_#{reply.model_name.plural}_path",topic,anchor: "new_reply")
    else
      send("#{reply.model_name.singular_route_key}_path",reply)
    end
  end
end
