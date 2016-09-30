module Payment
  module AutoPayable
    extend ActiveSupport::Concern
    included do
      after_create :auto_paid!
    end

    protected

    def auto_paid!
    end
  end
end
