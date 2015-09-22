module QaSolution
  extend ActiveSupport::Concern
  included do

    def corrections_count
      s = 0
      self.solutions.each do |c|
        if not c.corrections_count.nil?
          s+=c.corrections_count
        end
      end
      s
    end
  end
end