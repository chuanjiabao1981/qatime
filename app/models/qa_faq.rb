class QaFaq < ActiveRecord::Base
  enum qa_faq_type: { :common => 0 , :student => 1,:teacher => 2}

end
