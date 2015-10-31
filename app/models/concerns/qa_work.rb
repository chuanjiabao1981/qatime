module QaWork
  extend ActiveSupport::Concern
  included do


    scope :h_index_eager_load,lambda {includes(:teacher,:student)}


    self.per_page = 10

    def author
      self.teacher
    end
    def name
      self.title
    end


  end
end