class <%= domain_model_class %> < ActiveRecord::Base

  has_many :<%= plural_identity_model %>, inverse_of: :<%= domain_model %>

  validates_presence_of :email
  validates_format_of :email, with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

end
