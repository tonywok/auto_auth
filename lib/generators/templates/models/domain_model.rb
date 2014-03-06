class <%= domain_model_class %> < ActiveRecord::Base

  has_many :<%= plural_identity_model %>, inverse_of: :<%= domain_model %>

end
