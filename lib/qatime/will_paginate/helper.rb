# 答疑时间
module Qatime
  module WillPaginate
    # Helper方法
    module Helper
      def remote_will_paginate(collection, options = {})
        will_paginate(collection, options.merge(renderer: Qatime::WillPaginate::RemoteLinkRenderer))
      end
    end
  end
end
