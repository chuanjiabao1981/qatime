module ContentValidate
  extend ActiveSupport::Concern
  included do
    if self.attribute_names.include?("title")
      validates :title, length:{minimum: 2,maximum: 200}
    end
    #validates_presence_of :content
    #validates :content, length: {minimum: 5}
    before_validation :strip_whitespace
  end

  def strip_whitespace
    if self.attribute_names.include?("title")
      self.title = self.title.strip
    end
  end
end
