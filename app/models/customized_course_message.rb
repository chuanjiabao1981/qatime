class CustomizedCourseMessage < ActiveRecord::Base

  include QaToken
  include QaActionRecord
  include QaCustomizedCourseActionNotification


  belongs_to :customized_course_message_board,counter_cache: true
  belongs_to :author,class_name: User
  belongs_to :customized_course

  has_many :customized_course_message_replies,lambda { order "#{CustomizedCourseMessageReply.order_column.to_s} #{CustomizedCourseMessageReply.order_type.to_s}" },{:dependent => :destroy} do
    def build(attributes={})
      attributes[:customized_course_id]                         = proxy_association.owner.customized_course_id
      attributes[:customized_course_message_board_id]           = proxy_association.owner.customized_course_message_board_id
      super attributes
    end
    include QaPageNum
    def page_num(o)
      _page_num(o,by: CustomizedCourseMessageReply.order_column,order: CustomizedCourseMessageReply.order_type,per: CustomizedCourseMessageReply.per_page)
    end
  end



  validates_presence_of :title,:author

  self.per_page = 10

  def operator_id
    self.author_id
  end

end