module QaPageNum
  extend ActiveSupport::Concern
  included do


    def _page_num(o,options)
      column = options[:by] || :created_at
      order  = options[:order] || :desc
      per    = options[:per] || 10

      operator = (order == :asc ? "<=" : ">=")
      (where("#{column} #{operator} ?", o.send(column)).count.to_f / per).ceil
    end
  end
end