class <%= identity_model_class %> < ActiveRecord::Base

  include TokenVerification

  belongs_to :<%= domain_model %>, inverse_of: :<%= plural_identity_model %>

  has_secure_password
  validates_presence_of :email
  validates_format_of :email, with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

end
