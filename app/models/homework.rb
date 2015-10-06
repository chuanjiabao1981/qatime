class Homework < ActiveRecord::Base

  include QaToken
  include ContentValidate
  include QaSolution
  include QaCommon
  include QaWork


end
