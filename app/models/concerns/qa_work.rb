module QaWork
  extend ActiveSupport::Concern
  included do

    # belongs_to      :customized_course,counter_cache: true
    # belongs_to      :customized_tutorial,counter_cache: true

    # belongs_to      :teacher
    # belongs_to      :student
    #
    # has_many        :qa_files      , -> { order 'created_at asc' },as: :qa_fileable
    # has_many        :pictures,as: :imageable
    # has_many        :comments,-> { order 'created_at asc' },as: :commentable,dependent: :destroy
    #
    # has_many        :corrections
    #
    # has_many        :solutions,as: :solutionable,:dependent =>  :destroy  do
    #   def build(attributes={})
    #     attributes[:customized_course_id] = proxy_association.owner.customized_course_id
    #     super attributes
    #   end
    # end


    # accepts_nested_attributes_for :qa_files, allow_destroy: true

    scope :h_index_eager_load,lambda {includes(:teacher,:student,:customized_tutorial)}


    self.per_page = 10

    def author
      self.teacher
    end
    def name
      self.title
    end


  end
end