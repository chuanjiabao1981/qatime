module QaHandle
  extend ActiveSupport::Concern
  included do

    def _set_handle_infos(handle)

      if self.first_handle_author.nil?
        self.first_handle_author_id     = handle.author.id
        self.first_handle_created_at    = handle.created_at
      end
      self.last_handle_author_id        = handle.author.id
      self.last_handle_created_at       = handle.created_at
      self.save
    end

    def _update_handle_infos(a)
      s = self
      c = a
      if c.length == 0
        s.first_handle_created_at     = nil
        s.first_handle_author_id      = nil
        s.last_handle_created_at      = nil
        s.last_handle_author_id       = nil
        s.save
        return
      end
      first = c.first
      last  = c.last

      s.first_handle_created_at     = first.created_at
      s.first_handle_author_id      = first.author.id
      s.last_handle_created_at      = last.created_at
      s.last_handle_author_id       = last.author.id
      s.save
    end

    # 超时未批改  no_handle_and_timeout
    # 未批改     no_correction
    # 超时批改   handle_timeout
    # 按时批改   handle_in_time
    def handle_state
      #已经处理，判断时间
      if not self.handles_count.nil? and self.handles_count >0
        if self.first_handle_created_at
          if (self.first_handle_created_at - self.created_at) < eval(APP_CONSTANT["handle_timeout"])
            :handle_in_time
          else
            :handle_timeout
          end
        else
          #必须要有的
        end
      else
        #没有处理，判断时间
        if self.created_at <= eval(APP_CONSTANT["handle_timeout"]).ago
          :no_handle_and_timeout
        else
          :no_handle
        end
      end
    end
  end
end