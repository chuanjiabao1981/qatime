class RegisterCode < ActiveRecord::Base

  belongs_to :teacher
  def initialize(attributes = {})
    super(attributes)
    self.value = rand(10).to_s +
                 rand(10).to_s +
                 rand(10).to_s +
                 rand(10).to_s +
                 rand(10).to_s +
                 rand(10).to_s + "-" +format("%03d",Time.new().to_i%1000)
  end

end
