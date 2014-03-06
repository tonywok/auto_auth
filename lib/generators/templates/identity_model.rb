class <%= identity_model_class %> < ActiveRecord::Base

  has_secure_password

  belongs_to :<%= domain_model %>, inverse_of: :<%= plural_identity_model %>

end
